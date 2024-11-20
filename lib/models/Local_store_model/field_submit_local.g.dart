// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_submit_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FieldSubmitLocalAdapter extends TypeAdapter<FieldSubmitLocal> {
  @override
  final int typeId = 3;

  @override
  FieldSubmitLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FieldSubmitLocal(
      divisionID: fields[0] as String?,
      districtID: fields[1] as String?,
      upazillaID: fields[2] as String?,
      unionID: fields[3] as String?,
      latitude: fields[4] as String?,
      longitude: fields[5] as String?,
      officeType: fields[6] as String?,
      officeTitle: fields[7] as String?,
      locationMatch: fields[8] as String?,
      syncStatus: fields[9] as String?,
      officeTypeID: fields[10] as String?,
      locimg1: fields[11] as String?,
      locimg2: fields[12] as String?,
      locimg3: fields[13] as String?,
      locationID: fields[14] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, FieldSubmitLocal obj) {
    writer
      ..writeByte(15)
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
      ..write(obj.locationMatch)
      ..writeByte(9)
      ..write(obj.syncStatus)
      ..writeByte(10)
      ..write(obj.officeTypeID)
      ..writeByte(11)
      ..write(obj.locimg1)
      ..writeByte(12)
      ..write(obj.locimg2)
      ..writeByte(13)
      ..write(obj.locimg3)
      ..writeByte(14)
      ..write(obj.locationID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldSubmitLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
