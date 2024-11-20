import 'dart:convert';

import 'package:village_court_gems/models/locationModel.dart';

class TrainingEditModel {
  List<Datum>? data;
  List<Activation>? activations;
  List<Maintenance>? maintenances;
  int? subTotalActivationFemale;
  int? subTotalActivationMale;
  int? subTotalActivationTotal;
  int? subTotalMaintenanceFemale;
  int? subTotalMaintenanceMale;
  int? subTotalMaintenanceTotal;
  List<Activation>? minorityActivations;
  List<Maintenance>? minorityMaintenances;
  int? subTotalMinorityActivationFemale;
  int? subTotalMinorityActivationMale;
  int? subTotalMinorityActivationTotal;
  int? subTotalMinorityMaintenanceFemale;
  int? subTotalMinorityMaintenanceMale;
  int? subTotalMinorityMaintenanceTotal;
  int? status;
  String? message;

  TrainingEditModel({
    this.data,
    this.activations,
    this.maintenances,
    this.subTotalActivationFemale,
    this.subTotalActivationMale,
    this.subTotalActivationTotal,
    this.subTotalMaintenanceFemale,
    this.subTotalMaintenanceMale,
    this.subTotalMaintenanceTotal,
    this.minorityActivations,
    this.minorityMaintenances,
    this.subTotalMinorityActivationFemale,
    this.subTotalMinorityActivationMale,
    this.subTotalMinorityActivationTotal,
    this.subTotalMinorityMaintenanceFemale,
    this.subTotalMinorityMaintenanceMale,
    this.subTotalMinorityMaintenanceTotal,
    this.status,
    this.message,
  });

  factory TrainingEditModel.fromRawJson(String str) => TrainingEditModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TrainingEditModel.fromJson(Map<String, dynamic> json) => TrainingEditModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    activations: json["activations"] == null ? [] : List<Activation>.from(json["activations"]!.map((x) => Activation.fromJson(x))),
    maintenances: json["maintenances"] == null ? [] : List<Maintenance>.from(json["maintenances"]!.map((x) => Maintenance.fromJson(x))),
    subTotalActivationFemale: json["sub_total_activation_female"],
    subTotalActivationMale: json["sub_total_activation_male"],
    subTotalActivationTotal: json["sub_total_activation_total"],
    subTotalMaintenanceFemale: json["sub_total_maintenance_female"],
    subTotalMaintenanceMale: json["sub_total_maintenance_male"],
    subTotalMaintenanceTotal: json["sub_total_maintenance_total"],
    minorityActivations: json["minority_activations"] == null ? [] : List<Activation>.from(json["minority_activations"]!.map((x) => Activation.fromJson(x))),
    minorityMaintenances: json["minority_maintenances"] == null ? [] : List<Maintenance>.from(json["minority_maintenances"]!.map((x) => Maintenance.fromJson(x))),
    subTotalMinorityActivationFemale: json["sub_total_minority_activation_female"],
    subTotalMinorityActivationMale: json["sub_total_minority_activation_male"],
    subTotalMinorityActivationTotal: json["sub_total__minority_activation_total"],
    subTotalMinorityMaintenanceFemale: json["sub_total_minority_maintenance_female"],
    subTotalMinorityMaintenanceMale: json["sub_total_minority_maintenance_male"],
    subTotalMinorityMaintenanceTotal: json["sub_total_minority_maintenance_total"],
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "activations": activations == null ? [] : List<dynamic>.from(activations!.map((x) => x.toJson())),
    "maintenances": maintenances == null ? [] : List<dynamic>.from(maintenances!.map((x) => x.toJson())),
    "sub_total_activation_female": subTotalActivationFemale,
    "sub_total_activation_male": subTotalActivationMale,
    "sub_total_activation_total": subTotalActivationTotal,
    "sub_total_maintenance_female": subTotalMaintenanceFemale,
    "sub_total_maintenance_male": subTotalMaintenanceMale,
    "sub_total_maintenance_total": subTotalMaintenanceTotal,
    "minority_activations": minorityActivations == null ? [] : List<dynamic>.from(minorityActivations!.map((x) => x.toJson())),
    "minority_maintenances": minorityMaintenances == null ? [] : List<dynamic>.from(minorityMaintenances!.map((x) => x.toJson())),
    "sub_total_minority_activation_female": subTotalMinorityActivationFemale,
    "sub_total_minority_activation_male": subTotalMinorityActivationMale,
    "sub_total__minority_activation_total": subTotalMinorityActivationTotal,
    "sub_total_minority_maintenance_female": subTotalMinorityMaintenanceFemale,
    "sub_total_minority_maintenance_male": subTotalMinorityMaintenanceMale,
    "sub_total_minority_maintenance_total": subTotalMinorityMaintenanceTotal,
    "status": status,
    "message": message,
  };
}

class Activation {
  int? id;
  String? name;
  int? activationFemale;
  int? activationMale;
  int? activationTotal;

  Activation({
    this.id,
    this.name,
    this.activationFemale,
    this.activationMale,
    this.activationTotal,
  });

  factory Activation.fromRawJson(String str) => Activation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Activation.fromJson(Map<String, dynamic> json) => Activation(
    id: json["id"],
    name: json["name"],
    activationFemale: json["activation_female"],
    activationMale: json["activation_male"],
    activationTotal: json["activation_total"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "activation_female": activationFemale,
    "activation_male": activationMale,
    "activation_total": activationTotal,
  };
}

class Datum {
  int? id;
  int? locationId;
  int? trainingInfoSettingId;
  String? title;
  String? trainingFromDate;
  String? trainingToDate;
  String? trainingVenue;
  int? totalMale;
  int? totalFemale;
  int? totalParticipant;
  int? totalMinorityMale;
  int? totalMinorityFemale;
  int? totalMinorityParticipant;
  String? latitude;
  String? longitude;
  String? remark;
  List<Division>? divisions;
  List<District>? districts;
  List<Upazila>? upazilas;
  List<Union>? unions;
  String? selectedDisId;
  String? selectedDivId;
  String? selectedUpaId;
  String? selectedUniId;
  LocationLabel? locationLabel;

  Datum({
    this.id,
    this.locationId,
    this.trainingInfoSettingId,
    this.title,
    this.trainingFromDate,
    this.trainingToDate,
    this.trainingVenue,
    this.totalMale,
    this.totalFemale,
    this.totalParticipant,
    this.totalMinorityMale,
    this.totalMinorityFemale,
    this.totalMinorityParticipant,
    this.latitude,
    this.longitude,
    this.remark,
    this.divisions,
    this.districts,
    this.upazilas,
    this.unions,
    this.selectedDisId,
    this.selectedDivId,
    this.selectedUpaId,
    this.selectedUniId,
    this.locationLabel,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    locationId: json["location_id"],
    trainingInfoSettingId: json["training_info_setting_id"],
    title: json["title"],
    trainingFromDate: json["training_from_date"],
    trainingToDate: json["training_to_date"],
    trainingVenue: json["training_venue"],
    totalMale: json["total_male"],
    totalFemale: json["total_female"],
    totalParticipant: json["total_participant"],
    totalMinorityMale: json["total_minority_male"],
    totalMinorityFemale: json["total_minority_female"],
    totalMinorityParticipant: json["total_minority_participant"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    remark: json["remark"],
    divisions: json["divisions"] == null ? [] : List<Division>.from(json["divisions"]!.map((x) => Division.fromJson(x))),
    districts: json["districts"] == null ? [] : List<District>.from(json["districts"]!.map((x) => District.fromJson(x))),
    upazilas: json["upazilas"] == null ? [] : List<Upazila>.from(json["upazilas"]!.map((x) => Upazila.fromJson(x))),
    unions: json["unions"] == null ? [] : List<Union>.from(json["unions"]!.map((x) => Union.fromJson(x))),
    selectedDisId: json["selected_dis_id"] is int ? json["selected_dis_id"].toString() : json["selected_dis_id"],
    selectedDivId: json["selected_div_id"] is int ? json["selected_div_id"].toString() : json["selected_div_id"],
    selectedUpaId: json["selected_upa_id"] is int ? json["selected_upa_id"].toString() : json["selected_upa_id"],
    selectedUniId: json["selected_uni_id"] is int ? json["selected_uni_id"].toString() : json["selected_uni_id"],
    locationLabel: LocationLabel.fromJson(json["location_levels"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "location_id": locationId,
    "training_info_setting_id": trainingInfoSettingId,
    "title": title,
    "training_from_date": trainingFromDate,
    "training_to_date": trainingToDate,
    "training_venue": trainingVenue,
    "total_male": totalMale,
    "total_female": totalFemale,
    "total_participant": totalParticipant,
    "total_minority_male": totalMinorityMale,
    "total_minority_female": totalMinorityFemale,
    "total_minority_participant": totalMinorityParticipant,
    "latitude": latitude,
    "longitude": longitude,
    "remark": remark,
    "divisions": divisions == null ? [] : List<dynamic>.from(divisions!.map((x) => x.toJson())),
    "districts": districts == null ? [] : List<dynamic>.from(districts!.map((x) =>  x.toJson())),
    "upazilas": upazilas == null ? [] : List<dynamic>.from(upazilas!.map((x) =>  x.toJson())),
    "unions": unions == null ? [] : List<dynamic>.from(unions!.map((x) =>  x.toJson())),
    "selected_dis_id": selectedDisId,
    "selected_div_id": selectedDivId,
    "selected_upa_id": selectedUpaId,
    "selected_uni_id": selectedUniId,
    "location_levels": locationLabel!.toJson(),
  };
}

class LocationLabel {
  int? id;
  String? name;

  LocationLabel({
    this.id,
    this.name,
  });

  LocationLabel copyWith({
    int? id,
    String? name,
  }) =>
      LocationLabel(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory LocationLabel.fromRawJson(String str) => LocationLabel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LocationLabel.fromJson(Map<String, dynamic> json) => LocationLabel(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

// class Division {
//   int? id;
//   String? nameBn;
//   String? nameEn;
//   dynamic bbsCode;
//   dynamic latitude;
//   dynamic longitude;
//   dynamic url;
//   dynamic createdAt;
//   dynamic updatedAt;
//
//   Division({
//     this.id,
//     this.nameBn,
//     this.nameEn,
//     this.bbsCode,
//     this.latitude,
//     this.longitude,
//     this.url,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory Division.fromRawJson(String str) => Division.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Division.fromJson(Map<String, dynamic> json) => Division(
//     id: json["id"],
//     nameBn: json["name_bn"],
//     nameEn: json["name_en"],
//     bbsCode: json["bbs_code"],
//     latitude: json["latitude"],
//     longitude: json["longitude"],
//     url: json["url"],
//     createdAt: json["created_at"],
//     updatedAt: json["updated_at"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name_bn": nameBn,
//     "name_en": nameEn,
//     "bbs_code": bbsCode,
//     "latitude": latitude,
//     "longitude": longitude,
//     "url": url,
//     "created_at": createdAt,
//     "updated_at": updatedAt,
//   };
// }

class Maintenance {
  int? id;
  String? name;
  int? maintenanceFemale;
  int? maintenanceMale;
  int? maintenanceTotal;

  Maintenance({
    this.id,
    this.name,
    this.maintenanceFemale,
    this.maintenanceMale,
    this.maintenanceTotal,
  });

  factory Maintenance.fromRawJson(String str) => Maintenance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Maintenance.fromJson(Map<String, dynamic> json) => Maintenance(
    id: json["id"],
    name: json["name"],
    maintenanceFemale: json["maintenance_female"],
    maintenanceMale: json["maintenance_male"],
    maintenanceTotal: json["maintenance_total"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "maintenance_female": maintenanceFemale,
    "maintenance_male": maintenanceMale,
    "maintenance_total": maintenanceTotal,
  };
}
