import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../clock_view.dart';

class ClockScreen extends StatefulWidget {
  @override
  _ClockScreenState createState() => _ClockScreenState();
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
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Clock'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                DateFormat("EEE, d MMM").format(_currentTime),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                DateFormat("HH:mm").format(_currentTime),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ClockView(
                size: MediaQuery.of(context).size.height / 4,
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/alarm');
                      },
                      child: Text('Go to Alarm'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/countdown');
                      },
                      child: Text('Go to Countdown'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/stopwatch');
                      },
                      child: Text('Go to stopwatch'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
