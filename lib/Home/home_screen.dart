import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
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
            SizedBox(
              height: 20,
            ),
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
      onPressed: () async {
        PermissionStatus audio = await Permission.audio.request();
        if (audio == PermissionStatus.granted) {
          Navigator.pushNamed(context, '/meditate');
        }if (await Permission.storage.request().isGranted) {
          Navigator.pushNamed(context, '/meditate');
        }
        if(audio == PermissionStatus.denied){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Permission is Required")));
        }
        if(audio == PermissionStatus.permanentlyDenied){
          openAppSettings();
        }
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
      onPressed: () async {
        PermissionStatus notification = await Permission.notification.request();
        if (notification == PermissionStatus.granted) {
          Navigator.pushNamed(context, '/Clock');
        }
        if(notification == PermissionStatus.denied){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Permission is Required")));
        }
        if(notification == PermissionStatus.permanentlyDenied){
          openAppSettings();
        }/*else{
          Navigator.pushNamed(context, '/Clock');
        }*/

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
        Navigator.pushNamed(context, '/music');
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
