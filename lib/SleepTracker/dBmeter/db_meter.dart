import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

//ignore: must_be_immutable
class DbMeter extends StatefulWidget {
  double maxDB = 12;

  DbMeter(this.maxDB, {super.key});

  DbMeter.doNothing({super.key});

  @override
  State<DbMeter> createState() => _DbMeterState();
}

class _DbMeterState extends State<DbMeter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: Color(0xFFEDEEEF), width: 1.5),
      ),
      child: SfRadialGauge(
        title: const GaugeTitle(
            text: "Sleep Tracker Machine",
            textStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        enableLoadingAnimation: true,
        axes: [
          RadialAxis(
            axisLabelStyle: const GaugeTextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Times'),
            minimum: 0,
            maximum: 150,
            pointers: <GaugePointer>[
              NeedlePointer(
                value: widget.maxDB,
                enableAnimation: true,
                lengthUnit: GaugeSizeUnit.factor,
                needleLength: 0.8,
                needleEndWidth: 11,
                gradient: const LinearGradient(colors: <Color>[
                  Colors.white,
                  Colors.white,
                  Colors.white,
                  Colors.white
                ], stops: <double>[
                  0,
                  0.5,
                  0.5,
                  1
                ]),
                needleColor: const Color(0xFFF67280),
                knobStyle: const KnobStyle(
                  knobRadius: 0.1,
                  borderColor: Color(0xff1D5778),
                  sizeUnit: GaugeSizeUnit.factor,
                  color: Colors.white,
                  borderWidth: 0.1,
                  // color: Colors.white,
                ),
              ),
            ],
            majorTickStyle: const MajorTickStyle(
              length: 0.1,
              lengthUnit: GaugeSizeUnit.factor,
              color: Color(0xff445D86), // Color of the major ticks
            ),
            minorTickStyle: const MinorTickStyle(
              length: 0.05,
              lengthUnit: GaugeSizeUnit.factor,
              color: Color(0xff445D86), // Color of the minor ticks
            ),
            ranges: [
              GaugeRange(
                startWidth: 3,
                endWidth: 3,
                startValue: 0,
                endValue: 80,
                color: const Color(0xff33CC66),
              ),
              GaugeRange(
                startWidth: 7,
                endWidth: 7,
                startValue: 75,
                endValue: 100,
                color: const Color(0xFFFFB13B),
              ),
              GaugeRange(
                startWidth: 9,
                endWidth: 9,
                startValue: 100,
                endValue: 125,
                color: const Color(0xff337EFF),
              ),
              GaugeRange(
                startWidth: 12,
                endWidth: 12,
                startValue: 125,
                endValue: 160,
                color: const Color(0xffF80058),
              ),
            ],
            annotations: [
              GaugeAnnotation(
                widget: Center(
                  child: Text(
                    '${widget.maxDB.toStringAsFixed(2)} \n  dB',
                    style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                positionFactor: 0.78,
                angle: 90,
              )
            ],
          ),
        ],
      ),
    );
  }
}
