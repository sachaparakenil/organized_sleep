import 'package:organized_sleep/Clock/NewAlarm/notification/notification_service.dart';
import 'package:organized_sleep/Clock/NewAlarm/share_preference_service.dart';
import 'package:organized_sleep/Clock/NewAlarm/sleep_goal.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bedtime.dart';

class TimePickerScreen extends StatefulWidget {
  const TimePickerScreen({super.key});

  @override
  State<TimePickerScreen> createState() => _TimePickerScreenState();
}

class _TimePickerScreenState extends State<TimePickerScreen> {
  Time _time = Time(
      hour: DateTime.now().hour,
      minute: DateTime.now().minute,
      second: DateTime.now().second);
  bool iosStyle = true;
  String label2 = '';
  int initHour = 0;
  int initMinute = 0;
  int endHour = 8;
  int endMinute = 0;
  bool isDisableRange = false;

  @override
  void initState() {
    super.initState();
    retrieveSleepGoal();
  }

  void retrieveSleepGoal() async {
    DateTime sleepGoal = await AppSharedPreferences.getSleepGoal();
    String sleepGoalFormatted = '${sleepGoal.hour.toString().padLeft(2,'0')}:${sleepGoal.minute.toString().padLeft(2, '0')}';
    setState(() {
      label2 = sleepGoalFormatted;
    });
    Map<String, dynamic> values = await AppSharedPreferences.getBedTimeValues();
    setState(() {
      initHour = values['initHour'];
      initMinute = values['initMinute'];
      endHour = values['endHour'];
      endMinute = values['endMinute'];
      isDisableRange = values['isDisableRange'];
    });
  }

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
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
          'ALARM',
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: const Image(
                      image: AssetImage("assets/icon/alarm_ic'.png"))),
              SizedBox(height: 16,),
              Text(
                'BetterSleep Resources',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  children: [
                    Button(
                      label1: 'Sleep Goal',
                      label2: "$label2 hours",
                      onPressed: () async {
                        DateTime sleepGoal =
                            await AppSharedPreferences.getSleepGoal();
                        String sleepGoalFormatted =
                            '${sleepGoal.hour.toString().padLeft(2, '0')}:${sleepGoal.minute.toString().padLeft(2, '0')}';

                        final capturedContext = context; // Capture the context

                        Future<void> navigateAndSetState() async {
                          await Navigator.push(
                            capturedContext, // Use the captured context
                            MaterialPageRoute(
                              builder: (context) => const SleepGoalScreen(),
                            ),
                          );

                          setState(() {
                            label2 = sleepGoalFormatted;
                          });
                        }

                        navigateAndSetState();
                      },
                    ),
                    Button(
                      label1: 'BedTime Goal',
                      label2:
                          '${initHour.toString().padLeft(2, '0')}:${initMinute.toString().padLeft(2, '0')} - ${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')} hours',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BedTime(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String label1;
  final String label2;
  final VoidCallback? onPressed;

  const Button({
    Key? key,
    required this.label1,
    required this.label2, // Pass the label2 value as a parameter
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 16, left: 16, top: 8, bottom: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          // backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),

          disabledForegroundColor: Colors.black.withOpacity(0.38),
          disabledBackgroundColor: Colors.black.withOpacity(0.12),
          padding: EdgeInsets.zero, // To remove padding, if needed
          elevation: 0, // Disabled text color
          minimumSize: const Size(100, 40),
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xff254467), // Set the border color
              width: 1.5, // Set the border width
            ),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff0A1933), // Transparent at top left
                Color.fromRGBO(255, 255, 255, 0.1), // White at bottom right
              ],
            ),
          ),
          child: Container(
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, right: 15, left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label1,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  label2,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Button2 extends StatelessWidget  {
  final String label;
  final String iconData;
  final VoidCallback? onPressed;

  const Button2(
      {super.key, required this.label, this.onPressed, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            // backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
            foregroundColor: Colors.black,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),

            disabledForegroundColor: Colors.black.withOpacity(0.38),
            disabledBackgroundColor: Colors.black.withOpacity(0.12),
            padding: EdgeInsets.zero, // To remove padding, if needed
            elevation: 0, // Disabled text color
            minimumSize: const Size(100, 40),
          ),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xff254467), // Set the border color
                width: 1.5, // Set the border width
              ),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff0A1933), // Transparent at top left
                  Color.fromRGBO(255, 255, 255, 0.1), // White at bottom right
                ],
              ),
            ),
            child: Container(
              padding:
              const EdgeInsets.only(top: 15, bottom: 15, right: 7, left: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(
                      iconData,
                    ),
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(width: 6.0),
                  Center(
                    child: Text(
                      label,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
