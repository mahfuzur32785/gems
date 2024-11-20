import 'package:flutter/cupertino.dart';

class TstFVModel{
  final int id;
  final String name;

  TstFVModel({required this.id, required this.name});
  
}

class TstFvAreaModel{
  final int id;
  final String divName;
  final String distName;
  final String unionName;
  final String upazilaName;

  TstFvAreaModel({
    required this.id,
    required this.divName,
    required this.distName,
    required this.upazilaName,
    required this.unionName,
  });
  
}