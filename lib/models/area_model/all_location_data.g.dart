// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_location_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AllLocationDataAdapter extends TypeAdapter<AllLocationData> {
  @override
  final int typeId = 0;

  @override
  AllLocationData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AllLocationData(
      id: fields[0] as int?,
      divisionId: fields[1] as int?,
      districtId: fields[2] as int?,
      upazilaId: fields[3] as int?,
      unionId: fields[4] as int?,
      officeTypeId: fields[5] as int?,
      officeTitle: fields[6] as dynamic,
      nameBn: fields[7] as String?,
      nameEn: fields[8] as String?,
      bbsCode: fields[9] as dynamic,
      latitude: fields[10] as String?,
      longitude: fields[11] as String?,
      oldLatitude: fields[12] as String?,
      oldLongitude: fields[13] as String?,
      phase: fields[14] as int?,
      isVcmisActivated: fields[15] as int?,
      ngo: fields[16] as int?,
      activatedAt: fields[17] as dynamic,
      url: fields[18] as dynamic,
      createdAt: fields[19] as String?,
      updatedAt: fields[20] as String?,
      distance: fields[21] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, AllLocationData obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.divisionId)
      ..writeByte(2)
      ..write(obj.districtId)
      ..writeByte(3)
      ..write(obj.upazilaId)
      ..writeByte(4)
      ..write(obj.unionId)
      ..writeByte(5)
      ..write(obj.officeTypeId)
      ..writeByte(6)
      ..write(obj.officeTitle)
      ..writeByte(7)
      ..write(obj.nameBn)
      ..writeByte(8)
      ..write(obj.nameEn)
      ..writeByte(9)
      ..write(obj.bbsCode)
      ..writeByte(10)
      ..write(obj.latitude)
      ..writeByte(11)
      ..write(obj.longitude)
      ..writeByte(12)
      ..write(obj.oldLatitude)
      ..writeByte(13)
      ..write(obj.oldLongitude)
      ..writeByte(14)
      ..write(obj.phase)
      ..writeByte(15)
      ..write(obj.isVcmisActivated)
      ..writeByte(16)
      ..write(obj.ngo)
      ..writeByte(17)
      ..write(obj.activatedAt)
      ..writeByte(18)
      ..write(obj.url)
      ..writeByte(19)
      ..write(obj.createdAt)
      ..writeByte(20)
      ..write(obj.updatedAt)
      ..writeByte(21)
      ..write(obj.distance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllLocationDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
