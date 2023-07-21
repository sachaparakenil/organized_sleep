
import 'package:hive/hive.dart';
part 'details_model.g.dart';

@HiveType(typeId: 0)
class DetailsModel extends HiveObject {

  @HiveField(0)
  String sleepAt;

  @HiveField(1)
  String wakeAt;

  @HiveField(2)
  String maxVoice;

  @HiveField(3)
  String avgVoice;

  @HiveField(4)
  List<String> sniffing;

  DetailsModel({required this.sleepAt, required this.wakeAt, required this.maxVoice, required this.avgVoice, required this.sniffing});


}