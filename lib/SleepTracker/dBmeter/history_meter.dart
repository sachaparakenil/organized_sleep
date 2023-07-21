import 'package:flutter/material.dart';
import '../SleepAudioTracker/constants.dart';
import 'dB_meter.dart';

class HistoryMeter extends StatelessWidget {
  const HistoryMeter(
      {super.key,
      required this.sleepAt,
      required this.wakeAt,
      required this.maxVoice,
      required this.avgVoice,
      required this.sniffing});

  final List<String> sniffing;
  final String sleepAt, wakeAt, maxVoice, avgVoice;
  @override
  Widget build(BuildContext context) {
    double maxVoiceValue = double.parse(maxVoice);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "History Meter ",
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          dBMeter(maxVoiceValue),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    const Text(
                      "Sleep At: ",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " $sleepAt",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1C95FF)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    const Text(
                      "Wake At: ",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " $wakeAt",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1C95FF)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    const Text(
                      "Maximum Noise: ",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " $maxVoice dB",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1C95FF)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    const Text(
                      "Average Noise: ",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " $avgVoice dB",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1C95FF)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                GestureDetector(
                  onTap: () {
                    print('press view button ${sniffing}');
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => LongList(sniffing: sniffing,)));
                  },
                  child: const Text('Click To View sniffing Data',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class LongList extends StatelessWidget {
   LongList({super.key, required this.sniffing});
   final List<String> sniffing;

  // List listOfItems = List.generate(20, (index) => 'Sample Item - $index');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sniffing Data"),
        centerTitle: true,
      ),
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: sniffing.length,
          itemBuilder: (BuildContext context,int index){
            return GestureDetector(
              onTap: (){
                print('Tapped on item #$index');
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('${index + 1}.'),
                        SizedBox(width: 4,),
                        Text(sniffing[index]),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
