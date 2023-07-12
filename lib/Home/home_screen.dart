import 'package:flutter/material.dart';
import '../Clock/clock_view.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homescreen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClockView(
              size: MediaQuery.of(context).size.height / 4,
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonOne(),
                ButtonTwo(),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonThree(),
                ButtonFour(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonFive(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Button(
      label: 'Music Melodies',
      onPressed: () {
        Navigator.pushNamed(context, '/music');
      },
    );
  }
}

class ButtonTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Button(
      label: 'Breathing Meditation',
      onPressed: () {
        Navigator.pushNamed(context, '/breathing');
      },
    );
  }
}

class ButtonThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Button(
      label: 'Alarm',
      onPressed: () {
        Navigator.pushNamed(context, '/Clock');
      },
    );
  }
}

class ButtonFour extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Button(
      label: 'Sleep Tracker',
      onPressed: () {
        Navigator.pushNamed(context, '/sleep');
      },
    );
  }
}

class ButtonFive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Button(
      label: 'Self Meditate',
      onPressed: () {
        Navigator.pushNamed(context, '/meditate');
      },
    );
  }
}

class Button extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const Button({required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 100,
        width: 100,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Screens for each button route
class MusicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Melodies'),
      ),
      body: Center(
        child: Text('Music Screen'),
      ),
    );
  }
}

/*
class BreathingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breathing Meditation'),
      ),
      body: Center(
        child: Text('Breathing Screen'),
      ),
    );
  }
}
*/

class SleepScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Tracker'),
      ),
      body: Center(
        child: Text('Sleep Screen'),
      ),
    );
  }
}
