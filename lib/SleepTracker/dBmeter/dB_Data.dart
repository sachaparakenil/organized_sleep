// Initial Phase done 1

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../SleepAudioTracker/constants.dart';
import '../SleepAudioTracker/recorder_homeview.dart';
import 'dB_Chart.dart';
import 'dB_meter.dart';

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

  // five variables for noise recording
  bool isRecording = false;
  StreamSubscription<NoiseReading>? noiseSubscription;
  late NoiseMeter noiseMeter;
  double maxDB = 0;
  double? meanDB;

  // These three variables for chart
  List<ChartData> chartData = <ChartData>[];
  ChartSeriesController? _chartSeriesController;
  late int previousMillis;

  @override
  void initState() {
    super.initState();
    noiseMeter = NoiseMeter(onError);
    start();
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

  @override
  void dispose() {
    super.dispose();
    stop();
  }

  //method for taking noise data
  void onData(NoiseReading noiseReading) {
    setState(() {
      if (!isRecording) isRecording = true;
    });
    maxDB = noiseReading.maxDecibel;
    meanDB = noiseReading.meanDecibel;

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
    previousMillis = DateTime.now().millisecondsSinceEpoch;
    try {
      noiseSubscription = noiseMeter.noise.listen(onData);
    } catch (e) {
      print(e);
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
  }

  @override
  Widget build(BuildContext context) {
    String date = "${currentDate.day}-${currentDate.month}-${currentDate.year}";
    String time =
        "${currentTime.hour}:${currentTime.minute}:${currentTime.second}";

    if (chartData.length >= 100) {
      chartData.removeAt(0);
    }
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Sleep Tracker",
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onDoubleTap: () {},
                  child: FloatingActionButton.extended(
                    heroTag: isRecording ? 'STOP' : 'START',
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    label: Text(
                      isRecording ? 'STOP' : 'START',
                      style: kButtonTextStyle,
                    ),
                    onPressed: isRecording ? stop : start,
                    backgroundColor:
                        isRecording ? Color(0xFFFF5959) : Color(0xFFA9D539),
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: FloatingActionButton.extended(
                  label: const Text(
                    "SAVE",
                    style: kButtonTextStyle,
                  ),
                  heroTag: "SAVE",
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  backgroundColor: Color(0xFF0065FD),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  const RecorderHomeView()),
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: FloatingActionButton.extended(
                  label: const Text(
                    "RECORD",
                    style: kButtonTextStyle,
                  ),
                  heroTag: "RECORD",
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  backgroundColor: Color(0xFFFFB13B),
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  const RecorderHomeView()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Container(height: 350, child: dBMeter(maxDB)),

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