class AAcoInfoEditDataModel {
  int? status;
  String? message;
  AacoInfo? data;

  AAcoInfoEditDataModel({this.status, this.message, this.data});

  AAcoInfoEditDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new AacoInfo.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AacoInfo {
  int? id;
  String? name;
  String? email;
  dynamic mobile;
  int? gender;
  int? districtId;
  String? district;
  int? upazilaId;
  String? upazila;
  int? unionId;
  dynamic unionLists;
  String? union;
  int? recruitmentStatus;
  String? apointmentDate;
  int? aacoReasonId;
  int? accoAvailiablityStatus;
  String? nonCompletionOther;
  int? nonAvailabilityOther;
  String? createdBy;
  String? processingText;

  AacoInfo(
      {this.id,
      this.name,
      this.email,
      this.mobile,
      this.gender,
      this.districtId,
      this.district,
      this.upazilaId,
      this.upazila,
      this.unionId,
      this.unionLists,
      this.union,
      this.recruitmentStatus,
      this.apointmentDate,
      this.aacoReasonId,
      this.accoAvailiablityStatus,
      this.nonCompletionOther,
      this.nonAvailabilityOther,
      this.processingText,
      this.createdBy});

  AacoInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    gender = json['gender'];
    districtId = json['district_id'];
    district = json['district'];
    upazilaId = json['upazila_id'];
    upazila = json['upazila'];
    unionId = json['union_id'];
    unionLists = json['union_lists'];
    union = json['union'];
    recruitmentStatus = json['recruitment_status'];
    apointmentDate = json['apointment_date'];
    aacoReasonId = json['aaco_reason_id'];
    accoAvailiablityStatus = json['acco_availiablity_status'];
    nonCompletionOther = json['non_completion_other'];
    nonAvailabilityOther = json['non_availability_other'];
    createdBy = json['created_by'];
    processingText = json['processing_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['gender'] = this.gender;
    data['district_id'] = this.districtId;
    data['district'] = this.district;
    data['upazila_id'] = this.upazilaId;
    data['upazila'] = this.upazila;
    data['union_id'] = this.unionId;
    data['union_lists'] = this.unionLists;
    data['union'] = this.union;
    data['recruitment_status'] = this.recruitmentStatus;
    data['apointment_date'] = this.apointmentDate;
    data['aaco_reason_id'] = this.aacoReasonId;
    data['acco_availiablity_status'] = this.accoAvailiablityStatus;
    data['non_completion_other'] = this.nonCompletionOther;
    data['non_availability_other'] = this.nonAvailabilityOther;
    data['created_by'] = this.createdBy;
    data['processing_text'] = this.processingText;
    return data;
  }
}
