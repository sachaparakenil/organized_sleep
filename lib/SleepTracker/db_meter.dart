import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class dbMeter extends StatefulWidget {
  double maxDB = 12;

  dbMeter(
    this.maxDB, {super.key}
  );

  dbMeter.doNothing({super.key});

  @override
  State<dbMeter> createState() => _dbMeterState();
}

class _dbMeterState extends State<dbMeter> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFEDEEEF), width: 1.5),
        ),
        child: SfRadialGauge(
          title: const GaugeTitle(
              text: "dB Meter", textStyle: TextStyle(color: Color(0xFF4B4E4F))),
          enableLoadingAnimation: true,
          axes: [
            RadialAxis(
              axisLineStyle: const AxisLineStyle(
                thickness: 0.18,
                thicknessUnit: GaugeSizeUnit.factor,
                gradient: SweepGradient(colors: <Color>[
                  Color(0xff33CC66),
                  Color(0xFFFFB13B),
                  Color(0xffFF7A7A),
                ], stops: <double>[
                  0.13,
                  0.66,
                  1.00
                ]),
              ),
              minimum: 0,
              maximum: 150,
              pointers: [
                NeedlePointer(
                  value: widget.maxDB,
                  enableAnimation: true,
                  lengthUnit: GaugeSizeUnit.factor,
                  needleLength: 0.5,
                  needleEndWidth: 13,
                  gradient: const LinearGradient(colors: <Color>[
                    Color(0xFF313131),
                    Color(0xFF313131),
                    Color(0xFF313131),
                    Color(0xFF313131),
                  ], stops: <double>[
                    0,
                    0.5,
                    0.5,
                    1
                  ]),
                  needleColor: const Color(0xFFF67280),
                  knobStyle: const KnobStyle(
                    knobRadius: 0.06,
                    borderColor: Colors.grey,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: Colors.white,
                    borderWidth: 0.07,
                    // color: Colors.white,
                  ),
                ),
              ],
              ranges: [
                GaugeRange(
                  startValue: 0,
                  endValue: 50,
                  color: const Color(0xff33CC66),
                ),
                GaugeRange(
                  startValue: 50,
                  endValue: 100,
                  color: const Color(0xFFFFB13B),
                ),
                GaugeRange(
                  startValue: 100,
                  endValue: 160,
                  color: const Color(0xffFF7A7A),
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
                      ),
                    ),
                  ),
                  positionFactor: 0.78,
                  angle: 90,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
