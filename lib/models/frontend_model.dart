import 'dart:convert';

class FrontendModel {
  int? trainingCount;
  int? fieldVisitCount;
  int? accoCount;
  int? activityCount;
  TrainingPieCharts? trainingPieCharts;
  FieldVisitPieCharts? fieldVisitPieCharts;

  FrontendModel({
    this.trainingCount,
    this.fieldVisitCount,
    this.accoCount,
    this.activityCount,
    this.trainingPieCharts,
    this.fieldVisitPieCharts,
  });

  FrontendModel copyWith({
    int? trainingCount,
    int? fieldVisitCount,
    int? accoCount,
    int? activityCount,
    TrainingPieCharts? trainingPieCharts,
    FieldVisitPieCharts? fieldVisitPieCharts,
  }) =>
      FrontendModel(
        trainingCount: trainingCount ?? this.trainingCount,
        fieldVisitCount: fieldVisitCount ?? this.fieldVisitCount,
        accoCount: accoCount ?? this.accoCount,
        activityCount: activityCount ?? this.activityCount,
        trainingPieCharts: trainingPieCharts ?? this.trainingPieCharts,
        fieldVisitPieCharts: fieldVisitPieCharts ?? this.fieldVisitPieCharts,
      );

  factory FrontendModel.fromRawJson(String str) => FrontendModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FrontendModel.fromJson(Map<String, dynamic> json) => FrontendModel(
    trainingCount: json["trainingCount"],
    fieldVisitCount: json["fieldVisitCount"],
    accoCount: json["accoCount"],
    activityCount: json["activityCount"],
    trainingPieCharts: json["trainingPieCharts"] == null ? null : TrainingPieCharts.fromJson(json["trainingPieCharts"]),
    fieldVisitPieCharts: json["fieldVisitPieCharts"] == null ? null : FieldVisitPieCharts.fromJson(json["fieldVisitPieCharts"]),
  );

  Map<String, dynamic> toJson() => {
    "trainingCount": trainingCount,
    "fieldVisitCount": fieldVisitCount,
    "accoCount": accoCount,
    "activityCount": activityCount,
    "trainingPieCharts": trainingPieCharts?.toJson(),
    "fieldVisitPieCharts": fieldVisitPieCharts?.toJson(),
  };
}

class FieldVisitPieCharts {
  int? dcDdlgOffices;
  int? unoOffices;
  int? upOffices;
  int? otherOffices;
  int? totalCounts;

  FieldVisitPieCharts({
    this.dcDdlgOffices,
    this.unoOffices,
    this.upOffices,
    this.otherOffices,
    this.totalCounts,
  });

  FieldVisitPieCharts copyWith({
    int? dcDdlgOffices,
    int? unoOffices,
    int? upOffices,
    int? otherOffices,
    int? totalCounts,
  }) =>
      FieldVisitPieCharts(
        dcDdlgOffices: dcDdlgOffices ?? this.dcDdlgOffices,
        unoOffices: unoOffices ?? this.unoOffices,
        upOffices: upOffices ?? this.upOffices,
        otherOffices: otherOffices ?? this.otherOffices,
        totalCounts: totalCounts ?? this.totalCounts,
      );

  factory FieldVisitPieCharts.fromRawJson(String str) => FieldVisitPieCharts.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FieldVisitPieCharts.fromJson(Map<String, dynamic> json) => FieldVisitPieCharts(
    dcDdlgOffices: json["dc_ddlg_offices"],
    unoOffices: json["uno_offices"],
    upOffices: json["up_offices"],
    otherOffices: json["other_offices"],
    totalCounts: json["totalCounts"],
  );

  Map<String, dynamic> toJson() => {
    "dc_ddlg_offices": dcDdlgOffices,
    "uno_offices": unoOffices,
    "up_offices": upOffices,
    "other_offices": otherOffices,
    "totalCounts": totalCounts,
  };
}

class TrainingPieCharts {
  String? totalMale;
  String? totalFemale;
  String? totalParticipant;
  String? totalMinorityMale;
  String? totalMinorityFemale;
  String? totalMinorityParticipant;

  TrainingPieCharts({
    this.totalMale,
    this.totalFemale,
    this.totalParticipant,
    this.totalMinorityMale,
    this.totalMinorityFemale,
    this.totalMinorityParticipant,
  });

  TrainingPieCharts copyWith({
    String? totalMale,
    String? totalFemale,
    String? totalParticipant,
    String? totalMinorityMale,
    String? totalMinorityFemale,
    String? totalMinorityParticipant,
  }) =>
      TrainingPieCharts(
        totalMale: totalMale ?? this.totalMale,
        totalFemale: totalFemale ?? this.totalFemale,
        totalParticipant: totalParticipant ?? this.totalParticipant,
        totalMinorityMale: totalMinorityMale ?? this.totalMinorityMale,
        totalMinorityFemale: totalMinorityFemale ?? this.totalMinorityFemale,
        totalMinorityParticipant: totalMinorityParticipant ?? this.totalMinorityParticipant,
      );

  factory TrainingPieCharts.fromRawJson(String str) => TrainingPieCharts.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TrainingPieCharts.fromJson(Map<String, dynamic> json) => TrainingPieCharts(
    totalMale: json["total_male"],
    totalFemale: json["total_female"],
    totalParticipant: json["total_participant"],
    totalMinorityMale: json["total_minority_male"],
    totalMinorityFemale: json["total_minority_female"],
    totalMinorityParticipant: json["total_minority_participant"],
  );

  Map<String, dynamic> toJson() => {
    "total_male": totalMale,
    "total_female": totalFemale,
    "total_participant": totalParticipant,
    "total_minority_male": totalMinorityMale,
    "total_minority_female": totalMinorityFemale,
    "total_minority_participant": totalMinorityParticipant,
  };
}
