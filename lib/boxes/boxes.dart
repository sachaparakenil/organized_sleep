import 'package:hive/hive.dart';
import '../models/hour_models.dart';

class Boxes{
  static Box<Hours> getData() => Hive.box("hour");
}