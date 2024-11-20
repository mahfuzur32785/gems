import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

part 'field_submit_local.g.dart';

@HiveType(typeId: 3)
class FieldSubmitLocal {
  @HiveField(0)
  String? divisionID;
  @HiveField(1)
  String? districtID;
  @HiveField(2)
  String? upazillaID;
  @HiveField(3)
  String? unionID;
  @HiveField(4)
  String? latitude;
  @HiveField(5)
  String? longitude;
  @HiveField(6)
  String? officeType;
  @HiveField(7)
  String? officeTitle;
  @HiveField(8)
  String? locationMatch;
  @HiveField(9)
  String? syncStatus;
  @HiveField(10)
  String? officeTypeID;
  @HiveField(11)
  String? locimg1;
  @HiveField(12)
  String? locimg2;
  @HiveField(13)
  String? locimg3;
  @HiveField(14)
  int? locationID;

  FieldSubmitLocal({
    this.divisionID,
    this.districtID,
    this.upazillaID,
    this.unionID,
    this.latitude,
    this.longitude,
    this.officeType,
    this.officeTitle,
    this.locationMatch,
    this.syncStatus,
    this.officeTypeID,
    this.locimg1,
    this.locimg2,
    this.locimg3,
    this.locationID,
  });

  // factory FieldSubmitLocal.fromJson(Map<String,dynamic>){

  // }
}
