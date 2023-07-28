import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

class ExampleAlarmEditScreen extends StatefulWidget {
  final AlarmSettings? alarmSettings;

  const ExampleAlarmEditScreen({Key? key, this.alarmSettings})
      : super(key: key);

  @override
  State<ExampleAlarmEditScreen> createState() => _ExampleAlarmEditScreenState();
}

class _ExampleAlarmEditScreenState extends State<ExampleAlarmEditScreen> {
  late bool creating;
  late TimeOfDay selectedTime;
  late bool loopAudio;
  late bool vibrate;
  late bool showNotification;
  late String assetAudio;
  final _timePickerTheme = TimePickerThemeData(
    backgroundColor: Color(0xffbac6e7),
    hourMinuteShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide(color: Color(0xff07327a), width: 1),
    ),
    dayPeriodBorderSide: const BorderSide(color: Color(0xff07327a), width: 1),
    dayPeriodColor: MaterialStateColor.resolveWith((states) =>
    states.contains(MaterialState.selected) ? Color(0xff5282d2) : Color(
        0xffc3cfe5)),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide(color: Color(0xff609ae0), width: 1),
    ),
    dayPeriodTextColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected) ? Colors.white : Color(0xff86a8e1)),
    dayPeriodShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide(color: Color(0xff07327a), width: 4),
    ),
    hourMinuteColor: MaterialStateColor.resolveWith((states) =>
    states.contains(MaterialState.selected) ? Color(0xff5282d2) : Color(
        0xffc3cfe5)),
    hourMinuteTextColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected) ? Colors.white : Color(0xff86a8e1)),
    dialHandColor: Color(0xff2d70e0),
    dialBackgroundColor: Color(0xff86a8e1),
    hourMinuteTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    dayPeriodTextStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    helpTextStyle:
    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(0),
    ),
    dialTextColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected) ? Color(0xff07327a) : Color(
            0xff0d60ec)),
    entryModeIconColor: Color(0xff07327a),
  );

  @override
  void initState() {
    super.initState();
    creating = widget.alarmSettings == null;

    if (creating) {
      final dt = DateTime.now().add(const Duration(minutes: 1));
      selectedTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
      loopAudio = true;
      vibrate = true;
      showNotification = true;
      assetAudio = 'assets/marimba.mp3';
    } else {
      selectedTime = TimeOfDay(
        hour: widget.alarmSettings!.dateTime.hour,
        minute: widget.alarmSettings!.dateTime.minute,
      );
      loopAudio = widget.alarmSettings!.loopAudio;
      vibrate = widget.alarmSettings!.vibrate;
      showNotification = widget.alarmSettings!.notificationTitle != null &&
          widget.alarmSettings!.notificationTitle!.isNotEmpty &&
          widget.alarmSettings!.notificationBody != null &&
          widget.alarmSettings!.notificationBody!.isNotEmpty;
      assetAudio = widget.alarmSettings!.assetAudioPath;
    }
  }

  Future<void> pickTime() async {
    final res = await showTimePicker(
      initialTime: selectedTime,
      context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              // This uses the _timePickerTheme defined above
              timePickerTheme: _timePickerTheme,
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith((states) => Color(0xff07327a)),
                  foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                  overlayColor: MaterialStateColor.resolveWith((states) => Color(0xff07327a)),
                ),
              ),
            ),
            child: child!,
          );}
    );
    if (res != null) setState(() => selectedTime = res);
  }

  AlarmSettings buildAlarmSettings() {
    final now = DateTime.now();
    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 100000
        : widget.alarmSettings!.id;

    DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
      0,
      0,
    );
    if (dateTime.isBefore(DateTime.now())) {
      dateTime = dateTime.add(const Duration(days: 1));
    }

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      loopAudio: loopAudio,
      vibrate: vibrate,
      notificationTitle: showNotification ? 'Alarm example' : null,
      notificationBody: showNotification ? 'Your alarm ($id) is ringing' : null,
      assetAudioPath: assetAudio,
      stopOnNotificationOpen: false,
    );
    return alarmSettings;
  }

  void saveAlarm() {
    Alarm.set(alarmSettings: buildAlarmSettings()).then((res) {
      if (res) Navigator.pop(context, true);
    });
  }

  void deleteAlarm() {
    Alarm.stop(widget.alarmSettings!.id).then((res) {
      if (res) Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  "Cancel",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.blueAccent),
                ),
              ),
              TextButton(
                onPressed: saveAlarm,
                child: Text(
                  "Save",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.blueAccent),
                ),
              ),
            ],
          ),*/
          RawMaterialButton(
            onPressed: pickTime,
            fillColor:Color(0xffD3E1F6),
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                selectedTime.format(context),
                style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold, color: Color(0xff07327a))
              ),
            ),
          ),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
              color: Color(0xffD3E1F6),
            ),
            child: Row(
              children: [
                SizedBox(width: 5,),
                Image(image: AssetImage('assets/icon/loop_audio.png'), height: 20, width: 20,),
                SizedBox(width: 10),
                Text(
                  'Loop alarm audio',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Spacer(),
                Switch(
                  value: loopAudio,
                  onChanged: (value) => setState(() => loopAudio = value),
                    activeColor: Color(0xff07327a),
                    inactiveTrackColor: Colors.grey
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
              color: Color(0xffD3E1F6),
            ),
            child: Row(
              children: [
                SizedBox(width: 5,),
                Image(image: AssetImage('assets/icon/vibrate.png'), height: 20, width: 20,),
                SizedBox(width: 10,),
                Text(
                  'Vibrate',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Spacer(),
                Switch(
                  value: vibrate,
                  onChanged: (value) => setState(() => vibrate = value),
                    activeColor: Color(0xff07327a),
                    inactiveTrackColor: Colors.grey
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
                color: Color(0xffD3E1F6),
            ),
            child: Row(
              children: [
                SizedBox(width: 5,),
                Image(image: AssetImage('assets/icon/notification.png'), height: 20, width: 20,),
                SizedBox(width: 10,),
                Text(
                  'Show notification',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Spacer(),
                Switch(
                  value: showNotification,
                  onChanged: (value) => setState(() => showNotification = value),
                    activeColor: Color(0xff07327a),
                    inactiveTrackColor: Colors.grey
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
              color: Color(0xffD3E1F6),
            ),
            child: Row(
              children: [
                SizedBox(width: 5,),
                Image(image: AssetImage('assets/icon/sound.png'), height: 20, width: 20,),
                SizedBox(width: 10,),
                Text(
                  'Sound',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Color(0xff07327a),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: SizedBox(
                    height: 30,
                    child: DropdownButton(
                      value: assetAudio,
                      dropdownColor: Color(0xff07327a),
                      items: const [
                        DropdownMenuItem<String>(
                          value: 'assets/marimba.mp3',
                          child: Text('Marimba', style: TextStyle(color: Colors.white)),
                        ),
                        DropdownMenuItem<String>(
                          value: 'assets/nokia.mp3',
                          child: Text('Nokia', style: TextStyle(color: Colors.white)),
                        ),
                        DropdownMenuItem<String>(
                          value: 'assets/mozart.mp3',
                          child: Text('Mozart', style: TextStyle(color: Colors.white)),
                        ),
                        DropdownMenuItem<String>(
                          value: 'assets/star_wars.mp3',
                          child: Text('Star Wars', style: TextStyle(color: Colors.white)),
                        ),
                        DropdownMenuItem<String>(
                          value: 'assets/one_piece.mp3',
                          child: Text('One Piece', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                      onChanged: (value) => setState(() => assetAudio = value!),
                      underline: Container(),
                      icon: Icon(Icons.arrow_drop_down, color: Color(0xff335796)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Save(label: "Cancel", onPressed: () => Navigator.pop(context, false),color: Color(0xff07327a),)),
              SizedBox(width: 30,),
              Expanded(child: Save(label: "Save", onPressed: saveAlarm,color: Color(0xff07327a),)),
            ],
          ),
          SizedBox(height: 15,),
          if (!creating)
            Container(padding: EdgeInsets.symmetric(horizontal: 20),child: Save(label: "Delete Alarm", onPressed: deleteAlarm,color: Color(0xffBC544B),)),
          const SizedBox(),
        ],
      ),
    );
  }
}

class Save extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color color;

  const Save({super.key, required this.label, this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(25), // Set the border radius as desired
        /*border: Border.all(
          // color: Colors.black.withOpacity(0.5), // Set the border color with opacity
          width: 2.0, // Set the border width as needed
        ),*/
        boxShadow: [
          BoxShadow(
            color: color,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
