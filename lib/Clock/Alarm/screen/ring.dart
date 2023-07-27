import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

class ExampleAlarmRingScreen extends StatelessWidget {
  final AlarmSettings alarmSettings;

  const ExampleAlarmRingScreen({Key? key, required this.alarmSettings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/icon/bg3.png"), fit: BoxFit.fill),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Text(
                "ALARM",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
              ),
              SizedBox(height: 100,),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Image(
                      image: AssetImage("assets/icon/wakeup_alarm_ic.png"))),
              Text("WAKE-UP", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),),
              Text('Your Alarm Is Ringigng...', style: TextStyle(fontSize: 22, color: Colors.white),),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  /*RawMaterialButton(
                    onPressed: () {
                      final now = DateTime.now();
                      Alarm.set(
                        alarmSettings: alarmSettings.copyWith(
                          dateTime: DateTime(
                            now.year,
                            now.month,
                            now.day,
                            now.hour,
                            now.minute,
                            0,
                            0,
                          ).add(const Duration(minutes: 1)),
                        ),
                      ).then((_) => Navigator.pop(context));
                    },
                    child: Text(
                      "Snooze",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      Alarm.stop(alarmSettings.id)
                          .then((_) => Navigator.pop(context));
                    },
                    child: Text(
                      "Stop",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),*/
                  Button3(label: 'SNOOZE', iconData: 'assets/icon/snooz.png',onPressed: () {
                    final now = DateTime.now();
                    Alarm.set(
                      alarmSettings: alarmSettings.copyWith(
                        dateTime: DateTime(
                          now.year,
                          now.month,
                          now.day,
                          now.hour,
                          now.minute,
                          0,
                          0,
                        ).add(const Duration(minutes: 1)),
                      ),
                    ).then((_) => Navigator.pop(context));
                  },),
                  Button3(label: 'DISMISS', iconData: 'assets/icon/dismiss.png', onPressed: () {
                    Alarm.stop(alarmSettings.id)
                        .then((_) => Navigator.pop(context));
                  },)
                ],
              ),
              SizedBox(height: 40,)
            ],
          ),
        ),
      ),
    );
  }
}

class Button3 extends StatelessWidget {
  final String label;
  final String iconData;
  final VoidCallback? onPressed;

  const Button3(
      {super.key, required this.label, this.onPressed, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 0),
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
            minimumSize: Size(100, 40),
          ),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Color(0xff254467), // Set the border color
                width: 1.5, // Set the border width
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff0A1933), // Transparent at top left
                  Color.fromRGBO(255, 255, 255, 0.1), // White at bottom right
                ],
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(top: 15, bottom: 15, right: 7, left: 7),
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
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
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
