class AacoListModel {
  int? status;
  String? message;
  List<AacoData>? data;
  dynamic search;
  Pagination? pagination;

  AacoListModel(
      {this.status, this.message, this.data, this.search, this.pagination});

  AacoListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AacoData>[];
      json['data'].forEach((v) {
        data!.add(new AacoData.fromJson(v));
      });
    }
    search = json['search'];
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['search'] = this.search;
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class AacoData {
  int? id;
  dynamic name;
  dynamic email;
  dynamic mobile;
  dynamic gender;
  int? districtId;
  String? district;
  int? upazilaId;
  dynamic upazilaLists;
  String? upazila;
  int? unionId;
  dynamic unionLists;
  String? union;
  dynamic apointmentDate;
  int? recruitmentStatus;
  dynamic accoAvailiablityStatus;
  String? createdBy;

  AacoData(
      {this.id,
      this.name,
      this.email,
      this.mobile,
      this.gender,
      this.districtId,
      this.district,
      this.upazilaId,
      this.upazilaLists,
      this.upazila,
      this.unionId,
      this.unionLists,
      this.union,
      this.apointmentDate,
      this.recruitmentStatus,
      this.accoAvailiablityStatus,
      this.createdBy});

  AacoData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    gender = json['gender'];
    districtId = json['district_id'];
    district = json['district'];
    upazilaId = json['upazila_id'];
    upazilaLists = json['upazila_lists'];
    upazila = json['upazila'];
    unionId = json['union_id'];
    unionLists = json['union_lists'];
    union = json['union'];
    apointmentDate = json['apointment_date'];
    recruitmentStatus = json['recruitment_status'];
    accoAvailiablityStatus = json['acco_availiablity_status'];
    createdBy = json['created_by'];
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
    data['upazila_lists'] = this.upazilaLists;
    data['upazila'] = this.upazila;
    data['union_id'] = this.unionId;
    data['union_lists'] = this.unionLists;
    data['union'] = this.union;
    data['apointment_date'] = this.apointmentDate;
    data['recruitment_status'] = this.recruitmentStatus;
    data['acco_availiablity_status'] = this.accoAvailiablityStatus;
    data['created_by'] = this.createdBy;
    return data;
  }
}

class Pagination {
  int? currentPage;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  dynamic nextPageUrl;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Pagination(
      {this.currentPage,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.nextPageUrl,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}