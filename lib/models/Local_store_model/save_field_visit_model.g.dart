// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_field_visit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaveLocalFieldModelAdapter extends TypeAdapter<SaveLocalFieldModel> {
  @override
  final int typeId = 1;

  @override
  SaveLocalFieldModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaveLocalFieldModel(
      divisionID: fields[0] as String?,
      districtID: fields[1] as String?,
      upazillaID: fields[2] as String?,
      unionID: fields[3] as String?,
      latitude: fields[4] as String?,
      longitude: fields[5] as String?,
      officeType: fields[6] as String?,
      officeTitle: fields[7] as String?,
      remark: fields[8] as String?,
      syncStatus: fields[9] as String?,
      officeTypeID: fields[10] as String?,
      isChangeLocation: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SaveLocalFieldModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.divisionID)
      ..writeByte(1)
      ..write(obj.districtID)
      ..writeByte(2)
      ..write(obj.upazillaID)
      ..writeByte(3)
      ..write(obj.unionID)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitude)
      ..writeByte(6)
      ..write(obj.officeType)
      ..writeByte(7)
      ..write(obj.officeTitle)
      ..writeByte(8)
      ..write(obj.remark)
      ..writeByte(9)
      ..write(obj.syncStatus)
      ..writeByte(10)
      ..write(obj.officeTypeID)
      ..writeByte(11)
      ..write(obj.isChangeLocation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaveLocalFieldModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
