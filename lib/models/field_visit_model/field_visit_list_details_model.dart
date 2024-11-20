// To parse this JSON data, do
//
//     final fieldVisitListDetailsModel = fieldVisitListDetailsModelFromJson(jsonString);

import 'dart:convert';

FieldVisitListDetailsModel fieldVisitListDetailsModelFromJson(String str) =>
    FieldVisitListDetailsModel.fromJson(json.decode(str));

String fieldVisitListDetailsModelToJson(FieldVisitListDetailsModel data) => json.encode(data.toJson());

class FieldVisitListDetailsModel {
  int? status;
  String? message;
  List<Visit>? visit;
  List<FieldFinding>? fieldFindings;

  FieldVisitListDetailsModel({
     this.status,
     this.message,
     this.visit,
     this.fieldFindings,
  });

  factory FieldVisitListDetailsModel.fromJson(Map<String, dynamic> json) => FieldVisitListDetailsModel(
        status: json["status"],
        message: json["message"],
        visit: json["visit"] == null ? [] : List<Visit>.from(json["visit"]!.map((x) => Visit.fromJson(x))),
        
        fieldFindings:json['field_findings'] != null ? List<FieldFinding>.from(json["field_findings"].map((x) => FieldFinding.fromJson(x))) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "visit": visit?.map((x) => x.toJson()).toList(),
        "field_findings": fieldFindings?.map((x) => x.toJson()).toList()
      };
}

class FieldFinding {
  String? question;
  int? questionId;
  List<QuestionAnswer>? questionAnswer;

  FieldFinding({
     this.question,
     this.questionId,
     this.questionAnswer,
  });

  factory FieldFinding.fromJson(Map<String, dynamic> json) => FieldFinding(
        question: json["question"],
        questionId: json["question_id"],
        questionAnswer: List<QuestionAnswer>.from(json["question_answer"].map((x) => QuestionAnswer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "question_id": questionId,
        "question_answer": questionAnswer != null ? List<dynamic>.from(questionAnswer!.map((x) => x.toJson())) : null,
      };
}

class QuestionAnswer {
  String? answer;

  QuestionAnswer({
     this.answer,
  });

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) => QuestionAnswer(
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "answer": answer,
      };
}

class Visit {
  int? id;
  String? visitor;
  String? division;
  String? district;
  String? upazila;
  String? union;
  String? latitude;
  String? longitude;
  String? locationName;
  DateTime? visitDate;
  String? visitPurpose;
  List<Photo>? photo;

  Visit({
     this.id,
     this.visitor,
     this.division,
     this.district,
     this.upazila,
     this.union,
     this.latitude,
     this.longitude,
     this.locationName,
     this.visitDate,
     this.visitPurpose,
     this.photo,
  });

  factory Visit.fromJson(Map<String, dynamic> json) => Visit(
        id: json["id"],
        visitor: json["visitor"],
        division: json["division"],
        district: json["district"],
        upazila: json["upazila"],
        union: json["union"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        locationName: json["location_name"],
        visitDate: DateTime.parse(json["visit_date"]),
        visitPurpose: json["visit_purpose"],
        photo: json["photo"] == null ? [] : List<Photo>.from(json["photo"]!.map((x) => Photo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "visitor": visitor,
        "division": division,
        "district": district,
        "upazila": upazila,
        "union": union,
        "latitude": latitude,
        "longitude": longitude,
        "location_name": locationName,
        "visit_date":
            "${visitDate?.year.toString().padLeft(4, '0')}-${visitDate?.month.toString().padLeft(2, '0')}-${visitDate?.day.toString().padLeft(2, '0')}",
        "visit_purpose": visitPurpose,
        "photo":  photo?.map((x) => x.toJson()).toList(),
      };
}

class Photo {
  int? id;
  int? fieldVisitId;
  String? photo;
  String? createdAt;
  String? updatedAt;

  Photo(
      {this.id, this.fieldVisitId, this.photo, this.createdAt, this.updatedAt});

  Photo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fieldVisitId = json['field_visit_id'];
    photo = json['photo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['field_visit_id'] = this.fieldVisitId;
    data['photo'] = this.photo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
