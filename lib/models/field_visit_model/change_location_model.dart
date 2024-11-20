class ChangeLocationModel {
  String? message;
  int? changeLocationId;
  int? status;

  ChangeLocationModel({this.message, this.changeLocationId, this.status});

  ChangeLocationModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    changeLocationId = json['change_location_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['change_location_id'] = this.changeLocationId;
    data['status'] = this.status;
    return data;
  }
}