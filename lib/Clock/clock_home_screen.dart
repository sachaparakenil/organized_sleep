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
    final double topSpacing = 50.0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('CLOCK'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              decoration: BoxDecoration(
                  /*image: DecorationImage(
                image: AssetImage("assets/images/bg.png"), fit: BoxFit.fill),*/
                  color: Color(0xff021659)),
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
                        style: const TextStyle(fontSize: 55, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        DateFormat("EEE, d MMM").format(_currentTime),
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Click(
                                label: 'Alarm',
                                onPressed: () {
                                  Navigator.pushNamed(context, '/alarm');
                                }, iconData: Icons.alarm,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Click(
                                label: 'Countdown',
                                onPressed: () {
                                  Navigator.pushNamed(context, '/countdown');
                                },  iconData: Icons.timer,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Click(
                                label: 'Stopwatch',
                                onPressed: () {
                                  Navigator.pushNamed(context, '/stopwatch');
                                },  iconData: Icons.timelapse_rounded,
                              ),
                            ),
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
  final IconData iconData;
  final VoidCallback? onPressed;

  const Click({super.key, required this.label, this.onPressed, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10), // Set the border radius as desired
        border: Border.all(
          color: Colors.white.withOpacity(0.5), // Set the border color with opacity
          width: 2.0, // Set the border width as needed
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(255, 255, 255, 0.5),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Column(
            children: [
              Icon(iconData),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
