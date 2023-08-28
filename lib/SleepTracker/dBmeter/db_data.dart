// Initial Phase done 1

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:organized_sleep/Clock/CountDown/countdown_screen.dart';
import 'package:organized_sleep/SleepTracker/dBmeter/save_main.dart';
import 'package:organized_sleep/models/details_model.dart';
import '../../boxes/boxes.dart';
import '../SleepAudioTracker/recorder_homeview.dart';
import 'db_chart.dart';
import 'db_meter.dart';

class NoiseApp extends StatefulWidget {
  const NoiseApp({super.key});

  @override
  NoiseAppState createState() => NoiseAppState();
}

class NoiseAppState extends State<NoiseApp> with WidgetsBindingObserver {
  DateTime currentDate = DateTime.now();
  DateTime currentTime = DateTime.now();

  // DBValueCount dbValueCount = DBValueCount();

  String? selectedValue;

  // List to store time and date when noise crosses 80dB
  List<String> noiseCrossed80dBList = [];

  // five variables for noise recording
  bool isRecording = false;
  StreamSubscription<NoiseReading>? noiseSubscription;
  late NoiseMeter noiseMeter;
  double maxDB = 0;
  double? meanDB;
  double maxVoice = 0;

  // These three variables for chart
  List<ChartData> chartData = <ChartData>[];
  // ChartSeriesController? _chartSeriesController;
  late int previousMillis;
  late String startingTime;
  late String endingTime;
  late DateTime startTime;
  late DateTime endTime;

  @override
  void initState() {
    super.initState();
    noiseMeter = NoiseMeter(onError);
    // start();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.paused) {
      chartData.clear();
    }
  }

/*  @override
  void dispose() {
    super.dispose();
    stop();
  }*/
  @override
  void dispose() {
    super.dispose();
    if (noiseSubscription != null) {
      noiseSubscription!.cancel();
    }
    chartData.clear();
  }

  //method for taking noise data
  void onData(NoiseReading noiseReading) {
    setState(() {
      if (!isRecording) isRecording = true;
    });
    maxDB = noiseReading.maxDecibel;
    meanDB = noiseReading.meanDecibel;

    if (maxVoice <= maxDB) {
      maxVoice = maxDB;
    }

    // Check if the noise crosses 80dB and store DateTime value in the List
    if (maxDB > 80 && chartData.isNotEmpty && chartData.last.maxDB! <= 80) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('E, d MMM yyyy HH:mm').format(now);
      if (noiseCrossed80dBList.contains(formattedDate)) {
      } else {
        noiseCrossed80dBList.add(formattedDate);
      }
      // print(noiseCrossed80dBList);
    }

    chartData.add(
      ChartData(
        maxDB,
        meanDB,
        ((DateTime.now().millisecondsSinceEpoch - previousMillis) / 60000)
            .toDouble(),
      ),
    );
  }

  // error handle
  void onError(Object e) {
    if (kDebugMode) {
      print(e.toString());
    }
    isRecording = false;
  }

  void start() async {
    noiseCrossed80dBList.clear();
    DateTime now = DateTime.now();
    startingTime = DateFormat('dd:MM:yyyy HH:mm').format(now);
    startTime = DateFormat('dd:MM:yyyy HH:mm').parse(startingTime);
    previousMillis = DateTime.now().millisecondsSinceEpoch;
    try {
      noiseSubscription = noiseMeter.noise.listen(onData);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // User pressed stop
  void stop() async {
    try {
      noiseSubscription!.cancel();
      noiseSubscription = null;

      setState(() => isRecording = false);
    } catch (e) {
      if (kDebugMode) {
        print('stopRecorder error: $e');
      }
    }
    previousMillis = 0;
    chartData.clear();

    DateTime now = DateTime.now();
    endingTime = DateFormat('dd:MM:yyyy HH:mm').format(now);
    endTime = DateFormat('dd:MM:yyyy HH:mm').parse(endingTime);
    Duration difference = endTime.difference(startTime);

    // int daysDifference = difference.inDays;
    // int hoursDifference = difference.inHours % 24;
    int minutesDifference = difference.inMinutes % 60;

    if (minutesDifference > 10) {
      String max = maxVoice.toStringAsFixed(2);
      String avg = meanDB!.toStringAsFixed(2);
      final data = DetailsModel(
          sleepAt: startingTime,
          wakeAt: endingTime,
          maxVoice: max,
          avgVoice: avg,
          sniffing: noiseCrossed80dBList);

      final box = Boxes.getData();
      box.add(data);
      data.save();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20), // Adjust the radius as needed
            ),
            title: const Text('Warning!', style: TextStyle(color: Colors.red)),
            content: const Text(
                'To track your sleep,\nyou must use this tracker device for at least 10 minutes!'),
            actions: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(20), // Adjust the radius as needed
                  color: const Color(0xff07327a), // Set the background color
                ),
                child: TextButton(
                  child: const Text(
                    'Ok',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = AppBar().preferredSize.height;
    const double topSpacing = 50.0;
    /*String date = "${currentDate.day}-${currentDate.month}-${currentDate.year}";
    String time = "${currentTime.hour}:${currentTime.minute}";*/

    if (chartData.length >= 100) {
      chartData.removeAt(0);
    }
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
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "SLEEP TRACKER",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(100, 34), // specify width, height
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                    20,
                  ))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SaveMain()),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/icon/report.png'),
                    height: 20,
                    width: 20,
                  ),
                  Text(
                    'Report',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Button4(
              label: isRecording ? 'STOP' : 'START',
              iconData: isRecording
                  ? 'assets/icon/dismiss.png'
                  : 'assets/icon/play.png',
              onPressed: isRecording ? stop : start,
              buttonColor1: const Color(0xff0A1933),
              buttonColor2: const Color.fromRGBO(255, 255, 255, 0.1),
            ),
            Button4(
              label: "RECORD",
              iconData: 'assets/icon/record_data.png',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RecorderHomeView()),
                );
              },
              buttonColor1: const Color(0xff0A1933),
              buttonColor2: const Color.fromRGBO(255, 255, 255, 0.1),
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: appBarHeight + topSpacing),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/icon/bg3.png"), fit: BoxFit.fill),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 350, child: DbMeter(maxDB)),

            // Chart according the noise meter
            Expanded(child: DBChart(chartData: chartData)),

            // space between chart and floatingActionButton
            const SizedBox(
              height: 68,
            ),
          ],
        ),
      ),
    );
  }
}
