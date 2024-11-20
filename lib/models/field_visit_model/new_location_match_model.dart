class NewLocationMatchModel {
  OfficeType? officeType;
  int? status;

  String? message;

  NewLocationMatchModel({
    this.officeType,
    this.status,
    this.message,
  });
  NewLocationMatchModel.fromJson(Map<String, dynamic> json) {
    officeType = json['officeType'] != null ? OfficeType.fromJson(json['officeType']) : null;
    status = json['status'];

    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.officeType != null) {
      data['officeType'] = this.officeType!.toJson();
    }
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class OfficeType {
  List<OfficeTypeList>? officeTypeList;
  Map? data;

  OfficeType({
    this.officeTypeList,
    this.data,
  });
  OfficeType.fromJson(Map<String, dynamic> json) {
    if (json['officeTypeList'] != null) {
      officeTypeList = <OfficeTypeList>[];
      json['officeTypeList'].forEach((v) {
        officeTypeList!.add(new OfficeTypeList.fromJson(v));
      });
    }
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.officeTypeList != null) {
      data['officeTypeList'] = this.officeTypeList!.map((v) => v.toJson()).toList();
    }
    //if (this.data != null) {
    data['data'] = this.data ?? null;
    //}
    return data;
  }
}

// class OfficeAreaData {
//   DetailsData? detailsData;

//   OfficeAreaData({
//     this.detailsData,
//   });

// }

// class DetailsData {
//   List<Union>? unions;
//   List<Upazila>? upazilas;
//   List<District>? districts;
//   List<Division>? divisions;

//   DetailsData({
//     this.unions,
//     this.upazilas,
//     this.districts,
//     this.divisions,
//   });
// }

class LocMatchedDistrict {
  String? districtName;
  int? districtId;
  int? divisionId;
  int? officeTypeId;
  dynamic officeTitle;
  dynamic distance;
  dynamic locationID;


  LocMatchedDistrict({
    this.districtName,
    this.districtId,
    this.divisionId,
    this.officeTypeId,
    this.officeTitle,
    this.distance,
    this.locationID
  });
  LocMatchedDistrict.fromJson(Map<String, dynamic> json) {
		districtName = json['district_name'];
		districtId = json['district_id'];
		divisionId = json['division_id'];
		officeTypeId = json['office_type_id'];
		officeTitle = json['office_title'];
		distance = json['distance'];
    locationID = json['location_id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['district_name'] = this.districtName;
		data['district_id'] = this.districtId;
		data['division_id'] = this.divisionId;
		data['office_type_id'] = this.officeTypeId;
		data['office_title'] = this.officeTitle;
		data['distance'] = this.distance;
    data['location_id'] = this.locationID;
		return data;
	}
}

class LocMatchedDivision {
  String? divisionName;
  int? divisionId;
  int? officeTypeId;
  dynamic officeTitle;
  dynamic distance;
  dynamic locationID;

  LocMatchedDivision({
    this.divisionName,
    this.divisionId,
    this.officeTypeId,
    this.officeTitle,
    this.distance,
    this.locationID,
  });
  LocMatchedDivision.fromJson(Map<String, dynamic> json) {
		divisionName = json['division_name'];
		divisionId = json['division_id'];
		officeTypeId = json['office_type_id'];
		officeTitle = json['office_title'];
		distance = json['distance'];
    locationID = json['location_id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['division_name'] = this.divisionName;
		data['division_id'] = this.divisionId;
		data['office_type_id'] = this.officeTypeId;
		data['office_title'] = this.officeTitle;
		data['distance'] = this.distance;
    data['location_id'] = this.locationID;
		return data;
	}
}

class LocMatchedUnion {
  int? unionId;
  String? unionName;
  int? upazilaId;
  int? officeTypeId;
  dynamic officeTitle;
  dynamic distance;
  dynamic locationID;

  LocMatchedUnion({
    this.unionId,
    this.unionName,
    this.upazilaId,
    this.officeTypeId,
    this.officeTitle,
    this.distance,
    this.locationID,
  });
  LocMatchedUnion.fromJson(Map<String, dynamic> json) {
		unionId = json['union_id'];
		unionName = json['union_name'];
		upazilaId = json['upazila_id'];
		officeTypeId = json['office_type_id'];
		officeTitle = json['office_title'];
		distance = json['distance'];
    locationID = json['location_id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['union_id'] = this.unionId;
		data['union_name'] = this.unionName;
		data['upazila_id'] = this.upazilaId;
		data['office_type_id'] = this.officeTypeId;
		data['office_title'] = this.officeTitle;
		data['distance'] = this.distance;
    data['location_id'] = this.locationID;
		return data;
	}

}

class LocMatchedUpazila {
  String? upazilaName;
  int? upazilaId;
  int? districtId;
  int? officeTypeId;
  dynamic officeTitle;
  dynamic distance;
  dynamic locationID;

  LocMatchedUpazila({
    this.upazilaName,
    this.upazilaId,
    this.districtId,
    this.officeTypeId,
    this.officeTitle,
    this.distance,
    this.locationID,
  });
  LocMatchedUpazila.fromJson(Map<String, dynamic> json) {
		upazilaName = json['upazila_name'];
		upazilaId = json['upazila_id'];
		districtId = json['district_id'];
		officeTypeId = json['office_type_id'];
		officeTitle = json['office_title'];
		distance = json['distance'];
    locationID = json['location_id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['upazila_name'] = this.upazilaName;
		data['upazila_id'] = this.upazilaId;
		data['district_id'] = this.districtId;
		data['office_type_id'] = this.officeTypeId;
		data['office_title'] = this.officeTitle;
		data['distance'] = this.distance;
    data['location_id'] = this.locationID;
		return data;
	}
}

class OfficeTypeList {
  int? id;
  String? name;

  OfficeTypeList({
    this.id,
    this.name,
  });
  OfficeTypeList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
