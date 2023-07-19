/*

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../SleepAudioTracker/constants.dart';
import 'history_meter.dart';


class SaveMain extends StatefulWidget {
  double? dBNoise;
  String? date, time, area;

  SaveMain(double this.dBNoise, String this.date, this.time, this.area);

  SaveMain.history({super.key});

  @override
  State<SaveMain> createState() =>
      SaveMainState(dBNoise: dBNoise, date: date, time: time, area: area);
}

class SaveMainState extends State<SaveMain> {
  final double? dBNoise;
  final String? date, time, area;
  SaveMainState(
      {required this.dBNoise,
      required this.date,
      required this.time,
      required this.area});

  final box = Boxes.getData();

  @override
  Widget build(BuildContext context) {
    print(dBNoise);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                icon: Image.asset("assets/images/d1.png"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Warning!',
                            style: TextStyle(color: Colors.red)),
                        content: const Text(
                            'Do you really want to delete all images!'),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              deleteAll();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                  setState(() {});
                }),
          ),

        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Image.asset(
              'assets/images/back.png',
              height: 28,
              width: 28,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "Saved Noise",
            style: kAppbarStyle,
          ),
        ),
      ),
      body: ValueListenableBuilder<Box<SaveModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<SaveModel>();

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              int reversedIndex = data.length - 1 - index;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryMeter(
                        maxDB: data[reversedIndex].noiseData,
                        area: data[reversedIndex].area.toString(),
                        date: data[reversedIndex].date.toString(),
                        time: data[reversedIndex].time.toString(),
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        20), // Set the desired border radiusSet the desired background color
                  ),
                  child: Padding(
                    // outside card padding
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: Card(
                      // elevation: 0,
                      color: Color(0xffF6F7F8),
                      child: Padding(
                        //content padding
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 12, left: 16, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Noise Detected :",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      " ${data[reversedIndex].noiseData.toStringAsFixed(2)} dB",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF1C95FF)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                    "Area  :  ${data[reversedIndex].area.toString()}",
                                    style: const TextStyle(fontSize: 13)),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                    "Date  :  ${data[reversedIndex].date.toString()}",
                                    style: const TextStyle(fontSize: 13)),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                    "Time  :  ${data[reversedIndex].time.toString()}",
                                    style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                            Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Warning!',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          content: const Text(
                                              'Do you really want to delete this Noise!'),
                                          actions: [
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                delete(data[reversedIndex]);

                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    setState(() {});
                                  },
                                  icon: Image.asset(
                                    "assets/images/d2.png",                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void delete(SaveModel saveModel) async {
    await saveModel.delete();
    // Hive.box("SaveModel").clear();
  }

  void deleteAll() async {
    box.clear();
  }

}
*/
