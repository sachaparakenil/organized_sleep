import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  String _statusText = 'Inhale';
  Color _statusColor = Colors.green.shade100;
/*  int _selectedInhaleDuration = 4;
  int _selectedExhaleDuration = 4;
  int _selectedHoldDuration = 2;*/
  bool _isBreathing = false;
  FlutterTts speakFTTS = FlutterTts();
  int inhale = 4;
  int hold = 2;
  int exhale = 4;

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
        title: const Text(
          'BREATHING',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            padding: EdgeInsets.only(top: appBarHeight + topSpacing),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/icon/bg4.png"), fit: BoxFit.fill),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    children: [
                      Image(
                        image: AssetImage('assets/icon/meditation_ic.png'),
                        height: 200,
                        width: 200,
                      ),
                      Column(
                        children: [
                          Text(
                            '”',
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "As you breathe in, \n      cherish yourself. \nAs you breathe out, \n    cherish all beings.",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            '”',
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 10),
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
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      border: Border.all(
                        color: const Color(0xff42536C), // Set the border color
                        width: 1.5, // Set the border width
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(16),
                            color: const Color(0xffD3E1F6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'Inhale Duration ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xff07327a),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: SizedBox(
                                  height: 30,
                                  child: DropdownButton<int>(
                                    value: inhale,
                                    dropdownColor: const Color(0xff07327a),
                                    items: List.generate(10, (index) {
                                      return DropdownMenuItem<int>(
                                        value: index + 1,
                                        child: Text("${index + 1} Seconds",
                                            style: const TextStyle(
                                                color: Colors.white)),
                                      );
                                    }),
                                    underline: Container(),
                                    icon: const Icon(Icons.arrow_drop_down,
                                        color: Color(0xff335796)),
                                    onChanged: (value) =>
                                        setState(() => inhale = value!),
                                    /*onChanged: (int? value) {
                                      setState(() {
                                        initialValue = value ?? 1;
                                        selectedDuration = value ?? 1;
                                      });
                                    },*/
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(16),
                            color: const Color(0xffD3E1F6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'Hold Duration ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xff07327a),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: SizedBox(
                                  height: 30,
                                  child: DropdownButton<int>(
                                    value: hold,
                                    dropdownColor: const Color(0xff07327a),
                                    items: List.generate(10, (index) {
                                      return DropdownMenuItem<int>(
                                        value: index + 1,
                                        child: Text("${index + 1} Seconds",
                                            style: const TextStyle(
                                                color: Colors.white)),
                                      );
                                    }),
                                    underline: Container(),
                                    icon: const Icon(Icons.arrow_drop_down,
                                        color: Color(0xff335796)),
                                    onChanged: (value) =>
                                        setState(() => hold = value!),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(16),
                            color: const Color(0xffD3E1F6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'Exhale Duration ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xff07327a),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: SizedBox(
                                  height: 30,
                                  child: DropdownButton<int>(
                                    value: exhale,
                                    dropdownColor: const Color(0xff07327a),
                                    items: List.generate(10, (index) {
                                      return DropdownMenuItem<int>(
                                        value: index + 1,
                                        child: Text("${index + 1} Seconds",
                                            style: const TextStyle(
                                                color: Colors.white)),
                                      );
                                    }),
                                    underline: Container(),
                                    icon: const Icon(Icons.arrow_drop_down,
                                        color: Color(0xff335796)),
                                    onChanged: (value) =>
                                        setState(() => exhale = value!),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 10),
                    child: ElevatedButton(
                      onPressed:
                          _isBreathing ? _stopBreathing : _startBreathing,
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),

                        disabledForegroundColor: Colors.black.withOpacity(0.38),
                        disabledBackgroundColor: Colors.black.withOpacity(0.12),
                        padding:
                            EdgeInsets.zero, // To remove padding, if needed
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 6.0),
                              Center(
                                  child: _isBreathing
                                      ? const Text(
                                          'Stop Breathing',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        )
                                      : const Text(
                                          'Start Breathing',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

/*  void _showDurationDialog(String type) {
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
  }*/

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
      await _animateBreath(inhale, 'Inhale', Colors.green.shade100);
      await _animateBreath(hold, 'Hold', Colors.yellow.shade100);
      await _animateBreath(exhale, 'Exhale', Colors.red.shade100);
    }

    setState(() {
      _isBreathing = false;
      _statusText = 'Inhale';
      _statusColor = Colors.green.shade100;
    });
  }

  Future<void> _animateBreath(
      int duration, String statusText, Color statusColor) async {
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
          content:
              Text('Breathing will stop after completing the current task.'),
        );
      },
    );
  }
}
