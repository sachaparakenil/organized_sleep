import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organized_sleep/Clock/stopwatch_screen.dart';
import 'package:path_provider/path_provider.dart';
import '../Brething/breathing_main_screen.dart';
import '../Clock/clock_home_screen.dart';
import 'Home/home_screen.dart';
import '../Clock/clock_view.dart';
import '../Clock/alarm_screen.dart';
import '../Clock/countdown_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'home_screen.dart';
import '../models/hour_models.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(hoursAdapter());
  await Hive.openBox<hours>('hour');
  runApp(better_sleep());
}

class better_sleep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/alarm': (context) => AlarmScreen(),
        '/countdown': (context) => CountdownScreen(),
        '/stopwatch': (context) => StopWatchScreen(),
        '/music': (context) => MusicScreen(),
        '/breathing': (context) => BreathingScreen(),
        '/Clock': (context) => ClockScreen(),
        '/sleep': (context) => SleepScreen(),
        '/meditate': (context) => MeditateScreen(),
      },
    );
  }
}