import 'package:organized_sleep/Clock/NewAlarm/Alarm%20main%20Screen/share_preference_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_picker_sheet/widget/sheet.dart';
import 'package:time_picker_sheet/widget/time_picker.dart';

class SleepGoalScreen extends StatefulWidget {
  const SleepGoalScreen({super.key});

  @override
  State<SleepGoalScreen> createState() => _SleepGoalScreenState();
}

class _SleepGoalScreenState extends State<SleepGoalScreen> {
  DateTime dateTimeSelected = DateTime.now();
  static const String sleepGoalKey = 'sleep_goal';

  @override
  void initState() {
    super.initState();
    _loadSavedTime();
  }

  void _loadSavedTime() async {
    final savedTime = await AppSharedPreferences.getSleepGoal();
    setState(() {
      dateTimeSelected = savedTime;
    });
  }

  void _saveTimeToSharedPreferences(DateTime selectedTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(sleepGoalKey, selectedTime.millisecondsSinceEpoch);
  }

  void _openTimePickerSheet(BuildContext context) async {
    DateTime sleepGoal = await AppSharedPreferences.getSleepGoal();
    Future<void> navigator() async {
      final result = await TimePicker.show<DateTime?>(
        context: context,
        sheet: TimePickerSheet(
          sheetTitle: 'Select Time To Sleep',
          minuteTitle: 'Minute',
          hourTitle: 'Hour',
          saveButtonText: 'Save',
          initialDateTime: sleepGoal,
          sheetCloseIconColor: const Color(0xff131a49),
          saveButtonColor: const Color(0xff76a0e1),
          sheetTitleStyle: const TextStyle(
            color: Color(0xff131a49),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          hourTitleStyle: const TextStyle(
            color: Color(0xff333770),
            fontSize: 22,
          ),
          minuteTitleStyle: const TextStyle(
            color: Color(0xff333770),
            fontSize: 22,
          ),
          wheelNumberItemStyle:
              const TextStyle(color: Colors.black26, fontSize: 18),
          wheelNumberSelectedStyle:
              const TextStyle(color: Colors.black, fontSize: 18),
        ),
      );
      if (result != null) {
        setState(() {
          dateTimeSelected = result;
        });

        _saveTimeToSharedPreferences(result);
      }
    }

    navigator();
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Information',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Expanded(
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Center(child: Text('Sleep Quality')),
                      titleTextStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      content: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Column(
                          children: [
                            Text(
                                'Aim for 7-9 hours of sleep each night for better health. Consistent sleep schedule and a comfy sleep environment contribute to overall well-being.')
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ), //IconButton
        ],
        title: const Text(
          'SLEEP GOAL',
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
              image: AssetImage("assets/icon/bg4.png"), fit: BoxFit.fill),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 85),
                child: Column(
                  children: [
                    const Text(
                      'Sleep Goal',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      '${dateTimeSelected.hour.toString().padLeft(2, '0')} hr : ${dateTimeSelected.minute.toString().padLeft(2, '0')} min',
                      style: const TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: const Image(
                    image: AssetImage("assets/icon/snore_thumb.png"),
                    height: 250,
                    width: 250,
                  )),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(
                    right: 16, left: 16, top: 8, bottom: 8),
                child: ElevatedButton(
                  onPressed: () {
                    _openTimePickerSheet(context);
                  },
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
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
                          Color.fromRGBO(
                              255, 255, 255, 0.1), // White at bottom right
                        ],
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 20, right: 15, left: 15),
                      child: const Text(
                        'Select Sleep Goal',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
