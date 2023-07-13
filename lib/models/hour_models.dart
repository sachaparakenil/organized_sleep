import 'dart:core';
import 'package:hive/hive.dart';
part 'hour_models.g.dart';

@HiveType(typeId: 0)
class Hours extends HiveObject {

  @HiveField(0)
  String index;

  @HiveField(1)
  String hour;

  Hours({required this.hour, required this.index});

}