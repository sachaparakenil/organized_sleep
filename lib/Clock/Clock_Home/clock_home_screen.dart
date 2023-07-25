import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../clock_view.dart';

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Clock'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                DateFormat("EEE, d MMM").format(_currentTime),
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Text(
                DateFormat("HH:mm").format(_currentTime),
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ClockView(
                size: MediaQuery.of(context).size.height / 4,
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Column(
                  children: [
                    Click(
                      label: 'Alarm',
                      onPressed: () {
                        Navigator.pushNamed(context, '/alarm');
                      },
                    ),
                    Click(
                      label: 'Countdown',
                      onPressed: () {
                        Navigator.pushNamed(context, '/countdown');
                      },
                    ),
                    Click(
                      label: 'Stopwatch',
                      onPressed: () {
                        Navigator.pushNamed(context, '/stopwatch');
                      },
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

class Click extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const Click({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 80),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
