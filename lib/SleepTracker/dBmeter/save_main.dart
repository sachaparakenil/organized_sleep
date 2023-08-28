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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          title: const Text('Warning!',
                              style: TextStyle(color: Colors.red)),
                          content: const Text(
                              'Do you really want to delete all data?'),
                          actions: [
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    20), // Adjust the radius as needed
                                color: const Color(
                                    0xff07327a), // Set the background color
                              ),
                              child: TextButton(
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    20), // Adjust the radius as needed
                                color: const Color(
                                    0xff07327a), // Set the background color
                              ),
                              child: TextButton(
                                child: const Text(
                                  'OK',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  deleteAll();
                                  Navigator.pop(context);
                                },
                              ),
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
          title: const Text(
            'SLEEP REPORT',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(top: appBarHeight + topSpacing),
          decoration: const BoxDecoration(
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          'assets/icon/snore_thumb.png'),
                                      height: 200,
                                      width: 200,
                                    ),
                                    Text(
                                      'No Reports yet',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: box.length,
                                itemBuilder: (context, index) {
                                  int reversedIndex = data.length - 1 - index;
                                  double avgVoice = double.parse(
                                      data[reversedIndex].avgVoice);
                                  String sleepEnvironment;
                                  Color environmentColor;
                                  List<String> sleep =
                                      data[reversedIndex].sleepAt.split(" ");
                                  List<String> wake =
                                      data[reversedIndex].wakeAt.split(" ");
                                  if (avgVoice < 60.0) {
                                    sleepEnvironment = "Good";
                                    environmentColor = Colors.green;
                                  } else if (avgVoice >= 60.0 &&
                                      avgVoice <= 70.0) {
                                    sleepEnvironment = "Moderate";
                                    environmentColor = Colors.amber;
                                  } else if (avgVoice > 70.0 &&
                                      avgVoice < 80.0) {
                                    sleepEnvironment = "Loud";
                                    environmentColor = Colors.orangeAccent;
                                  } else {
                                    sleepEnvironment = "Very Loud";
                                    environmentColor = Colors.redAccent;
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
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 25),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  'Sleep Report      ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      color: environmentColor,
                                                    ),
                                                    child: Text(
                                                      sleepEnvironment,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                const Spacer(),
                                                InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20), // Adjust the radius as needed
                                                            ),
                                                            title: const Text(
                                                                'Warning!',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red)),
                                                            content: const Text(
                                                                'Do you really want to delete this data?'),
                                                            actions: [
                                                              Container(
                                                                height: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20), // Adjust the radius as needed
                                                                  color: const Color(
                                                                      0xff07327a), // Set the background color
                                                                ),
                                                                child:
                                                                    TextButton(
                                                                  child:
                                                                      const Text(
                                                                    'Cancel',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ),
                                                              Container(
                                                                height: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20), // Adjust the radius as needed
                                                                  color: const Color(
                                                                      0xff07327a), // Set the background color
                                                                ),
                                                                child:
                                                                    TextButton(
                                                                  child:
                                                                      const Text(
                                                                    'OK',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    delete(data[
                                                                        reversedIndex]);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: const Icon(
                                                        Icons.delete)),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${sleep[0]} - ${wake[0]}',
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                AtBox(
                                                    label: sleep[1],
                                                    iconData:
                                                        'assets/icon/sleep.png',
                                                    title: 'Sleep At'),
                                                AtBox(
                                                    label: wake[1],
                                                    iconData:
                                                        'assets/icon/wakeup.png',
                                                    title: 'Wake At'),
                                                NoiseBox(
                                                    label:
                                                        '${data[reversedIndex].maxVoice} db',
                                                    title: 'Max Noise'),
                                                NoiseBox(
                                                    label:
                                                        '${data[reversedIndex].avgVoice} db',
                                                    title: 'Avg Noise')
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

class NoiseBox extends StatelessWidget {
  final String label;
  final String title;

  const NoiseBox({super.key, required this.label, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xff254467), // Set the border color
            width: 1.5, // Set the border width
          ),
          gradient: const LinearGradient(
            colors: [
              Color(0xff637ba8),
              Color(0xff02122C),
            ],
          ),
        ),
        child: Column(
          children: [
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(
              height: 5,
            ),
            Text(title, style: sSaveSubText)
          ],
        ),
      ),
    );
  }
}

class AtBox extends StatelessWidget {
  final String label;
  final String iconData;
  final String title;

  const AtBox(
      {super.key,
      required this.label,
      required this.iconData,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xff254467), // Set the border color
            width: 1.5, // Set the border width
          ),
          gradient: const LinearGradient(
            colors: [
              Color(0xff637ba8),
              Color(0xff02122C),
            ],
          ),
        ),
        child: Column(
          children: [
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Image(
                  image: AssetImage(iconData),
                  height: 15,
                  width: 15,
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(title, style: sSaveSubText),
              ],
            )
          ],
        ),
      ),
    );
  }
}
