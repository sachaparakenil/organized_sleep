import 'dart:async';
import 'package:flutter/material.dart';
import 'package:organized_sleep/Clock/CountDown/countdown_screen.dart';

class StopWatchScreen extends StatefulWidget {
  const StopWatchScreen({Key? key}) : super(key: key);

  @override
  State<StopWatchScreen> createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen> {
  int seconds = 0, minutes = 0, hours = 0;
  String digitSeconds = "00", digitMinutes = "00", digitHours = "00";
  Timer? timer;
  bool started = false;
  List laps = [];

  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  void reset() {
    timer!.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;
      digitHours = "00";
      digitMinutes = "00";
      digitSeconds = "00";
      laps.clear();
      started = false;
    });
  }

  void addLaps() {
    String lap = "$digitHours:$digitMinutes:$digitSeconds";
    setState(() {
      laps.add(lap);
    });
  }

  void start() {
    started = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int localSeconds = seconds + 1;
      int localMinutes = minutes;
      int localHours = hours;
      if (localSeconds > 59) {
        localMinutes++;
        localSeconds = 0;
        if (localMinutes > 59) {
          localHours++;
          localMinutes = 0;
        }
      }
      setState(() {
        seconds = localSeconds;
        minutes = localMinutes;
        hours = localHours;
        digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
        digitHours = (hours >= 10) ? "$hours" : "0$hours";
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = AppBar().preferredSize.height;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
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
          title: const Text('STOPWATCH',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(top: appBarHeight),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/icon/bg3.png"), fit: BoxFit.fill),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
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
                            255, 255, 255, 0.1), // White at bottom right
                      ],
                    ),
                  ),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: digitHours,
                            style: const TextStyle(
                                fontSize: 50,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                            text: 'HOURS',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          TextSpan(
                            text: ' $digitMinutes',
                            style: const TextStyle(
                                fontSize: 50,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                            text: 'MIN',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          TextSpan(
                            text: ' $digitSeconds',
                            style: const TextStyle(
                                fontSize: 50,
                                color: Color(0xff337EFF),
                                fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                            text: 'SEC',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      (started) ? addLaps() : null;
                    },
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),

                      disabledForegroundColor: Colors.black.withOpacity(0.38),
                      disabledBackgroundColor: Colors.black.withOpacity(0.12),
                      padding: EdgeInsets.zero, // To remove padding, if needed
                      elevation: 0, // Disabled text color
                      minimumSize: const Size(100, 40),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color:
                              const Color(0xff3060A3), // Set the border color
                          width: 1, // Set the border width
                        ),
                        color: const Color(0xff1466F2),
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 15, right: 7, left: 7),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('assets/icon/lap.png'),
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 6.0),
                            Center(
                              child: Text(
                                'LAP',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 0, right: 10, left: 10, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Button4(
                        label: (started) ? "PAUSE" : "START",
                        iconData: (started)
                            ? 'assets/icon/pause.png'
                            : 'assets/icon/play.png',
                        onPressed: () {
                          (started) ? stop() : start();
                        },
                        buttonColor1: const Color(0xff0A1933),
                        buttonColor2: const Color.fromRGBO(255, 255, 255, 0.1),
                      ),
                      Button4(
                        label: "STOP",
                        iconData: 'assets/icon/dismiss.png',
                        onPressed: () {
                          reset();
                        },
                        buttonColor1: const Color(0xff0A1933),
                        buttonColor2: const Color.fromRGBO(255, 255, 255, 0.1),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color(0xff254467), // Set the border color
                        width: 1.5, // Set the border width
                      ),
                      color: Colors.white,
                    ),
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: laps.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: const Color(0xffD3E1F6)),
                            margin: const EdgeInsets.all(10.0),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Lap No. ${index + 1}",
                                  style: const TextStyle(
                                    color: Color(0xff0A1933),
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  laps[index],
                                  style: const TextStyle(
                                    color: Color(0xff0A1933),
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
