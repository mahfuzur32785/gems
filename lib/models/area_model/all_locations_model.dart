import 'package:village_court_gems/models/area_model/all_location_data.dart';

class AllLocationModel {
  List<AllLocationData>? data;
  int? status;
  String? message;

  AllLocationModel({this.data, this.status, this.message});

  AllLocationModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AllLocationData>[];
      json['data'].forEach((v) {
        data!.add(new AllLocationData.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

