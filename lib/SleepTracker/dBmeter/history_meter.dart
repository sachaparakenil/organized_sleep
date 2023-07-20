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
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "History Meter ",
            style: kAppbarStyle,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /*dBMeter(maxVoice),*/
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Noise Detected :",
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
                Text("Sleep At : $sleepAt", style: const TextStyle(fontSize: 13)),
                const SizedBox(
                  height: 4,
                ),
                Text("Wake At : $wakeAt", style: const TextStyle(fontSize: 13)),
                const SizedBox(
                  height: 4,
                ),
                Text("Maximum Voice : $maxVoice", style: const TextStyle(fontSize: 13)),
                const SizedBox(
                  height: 4,
                ),
                Text("Average Voice : $avgVoice", style: const TextStyle(fontSize: 13)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
