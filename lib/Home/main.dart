import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:organized_sleep/Clock/StopWatch/stopwatch_screen.dart';
import 'package:path_provider/path_provider.dart';
import '../Brething/breathing_main_screen.dart';
import '../Clock/Clock_Home/clock_home_screen.dart';
import '../Music_melodies/self_home_screen.dart';
import '../Clock/Alarm/alarm_screen.dart';
import '../Clock/CountDown/countdown_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'home_screen.dart';
import '../Splash_screen/splash_screen.dart';
import '../models/hour_models.dart';
import 'package:alarm/alarm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(hoursAdapter());
  await Hive.openBox<hours>('hour');
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Alarm.init();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Splash()));
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
        '/meditate': (context) => AudioPlayerPage(),
      },
    );
  }
}
