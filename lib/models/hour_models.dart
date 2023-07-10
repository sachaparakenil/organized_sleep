import 'dart:core';
import 'package:hive/hive.dart';
part 'hour_models.g.dart';

@HiveType(typeId: 0)
class hours extends HiveObject {

  @HiveField(0)
  String index;

  @HiveField(1)
  String hour;

  hours({required this.hour, required this.index});

}