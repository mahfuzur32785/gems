// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_image_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalImageModelAdapter extends TypeAdapter<LocalImageModel> {
  @override
  final int typeId = 2;

  @override
  LocalImageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalImageModel(
      uniqueImageID: fields[0] as String?,
      localFiledPhoto: fields[1] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, LocalImageModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.uniqueImageID)
      ..writeByte(1)
      ..write(obj.localFiledPhoto);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalImageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
