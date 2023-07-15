import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:organized_sleep/Clock/StopWatch/stopwatch_screen.dart';
import 'package:path_provider/path_provider.dart';
import '../Breathing/breathing_main_screen.dart';
import '../Clock/Clock_Home/clock_home_screen.dart';
import '../Music_melodies/music_home_screen.dart';
import '../Clock/Alarm/alarm_screen.dart';
import '../Clock/CountDown/countdown_screen.dart';
import 'package:hive/hive.dart';
import '../Self_meditation/self_meditation.dart';
import '../SleepTracker/sleep_home.dart';
import 'home_screen.dart';
import '../Splash_screen/splash_screen.dart';
import '../models/hour_models.dart';
import 'package:alarm/alarm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(HoursAdapter());
  await Hive.openBox<Hours>('hour');
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Alarm.init();
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Splash()));
}

class BetterSleep extends StatelessWidget {
  const BetterSleep({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/alarm': (context) => const AlarmScreen(),
        '/countdown': (context) => const CountdownScreen(),
        '/stopwatch': (context) => const StopWatchScreen(),
        '/breathing': (context) => const BreathingScreen(),
        '/Clock': (context) => const ClockScreen(),
        '/sleep': (context) =>  const SleepScreen(),
        '/meditate': (context) => AudioPlayerPage(),
        '/selfPractice': (context) => const CountdownPage(),
      },
    );
  }
}
