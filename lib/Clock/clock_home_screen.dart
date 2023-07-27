import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'clock_view.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  late Timer _timer;
  late DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = AppBar().preferredSize.height;
    const double topSpacing = 50.0;
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
        centerTitle: true,
        title: const Text('CLOCK', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/icon/bg2.png"), fit: BoxFit.fill),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: appBarHeight + topSpacing),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      ClockView(
                        size: MediaQuery.of(context).size.height / 4,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        DateFormat("HH:mm").format(_currentTime),
                        style: const TextStyle(
                            fontSize: 55,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat("EEE, d MMM").format(_currentTime),
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Click(
                                label: "Alarm",
                                onPressed: () {
                                  Navigator.pushNamed(context, '/alarm');
                                },
                                iconData: "assets/icon/alarm_.png"),
                            Click(
                                label: "CountDown",
                                onPressed: () {
                                  Navigator.pushNamed(context, '/countdown');
                                },
                                iconData: "assets/icon/countdown.png"),
                            Click(
                                label: "StopWatch",
                                onPressed: () {
                                  Navigator.pushNamed(context, '/stopwatch');
                                },
                                iconData: "assets/icon/timer.png")
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Click extends StatelessWidget {
  final String label;
  final String iconData;
  final VoidCallback? onPressed;

  const Click(
      {super.key, required this.label, this.onPressed, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 0),
        child: ElevatedButton(
          onPressed: onPressed,
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
            minimumSize: Size(100, 40),
          ),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: Color(0xff254467), // Set the border color
                width: 1.5, // Set the border width
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff0A1933), // Transparent at top left
                  Color.fromRGBO(255, 255, 255, 0.3), // White at bottom right
                ],
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(top: 15, bottom: 15, right: 7, left: 7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Image(
                    image: AssetImage(
                      iconData,
                    ),
                    width: 35,
                    height: 35,
                  ),
                  const SizedBox(height: 6.0),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Goto',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                        Text(
                          label,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  const Image(
                    image: AssetImage(
                      "assets/icon/enter.png",
                    ),
                    width: 15,
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
