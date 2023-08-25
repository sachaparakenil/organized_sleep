import 'package:organized_sleep/Clock/NewAlarm/share_preference_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                      image: AssetImage("assets/icon/snore_thumb.png"))),
              Container(
                padding:
                    const EdgeInsets.only(right: 16, left: 16, top: 8, bottom: 8),
                child: ElevatedButton(
                  onPressed: () {
                    _openTimePickerSheet(context);
                  },
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
              const SizedBox(height: 20),
              Text(
                'Selected Time: ${dateTimeSelected.hour.toString().padLeft(2, '0')}:${dateTimeSelected.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 22, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
