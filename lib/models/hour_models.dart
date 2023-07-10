import 'dart:core';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class hours {

  @HiveField(0)
  String index;

  @HiveField(1)
  String hour;

  hours({required this.hour, required this.index});

}