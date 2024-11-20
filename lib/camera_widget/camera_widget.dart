import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:village_court_gems/camera_widget/camera_model.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    super.key,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  bool _isPermissionGranted = false;
  late final Future<void> _future;
  CameraController? _cameraController;
  bool isCamButtonLoading = false;
  // final textRecognizer = TextRecognizer();
  XFile? captureImgFile;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _future = _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    //Provider.of<OperationProvider>(context, listen: false).requestCameraPermission();
    final status = await Permission.camera.request();

    setState(() {
      _isPermissionGranted = status == PermissionStatus.granted;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    //textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed && _cameraController != null && _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return SafeArea(
          child: Stack(
            children: [
              if (_isPermissionGranted)
                FutureBuilder<List<CameraDescription>>(
                    future: availableCameras(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _initCameraController(snapshot.data!);
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            CameraPreview(_cameraController!),
                            captureImgFile != null
                                ? Positioned.fill(
                                    child: Image.file(
                                    File(captureImgFile!.path),
                                    fit: BoxFit.cover,
                                  ))
                                : SizedBox.shrink()
                            //       : Material(
                            //         child: ElevatedButton(onPressed: () {
                            //           backFromCamera();
                            //         },child: Text('Back'),),
                            //       )
                            // RotatedBox(
                            //     quarterTurns: 1 - _cameraController!.description.sensorOrientation ~/ 90, child: CameraPreview(_cameraController!)),
                            // Material(
                            //   child: Container(
                            //       height: 50,
                            //       decoration: BoxDecoration(color: Colors.white),
                            //       child: Column(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           Row(
                            //             children: [
                            //               // BackButton(
                            //               //   onPressed: () {
                            //               //    Navigator.of(context).pop();
                            //               //   },
                            //               // ),

                            //               Text(
                            //                 'Date :',
                            //                 style: TextStyle(fontSize: 17, color: Colors.black),
                            //               ),
                            //               Text(
                            //                 '${DateConverter.formatDate(DateTime.now())}',
                            //                 style: TextStyle(fontSize: 17, color: Color.fromARGB(255, 108, 104, 104)),
                            //               ),
                            //             ],
                            //           ),

                            //         ],
                            //       )),
                            // )
                          ],
                        );
                      } else {
                        return const LinearProgressIndicator();
                      }
                    }),
              Scaffold(
                backgroundColor: _isPermissionGranted ? Colors.transparent : null,
                body: _isPermissionGranted
                    ? Column(
                        children: [
                          Expanded(child: Container()),
                          Container(
                              padding: const EdgeInsets.only(bottom: 30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      backFromCamera();
                                    },
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      captureImgFile == null
                                          ? ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                  )),
                                              icon: Icon(Icons.camera),
                                              onPressed: captureImgFirst,
                                              label: const Text('Capture'),
                                            )
                                          : ElevatedButton.icon(
                                            icon: Icon(Icons.refresh),
                                             style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                  )),
                                              onPressed: () {
                                                setState(() {
                                                  captureImgFile = null;
                                                });
                                              },
                                              label: Text(
                                                'Retry',
                                                style: TextStyle(color: Colors.white),
                                              )),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      captureImgFile != null
                                          ? ElevatedButton.icon(
                                            icon: Icon(Icons.check),
                                             style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                  )),
                                              onPressed: () {
                                                captureImage(pictureFile: captureImgFile!);
                                              },
                                              label: Text('OK', style: TextStyle(color: Colors.white)))
                                          : SizedBox.shrink(),
                                    ],
                                  ),
                                  Spacer(),
                                ],
                              )),
                        ],
                      )
                    : Center(
                        child: Container(
                          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                          child: const Text('Camera permission denied'),
                        ),
                      ),
              )
            ],
          ),
        );
      },
    );
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(camera, ResolutionPreset.max,enableAudio: false);
    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.auto);

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    // Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  backFromCamera() {
    CameraDataModel cameraDataModel = CameraDataModel(
      xpictureFile: null,
    );
    Navigator.of(context).pop(cameraDataModel);
  }

  captureImgFirst() async {
    try {
      final img = await _cameraController!.takePicture();
      setState(() {
        captureImgFile = img;
      });
    } catch (e) {
      return;
      // if (context.mounted)
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('An error occurred when taking picture'),
      //     ),
      //   );
    }
  }

  captureImage({required XFile pictureFile}) async {
    if (_cameraController == null) return;
    final navigator = Navigator.of(context);
    // op.isCamLoading(value: true);
    try {
      CameraDataModel cameraDataModel = CameraDataModel();
      //final pictureFile = await _cameraController!.takePicture();

      cameraDataModel = CameraDataModel(
        //pictureFile: pictureFile,

        // imgByte: byte,
        xpictureFile: pictureFile,
      );
      //op.isCamLoading(value: false);
      navigator.pop(cameraDataModel);
      // } else {
      //  // op.isCamLoading(value: false);
      //   navigator.pop(null);
      //  // Geolocator.openLocationSettings();
      // }

      //var s = pictureFile.path;
      //   final file = File(pictureFile.path);

      //    final appDir = await getApplicationDocumentsDirectory(); // Or any other directory you prefer
      // final uniqueFileName = DateTime.now().microsecondsSinceEpoch;
      // final savedImage = File('${appDir.path}/$uniqueFileName.jpg');
      // await savedImage.writeAsBytes(await pictureFile.readAsBytes());
      //var s= file.toString();
      //final byte = file.readAsBytesSync();

      // navigator.pop(pictureFile);
      //await navigator.push(MaterialPageRoute(builder: (BuildContext context) => ResultScreen(text: recognizedText.text)));
    } catch (e) {
      navigator.pop(CameraDataModel(xpictureFile: null));
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Something went wrong'),
      //   ),
      // );
    }
    // op.isCamLoading(value: false);
  }
}

class ResultScreen extends StatelessWidget {
  final String text;

  const ResultScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
        ),
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: Text(text),
        ),
      );
}
