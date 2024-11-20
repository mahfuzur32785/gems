class OfficeTypeModel {
  List<OfficeTypeData>? data;
  int? status;
  String? message;

  OfficeTypeModel({this.data, this.status, this.message});

  OfficeTypeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <OfficeTypeData>[];
      json['data'].forEach((v) {
        data!.add(new OfficeTypeData.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class OfficeTypeData {
  int? id;
  String? name;
  dynamic createdAt;
  dynamic updatedAt;

  OfficeTypeData({this.id, this.name, this.createdAt, this.updatedAt});

  OfficeTypeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}