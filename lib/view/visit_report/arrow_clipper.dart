import 'dart:ui';

import 'package:flutter/material.dart';

class ArrowClipper extends CustomClipper<Path> {
  const ArrowClipper({this.addBackArrow = false});

  final bool addBackArrow;

  @override
  Path getClip(Size size) {
    final path = Path();

    double arrowWidth = size.height / 2; // Adjust the proportion of arrow height

    path.lineTo(size.width - arrowWidth, 0.0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - arrowWidth, size.height);
    path.lineTo(0.0, size.height);
    if (addBackArrow) {
      path.lineTo(arrowWidth , size.height / 2);
    }
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}