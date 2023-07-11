import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

class BreathingScreen extends StatefulWidget {
  @override
  _BreathingScreenState createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  String _statusText = 'Inhale';
  Color _statusColor = Colors.green;
  int _selectedInhaleDuration = 4;
  int _selectedExhaleDuration = 4;
  int _selectedHoldDuration = 2;
  bool _isBreathing = false;
  FlutterTts ftts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breathing App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _statusText,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _statusColor,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Inhale Duration: $_selectedInhaleDuration seconds'),
                ElevatedButton(
                  onPressed:
                  _isBreathing ? null : () => _showDurationDialog('Inhale'),
                  child: Text('Change'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Hold Duration: $_selectedHoldDuration seconds'),
                ElevatedButton(
                  onPressed:
                  _isBreathing ? null : () => _showDurationDialog('Hold'),
                  child: Text('Change'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Exhale Duration: $_selectedExhaleDuration seconds'),
                ElevatedButton(
                  onPressed:
                  _isBreathing ? null : () => _showDurationDialog('Exhale'),
                  child: Text('Change'),
                ),
              ],
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isBreathing ? _stopBreathing : _startBreathing,
              child: _isBreathing ? Text('Stop Breathing') : Text('Start Breathing'),
            ),
          ],
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
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  bool _stopRequested = false;

  void _speakText(String text) async {
    await ftts.speak(text);
    await ftts.setLanguage("en-US");
    await ftts.setSpeechRate(0.5);
    await ftts.setVolume(1.0);
    await ftts.setPitch(1);
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
        Future.delayed(Duration(seconds: 5), () {
          Navigator.of(context).pop();
          setState(() {
            _stopRequested = true;
          });
        });

        return AlertDialog(
          title: Text('Breathing Stop Requested'),
          content: Text('Breathing will stop after completing the current task.'),
        );
      },
    );
  }

}