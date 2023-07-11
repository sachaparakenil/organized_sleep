import 'package:hive/hive.dart';
import '../models/hour_models.dart';

class Boxes{
  static Box<hours> getData() => Hive.box("hour");
}