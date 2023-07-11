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
              onPressed: _isBreathing ? null : _startBreathing,
              child: Text('Start Breathing'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isBreathing ? _stopBreathing : null,
              child: Text('Stop Breathing'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDurationDialog(String type) async {
    int initialValue = 0;
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

    int? selectedDuration = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int duration = initialValue;
        return AlertDialog(
          title: Text('Set $type Duration'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: duration,
                items: List.generate(10, (index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text((index + 1).toString()),
                  );
                }),
                onChanged: (int? value) {
                  duration = value ?? 1;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(duration);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    // Update the selected duration based on the dialog result
    if (selectedDuration != null) {
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
    }
  }

  /*int? selectedDuration = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int duration = initialValue;
        return AlertDialog(
          title: Text('Set $type Duration'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: duration,
                items: List.generate(10, (index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text((index + 1).toString()),
                  );
                }),
                onChanged: (int? value) {
                  setState(() {
                    duration = value ?? 1;
                  });
                },
              ),
              Text('$duration seconds'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(duration);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (selectedDuration != null) {
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
    }
  }*/

  Future<void> _startBreathing() async {
    setState(() {
      _isBreathing = true;
    });

    while (_isBreathing) {
      await _animateBreath(_selectedInhaleDuration, 'Inhale', Colors.green);
      await _animateBreath(_selectedHoldDuration, 'Hold', Colors.yellow);
      await _animateBreath(_selectedExhaleDuration, 'Exhale', Colors.red);
    }
  }

  Future<void> _animateBreath(
      int duration, String statusText, Color statusColor) async {
    setState(() {
      _statusText = statusText;
      _statusColor = statusColor;
    });
    await ftts.speak(_statusText);
    await ftts.setLanguage("en-US");
    await ftts.setSpeechRate(0.5);
    await ftts.setVolume(1.0);
    await ftts.setPitch(1);
    await Future.delayed(Duration(seconds: duration));
  }

  void _stopBreathing() {
    setState(() {
      _isBreathing = false;
      _statusText = 'Inhale';
      _statusColor = Colors.green;
    });
  }
}
