// To parse this JSON data, do
//
//     final trainingModel = trainingModelFromJson(jsonString);

import 'dart:convert';

import 'package:village_court_gems/models/new_TraningModel.dart';

TrainingModel trainingModelFromJson(String str) => TrainingModel.fromJson(json.decode(str));

String trainingModelToJson(TrainingModel data) => json.encode(data.toJson());

class TrainingModel {
  List<AllTrainingData> data;
  int status;
  String message;

  TrainingModel({
    required this.data,
    required this.status,
    required this.message,
  });

  factory TrainingModel.fromJson(Map<String, dynamic> json) => TrainingModel(
        data: List<AllTrainingData>.from(json["data"].map((x) => AllTrainingData.fromJson(x))),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
      };
}

// class TrainingInfoModel {
//   int id;
//   String title;
//   int count;
//   Component component;
//   Component locationLevel;
//   Map<String, String> divisions;
//   List<TrainingInfoParticipant> trainingInfoParticipants;
//
//   TrainingInfoModel({
//     required this.id,
//     required this.title,
//     required this.count,
//     required this.component,
//     required this.locationLevel,
//     required this.divisions,
//     required this.trainingInfoParticipants,
//   });
//
//   factory TrainingInfoModel.fromJson(Map<String, dynamic> json) => TrainingInfoModel(
//         id: json["id"],
//         title: json["title"],
//         count: json["count"],
//         component: Component.fromJson(json["component"]),
//         locationLevel: Component.fromJson(json["location_level"]),
//         divisions: Map.from(json["divisions"]).map((k, v) => MapEntry<String, String>(k, v)),
//         trainingInfoParticipants: List<TrainingInfoParticipant>.from(
//             json["training_info_participants_activation"].map((x) => TrainingInfoParticipant.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//         "count": count,
//         "component": component.toJson(),
//         "location_level": locationLevel.toJson(),
//         "divisions": Map.from(divisions).map((k, v) => MapEntry<String, dynamic>(k, v)),
//         "training_info_participants_activation": List<dynamic>.from(trainingInfoParticipants.map((x) => x.toJson())),
//       };
// }
//
// class Component {
//   int id;
//   String name;
//
//   Component({
//     required this.id,
//     required this.name,
//   });
//
//   factory Component.fromJson(Map<String, dynamic> json) => Component(
//         id: json["id"],
//         name: json["name"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//       };
// }
//
// class TrainingInfoParticipant {
//   int? id;
//   int? serialId;
//   String? name;
//   String? check;
//
//   TrainingInfoParticipant({
//     this.id,
//     this.serialId,
//     this.name,
//     this.check,
//   });
//
//   factory TrainingInfoParticipant.fromRawJson(String str) => TrainingInfoParticipant.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory TrainingInfoParticipant.fromJson(Map<String, dynamic> json) => TrainingInfoParticipant(
//     id: json["id"],
//     serialId: json["serial_id"],
//     name: json["name"],
//     check: json["check"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "serial_id": serialId,
//     "name": name,
//     "check": check,
//   };
// }
