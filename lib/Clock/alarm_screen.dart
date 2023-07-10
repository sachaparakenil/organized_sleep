import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:organized_sleep/boxes/boxes.dart';
import 'package:organized_sleep/models/hour_models.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../boxes/boxes.dart';

class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {

  @override
  void dispose() {
    Hive.box("transaction").close();
    super.dispose();
  }

/*  void _addAlarm(TimeOfDay selectedTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _alarms.add(selectedTime);
      _saveAlarms(prefs);
    });
  }*/

  void delete(hours val)async{
    await val.delete();
  }

/*  void _saveAlarms(SharedPreferences prefs) {
    List<String> alarmStrings =
    _alarms.map((alarm) => alarm.format(context)).toList();
    prefs.setStringList('alarms', alarmStrings);
  }*/

/*  void _loadAlarms(SharedPreferences prefs) {
    List<String>? alarmStrings = prefs.getStringList('alarms');
    if (alarmStrings != null) {
      setState(() {
        _alarms = alarmStrings
            .map((alarmString) =>
            TimeOfDay.fromDateTime(DateTime.parse(alarmString)))
            .toList();
      });
    }
  }*/
/*
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      _loadAlarms(prefs);
    });
  }*/

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
