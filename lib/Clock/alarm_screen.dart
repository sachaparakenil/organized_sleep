

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:organized_sleep/boxes/boxes.dart';
import 'package:organized_sleep/models/hour_models.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../boxes/boxes.dart';
import 'dart:async';

Timer? timer;

class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  double _timeOfDayToDouble(TimeOfDay tod) => tod.hour + tod.minute / 60.0;


  void playSound(String soundFilePath) {
    audioPlayer.play(AssetSource(soundFilePath));
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(seconds: 1), (Timer t) => checkForNewSharedLists());
  }

  @override
  void dispose() {
    timer?.cancel();
    Hive.box("transaction").close();
    super.dispose();
  }

  void delete(hours val) async {
    await val.delete();
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void checkForNewSharedLists() {
    var box = Boxes.getData();
    var data = box.values.toList().cast<hours>();
    String show = (data.first.hour.replaceAll("PM", "")).trim();

    List<String> hourMinute = show.split(':');
    int hour = int.parse(hourMinute[0]);
    int minute = int.parse(hourMinute[1]);
    TimeOfDay have = TimeOfDay(hour: hour, minute: minute);
    String formattedTime = formatTimeOfDay(have);


    if (_timeOfDayToDouble(TimeOfDay.now()) == _timeOfDayToDouble(have)) {
      // print(data.first.hour);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (pickedTime != null) {
                  final data =
                      hours(hour: pickedTime.format(context), index: "1");
                  final box = Boxes.getData();
                  box.add(data);
                  data.save();
                }
                double startTime = _timeOfDayToDouble(pickedTime!);
               var now = _timeOfDayToDouble(TimeOfDay.now());
                if (now == startTime) {
                  playSound('summer.mp3');
                }
                print("startTime $startTime");
                // bool categoryExists = box.values.any((item) =>
                // item.name.toLowerCase() == data.name.toLowerCase());
              },
              child: Text('Add Alarm'),
            ),
            SizedBox(height: 20),
            Text(
              'Alarms:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Expanded(
                child: ValueListenableBuilder<Box<hours>>(
              valueListenable: Boxes.getData().listenable(),
              builder: (context, box, _) {
                var data = box.values.toList().cast<hours>();
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.alarm),
                      title: Text(data[index].hour.toString()),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => delete(data[index]),
                      ),
                    );
                  },
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
