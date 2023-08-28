import 'package:organized_sleep/Clock/NewAlarm/notification/notification_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:organized_sleep/Clock/NewAlarm/Alarm%20main%20Screen/share_preference_service.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../../Alarm/screen/edit_alarm.dart';

class BedTime extends StatefulWidget {
  const BedTime({super.key});

  @override
  State<BedTime> createState() => _BedTimeState();
}

class _BedTimeState extends State<BedTime> {
  final ClockTimeFormat _clockTimeFormat = ClockTimeFormat.twentyFourHours;
  final ClockIncrementTimeFormat _clockIncrementTimeFormat =
      ClockIncrementTimeFormat.oneMin;

  PickedTime _inBedTime = PickedTime(h: 0, m: 0);
  PickedTime _outBedTime = PickedTime(h: 8, m: 0);
  PickedTime _intervalBedTime = PickedTime(h: 0, m: 0);

  bool _isSleepGoal = false;

  bool? validRange = true;

  bool _isWakeUpAlarmEnabled = false;
  bool _isBedTimeAlarmEnabled = false;

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
      "Your daily sleep goal is ${hours.toString().padLeft(2, '0')}.${minutes.toString().padLeft(2, '0')} hours.",
      style: const TextStyle(
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

  void _updateLabels(
      PickedTime init, PickedTime end, bool? isDisableRange) async {
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

    if (_isWakeUpAlarmEnabled) {
      cancelAlarm(2);
      _scheduleAlarm(end.h, end.m, 2);
      debugPrint('${end.h}:${end.m} Alarm is Set');
    }
    if (_isBedTimeAlarmEnabled) {
      cancelAlarm(1);
      _scheduleAlarmForBed(init.h, init.m, 1);
      debugPrint('${init.h}:${init.m} Alarm is Set');
    }

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
    debugPrint("$selectedMinutes selected Seconds");
    debugPrint("$currentMinutes Current Seconds");
    debugPrint("$differenceInSeconds Difference in Seconds");
    debugPrint('$delayDuration Delay Duration');

    await AndroidAlarmManager.oneShot(
      delayDuration,
      id,
      callback,
      wakeup: true,
    );
  }

  static Future<void> callback() async {
    debugPrint("Start playing");
    FlutterRingtonePlayer.play(
      android: AndroidSounds.alarm,
      ios: IosSounds.glass,
      looping: true,
      volume: 1,
      asAlarm: true,
    );

    bool isRingtonePlaying = await AppSharedPreferences.getIsRingtonePlaying();
    debugPrint("$isRingtonePlaying  before giving true in notification");

    await AppSharedPreferences.setIsRingtonePlaying(true);
    debugPrint("$isRingtonePlaying  after giving true in notification");

    await NotificationService.showNotification(
      title: 'WakeUp Alarm',
      body:
          "Rise and shine, it's a brand new day filled with endless possibilities!",
      payload: {
        "navigate": "true",
      },
    );
    bool wakeUp = await AppSharedPreferences.getWakeUpAlarmEnabled();
    wakeUp = false;
    AppSharedPreferences.setWakeUpAlarmEnabled(false);
  }

  void _scheduleAlarmForBed(int hour, int minute, int id) async {
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
    debugPrint("$selectedMinutes selected Seconds");
    debugPrint("$currentMinutes Current Seconds");
    debugPrint("$differenceInSeconds Difference in Seconds");
    debugPrint('$delayDuration Delay Duration');

    await AndroidAlarmManager.oneShot(
      delayDuration,
      1,
      callbackForWake,
      wakeup: true,
    );
  }

  static Future<void> callbackForWake() async {
    debugPrint("Start playing");
    FlutterRingtonePlayer.play(
      android: AndroidSounds.alarm,
      ios: IosSounds.glass,
      looping: true,
      volume: 1,
      asAlarm: true,
    );

    bool isRingtonePlaying = await AppSharedPreferences.getIsRingtonePlaying();
    debugPrint("$isRingtonePlaying  before giving true in notification");

    await AppSharedPreferences.setIsRingtonePlaying(true);
    debugPrint("$isRingtonePlaying  after giving true in notification");

    await NotificationService.showNotification(
      title: 'BedTime Reminder',
      body:
          "Embrace the night and let your dreams guide you towards a brighter tomorrow.",
      payload: {
        "navigate": "true",
      },
    );
    bool sleepTime = await AppSharedPreferences.getBedTimeAlarmEnabled();
    sleepTime = false;
    AppSharedPreferences.setBedTimeAlarmEnabled(false);
  }

  Future<void> cancelAlarm(int id) async {
    AndroidAlarmManager.cancel(id);
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = AppBar().preferredSize.height + 10;
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
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/icon/bg3.png"), fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TimePicker(
              initTime: _inBedTime,
              endTime: _outBedTime,
              height: 260.0,
              width: 260.0,
              onSelectionChange: _updateLabels,
              onSelectionEnd: (start, end, isDisableRange) => debugPrint(
                  'onSelectionEnd => init : ${start.h}:${start.m}, end : ${end.h}:${end.m}, isDisableRange: $isDisableRange'),
              primarySectors: _clockTimeFormat.value,
              secondarySectors: _clockTimeFormat.value * 2,
              decoration: TimePickerDecoration(
                baseColor: const Color.fromARGB(110, 255, 255, 255),
                pickerBaseCirclePadding: 15.0,
                sweepDecoration: TimePickerSweepDecoration(
                  pickerStrokeWidth: 30.0,
                  pickerColor: _isSleepGoal
                      ? Colors.white
                      : const Color.fromARGB(110, 255, 255, 255),
                  showConnector: true,
                ),
                initHandlerDecoration: TimePickerHandlerDecoration(
                  color: const Color(0xFF141925),
                  shape: BoxShape.circle,
                  radius: 12.0,
                  icon: const Icon(
                    Icons.bedtime_outlined,
                    size: 20.0,
                    color: Color(0xFF3CDAF7),
                  ),
                ),
                endHandlerDecoration: TimePickerHandlerDecoration(
                  color: const Color(0xFF141925),
                  shape: BoxShape.circle,
                  radius: 12.0,
                  icon: const Icon(
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
                  color: const Color(0xFF3CDAF7),
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
                      '${intl.NumberFormat('00').format(_intervalBedTime.h)}Hr ${intl.NumberFormat('00').format(_intervalBedTime.m)}Min',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: _isSleepGoal
                            ? const Color(0xFF3CDAF7)
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _timeWidget(
                  'BedTime',
                  _inBedTime,
                  const Image(
                    image: AssetImage('assets/icon/sleep.png'),
                    height: 25,
                    width: 25,
                  ),
                ),
                _timeWidget(
                  'WakeUp',
                  _outBedTime,
                  const Image(
                    image: AssetImage('assets/icon/wakeup.png'),
                    height: 25,
                    width: 25,
                  ),
                ),
              ],
            ),
            Container(
              width: 300.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xff254467), // Set the border color
                  width: 1.5, // Set the border width
                ),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff637ba8),
                    Color(0xff02122C),
                  ],
                ),
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
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(18),
                      color: const Color(0xffD3E1F6),
                    ),
                    child: SwitchListTile(
                      title: const Text(
                        'Wake Up Alarm',
                        style: TextStyle(color: Colors.black),
                      ),
                      value: _isWakeUpAlarmEnabled,
                      activeColor: const Color(0xff07327a),
                      inactiveTrackColor: Colors.grey,
                      onChanged: (value) async {
                        setState(() {
                          _isWakeUpAlarmEnabled = value;
                        });
                        await AppSharedPreferences.setWakeUpAlarmEnabled(value);
                        if (_isWakeUpAlarmEnabled) {
                          debugPrint('Wake Up Alarm is enabled');
                          _scheduleAlarm(_outBedTime.h, _outBedTime.m, 2);
                        } else {
                          debugPrint('Wake Up Alarm is disabled');
                          cancelAlarm(2);
                        }
                        // Implement the logic to handle wake up alarm enable/disable
                        // You can update shared preferences or call relevant methods here
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(18),
                      color: const Color(0xffD3E1F6),
                    ),
                    child: SwitchListTile(
                      title: const Text(
                        'Bedtime Alarm',
                        style: TextStyle(color: Colors.black),
                      ),
                      value: _isBedTimeAlarmEnabled,
                      activeColor: const Color(0xff07327a),
                      inactiveTrackColor: Colors.grey,
                      onChanged: (value) async {
                        setState(() {
                          _isBedTimeAlarmEnabled = value;
                        });
                        if (_isBedTimeAlarmEnabled) {
                          debugPrint('Bed Time Alarm is enabled');
                          _scheduleAlarmForBed(_inBedTime.h, _inBedTime.m, 1);
                        } else {
                          debugPrint('Bed Time Alarm is disabled');
                          cancelAlarm(1);
                        }
                        await AppSharedPreferences.setBedTimeAlarmEnabled(
                            value);
                        // Implement the logic to handle bedtime alarm enable/disable
                        // You can update shared preferences or call relevant methods here
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeWidget(String title, PickedTime time, Image image) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xff254467), // Set the border color
          width: 1.5, // Set the border width
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xff637ba8),
            Color(0xff02122C),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Text(
            '${intl.NumberFormat('00').format(time.h)}:${intl.NumberFormat('00').format(time.m)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 7),
          image,
        ],
      ),
    );
  }
}
