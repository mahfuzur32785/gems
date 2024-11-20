// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
    Data ? data;
    String message;
    int status;

    ProfileModel({
         this.data,
        required this.message,
        required this.status,
    });

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        data: Data.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
        "message": message,
        "status": status,
    };
}

class Data {
    int? id;
    String? name;
    String? mobile;
    String? email;
    String? userName;
    String? role;
    String? userLevel;
    String? userType;
    String? ngo;
    List<District>? district;

    Data({this.id, this.name, this.mobile, this.email, this.userName, this.role, this.userLevel, this.userType, this.ngo, this.district,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        mobile: json["mobile"],
        email: json["email"],
        userName: json["user_name"],
        role: json["role"],
        userLevel: json["user_level"],
        userType: json["user_type"],
        ngo: json["ngo"],
        district: json["district"] == null ? [] : List<District>.from(json["district"]!.map((x) => District.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile": mobile,
        "email": email,
        "user_name": userName,
        "role": role,
        "user_level": userLevel,
        "user_type": userType,
        "ngo": ngo,
        "district": district == null ? [] : List<dynamic>.from(district!.map((x) => x!.toJson())),
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
