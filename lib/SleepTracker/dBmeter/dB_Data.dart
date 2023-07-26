// Initial Phase done 1

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:organized_sleep/SleepTracker/dBmeter/save_main.dart';
import 'package:organized_sleep/models/details_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../boxes/boxes.dart';
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

    if(maxVoice <= maxDB){
      maxVoice = maxDB;
    }

    // Check if the noise crosses 80dB and store DateTime value in the List
    if (maxDB > 80 && chartData.isNotEmpty && chartData.last.maxDB! <= 80) {
      DateTime now = DateTime.now();
      String formattedDate = 'Noise crossed 80dB at ${DateFormat('E, d MMM yyyy HH:mm').format(now)}';
      if(noiseCrossed80dBList.contains(formattedDate)){

      }else{
        noiseCrossed80dBList.add(formattedDate);
      }
      print(noiseCrossed80dBList);
    }

    chartData.add(
      ChartData(
        maxDB,
        meanDB,
        ((DateTime.now().millisecondsSinceEpoch - previousMillis) / 60000).toDouble(),
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
    DateTime now = DateTime.now();
    startingTime = DateFormat('dd:MM:yyyy HH:mm').format(now);
    startTime = DateFormat('dd:MM:yyyy HH:mm').parse(startingTime);
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

    DateTime now = DateTime.now();
    endingTime = DateFormat('dd:MM:yyyy HH:mm').format(now);
    endTime = DateFormat('dd:MM:yyyy HH:mm').parse(endingTime);
    Duration difference = endTime.difference(startTime);

    int daysDifference = difference.inDays;
    int hoursDifference = difference.inHours % 24;
    int minutesDifference = difference.inMinutes % 60;


    if(minutesDifference > 2){
      print(noiseCrossed80dBList);
      print(maxVoice);
      print(meanDB);
      print("Time difference: $daysDifference days, $hoursDifference hours, $minutesDifference minutes");
      print(startTime);
      print(endTime);
    }
    String max = maxVoice.toStringAsFixed(2);
    String avg = meanDB!.toStringAsFixed(2);


    /*var box = await Hive.openBox('Sleep Report');
    box.put('SleepAt', startingTime);
    box.put('WakeAt', endingTime);
    box.put('maxVoice', max);
    box.put('AvgVoice', avg);
    box.put('list', noiseCrossed80dBList);*/

    final data = DetailsModel(sleepAt: startingTime, wakeAt: endingTime, maxVoice: max, avgVoice: avg, sniffing: noiseCrossed80dBList);

    final box = Boxes.getData();
    box.add(data);
    data.save();
    // noiseCrossed80dBList.clear();


  }



  @override
  Widget build(BuildContext context) {
    String date = "${currentDate.day}-${currentDate.month}-${currentDate.year}";
    String time =
        "${currentTime.hour}:${currentTime.minute}";

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
          centerTitle: true,
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
                    "REPORT",
                    style: kButtonTextStyle,
                  ),
                  heroTag: "REPORT",
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  backgroundColor: Color(0xFF5783DB),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  const SaveMain()),
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