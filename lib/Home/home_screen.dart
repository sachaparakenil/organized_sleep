import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Clock/clock_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('HomeScreen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClockView(
              size: MediaQuery.of(context).size.height / 4,
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonOne(),
                ButtonTwo(),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonThree(),
                ButtonFour(),
              ],
            ),
            const Row(
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
  const ButtonOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Button(
      label: 'Music Melodies',
      onPressed: () async {
        PermissionStatus audio = await Permission.audio.request();
        if (audio == PermissionStatus.granted) {
          Navigator.pushNamed(context, '/meditate');
        }
        if (await Permission.storage.request().isGranted) {
          Navigator.pushNamed(context, '/meditate');
        }
        if (audio == PermissionStatus.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("This Permission is Required")));
        }
        if (audio == PermissionStatus.permanentlyDenied) {
          openAppSettings();
        }
      },
    );
  }
}

class ButtonTwo extends StatelessWidget {
  const ButtonTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Button(
      label: 'Breathing',
      onPressed: () {
        Navigator.pushNamed(context, '/breathing');
      },
    );
  }
}

class ButtonThree extends StatelessWidget {
  const ButtonThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Button(
      label: 'Alarm',
      onPressed: () async {
        PermissionStatus notification = await Permission.notification.request();
        if (notification == PermissionStatus.granted) {
          Navigator.pushNamed(context, '/Clock');
        }
        if (notification == PermissionStatus.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("This Permission is Required")));
        }
        if (notification == PermissionStatus.permanentlyDenied) {
          openAppSettings();
        }
      },
    );
  }
}

class ButtonFour extends StatelessWidget {
  const ButtonFour({super.key});

  @override
  Widget build(BuildContext context) {
    return Button(
      label: 'Sleep Tracker',
      onPressed: () async {
        PermissionStatus microphone = await Permission.microphone.request();
        if (microphone == PermissionStatus.granted) {
          Navigator.pushNamed(context, '/noiseApp');
        }
        if (microphone == PermissionStatus.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("This Permission is Required")));
        }
        if (microphone == PermissionStatus.permanentlyDenied) {
          openAppSettings();
        }
      },
    );
  }
}

class ButtonFive extends StatelessWidget {
  const ButtonFive({super.key});

  @override
  Widget build(BuildContext context) {
    return Button(
      label: 'Self Meditate',
      onPressed: () {
        Navigator.pushNamed(context, '/selfPractice');
      },
    );
  }
}


class Button extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const Button({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 100,
        width: 100,
        margin: const EdgeInsets.all(10),
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
      ),
    );
  }
}

