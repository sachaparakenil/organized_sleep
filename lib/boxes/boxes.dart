import 'package:hive/hive.dart';
import '../models/details_model.dart';

class Boxes {
  static Box<DetailsModel> getData() => Hive.box<DetailsModel>('Sleep Report');
}
