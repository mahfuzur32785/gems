import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

part 'save_field_visit_model.g.dart';

@HiveType(typeId: 1)
class SaveLocalFieldModel {
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
  String? remark;
  @HiveField(9)
  String? syncStatus;
  @HiveField(10)
  String? officeTypeID;
  @HiveField(11)
  String? isChangeLocation;
  @HiveField(12)
  String? clocimg1;
  @HiveField(13)
  String? clocimg2;
  @HiveField(14)
  String? clocimg3;

  SaveLocalFieldModel({
    this.divisionID,
    this.districtID,
    this.upazillaID,
    this.unionID,
    this.latitude,
    this.longitude,
    this.officeType,
    this.officeTitle,
    this.remark,
    this.syncStatus,
    this.officeTypeID,
    this.isChangeLocation,
    this.clocimg1,
    this.clocimg2,
    this.clocimg3
  });
}
