/*
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../SleepAudioTracker/constants.dart';
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

}*/

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:organized_sleep/models/details_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../boxes/boxes.dart';
import '../../constant.dart';
import 'history_meter.dart';

class SaveMain extends StatefulWidget {
  const SaveMain({super.key});

  @override
  State<SaveMain> createState() => SaveMainState();
}

class SaveMainState extends State<SaveMain> {
  SaveMainState();
  final box = Boxes.getData();

  void deleteAll() async {
    box.clear();
  }

  Future<void> delete(DetailsModel detailsModel) async {
    await detailsModel.delete();
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = AppBar().preferredSize.height;
    const double topSpacing = 50.0;
    // List<String> sleep = sleepAt.split(" ");
    // List<String> wake = wakeAt.split(" ");
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Warning!',
                              style: TextStyle(color: Colors.red)),
                          content: const Text(
                              'Do you really want to delete all data?'),
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
          title: Text(
            'Sleep Report',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(top: appBarHeight + topSpacing),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/icon/bg3.png"), fit: BoxFit.fill),
          ),
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: FutureBuilder(
                future: Hive.openBox('Sleep Report'),
                builder: (context, snapshot) {
                  return ValueListenableBuilder<Box<DetailsModel>>(
                      valueListenable: Boxes.getData().listenable(),
                      builder: (context, box, _) {
                        var data = box.values.toList().cast<DetailsModel>();
                        return box.isEmpty
                            ? const Center(
                                child: Text(
                                  'No records yet',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : ListView.builder(
                                itemCount: box.length,
                                itemBuilder: (context, index) {
                                  int reversedIndex = data.length - 1 - index;
                                  double avgVoice = double.parse(
                                      data[reversedIndex].avgVoice);
                                  String sleepEnvironment;
                                  List<String> sleep = data[reversedIndex]
                                      .sleepAt.split(" ");
                                  List<String> wake = data[reversedIndex]
                                      .wakeAt.split(" ");
                                  if (avgVoice < 50.0) {
                                    sleepEnvironment = "Peaceful";
                                  } else if (avgVoice >= 50.0 &&
                                      avgVoice <= 65.0) {
                                    sleepEnvironment = "Pleasant";
                                  } else if (avgVoice > 65.0 &&
                                      avgVoice < 80.0) {
                                    sleepEnvironment = "Ordinary";
                                  } else {
                                    sleepEnvironment = "Unpleasant";
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HistoryMeter(
                                            maxVoice:
                                                data[reversedIndex].maxVoice,
                                            sleepAt: data[reversedIndex]
                                                .sleepAt
                                                .toString(),
                                            wakeAt: data[reversedIndex]
                                                .wakeAt
                                                .toString(),
                                            avgVoice: data[reversedIndex]
                                                .avgVoice
                                                .toString(),
                                            sniffing:
                                                data[reversedIndex].sniffing,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                    'Sleep Report      '),
                                                Text(sleepEnvironment),
                                                Spacer(),
                                                InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                        context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Warning!',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red)),
                                                            content: const Text(
                                                                'Do you really want to delete this data?'),
                                                            actions: [
                                                              TextButton(
                                                                child: const Text(
                                                                    'Cancel'),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                              TextButton(
                                                                child:
                                                                Text('OK'),
                                                                onPressed: () {
                                                                  delete(data[
                                                                  reversedIndex]);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Icon(Icons.delete)),
                                              ],
                                            ),
                                            SizedBox(height: 8,),
                                            Row(
                                              children: [
                                                Text('${sleep[0]} - ${wake[0]}'),
                                              ],
                                            ),
                                            SizedBox(height: 5,),
                                            /*Row(
                                              children: [
                                                Text(
                                                    'Sleep At: ${data[reversedIndex].sleepAt}'),
                                                Spacer(),
                                                InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Warning!',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red)),
                                                            content: const Text(
                                                                'Do you really want to delete this data?'),
                                                            actions: [
                                                              TextButton(
                                                                child: const Text(
                                                                    'Cancel'),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                              TextButton(
                                                                child:
                                                                    Text('OK'),
                                                                onPressed: () {
                                                                  delete(data[
                                                                      reversedIndex]);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Icon(Icons.delete)),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    'Wake At: ${data[reversedIndex].wakeAt}'),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    'Maximum Voice: ${data[reversedIndex].maxVoice} db'),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    'Average Voice: ${data[reversedIndex].avgVoice} db'),
                                                Spacer(),
                                                Container(
                                                  child: Text(
                                                      'Sleep environment: $sleepEnvironment'),
                                                ),
                                                *//*if(50 > (int.parse(data[reversedIndex].avgVoice)))
                                              Container(
                                                  child: Text('Sleep envirnoment: Peaceful')
                                              ),
                                            if(50 <= (int.parse(data[reversedIndex].avgVoice)) && (int.parse(data[reversedIndex].avgVoice)) <= 65)
                                              Container(
                                                child: Text('Sleep envirnoment: Pleasant')
                                              ),
                                            if(65< (int.parse(data[reversedIndex].avgVoice)) && (int.parse(data[reversedIndex].avgVoice)) <80)
                                              Container(
                                                child: Text('Sleep envirnoment: Ordinary'),
                                              ),
                                            if(80<= (int.parse(data[reversedIndex].avgVoice)))
                                              Container(
                                                child: Text('Sleep envirnoment: Unpleasant '),
                                              )*//*
                                              ],
                                            ),*/
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(
                                                        color:
                                                        Color(0xff254467), // Set the border color
                                                        width: 1.5, // Set the border width
                                                      ),
                                                        color: Color(0xff26344A)
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Text(sleep[1], style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                                        SizedBox(height: 5,),
                                                        Row(
                                                          children: [
                                                            Image(image: AssetImage('assets/icon/sleep.png'),height: 15,width: 15,),
                                                            SizedBox(width: 3,),
                                                            Text('Sleep At',style: sSaveSubText),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(
                                                        color:
                                                        Color(0xff254467), // Set the border color
                                                        width: 1.5, // Set the border width
                                                      ),
                                                        color: Color(0xff26344A)
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Text(wake[1], style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                                                        SizedBox(height: 5,),
                                                        Row(
                                                          children: [
                                                            Image(image: AssetImage('assets/icon/wakeup.png'),height: 15,width: 15,),
                                                            SizedBox(width: 3,),
                                                            Text('Wake At',style: sSaveSubText),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(
                                                        color:
                                                        Color(0xff254467), // Set the border color
                                                        width: 1.5, // Set the border width
                                                      ),
                                                        color: Color(0xff26344A)
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Text('${data[reversedIndex].maxVoice} db', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                                                        SizedBox(height: 5,),
                                                        Text('Max Noise',style: sSaveSubText)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(
                                                        color:
                                                        Color(0xff254467), // Set the border color
                                                        width: 1.5, // Set the border width
                                                      ),
                                                      color: Color(0xff26344A)
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Text('${data[reversedIndex].avgVoice} db', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                                        SizedBox(height: 5,),
                                                        Text('Avg Noise',style: sSaveSubText)
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                      });
                }),
          ),
        ));
  }
}
