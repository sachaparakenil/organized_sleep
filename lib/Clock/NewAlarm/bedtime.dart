import 'package:organized_sleep/Clock/NewAlarm/notification/notification_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:organized_sleep/Clock/NewAlarm/share_preference_service.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shared_preferences/shared_preferences.dart';

class BedTime extends StatefulWidget {
  const BedTime({super.key});

  @override
  State<BedTime> createState() => _BedTimeState();
}

class _BedTimeState extends State<BedTime> {
  ClockTimeFormat _clockTimeFormat = ClockTimeFormat.twentyFourHours;
  ClockIncrementTimeFormat _clockIncrementTimeFormat =
      ClockIncrementTimeFormat.oneMin;

  PickedTime _inBedTime = PickedTime(h: 0, m: 0);
  PickedTime _outBedTime = PickedTime(h: 8, m: 0);
  PickedTime _intervalBedTime = PickedTime(h: 0, m: 0);

  bool _isSleepGoal = false;

  bool? validRange = true;

  bool _isWakeUpAlarmEnabled = false;
  bool _isBedTimeAlarmEnabled = false;

  double currentvol = 0.5;
  String buttontype = "none";

  @override
  void initState() {
    super.initState();
    initializeData(); // Call the async method here
  }

  Future<void> initializeData() async {
    DateTime sleepGoal = await AppSharedPreferences.getSleepGoal();
    double sleepGoalDecimal = sleepGoal.hour + (sleepGoal.minute / 60);
    int hours = sleepGoalDecimal.toInt();
    int minutes = ((sleepGoalDecimal - hours) * 60).toInt();
    double time = double.parse('$hours.$minutes');
    setState(() {
      _isSleepGoal = (sleepGoalDecimal >= time);
    });

    _loadSavedPreferences();
  }

  Future<Widget> textWidget() async {
    DateTime sleepGoal = await AppSharedPreferences.getSleepGoal();
    double sleepGoalDecimal = sleepGoal.hour + (sleepGoal.minute / 60);
    int hours = sleepGoalDecimal.toInt();
    int minutes = ((sleepGoalDecimal - hours) * 60).toInt();

    return Text(
      "Your daily sleep goal is ${hours.toString().padLeft(2, '0')}.${minutes
          .toString().padLeft(2, '0')} hours.",
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void _loadSavedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int initHour = prefs.getInt('init_hour') ?? 0;
    int initMinute = prefs.getInt('init_minute') ?? 0;
    int endHour = prefs.getInt('end_hour') ?? 8;
    int endMinute = prefs.getInt('end_minute') ?? 0;
    bool isDisableRange = prefs.getBool('is_disable_range') ?? false;
    _isWakeUpAlarmEnabled = await AppSharedPreferences.getWakeUpAlarmEnabled();
    _isBedTimeAlarmEnabled =
    await AppSharedPreferences.getBedTimeAlarmEnabled();

    _inBedTime = PickedTime(h: initHour, m: initMinute);
    _outBedTime = PickedTime(h: endHour, m: endMinute);
    _intervalBedTime = formatIntervalTime(
      init: _inBedTime,
      end: _outBedTime,
      clockTimeFormat: _clockTimeFormat,
      clockIncrementTimeFormat: _clockIncrementTimeFormat,
    );
    DateTime sleepGoal = await AppSharedPreferences.getSleepGoal();
    double sleepGoalDecimal = sleepGoal.hour + (sleepGoal.minute / 60);
    int hours = sleepGoalDecimal.toInt();
    int minutes = ((sleepGoalDecimal - hours) * 60).toInt();
    double time = double.parse('$hours.$minutes');
    _isSleepGoal = validateSleepGoal(
      inTime: _inBedTime,
      outTime: _outBedTime,
      sleepGoal: time,
      clockTimeFormat: _clockTimeFormat,
      clockIncrementTimeFormat: _clockIncrementTimeFormat,
    );

    setState(() {
      validRange = isDisableRange;
    });
  }

  void _updateLabels(PickedTime init, PickedTime end,
      bool? isDisableRange) async {
    _inBedTime = init;
    _outBedTime = end;
    _intervalBedTime = formatIntervalTime(
      init: _inBedTime,
      end: _outBedTime,
      clockTimeFormat: _clockTimeFormat,
      clockIncrementTimeFormat: _clockIncrementTimeFormat,
    );
    DateTime sleepGoal = await AppSharedPreferences.getSleepGoal();
    double sleepGoalDecimal = sleepGoal.hour + (sleepGoal.minute / 60);
    int hours = sleepGoalDecimal.toInt();
    int minutes = ((sleepGoalDecimal - hours) * 60).toInt();
    double time = double.parse('$hours.$minutes');
    _isSleepGoal = validateSleepGoal(
      inTime: init,
      outTime: end,
      sleepGoal: time,
      clockTimeFormat: _clockTimeFormat,
      clockIncrementTimeFormat: _clockIncrementTimeFormat,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('init_hour', init.h);
    prefs.setInt('init_minute', init.m);
    prefs.setInt('end_hour', end.h);
    prefs.setInt('end_minute', end.m);
    prefs.setBool('is_disable_range', isDisableRange ?? false);

    setState(() {
      validRange = isDisableRange;
    });
  }

/*  void printAllValues() {
    print("Wake-up Hours: ${_outBedTime.h}");
    print("Wake-up Minutes: ${_outBedTime.m}");
    print("In Bed Time Hours: ${_inBedTime.h}");
    print("In Bed Time Minutes: ${_inBedTime.m}");
    print("Interval Bed Time Hours: ${_intervalBedTime.h}");
    print("Interval Bed Time Minutes: ${_intervalBedTime.m}");
    print("Is Sleep Goal: $_isSleepGoal");
    print("Valid Range: $validRange");
    print("Is Wake Up Alarm Enabled: $_isWakeUpAlarmEnabled");
    print("Is Bed Time Alarm Enabled: $_isBedTimeAlarmEnabled");
  }*/
  void _scheduleAlarm(int hour, int minute, int id) async {
    DateTime now = DateTime.now();
    int selectedMinutes = hour * 60 * 60 + minute * 60;

    int currentMinutes = now.hour * 60 * 60 + now.minute * 60 + now.second;

    late int differenceInSeconds;

    if (selectedMinutes < currentMinutes) {
      selectedMinutes = selectedMinutes + 60 * 24 * 60;
      differenceInSeconds = selectedMinutes - currentMinutes;
    } else if (selectedMinutes > currentMinutes) {
      differenceInSeconds = selectedMinutes - currentMinutes;
    }
    Duration delayDuration = Duration(seconds: differenceInSeconds);
    print("$selectedMinutes selected Seconds");
    print("$currentMinutes Current Seconds");
    print("$differenceInSeconds Difference in Seconds");
    print('$delayDuration Delay Duration');

    await AndroidAlarmManager.oneShot(
      delayDuration,
      id,
      callback,
      wakeup: true,
    );
  }

/*  void _scheduleAlarmForBed() async {
    DateTime now = DateTime.now();
    int selectedMinutes = _inBedTime.h * 60 * 60 + _inBedTime.m * 60;

    int currentMinutes = now.hour * 60 * 60 + now.minute * 60 + now.second;

    late int differenceInSeconds;

    if (selectedMinutes < currentMinutes) {
      selectedMinutes = selectedMinutes + 60 * 24 * 60;
      differenceInSeconds = selectedMinutes - currentMinutes;
    } else if (selectedMinutes > currentMinutes) {
      differenceInSeconds = selectedMinutes - currentMinutes;
    }
    Duration delayDuration = Duration(seconds: differenceInSeconds);
    print("$selectedMinutes selected Seconds");
    print("$currentMinutes Current Seconds");
    print("$differenceInSeconds Difference in Seconds");
    print('$delayDuration Delay Duration');

    await AndroidAlarmManager.oneShot(
      delayDuration,
      1,
      callback,
      wakeup: true,
    );
  }*/
  static bool flag = false;
  static Future<void> stopRingtone() async {
    await FlutterRingtonePlayer.stop();
  }


  static Future<void> callback() async {
    print("Start playing");
    flag = true;
    FlutterRingtonePlayer.play(
      android: AndroidSounds.alarm,
      ios: IosSounds.glass,
      looping: true,
      // Android only - API >= 28
      volume: 0.1,
      // Android only - API >= 28
      asAlarm: false, // Android only - all APIs
    );



    await NotificationService.showNotification(
        title: 'music',
        body: 'body',
        payload: {
          "navigate": "true",
        },
        actionButtons: [
          NotificationActionButton(
            key: 'check',
            label: 'Check it out',
            actionType: ActionType.SilentAction,
            color: Colors.green,
          )
        ]);
    // await Future.delayed(Duration(seconds: 10));
    // stopRingtone();
  }

  // static void stopRingtone() {
  //   FlutterRingtonePlayer.stop();
  //   if (kDebugMode) {
  //     print("Ringtone Stopped");
  //   }
  //
  // }

  Future<void> cancelAlarm(int id) async {
    AndroidAlarmManager.cancel(id);
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = AppBar().preferredSize.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Container(
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                'assets/icon/back.png',
                width: 20,
                height: 20,
              ),
            ),
          ),
        ),
        title: const Text(
          'SLEEP CYCLE',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.only(top: appBarHeight),
        decoration:  const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/icon/bg3.png"), fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _timeWidget(
                  'BedTime',
                  _inBedTime,
                  Icon(
                    Icons.power_settings_new_outlined,
                    size: 25.0,
                    color: Color(0xFF3CDAF7),
                  ),
                ),
                _timeWidget(
                  'WakeUp',
                  _outBedTime,
                  Icon(
                    Icons.notifications_active_outlined,
                    size: 25.0,
                    color: Color(0xFF3CDAF7),
                  ),
                ),
              ],
            ),
            TimePicker(
              initTime: _inBedTime,
              endTime: _outBedTime,
              height: 260.0,
              width: 260.0,
              onSelectionChange: _updateLabels,
              onSelectionEnd: (start, end, isDisableRange) =>
                  print(
                      'onSelectionEnd => init : ${start.h}:${start.m}, end : ${end
                          .h}:${end.m}, isDisableRange: $isDisableRange'),
              primarySectors: _clockTimeFormat.value,
              secondarySectors: _clockTimeFormat.value * 2,
              decoration: TimePickerDecoration(
                baseColor: Color(0xFF1F2633),
                pickerBaseCirclePadding: 15.0,
                sweepDecoration: TimePickerSweepDecoration(
                  pickerStrokeWidth: 30.0,
                  pickerColor: _isSleepGoal ? Color(0xFF3CDAF7) : Colors.white,
                  showConnector: true,
                ),
                initHandlerDecoration: TimePickerHandlerDecoration(
                  color: Color(0xFF141925),
                  shape: BoxShape.circle,
                  radius: 12.0,
                  icon: Icon(
                    Icons.power_settings_new_outlined,
                    size: 20.0,
                    color: Color(0xFF3CDAF7),
                  ),
                ),
                endHandlerDecoration: TimePickerHandlerDecoration(
                  color: Color(0xFF141925),
                  shape: BoxShape.circle,
                  radius: 12.0,
                  icon: Icon(
                    Icons.notifications_active_outlined,
                    size: 20.0,
                    color: Color(0xFF3CDAF7),
                  ),
                ),
                primarySectorsDecoration: TimePickerSectorDecoration(
                  color: Colors.white,
                  width: 1.0,
                  size: 4.0,
                  radiusPadding: 25.0,
                ),
                secondarySectorsDecoration: TimePickerSectorDecoration(
                  color: Color(0xFF3CDAF7),
                  width: 1.0,
                  size: 2.0,
                  radiusPadding: 25.0,
                ),
                clockNumberDecoration: TimePickerClockNumberDecoration(
                  defaultTextColor: Colors.white,
                  defaultFontSize: 12.0,
                  scaleFactor: 2.0,
                  showNumberIndicators: true,
                  clockTimeFormat: _clockTimeFormat,
                  clockIncrementTimeFormat: _clockIncrementTimeFormat,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(62.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${intl.NumberFormat('00').format(
                          _intervalBedTime.h)}Hr ${intl.NumberFormat('00').format(
                          _intervalBedTime.m)}Min',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: _isSleepGoal ? Color(0xFF3CDAF7) : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 300.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFF1F2633),
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<Widget>(
                  future: textWidget(),
                  builder: (context, snapshot) {
                    return snapshot.data ??
                        Container(); // Return the widget or a placeholder
                  },
                ),
              ),
            ),
            SwitchListTile(
              title: Text(
                'Wake Up Alarm',
                style: TextStyle(color: Colors.white),
              ),
              value: _isWakeUpAlarmEnabled,
              onChanged: (value) async {
                setState(() {
                  _isWakeUpAlarmEnabled = value;
                });
                await AppSharedPreferences.setWakeUpAlarmEnabled(value);
                if (_isWakeUpAlarmEnabled) {
                  print('Wake Up Alarm is enabled');
                  _scheduleAlarm(_outBedTime.h, _outBedTime.m, 2);
                } else {
                  print('Wake Up Alarm is disabled');
                  cancelAlarm(2);
                }
                // Implement the logic to handle wake up alarm enable/disable
                // You can update shared preferences or call relevant methods here
              },
            ),
            SwitchListTile(
              title: const Text(
                'Bedtime Alarm',
                style: TextStyle(color: Colors.white),
              ),
              value: _isBedTimeAlarmEnabled,
              onChanged: (value) async {
                setState(() {
                  _isBedTimeAlarmEnabled = value;
                });
                if (_isBedTimeAlarmEnabled) {
                  print('Bed Time Alarm is enabled');
                  _scheduleAlarm(_inBedTime.h, _inBedTime.m, 1);
                } else {
                  print('Bed Time Alarm is disabled');
                  cancelAlarm(1);
                }
                await AppSharedPreferences.setBedTimeAlarmEnabled(value);
                // Implement the logic to handle bedtime alarm enable/disable
                // You can update shared preferences or call relevant methods here
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeWidget(String title, PickedTime time, Icon icon) {
    return Container(
      width: 150.0,
      decoration: BoxDecoration(
        color: Color(0xFF1F2633),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Text(
              '${intl.NumberFormat('00').format(time.h)}:${intl.NumberFormat(
                  '00').format(time.m)}',
              style: TextStyle(
                color: Color(0xFF3CDAF7),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Text(
              '$title',
              style: TextStyle(
                color: Color(0xFF3CDAF7),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            icon,
          ],
        ),
      ),
    );
  }
}
