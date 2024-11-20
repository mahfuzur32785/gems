import 'dart:typed_data';

import 'package:hive/hive.dart';
part 'local_image_model.g.dart';

@HiveType(typeId: 2)
class LocalImageModel extends HiveObject{
  @HiveField(0)
  String? uniqueImageID;
  @HiveField(1)
  Uint8List? localFiledPhoto;
  
  LocalImageModel({
    this.uniqueImageID,
    this.localFiledPhoto
  });
  

}