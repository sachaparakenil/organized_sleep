import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:organized_sleep/Clock/StopWatch/stopwatch_screen.dart';
import 'package:organized_sleep/models/details_model.dart';
import 'package:path_provider/path_provider.dart';
import '../Breathing/breathing_main_screen.dart';
import '../Clock/Clock_Home/clock_home_screen.dart';
import '../Music_melodies/music_home_screen.dart';
import '../Clock/Alarm/alarm_screen.dart';
import '../Clock/CountDown/countdown_screen.dart';
import 'package:hive/hive.dart';
import '../Self_meditation/self_meditation.dart';
import '../SleepTracker/SleepAudioTracker/recorder_homeview.dart';
import '../SleepTracker/dBmeter/dB_Data.dart';
import 'home_screen.dart';
import '../Splash_screen/splash_screen.dart';
import 'package:alarm/alarm.dart';
import 'package:organized_sleep/SleepTracker/dBmeter/save_main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(DetailsModelAdapter());
  await Hive.openBox<DetailsModel>("Sleep Report");

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
        '/sleep': (context) =>  const RecorderHomeView(),
        '/meditate': (context) => AudioPlayerPage(),
        '/selfPractice': (context) => const CountdownPage(),
        '/noiseApp': (context) => const NoiseApp(),
      },
    );
  }
}
