import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../Clock/CountDown/countdown_screen.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  String _statusText = 'Inhale';
  Color _statusColor = Colors.green;
  int _selectedInhaleDuration = 4;
  int _selectedExhaleDuration = 4;
  int _selectedHoldDuration = 2;
  bool _isBreathing = false;
  FlutterTts speakFTTS = FlutterTts();

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('BREATHING', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: appBarHeight+topSpacing),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/icon/bg3.png"), fit: BoxFit.fill),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("“As you breathe in, cherish yourself. As you breathe out, cherish all beings.”", style: TextStyle(fontSize: 18, color: Colors.white),),
              const SizedBox(height: 20,),
              const Text("Dalai Lama", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),),
              const SizedBox(height: 40,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Color(0xff254467), // Set the border color
                    width: 1.5, // Set the border width
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff0A1933), // Transparent at top left
                      Color.fromRGBO(
                          255, 255, 255, 0.1), // White at bottom right
                    ],
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                margin: EdgeInsets.symmetric(horizontal: 100,vertical: 10),
                child: Center(
                  child: Text(
                    _statusText,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: _statusColor,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(27),
                  border: Border.all(
                    color: Color(0xff42536C), // Set the border color
                    width: 1.5, // Set the border width
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                        color: Color(0xffD3E1F6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Inhale Duration: $_selectedInhaleDuration seconds'),
                          ElevatedButton(
                            onPressed:
                            _isBreathing ? null : () => _showDurationDialog('Inhale'),
                            child: const Text('Change'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                        color: Color(0xffD3E1F6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Hold Duration: $_selectedHoldDuration seconds'),
                          ElevatedButton(
                            onPressed:
                            _isBreathing ? null : () => _showDurationDialog('Hold'),
                            child: const Text('Change'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                        color: Color(0xffD3E1F6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Exhale Duration: $_selectedExhaleDuration seconds'),
                          ElevatedButton(
                            onPressed:
                            _isBreathing ? null : () => _showDurationDialog('Exhale'),
                            child: const Text('Change'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isBreathing ? _stopBreathing : _startBreathing,
                child: _isBreathing ? const Text('Stop Breathing') : const Text('Start Breathing'),
              ),
              // Button4(label: 'STOP BREATHING', iconData: '',)
            ],
          ),
        ),
      ),
    );
  }

  void _showDurationDialog(String type) {
    int initialValue = 1;
    int selectedDuration = 1;

    switch (type) {
      case 'Inhale':
        initialValue = _selectedInhaleDuration;
        break;
      case 'Exhale':
        initialValue = _selectedExhaleDuration;
        break;
      case 'Hold':
        initialValue = _selectedHoldDuration;
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set $type Duration'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<int>(
                    value: initialValue,
                    items: List.generate(10, (index) {
                      return DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text((index + 1).toString()),
                      );
                    }),
                    onChanged: (int? value) {
                      setState(() {
                        initialValue = value ?? 1;
                        selectedDuration = value ?? 1;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  switch (type) {
                    case 'Inhale':
                      _selectedInhaleDuration = selectedDuration;
                      break;
                    case 'Exhale':
                      _selectedExhaleDuration = selectedDuration;
                      break;
                    case 'Hold':
                      _selectedHoldDuration = selectedDuration;
                      break;
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  bool _stopRequested = false;

  void _speakText(String text) async {
    await speakFTTS.speak(text);
    await speakFTTS.setLanguage("en-US");
    await speakFTTS.setSpeechRate(0.5);
    await speakFTTS.setVolume(1.0);
    await speakFTTS.setPitch(1);
  }

  void _startBreathing() async {
    setState(() {
      _isBreathing = true;
      _stopRequested = false;
    });

    while (_isBreathing && !_stopRequested) {
      await _animateBreath(_selectedInhaleDuration, 'Inhale', Colors.green);
      await _animateBreath(_selectedHoldDuration, 'Hold', Colors.yellow);
      await _animateBreath(_selectedExhaleDuration, 'Exhale', Colors.red);
    }

    setState(() {
      _isBreathing = false;
      _statusText = 'Inhale';
      _statusColor = Colors.green;
    });
  }

  Future<void> _animateBreath(int duration, String statusText,
      Color statusColor) async {
    setState(() {
      _statusText = statusText;
      _statusColor = statusColor;
    });

    _speakText(_statusText); // Call the text-to-speech method here

    await Future.delayed(Duration(seconds: duration));

    if (_stopRequested) {
      return;
    }
  }

  void _stopBreathing() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pop();
          setState(() {
            _stopRequested = true;
          });
        });

        return const AlertDialog(
          title: Text('Breathing Stop Requested'),
          content: Text('Breathing will stop after completing the current task.'),
        );
      },
    );
  }

}