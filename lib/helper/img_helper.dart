import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

byteToFileConverter(Uint8List byte,String imgTitle) async {
  Uint8List imageInUnit8List = byte; // store unit8List image here ;
  final tempDir = await getTemporaryDirectory();
  File file = await File('${tempDir.path}/$imgTitle.png').create();
  file.writeAsBytesSync(imageInUnit8List);
}
