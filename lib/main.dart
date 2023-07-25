import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:organized_sleep/Clock/StopWatch/stopwatch_screen.dart';
import 'package:organized_sleep/models/details_model.dart';
import 'package:organized_sleep/self_meditate/meditation_home_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'Clock/Clock_Home/clock_home_screen.dart';
import 'Clock/Alarm/alarm_screen.dart';
import 'Clock/CountDown/countdown_screen.dart';
import 'package:hive/hive.dart';
import 'SleepTracker/SleepAudioTracker/recorder_homeview.dart';
import 'SleepTracker/dBmeter/dB_Data.dart';
import 'self_meditate/Breathing/breathing_main_screen.dart';
import 'self_meditate/Meditate_Yourself/self_meditation.dart';
import 'self_meditate/Music_melodies/music_home_screen.dart';
import 'Home/home_screen.dart';
import 'Splash_screen/splash_screen.dart';
import 'package:alarm/alarm.dart';
import 'package:audioplayers/audioplayers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(DetailsModelAdapter());
  await Hive.openBox<DetailsModel>("Sleep Report");

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Alarm.init();
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Splash()));
  WidgetsBinding.instance.addObserver(_Handler());
}

class _Handler extends WidgetsBindingObserver {
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      audioPlayer.resume(); // Audio player is a custom class with resume and pause static methods
    } else {
      audioPlayer.pause();
    }
  }
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
        '/meditation': (context) => const Meditation(),
      },
    );
  }
}
