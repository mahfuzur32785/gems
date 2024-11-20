// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'dart:convert';

LocationModel locationModelFromJson(String str) => LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  List<Union>? unions;
  List<Upazila>? upazilas;
  List<District>? districts;
  List<Division>? divisions;
  int? status;
  String? message;

  LocationModel({
    this.unions,
    this.upazilas,
    this.districts,
    this.divisions,
    this.status,
    this.message,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        unions: json["unions"] == null ? [] : List<Union>.from(json["unions"].map((x) => Union.fromJson(x))),
        upazilas: json["upazilas"] == null ? [] : List<Upazila>.from(json["upazilas"].map((x) => Upazila.fromJson(x))),
        districts: json["districts"] == null ? [] : List<District>.from(json["districts"].map((x) => District.fromJson(x))),
        divisions: json["divisions"] == null ? [] : List<Division>.from(json["divisions"].map((x) => Division.fromJson(x))),
        status: json["status"],
    message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "unions": List<dynamic>.from(unions!.map((x) => x.toJson())),
        "upazilas": List<dynamic>.from(upazilas!.map((x) => x.toJson())),
        "districts": List<dynamic>.from(districts!.map((x) => x.toJson())),
        "divisions": List<dynamic>.from(divisions!.map((x) => x.toJson())),
        "status": status,
        "message": message,
      };
}

class District {
  String? districtName;
  int? districtId;
  int? divisionId;

  int? id;
  String? nameBn;
  String? nameEn;
  dynamic bbsCode;
  double? latitude;
  double? longitude;
  dynamic oldLatitude;
  dynamic oldLongitude;
  int? ngo;
  dynamic url;
  String? createdAt;
  String? updatedAt;


  District({
    this.districtName,
    this.districtId,
    this.divisionId,
    this.id,
    this.nameBn,
    this.nameEn,
    this.bbsCode,
     this.latitude,
     this.longitude,
    this.oldLatitude,
    this.oldLongitude,
    this.ngo,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
        districtName: json["district_name"],
        districtId: json["district_id"],
        divisionId: json["division_id"],
        id: json["id"],
        nameBn: json["name_bn"],
        nameEn: json["name_en"],
        bbsCode: json["bbs_code"],
        latitude: json["latitude"] is String? double.parse(json["latitude"]) : json["latitude"] ?? 0.0,
        longitude: json["longitude"] is String? double.parse(json["longitude"]) : json["longitude"] ?? 0.0,
        oldLatitude: json["old_latitude"],
        oldLongitude: json["old_longitude"],
        ngo: json["ngo"],
        url: json["url"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "district_name": districtName,
        "district_id": districtId,
        "division_id": divisionId,
        "id": id,
        "name_bn": nameBn,
        "name_en": nameEn,
        "bbs_code": bbsCode,
        "latitude": latitude,
        "longitude": longitude,
        "old_latitude": oldLatitude,
        "old_longitude": oldLongitude,
        "ngo": ngo,
        "url": url,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Division {
  int? id;
  int? divisionId;
  String? divisionName;
  String? nameBn;
  String? nameEn;
  dynamic bbsCode;
  double? latitude;
  double? longitude;
  dynamic url;
  DateTime? createdAt;
  DateTime? updatedAt;

  Division({
    this.divisionId,
    this.divisionName,
    this.id,
    this.nameBn,
    this.nameEn,
    this.bbsCode,
     this.latitude,
     this.longitude,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  factory Division.fromJson(Map<String, dynamic> json) => Division(
        divisionId: json["division_id"],
        divisionName: json["division_name"],
        id: json["id"],
        nameBn: json["name_bn"],
        nameEn: json["name_en"],
        bbsCode: json["bbs_code"],
        latitude: json["latitude"] is String ? double.parse(json["latitude"]) : json["latitude"] ?? 0.0,
        longitude: json["longitude"] is String ? double.parse(json["longitude"]) : json["longitude"] ?? 0.0,
        url: json["url"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),

  );

  Map<String, dynamic> toJson() => {
        "division_id": divisionId,
        "division_name": divisionName,
        "id": id,
        "name_bn": nameBn,
        "name_en": nameEn,
        "bbs_code": bbsCode,
        "latitude": latitude,
        "longitude": longitude,
        "url": url,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Union {
  int? unionId;
  String? unionName;
  int? id;
  int? divisionId;
  int? districtId;
  int? upazilaId;
  String? nameBn;
  String? nameEn;
  dynamic bbsCode;
  double? latitude;
  double? longitude;
  int? phase;
  int? isVcmisActivated;
  dynamic url;
  dynamic activatedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  Union({
    this.unionId,
    this.unionName,
    this.id,
    this.divisionId,
    this.districtId,
    this.upazilaId,
    this.nameBn,
    this.nameEn,
    this.bbsCode,
     this.latitude,
     this.longitude,
    this.phase,
    this.isVcmisActivated,
    this.url,
    this.activatedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Union.fromJson(Map<String, dynamic> json) => Union(
        unionId: json["union_id"],
        unionName: json["union_name"],
        id: json["id"],
        divisionId: json["division_id"],
        districtId: json["district_id"],
        upazilaId: json["upazila_id"],
        nameBn: json["name_bn"],
        nameEn: json["name_en"],
        bbsCode: json["bbs_code"],
        latitude: json["latitude"] is String ? double.parse(json["latitude"]) : json["latitude"] ?? 0.0,
        longitude: json["longitude"]  is String ? double.parse(json["longitude"]) : json["longitude"] ?? 0.0,
        phase: json["phase"],
        isVcmisActivated: json["is_vcmis_activated"],
        url: json["url"],
        activatedAt: json["activated_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "union_id": unionId,
        "union_name": unionName,
        "id": id,
        "division_id": divisionId,
        "district_id": districtId,
        "upazila_id": upazilaId,
        "name_bn": nameBn,
        "name_en": nameEn,
        "bbs_code": bbsCode,
        "latitude": latitude,
        "longitude": longitude,
        "phase": phase,
        "is_vcmis_activated": isVcmisActivated,
        "url": url,
        "activated_at": activatedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Upazila {
  String? upazilaName;
  int? upazilaId;
  int? districtId;
  int? id;
  int? divisionId;
  String? nameBn;
  String? nameEn;
  dynamic bbsCode;
  double? latitude;
  double? longitude;
  dynamic url;
  DateTime? createdAt;
  DateTime? updatedAt;
  Upazila({
    this.upazilaName,
    this.upazilaId,
    this.districtId,
    this.id,
    this.divisionId,
    this.nameBn,
    this.nameEn,
    this.bbsCode,
     this.latitude,
     this.longitude,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  factory Upazila.fromJson(Map<String, dynamic> json) => Upazila(
        upazilaName: json["upazila_name"],
        upazilaId: json["upazila_id"],
        id: json["id"],
        divisionId: json["division_id"],
        districtId: json["district_id"],
        nameBn: json["name_bn"],
        nameEn: json["name_en"],
        bbsCode: json["bbs_code"],
        latitude: json["latitude"] is String? double.parse(json["latitude"]) : json["latitude"] ?? 0.0,
        longitude: json["longitude"] is String? double.parse(json["longitude"]) : json["longitude"] ?? 0.0,
        url: json["url"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),

  );

  Map<String, dynamic> toJson() => {
        "upazila_name": upazilaName,
        "upazila_id": upazilaId,
        "id": id,
        "division_id": divisionId,
        "district_id": districtId,
        "name_bn": nameBn,
        "name_en": nameEn,
        "bbs_code": bbsCode,
        "latitude": latitude,
        "longitude": longitude,
        "url": url,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
