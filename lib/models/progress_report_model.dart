import 'dart:convert';

class ProgressReportModel {
  Data? data;
  String? search;
  int? status;
  String? message;

  ProgressReportModel({
    this.data,
    this.search,
    this.status,
    this.message,
  });

  ProgressReportModel copyWith({
    Data? data,
    String? search,
    int? status,
    String? message,
  }) =>
      ProgressReportModel(
        data: data ?? this.data,
        search: search ?? this.search,
        status: status ?? this.status,
        message: message ?? this.message,
      );

  factory ProgressReportModel.fromRawJson(String str) => ProgressReportModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProgressReportModel.fromJson(Map<String, dynamic> json) => ProgressReportModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    search: json["search"],
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "search": search,
    "status": status,
    "message": message,
  };
}

class Data {
  int? currentPage;
  List<ProgressData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Data({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  Data copyWith({
    int? currentPage,
    List<ProgressData>? data,
    String? firstPageUrl,
    int? from,
    int? lastPage,
    String? lastPageUrl,
    List<Link>? links,
    dynamic nextPageUrl,
    String? path,
    int? perPage,
    dynamic prevPageUrl,
    int? to,
    int? total,
  }) =>
      Data(
        currentPage: currentPage ?? this.currentPage,
        data: data ?? this.data,
        firstPageUrl: firstPageUrl ?? this.firstPageUrl,
        from: from ?? this.from,
        lastPage: lastPage ?? this.lastPage,
        lastPageUrl: lastPageUrl ?? this.lastPageUrl,
        links: links ?? this.links,
        nextPageUrl: nextPageUrl ?? this.nextPageUrl,
        path: path ?? this.path,
        perPage: perPage ?? this.perPage,
        prevPageUrl: prevPageUrl ?? this.prevPageUrl,
        to: to ?? this.to,
        total: total ?? this.total,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<ProgressData>.from(json["data"]!.map((x) => ProgressData.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class ProgressData {
  int? id;
  int? month;
  String? year;
  String? reportDate;
  dynamic userType;
  int? userId;
  int? districtId;
  int? upazilaId;
  int? ngoId;
  String? status;
  dynamic comment;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  District? district;
  District? upazila;
  District? ngo;
  User? user;

  ProgressData({
    this.id,
    this.month,
    this.year,
    this.reportDate,
    this.userType,
    this.userId,
    this.districtId,
    this.upazilaId,
    this.ngoId,
    this.status,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.district,
    this.upazila,
    this.ngo,
    this.user,
  });

  ProgressData copyWith({
    int? id,
    int? month,
    String? year,
    String? reportDate,
    dynamic userType,
    int? userId,
    int? districtId,
    int? upazilaId,
    int? ngoId,
    String? status,
    dynamic comment,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
    District? district,
    District? upazila,
    District? ngo,
    User? user,
  }) =>
      ProgressData(
        id: id ?? this.id,
        month: month ?? this.month,
        year: year ?? this.year,
        reportDate: reportDate ?? this.reportDate,
        userType: userType ?? this.userType,
        userId: userId ?? this.userId,
        districtId: districtId ?? this.districtId,
        upazilaId: upazilaId ?? this.upazilaId,
        ngoId: ngoId ?? this.ngoId,
        status: status ?? this.status,
        comment: comment ?? this.comment,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        district: district ?? this.district,
        upazila: upazila ?? this.upazila,
        ngo: ngo ?? this.ngo,
        user: user ?? this.user,
      );

  factory ProgressData.fromRawJson(String str) => ProgressData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProgressData.fromJson(Map<String, dynamic> json) => ProgressData(
    id: json["id"],
    month: json["month"],
    year: json["year"],
    reportDate: json["report_date"],
    userType: json["user_type"],
    userId: json["user_id"],
    districtId: json["district_id"],
    upazilaId: json["upazila_id"],
    ngoId: json["ngo_id"],
    status: json["status"],
    comment: json["comment"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    district: json["district"] == null ? null : District.fromJson(json["district"]),
    upazila: json["upazila"] == null ? null : District.fromJson(json["upazila"]),
    ngo: json["ngo"] == null ? null : District.fromJson(json["ngo"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "month": month,
    "year": year,
    "report_date": reportDate,
    "user_type": userType,
    "user_id": userId,
    "district_id": districtId,
    "upazila_id": upazilaId,
    "ngo_id": ngoId,
    "status": status,
    "comment": comment,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "district": district?.toJson(),
    "upazila": upazila?.toJson(),
    "ngo": ngo?.toJson(),
    "user": user?.toJson(),
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

class User {
  int? id;
  String? name;
  int? userTypeId;
  UserType? userType;

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
    UserType? userType,
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
    userType: json["user_type"] == null ? null : UserType.fromJson(json["user_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "user_type_id": userTypeId,
    "user_type": userType?.toJson(),
  };
}

class UserType {
  int? id;
  String? name;

  UserType({
    this.id,
    this.name,
  });

  UserType copyWith({
    int? id,
    String? name,
  }) =>
      UserType(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory UserType.fromRawJson(String str) => UserType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserType.fromJson(Map<String, dynamic> json) => UserType(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  Link copyWith({
    String? url,
    String? label,
    bool? active,
  }) =>
      Link(
        url: url ?? this.url,
        label: label ?? this.label,
        active: active ?? this.active,
      );

  factory Link.fromRawJson(String str) => Link.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
