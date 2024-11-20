import 'dart:convert';

class FootprintResponseModel {
  int? id;
  int? visitorId;
  int? divisionId;
  int? districtId;
  int? upazilaId;
  int? unionId;
  int? officeTypeId;
  DateTime? visitDate;
  String? latitude;
  String? longitude;
  User? user;
  District? division;
  District? district;
  District? upazila;
  District? union;
  Type? officeType;
  List<FieldVisitPhoto>? fieldVisitPhotos;

  FootprintResponseModel({
    this.id,
    this.visitorId,
    this.divisionId,
    this.districtId,
    this.upazilaId,
    this.unionId,
    this.officeTypeId,
    this.visitDate,
    this.latitude,
    this.longitude,
    this.user,
    this.division,
    this.district,
    this.upazila,
    this.union,
    this.officeType,
    this.fieldVisitPhotos,
  });

  FootprintResponseModel copyWith({
    int? id,
    int? visitorId,
    int? divisionId,
    int? districtId,
    int? upazilaId,
    int? unionId,
    int? officeTypeId,
    DateTime? visitDate,
    String? latitude,
    String? longitude,
    User? user,
    District? division,
    District? district,
    District? upazila,
    District? union,
    Type? officeType,
    List<FieldVisitPhoto>? fieldVisitPhotos,
  }) =>
      FootprintResponseModel(
        id: id ?? this.id,
        visitorId: visitorId ?? this.visitorId,
        divisionId: divisionId ?? this.divisionId,
        districtId: districtId ?? this.districtId,
        upazilaId: upazilaId ?? this.upazilaId,
        unionId: unionId ?? this.unionId,
        officeTypeId: officeTypeId ?? this.officeTypeId,
        visitDate: visitDate ?? this.visitDate,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        user: user ?? this.user,
        division: division ?? this.division,
        district: district ?? this.district,
        upazila: upazila ?? this.upazila,
        union: union ?? this.union,
        officeType: officeType ?? this.officeType,
        fieldVisitPhotos: fieldVisitPhotos ?? this.fieldVisitPhotos,
      );

  factory FootprintResponseModel.fromRawJson(String str) => FootprintResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FootprintResponseModel.fromJson(Map<String, dynamic> json) => FootprintResponseModel(
    id: json["id"],
    visitorId: json["visitor_id"],
    divisionId: json["division_id"],
    districtId: json["district_id"],
    upazilaId: json["upazila_id"],
    unionId: json["union_id"],
    officeTypeId: json["office_type_id"],
    visitDate: json["visit_date"] == null ? null : DateTime.parse(json["visit_date"]),
    latitude: json["latitude"],
    longitude: json["longitude"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    division: json["division"] == null ? null : District.fromJson(json["division"]),
    district: json["district"] == null ? null : District.fromJson(json["district"]),
    upazila: json["upazila"] == null ? null : District.fromJson(json["upazila"]),
    union: json["union"] == null ? null : District.fromJson(json["union"]),
    officeType: json["office_type"] == null ? null : Type.fromJson(json["office_type"]),
    fieldVisitPhotos: json["field_visit_photos"] == null ? [] : List<FieldVisitPhoto>.from(json["field_visit_photos"]!.map((x) => FieldVisitPhoto.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "visitor_id": visitorId,
    "division_id": divisionId,
    "district_id": districtId,
    "upazila_id": upazilaId,
    "union_id": unionId,
    "office_type_id": officeTypeId,
    "visit_date": "${visitDate!.year.toString().padLeft(4, '0')}-${visitDate!.month.toString().padLeft(2, '0')}-${visitDate!.day.toString().padLeft(2, '0')}",
    "latitude": latitude,
    "longitude": longitude,
    "user": user?.toJson(),
    "division": division?.toJson(),
    "district": district?.toJson(),
    "upazila": upazila?.toJson(),
    "union": union?.toJson(),
    "office_type": officeType?.toJson(),
    "field_visit_photos": fieldVisitPhotos == null ? [] : List<dynamic>.from(fieldVisitPhotos!.map((x) => x.toJson())),
  };
}

class District {
  int? id;
  String? nameEn;

  District({
    this.id,
    this.nameEn,
  });

  District copyWith({
    int? id,
    String? nameEn,
  }) =>
      District(
        id: id ?? this.id,
        nameEn: nameEn ?? this.nameEn,
      );

  factory District.fromRawJson(String str) => District.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory District.fromJson(Map<String, dynamic> json) => District(
    id: json["id"],
    nameEn: json["name_en"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_en": nameEn,
  };
}

class FieldVisitPhoto {
  int? id;
  String? photo;
  int? fieldVisitId;

  FieldVisitPhoto({
    this.id,
    this.photo,
    this.fieldVisitId,
  });

  FieldVisitPhoto copyWith({
    int? id,
    String? photo,
    int? fieldVisitId,
  }) =>
      FieldVisitPhoto(
        id: id ?? this.id,
        photo: photo ?? this.photo,
        fieldVisitId: fieldVisitId ?? this.fieldVisitId,
      );

  factory FieldVisitPhoto.fromRawJson(String str) => FieldVisitPhoto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FieldVisitPhoto.fromJson(Map<String, dynamic> json) => FieldVisitPhoto(
    id: json["id"],
    photo: json["photo"],
    fieldVisitId: json["field_visit_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "photo": photo,
    "field_visit_id": fieldVisitId,
  };
}

class Type {
  int? id;
  String? name;

  Type({
    this.id,
    this.name,
  });

  Type copyWith({
    int? id,
    String? name,
  }) =>
      Type(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Type.fromRawJson(String str) => Type.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class User {
  int? id;
  String? name;
  int? userTypeId;
  Type? userType;

  User({
    this.id,
    this.name,
    this.userTypeId,
    this.userType,
  });

  User copyWith({
    int? id,
    String? name,
    int? userTypeId,
    Type? userType,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        userTypeId: userTypeId ?? this.userTypeId,
        userType: userType ?? this.userType,
      );

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    userTypeId: json["user_type_id"],
    userType: json["user_type"] == null ? null : Type.fromJson(json["user_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "user_type_id": userTypeId,
    "user_type": userType?.toJson(),
  };
}
