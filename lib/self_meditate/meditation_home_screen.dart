import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Home/home_screen.dart';

class Meditation extends StatelessWidget {
  const Meditation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Meditation'),
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
    return Button1(
      label: 'Mediate YourSelf',
      onPressed: () {
        Navigator.pushNamed(context, '/selfPractice');
      }, iconData: '',
    );
  }
}

class ButtonTwo extends StatelessWidget {
  const ButtonTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Button1(
      label: 'Breathing',
      onPressed: () {
        Navigator.pushNamed(context, '/breathing');
      }, iconData: '',
    );
  }
}

class ButtonThree extends StatelessWidget {
  const ButtonThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Button1(
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
      }, iconData: '',
    );
  }
}
/*

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
*/
