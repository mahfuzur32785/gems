import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as toast;

class AllService {
  static Widget LoadingToast() {
    return const SizedBox(
      width: 40,
      height: 40,
      child: CircularProgressIndicator(
        backgroundColor: Color(0xFF078669),
        strokeWidth: 6,
      ),
    );
  }

  void showToast(String text,{bool isError= false}) {
    toast.Fluttertoast.showToast(
      
      msg: text,
      toastLength: toast.Toast.LENGTH_SHORT,
      gravity: toast.ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor:isError ? Colors.red : Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  internetCheckDialog(BuildContext context) => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

// --- Button Widget --- //
}
