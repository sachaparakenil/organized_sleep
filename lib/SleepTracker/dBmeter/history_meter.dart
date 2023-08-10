import 'package:flutter/material.dart';
import '../../constant.dart';
import 'db_meter.dart';

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
    List<String> sleep = sleepAt.split(" ");
    List<String> wake = wakeAt.split(" ");
    final double appBarHeight = AppBar().preferredSize.height;
    const double topSpacing = 50.0;
    double maxVoiceValue = double.parse(maxVoice);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "History Meter ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: appBarHeight + topSpacing),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/icon/bg3.png"), fit: BoxFit.fill),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/icon/snore_thumb.png'),
                height: 200,
                width: 200,
              ),
              DbMeter(maxVoiceValue),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AtIndicator(
                        label1: sleep[1], label2: sleep[0], title: 'SleepAt'),
                    AtIndicator(
                        label1: wake[1], label2: wake[0], title: 'WakeAt'),
                  ],
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 40, right: 20, left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AtIndicator(
                        label1: maxVoice, label2: 'db', title: 'MaxNoise'),
                    AtIndicator(
                        label1: avgVoice, label2: 'db', title: 'AvgNoise')
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xff254467), // Set the border color
                    width: 1.5, // Set the border width
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff0A1933), // Transparent at top left
                      Color.fromRGBO(
                          255, 255, 255, 0.05), // White at bottom right
                    ],
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 100),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors
                        .transparent, // Set the button color to transparent
                    elevation:
                        0, // Set the button elevation to 0 to remove shadow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      // If you want to remove the button's default side padding, you can set the side padding to zero
                      side: BorderSide.none,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => LongList(
                              sniffing: sniffing,
                            )));
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/icon/report.png'),
                        height: 25,
                        width: 25,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Sniffing Data'),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LongList extends StatelessWidget {
  const LongList({super.key, required this.sniffing});
  final List<String> sniffing;

  // List listOfItems = List.generate(20, (index) => 'Sample Item - $index');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Sniffing Data"),
        centerTitle: true,
      ),
      body: sniffing.isEmpty
          ? Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/icon/bg3.png"), fit: BoxFit.fill),
              ),
              child: const Center(
                child: Text(
                  'Your Sleep Is Better\nThan 95% Populations',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/icon/bg3.png"), fit: BoxFit.fill),
              ),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: sniffing.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(color: Colors.white, width: 1.5),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Container(
                                      padding: const EdgeInsets.all(12),
                                      width: 60.0,
                                      height: 60.0,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff173761),
                                      ),
                                      child: const Image(
                                        image: AssetImage(
                                            'assets/icon/snore_ic.png'),
                                        height: 30,
                                        width: 30,
                                        color: Colors.white,
                                      )),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Noise Crossed',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      sniffing[index],
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.redAccent),
                                    child: const Text(
                                      '80dB',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
    );
  }
}

class AtIndicator extends StatelessWidget {
  final String label1;
  final String label2;
  final String title;

  const AtIndicator(
      {super.key,
      required this.label1,
      required this.title,
      required this.label2});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label1,
              style: sHistoryText,
            ),
            Text(
              label2,
              style: sHistorySubText,
            ),
            Text(
              title,
              style: sHistoryNameText,
            )
          ],
        ),
      ),
    );
  }
}

class NoiseIndicator extends StatelessWidget {
  final String label;
  final String title;
  final VoidCallback? onPressed;

  const NoiseIndicator(
      {super.key, required this.label, this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xff254467), // Set the border color
            width: 1.5, // Set the border width
          ),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff0A1933), // Transparent at top left
              Color.fromRGBO(255, 255, 255, 0.05), // White at bottom right
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: sHistoryText,
                ),
              ],
            ),
            Text(
              title,
              style: sHistorySubText,
            )
          ],
        ),
      ),
    );
  }
}
