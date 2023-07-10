import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  List<TimeOfDay> _alarms = [];

  @override
  void dispose() {

    Hive.box("transaction").close();
    super.dispose();
  }

  void _addAlarm(TimeOfDay selectedTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _alarms.add(selectedTime);
      _saveAlarms(prefs);
    });
  }

  void _removeAlarm(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _alarms.removeAt(index);
      _saveAlarms(prefs);
    });
  }

  void _saveAlarms(SharedPreferences prefs) {
    List<String> alarmStrings = _alarms
        .map((alarm) => alarm.format(context))
        .toList();
    prefs.setStringList('alarms', alarmStrings);
  }

  void _loadAlarms(SharedPreferences prefs) {
    List<String>? alarmStrings = prefs.getStringList('alarms');
    if (alarmStrings != null) {
      setState(() {
        _alarms = alarmStrings
            .map((alarmString) =>
            TimeOfDay.fromDateTime(DateTime.parse(alarmString)))
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      _loadAlarms(prefs);
    });
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
                var box = await Hive.openBox("hour");
                box.put('index', 'hourFormat');
                print(box.get('index'));
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  _addAlarm(pickedTime);
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
              child: ListView.builder(
                itemCount: _alarms.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.alarm),
                    title: Text(
                      _alarms[index].format(context),
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeAlarm(index),
                    ),
                  );
                },
              ),
            ),
            FutureBuilder(future: Hive.openBox("hour"),builder: (context, snapshot){
              return Text(snapshot.data!.get('index').toString());
            }),
          ],
        ),
      ),
    );
  }
}

