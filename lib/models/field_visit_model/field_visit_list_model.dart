// To parse this JSON data, do
//
//     final fieldVisitListModel = fieldVisitListModelFromJson(jsonString);

import 'dart:convert';

FieldVisitListModel fieldVisitListModelFromJson(String str) => FieldVisitListModel.fromJson(json.decode(str));

String fieldVisitListModelToJson(FieldVisitListModel data) => json.encode(data.toJson());

class FieldVisitListModel {
  int status;
  String message;
  List<FieldVisitData> data;
  Pagination? pagination;

  FieldVisitListModel({
    required this.status,
    required this.message,
    required this.data,
    this.pagination,
  });

  factory FieldVisitListModel.fromJson(Map<String, dynamic> json) => FieldVisitListModel(
        status: json["status"],
        message: json["message"],
        data: List<FieldVisitData>.from(json["data"].map((x) => FieldVisitData.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "pagination": pagination!.toJson(),
      };
}

class FieldVisitData {
  int? id;
  int? status;
  String? division;
  String? district;
  String? upazila;
  String? union;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? visitDate;
  String? officeType;
  String? officeTitle;

  FieldVisitData(
      {this.id,
      this.status,
      this.division,
      this.district,
      this.upazila,
      this.union,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.visitDate,
      this.officeType,
      this.officeTitle});

  FieldVisitData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'] is String ? int.parse(json['status']) : json['status'];
    division = json['division'];
    district = json['district'];
    upazila = json['upazila'];
    union = json['union'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    visitDate = json['visit_date'];
    officeType = json['office_type'];
    officeTitle = json['office_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['division'] = this.division;
    data['district'] = this.district;
    data['upazila'] = this.upazila;
    data['union'] = this.union;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['created_at'] = this.createdAt;
    data['visit_date'] = this.visitDate;
    data['office_type'] = this.officeType;
    data['office_title'] = this.officeTitle;
    return data;
  }
}

class Pagination {
  int? currentPage;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  dynamic? nextPageUrl;
  int? perPage;
  dynamic? prevPageUrl;
  int? to;
  int? total;

  Pagination({
    this.currentPage,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: json["current_page"],
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}
