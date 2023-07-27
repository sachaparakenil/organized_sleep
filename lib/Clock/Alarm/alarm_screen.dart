import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:organized_sleep/Clock/Alarm/screen/ring.dart';
import 'package:organized_sleep/Clock/Alarm/widgets/tile.dart';
import 'screen/edit_alarm.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  late List<AlarmSettings> alarms;

  static StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ExampleAlarmRingScreen(alarmSettings: alarmSettings),
        ));
    loadAlarms();
  }

/*  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.6,
            child: ExampleAlarmEditScreen(alarmSettings: settings),
          );
        });

    if (res != null && res == true) loadAlarms();
  }*/

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Center(child: Text("SET ALARM")),
          content: SingleChildScrollView(
            child: ExampleAlarmEditScreen(alarmSettings: settings),
          ),
        );
      },
    );

    if (res != null && res == true) {
      loadAlarms();
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
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
      body: Stack(children: [
        Container(
          padding: EdgeInsets.only(top: appBarHeight),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/icon/bg3.png"), fit: BoxFit.fill),
          ),
          child: SafeArea(
            child: alarms.isNotEmpty
                ? /*ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: alarms.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return ExampleAlarmTile(
                        key: Key(alarms[index].id.toString()),
                        title: TimeOfDay(
                          hour: alarms[index].dateTime.hour,
                          minute: alarms[index].dateTime.minute,
                        ).format(context),
                        onPressed: () => navigateToAlarmScreen(alarms[index]),
                        onDismissed: () {
                          Alarm.stop(alarms[index].id).then((_) => loadAlarms());
                        },
                      );
                    },
                  )*/
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: alarms.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) {
                              return ExampleAlarmTile(
                                key: Key(alarms[index].id.toString()),
                                title: TimeOfDay(
                                  hour: alarms[index].dateTime.hour,
                                  minute: alarms[index].dateTime.minute,
                                ).format(context),
                                onPressed: () =>
                                    navigateToAlarmScreen(alarms[index]),
                                onDismissed: () {
                                  Alarm.stop(alarms[index].id)
                                      .then((_) => loadAlarms());
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Button2(
                            label: 'ADD ALARM',
                            iconData: 'assets/icon/add_alarm.png',
                            onPressed: () {
                              navigateToAlarmScreen(null);
                            },
                          ),
                          Button2(
                            label: 'RING ALARM',
                            iconData: 'assets/icon/ring_alarm.png',
                            onPressed: () {
                              final alarmSettings = AlarmSettings(
                                id: 42,
                                dateTime: DateTime.now(),
                                assetAudioPath: 'assets/marimba.mp3',
                              );
                              Alarm.set(alarmSettings: alarmSettings);
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  )
                : Center(
                    child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Image(
                              image: AssetImage("assets/icon/alarm_ic'.png"))),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        "No Alarm Set",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white),
                      ),
                      Text("Set alarm first",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          /*Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                  10), // Set the border radius as desired
                              border: Border.all(
                                color: Colors.white.withOpacity(
                                    0.5), // Set the border color with opacity
                                width: 2.0, // Set the border width as needed
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(255, 255, 255, 0.5),
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: () {
                                navigateToAlarmScreen(null);
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.alarm,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'ADD ALARM',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                  10), // Set the border radius as desired
                              border: Border.all(
                                color: Colors.white.withOpacity(
                                    0.5), // Set the border color with opacity
                                width: 2.0, // Set the border width as needed
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(255, 255, 255, 0.5),
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: () {
                                final alarmSettings = AlarmSettings(
                                  id: 42,
                                  dateTime: DateTime.now(),
                                  assetAudioPath: 'assets/marimba.mp3',
                                );
                                Alarm.set(alarmSettings: alarmSettings);
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.ring_volume,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'RING ALARM',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),*/
                          Button2(
                            label: 'ADD ALARM',
                            iconData: 'assets/icon/add_alarm.png',
                            onPressed: () {
                              navigateToAlarmScreen(null);
                            },
                          ),
                          Button2(
                            label: 'RING ALARM',
                            iconData: 'assets/icon/ring_alarm.png',
                            onPressed: () {
                              final alarmSettings = AlarmSettings(
                                id: 42,
                                dateTime: DateTime.now(),
                                assetAudioPath: 'assets/marimba.mp3',
                              );
                              Alarm.set(alarmSettings: alarmSettings);
                            },
                          ),
                        ],
                      ),
                    ],
                  )),
          ),
        ),
      ]),
    );
  }
}

class Button2 extends StatelessWidget {
  final String label;
  final String iconData;
  final VoidCallback? onPressed;

  const Button2(
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
