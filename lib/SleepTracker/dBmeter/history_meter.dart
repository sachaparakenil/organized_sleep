import 'package:flutter/material.dart';
import '../SleepAudioTracker/constants.dart';
import 'dB_meter.dart';

class HistoryMeter extends StatelessWidget {
  const HistoryMeter(
      {super.key,
      required this.maxDB,
      required this.date,
      required this.time,
      required this.area});

  final double maxDB;
  final String date, time, area;

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
          dBMeter(maxDB),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Noise Detected :",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " ${maxDB.toStringAsFixed(2)} dB",
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
                Text("Area : $area", style: const TextStyle(fontSize: 13)),
                const SizedBox(
                  height: 4,
                ),
                Text("Date : $date", style: const TextStyle(fontSize: 13)),
                const SizedBox(
                  height: 4,
                ),
                Text("Time : $time", style: const TextStyle(fontSize: 13)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
