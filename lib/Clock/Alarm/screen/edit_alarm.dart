import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
// ignore: unnecessary_import
import 'package:flutter/foundation.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

int id = 0;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
StreamController<String?>.broadcast();

const MethodChannel platform =
MethodChannel('dexterx.dev/flutter_local_notifications_example');

const String portName = 'notification_send_port';

String? selectedNotificationPayload;

const String urlLaunchActionId = 'id_1';

const String navigationActionId = 'id_3';

const String darwinNotificationCategoryText = 'textCategory';

const String darwinNotificationCategoryPlain = 'plainCategory';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class ExampleAlarmEditScreen extends StatefulWidget {
  final AlarmSettings? alarmSettings;

  const ExampleAlarmEditScreen({Key? key, this.alarmSettings})
      : super(key: key);

  @override
  State<ExampleAlarmEditScreen> createState() => _ExampleAlarmEditScreenState();
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

class _ExampleAlarmEditScreenState extends State<ExampleAlarmEditScreen> {
  late bool creating;
  late TimeOfDay selectedTime;
  late bool loopAudio;
  late bool vibrate;
  late bool showNotification;

  bool _notificationsEnabled = false;
  late String assetAudio;
  final _timePickerTheme = TimePickerThemeData(
    backgroundColor:  Colors.white,
    hourMinuteShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide(color: Color(0xff07327a), width: 1),
    ),
    dayPeriodBorderSide: const BorderSide(color: Color(0xff07327a), width: 1),
    dayPeriodColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? const Color(0xff5282d2)
            : const Color(0xffc3cfe5)),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide(color: Color(0xff609ae0), width: 1),
    ),
    dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? Colors.white
            : const Color(0xff86a8e1)),
    dayPeriodShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide(color: Color(0xff07327a), width: 4),
    ),
    hourMinuteColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? const Color(0xff5282d2)
            : const Color(0xffc3cfe5)),
    hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? Colors.white
            : const Color(0xff86a8e1)),
    dialHandColor: const Color(0xff2d70e0),
    dialBackgroundColor: const Color(0xffadbfde),
    hourMinuteTextStyle:
        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    dayPeriodTextStyle:
        const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    helpTextStyle: const TextStyle(
        fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(0),
    ),
    dialTextColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? const Color(0xff07327a)
            : const Color(0xff0d60ec)),
    entryModeIconColor: const Color(0xff07327a),
  );

  @override
  void initState() {
    super.initState();
    _isAndroidPermissionGranted();
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
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

  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled() ??
          false;

      setState(() {
        _notificationsEnabled = granted;
      });
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
      await androidImplementation?.requestPermission();
      setState(() {
        _notificationsEnabled = grantedNotificationPermission ?? false;
      });
    }
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        SecondPage(receivedNotification.payload),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) => SecondPage(payload),
      ));
    });
  }

  Future<void> _showNotificationWithActions() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          urlLaunchActionId,
          'Action 1',
          icon: DrawableResourceAndroidBitmap('food'),
          contextual: true,
        ),
        AndroidNotificationAction(
          'id_2',
          'Action 2',
          titleColor: Color.fromARGB(255, 255, 0, 0),
          icon: DrawableResourceAndroidBitmap('secondary_icon'),
        ),
        AndroidNotificationAction(
          navigationActionId,
          'Action 3',
          icon: DrawableResourceAndroidBitmap('secondary_icon'),
          showsUserInterface: true,
          // By default, Android plugin will dismiss the notification when the
          // user tapped on a action (this mimics the behavior on iOS).
          cancelNotification: false,
        ),
      ],
    );

    const DarwinNotificationDetails iosNotificationDetails =
    DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain,
    );

    const DarwinNotificationDetails macOSNotificationDetails =
    DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain,
    );

    const LinuxNotificationDetails linuxNotificationDetails =
    LinuxNotificationDetails(
      actions: <LinuxNotificationAction>[
        LinuxNotificationAction(
          key: urlLaunchActionId,
          label: 'Action 1',
        ),
        LinuxNotificationAction(
          key: navigationActionId,
          label: 'Action 2',
        ),
      ],
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
      macOS: macOSNotificationDetails,
      linux: linuxNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
        id++, 'plain title', 'plain body', notificationDetails,
        payload: 'item z');
  }

  Future<void> _showFullScreenNotification() async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Turn off your screen'),
        content: const Text(
            'to see the full-screen intent in 5 seconds, press OK and TURN '
                'OFF your screen'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await flutterLocalNotificationsPlugin.zonedSchedule(
                  0,
                  'scheduled title',
                  'scheduled body',
                  tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
                  const NotificationDetails(
                      android: AndroidNotificationDetails(
                          'full screen channel id', 'full screen channel name',
                          channelDescription: 'full screen channel description',
                          priority: Priority.high,
                          importance: Importance.high,
                          fullScreenIntent: true)),
                  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
                  uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime);

              Navigator.pop(context);
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  Future<void> _showSoundUriNotification() async {
    /// this calls a method over a platform channel implemented within the
    /// example app to return the Uri for the default alarm sound and uses
    /// as the notification sound
    final String? alarmUri = await platform.invokeMethod<String>('getAlarmUri');
    final UriAndroidNotificationSound uriSound =
    UriAndroidNotificationSound(alarmUri!);
    final AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('uri channel id', 'uri channel name',
        channelDescription: 'uri channel description',
        sound: uriSound,
        styleInformation: const DefaultStyleInformation(true, true));
    final NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'uri sound title', 'uri sound body', notificationDetails);
  }


  Future<void> _showInsistentNotification() async {
    // This value is from: https://developer.android.com/reference/android/app/Notification.html#FLAG_INSISTENT
    const int insistentFlag = 4;
    final AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        additionalFlags: Int32List.fromList(<int>[insistentFlag]));
    final NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'insistent title', 'insistent body', notificationDetails,
        payload: 'item x');
  }

  Future<void> _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _showOngoingNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ongoing: true,
        autoCancel: false);
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++,
        'ongoing notification title',
        'ongoing notification body',
        notificationDetails);
  }

  Future<void> _getNotificationChannels() async {
    final Widget notificationChannelsDialogContent =
    await _getNotificationChannelsDialogContent();
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: notificationChannelsDialogContent,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<Widget> _getNotificationChannelsDialogContent() async {
    try {
      final List<AndroidNotificationChannel>? channels =
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
          .getNotificationChannels();

      return Container(
        width: double.maxFinite,
        child: ListView(
          children: <Widget>[
            const Text(
              'Notifications Channels',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(color: Colors.black),
            if (channels?.isEmpty ?? true)
              const Text('No notification channels')
            else
              for (AndroidNotificationChannel channel in channels!)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('id: ${channel.id}\n'
                        'name: ${channel.name}\n'
                        'description: ${channel.description}\n'
                        'groupId: ${channel.groupId}\n'
                        'importance: ${channel.importance.value}\n'
                        'playSound: ${channel.playSound}\n'
                        'sound: ${channel.sound?.sound}\n'
                        'enableVibration: ${channel.enableVibration}\n'
                        'vibrationPattern: ${channel.vibrationPattern}\n'
                        'showBadge: ${channel.showBadge}\n'
                        'enableLights: ${channel.enableLights}\n'
                        'ledColor: ${channel.ledColor}\n'),
                    const Divider(color: Colors.black),
                  ],
                ),
          ],
        ),
      );
    } on PlatformException catch (error) {
      return Text(
        'Error calling "getNotificationChannels"\n'
            'code: ${error.code}\n'
            'message: ${error.message}',
      );
    }
  }

  Future<void> _showNotificationWithAudioAttributeAlarm() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your alarm channel id',
      'your alarm channel name',
      channelDescription: 'your alarm channel description',
      importance: Importance.max,
      priority: Priority.high,
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'notification sound controlled by alarm volume',
      'alarm notification sound body',
      platformChannelSpecifics,
    );
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
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => const Color(0xff07327a)),
                  foregroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.white),
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => const Color(0xff07327a)),
                ),
              ),
            ),
            child: child!,
          );
        });
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
          RawMaterialButton(
            onPressed: pickTime,
            fillColor: const Color(0xffD3E1F6),
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Text(selectedTime.format(context),
                  style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff07327a))),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
              color: const Color(0xffD3E1F6),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                const Image(
                  image: AssetImage('assets/icon/loop_audio.png'),
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  'Loop alarm audio',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Switch(
                    value: loopAudio,
                    onChanged: (value) => setState(() => loopAudio = value),
                    activeColor: const Color(0xff07327a),
                    inactiveTrackColor: Colors.grey),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
              color: const Color(0xffD3E1F6),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                const Image(
                  image: AssetImage('assets/icon/vibrate.png'),
                  height: 20,
                  width: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Vibrate',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Switch(
                    value: vibrate,
                    onChanged: (value) => setState(() => vibrate = value),
                    activeColor: const Color(0xff07327a),
                    inactiveTrackColor: Colors.grey),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
              color: const Color(0xffD3E1F6),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                const Image(
                  image: AssetImage('assets/icon/notification.png'),
                  height: 20,
                  width: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Show notification',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Switch(
                    value: showNotification,
                    onChanged: (value) =>
                        setState(() => showNotification = value),
                    activeColor: const Color(0xff07327a),
                    inactiveTrackColor: Colors.grey),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
              color: const Color(0xffD3E1F6),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                const Image(
                  image: AssetImage('assets/icon/sound.png'),
                  height: 20,
                  width: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Sound',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xff07327a),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: SizedBox(
                    height: 30,
                    child: DropdownButton(
                      value: assetAudio,
                      dropdownColor: const Color(0xff07327a),
                      items: const [
                        DropdownMenuItem<String>(
                          value: 'assets/marimba.mp3',
                          child: Text('Marimba',
                              style: TextStyle(color: Colors.white)),
                        ),
                        DropdownMenuItem<String>(
                          value: 'assets/nokia.mp3',
                          child: Text('Nokia',
                              style: TextStyle(color: Colors.white)),
                        ),
                        DropdownMenuItem<String>(
                          value: 'assets/mozart.mp3',
                          child: Text('Mozart',
                              style: TextStyle(color: Colors.white)),
                        ),
                        DropdownMenuItem<String>(
                          value: 'assets/star_wars.mp3',
                          child: Text('Star Wars',
                              style: TextStyle(color: Colors.white)),
                        ),
                        DropdownMenuItem<String>(
                          value: 'assets/one_piece.mp3',
                          child: Text('One Piece',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                      onChanged: (value) => setState(() => assetAudio = value!),
                      underline: Container(),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Color(0xff335796)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Save(
                label: "Cancel",
                onPressed: () => Navigator.pop(context, false),
                color: const Color(0xff07327a),
              )),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                  child: Save(
                label: "Save",
                onPressed: saveAlarm,
                color: const Color(0xff07327a),
              )),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          if (!creating)
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Save(
                  label: "Delete Alarm",
                  onPressed: deleteAlarm,
                  color: const Color(0xffBC544B),
                )),
          const SizedBox(),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Column(children: <Widget>[
                  if (kIsWeb || !Platform.isLinux) ...<Widget>[
                    PaddedElevatedButton(
                      buttonText: 'Cancel all notifications',
                      onPressed: () async {
                        await _cancelAllNotifications();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with plain actions',
                      onPressed: () async {
                        await _showNotificationWithActions();
                      },
                    ),
                    if (Platform.isAndroid) ...<Widget>[
                      PaddedElevatedButton(
                        buttonText: 'Show notification using Android Uri sound',
                        onPressed: () async {
                          await _showSoundUriNotification();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show insistent notification',
                        onPressed: () async {
                          await _showInsistentNotification();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show ongoing notification',
                        onPressed: () async {
                          await _showOngoingNotification();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show full-screen notification',
                        onPressed: () async {
                          await _showFullScreenNotification();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Show notification with sound controlled by '
                            'alarm volume',
                        onPressed: () async {
                          await _showNotificationWithAudioAttributeAlarm();
                        },
                      ),
                      PaddedElevatedButton(
                        buttonText: 'Get notification channels',
                        onPressed: () async {
                          await _getNotificationChannels();
                        },
                      ),
                    ],
                  ],
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Save extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color color;

  const Save(
      {super.key, required this.label, this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius:
            BorderRadius.circular(25), // Set the border radius as desired
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


class SecondPage extends StatefulWidget {
  const SecondPage(
      this.payload, {
        Key? key,
      }) : super(key: key);

  static const String routeName = '/secondPage';

  final String? payload;

  @override
  State<StatefulWidget> createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {
  String? _payload;

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Second Screen'),
    ),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('payload ${_payload ?? ''}'),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Go back!'),
          ),
        ],
      ),
    ),
  );
}

class PaddedElevatedButton extends StatelessWidget {
  const PaddedElevatedButton({
    required this.buttonText,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
    child: ElevatedButton(
      onPressed: onPressed,
      child: Text(buttonText),
    ),
  );
}
