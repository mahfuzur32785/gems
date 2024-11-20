class UpdNewLocation {
  List<UpdNewLocationData>? data;
  int? status;
   String? message;

  UpdNewLocation({this.data, this.status});

  UpdNewLocation.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <UpdNewLocationData>[];
      json['data'].forEach((v) {
        data!.add(new UpdNewLocationData.fromJson(v));
      });
    }
    status = json['status'];
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message']=this.message;
    return data;
  }
}

class UpdNewLocationData {
  int? id;
  int? divisionId;
  String? divisionName;
  int? districtId;
  String? districtName;
  int? upazilaId;
  String? upazilaName;
  int? unionId;
  String? unionName;
  int? officeTypeId;
  String? officeTypeName;
  String? officeTitle;
  String? distance;
  int? locationId;

  UpdNewLocationData(
      {this.id,
      this.divisionId,
      this.divisionName,
      this.districtId,
      this.districtName,
      this.upazilaId,
      this.upazilaName,
      this.unionId,
      this.unionName,
      this.officeTypeId,
      this.officeTypeName,
      this.officeTitle,
      this.distance,
      this.locationId});

  UpdNewLocationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    divisionId = json['division_id'];
    divisionName = json['division_name'];
    districtId = json['district_id'];
    districtName = json['district_name'];
    upazilaId = json['upazila_id'];
    upazilaName = json['upazila_name'];
    unionId = json['union_id'];
    unionName = json['union_name'];
    officeTypeId = json['office_type_id'];
    officeTypeName = json['office_type_name'];
    officeTitle = json['office_title'];
    distance = json['distance'];
    locationId = json['location_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['division_id'] = this.divisionId;
    data['division_name'] = this.divisionName;
    data['district_id'] = this.districtId;
    data['district_name'] = this.districtName;
    data['upazila_id'] = this.upazilaId;
    data['upazila_name'] = this.upazilaName;
    data['union_id'] = this.unionId;
    data['union_name'] = this.unionName;
    data['office_type_id'] = this.officeTypeId;
    data['office_type_name'] = this.officeTypeName;
    data['office_title'] = this.officeTitle;
    data['distance'] = this.distance;
    data['location_id'] = this.locationId;
    return data;
  }
}