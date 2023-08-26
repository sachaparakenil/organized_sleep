import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:organized_sleep/main.dart';
import '../Clock/Alarm/screen/edit_alarm.dart';
import '../Clock/NewAlarm/Alarm main Screen/ring.dart';
import '../Clock/NewAlarm/Alarm main Screen/share_preference_service.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    performAsyncInitialization();
  }

  Future<void> performAsyncInitialization() async {
    await navigate();
    await setAlarm();
  }

  static Future<void> setAlarm() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

/*  static Future<void> stopRingtone() async {
    await FlutterRingtonePlayer.stop();
  }*/
  navigate() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    bool isRingtonePlaying = await AppSharedPreferences.getIsRingtonePlaying();
    debugPrint('$isRingtonePlaying before going in main screen');
    if (isRingtonePlaying) {
      await AppSharedPreferences.setIsRingtonePlaying(false);
      // isRingtonePlaying = false;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ExampleAlarmRingScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BetterSleep()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icon/splash_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(70.0),
          child: Center(
            child: Image(
              image: AssetImage(
                "assets/icon/splash_icon.png",
              ),
            ),
          ),
        ),
      ),
    );
  }
}

