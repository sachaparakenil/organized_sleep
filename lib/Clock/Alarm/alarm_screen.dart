import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:organized_sleep/Clock/NewAlarm/Alarm%20main%20Screen/ring.dart';
import 'package:organized_sleep/Clock/Alarm/widgets/tile.dart';
import '../NewAlarm/Alarm main Screen/newAlarm.dart';
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
          builder: (context) => const ExampleAlarmRingScreen(),
        ));
    loadAlarms();
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Center(child: Text("SET ALARM")),
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
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/icon/bg3.png"), fit: BoxFit.fill),
          ),
          child: SafeArea(
            child: alarms.isNotEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ListView.separated(
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
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  )
                : Center(
                    child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: const Image(
                              image: AssetImage("assets/icon/alarm_ic'.png"))),
                      const SizedBox(
                        height: 24,
                      ),
                      const Text(
                        "No Alarm Set",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white),
                      ),
                      const Text("Set alarm first",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    ],
                  )),
          ),
        ),
      ]),
    );
  }
}
