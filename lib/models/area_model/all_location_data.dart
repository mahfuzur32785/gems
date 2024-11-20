import 'package:hive/hive.dart';
part 'all_location_data.g.dart';

@HiveType(typeId: 0)
class AllLocationData extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  int? divisionId;
  @HiveField(2)
  int? districtId;
  @HiveField(3)
  int? upazilaId;
  @HiveField(4)
  int? unionId;
  @HiveField(5)
  int? officeTypeId;
  @HiveField(6)
  dynamic officeTitle;
  @HiveField(7)
  String? nameBn;
  @HiveField(8)
  String? nameEn;
  @HiveField(9)
  dynamic bbsCode;
  @HiveField(10)
  String? latitude;
  @HiveField(11)
  String? longitude;
  @HiveField(12)
  String? oldLatitude;
  @HiveField(13)
  String? oldLongitude;
  @HiveField(14)
  int? phase;
  @HiveField(15)
  int? isVcmisActivated;
  @HiveField(16)
  int? ngo;
  @HiveField(17)
  dynamic activatedAt;
  @HiveField(18)
  dynamic url;
  @HiveField(19)
  String? createdAt;
  @HiveField(20)
  String? updatedAt;
  @HiveField(21)
  double? distance;

  AllLocationData(
      {this.id,
      this.divisionId,
      this.districtId,
      this.upazilaId,
      this.unionId,
      this.officeTypeId,
      this.officeTitle,
      this.nameBn,
      this.nameEn,
      this.bbsCode,
      this.latitude,
      this.longitude,
      this.oldLatitude,
      this.oldLongitude,
      this.phase,
      this.isVcmisActivated,
      this.ngo,
      this.activatedAt,
      this.url,
      this.createdAt,
      this.updatedAt,
      this.distance});

  AllLocationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    divisionId = json['division_id'];
    districtId = json['district_id'];
    upazilaId = json['upazila_id'];
    unionId = json['union_id'];
    officeTypeId = json['office_type_id'];
    officeTitle = json['office_title'];
    nameBn = json['name_bn'];
    nameEn = json['name_en'];
    bbsCode = json['bbs_code'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    oldLatitude = json['old_latitude'];
    oldLongitude = json['old_longitude'];
    phase = json['phase'];
    isVcmisActivated = json['is_vcmis_activated'];
    ngo = json['ngo'];
    activatedAt = json['activated_at'];
    url = json['url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['division_id'] = this.divisionId;
    data['district_id'] = this.districtId;
    data['upazila_id'] = this.upazilaId;
    data['union_id'] = this.unionId;
    data['office_type_id'] = this.officeTypeId;
    data['office_title'] = this.officeTitle;
    data['name_bn'] = this.nameBn;
    data['name_en'] = this.nameEn;
    data['bbs_code'] = this.bbsCode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['old_latitude'] = this.oldLatitude;
    data['old_longitude'] = this.oldLongitude;
    data['phase'] = this.phase;
    data['is_vcmis_activated'] = this.isVcmisActivated;
    data['ngo'] = this.ngo;
    data['activated_at'] = this.activatedAt;
    data['url'] = this.url;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['distance'] = this.distance;
    return data;
  }
}
