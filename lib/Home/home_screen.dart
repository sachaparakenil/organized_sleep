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
        title: const Text('Better Sleep'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonOne(),
            ButtonTwo(),
            ButtonThree(),
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

class ButtonTwo extends StatelessWidget {
  const ButtonTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Button(
      label: 'Self Meditation',
      onPressed: () {
        Navigator.pushNamed(context, '/meditation');
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

class Button extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const Button({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 80),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
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
