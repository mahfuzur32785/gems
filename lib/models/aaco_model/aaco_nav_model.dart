class AacoNonAVListModel {
  int? status;
  List<AacoResult>? result;
  String? message;

  AacoNonAVListModel({this.status, this.result, this.message});

  AacoNonAVListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = <AacoResult>[];
      json['result'].forEach((v) {
        result!.add(new AacoResult.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class AacoResult {
  int? id;
  String? name;
  int? reasonType;
  String? description;
  String? createdAt;
  String? updatedAt;

  AacoResult(
      {this.id,
      this.name,
      this.reasonType,
      this.description,
      this.createdAt,
      this.updatedAt});

  AacoResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    reasonType = json['reason_type'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['reason_type'] = this.reasonType;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}