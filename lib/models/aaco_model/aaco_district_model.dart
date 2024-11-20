class AacoDistListModel {
  String? status;
  List<AacoDistricts>? districts;
  String? message;

  AacoDistListModel({this.status, this.districts, this.message});

  AacoDistListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['districts'] != null) {
      districts = <AacoDistricts>[];
      json['districts'].forEach((v) {
        districts!.add(new AacoDistricts.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.districts != null) {
      data['districts'] = this.districts!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class AacoDistricts {
  String? nameEn;
  int? id;

  AacoDistricts({this.nameEn, this.id});

  AacoDistricts.fromJson(Map<String, dynamic> json) {
    nameEn = json['name_en'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name_en'] = this.nameEn;
    data['id'] = this.id;
    return data;
  }
}