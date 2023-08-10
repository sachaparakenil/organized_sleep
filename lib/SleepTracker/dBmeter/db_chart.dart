import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// pending testing on different device

class DBChart extends StatelessWidget {
  const DBChart({
    super.key,
    required this.chartData,
  });

  final List<ChartData> chartData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          // border: Border.all(color: const Color(0xFFEDEEEF), width: 1.5),
        ),
        child: SfCartesianChart(
          title: ChartTitle(
              text: 'Graph of noise from the background',
              textStyle:
                  const TextStyle(color: Color(0xFFE1E4E8), fontSize: 13),
              alignment: ChartAlignment.far),
          series: <AreaSeries<ChartData, double>>[
            AreaSeries(
                gradient: const LinearGradient(
                    colors: [Color(0xFFCEE9FF), Color(0xFF35A1FF)],
                    stops: [0.2, 1]),
                borderWidth: 3,
                dataSource: chartData,
                xValueMapper: (ChartData value, _) => value.frames,
                yValueMapper: (ChartData value, _) => value.maxDB?.floor(),
                borderGradient: const LinearGradient(
                    colors: [Color(0xFFCEE9FF), Color(0xFF35A1FF)],
                    stops: [0.2, 1]))
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final double? maxDB;
  final double? meanDB;
  final double frames;

  ChartData(this.maxDB, this.meanDB, this.frames);
}
