import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Home/home_screen.dart';

class Meditation extends StatelessWidget {
  const Meditation({super.key});

  @override
  Widget build(BuildContext context) {
    /*final double appBarHeight = AppBar().preferredSize.height;
    const double topSpacing = 50.0;*/
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
          centerTitle: true,
          title: const Text(
            'MEDITATION',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/icon/bg5.png"),
                      fit: BoxFit.fill),
                ),
                child: Container(
                  child: Row(
                    children: [
                      ButtonOne(),
                      ButtonTwo(),
                      ButtonThree(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class ButtonOne extends StatelessWidget {
  const ButtonOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Button5(
      label: 'Mediate\nYourSelf',
      onPressed: () {
        Navigator.pushNamed(context, '/selfPractice');
      },
      iconData: 'assets/icon/meditate.png',
    );
  }
}

class ButtonTwo extends StatelessWidget {
  const ButtonTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Button5(
      label: 'Breathing\nExercise',
      onPressed: () {
        Navigator.pushNamed(context, '/breathing');
      },
      iconData: 'assets/icon/breathing.png',
    );
  }
}

class ButtonThree extends StatelessWidget {
  const ButtonThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Button5(
      label: 'Music\nMelodies',
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
      iconData: 'assets/icon/music (1).png',
    );
  }
}

class Button5 extends StatelessWidget {
  final String label;
  final String iconData;
  final VoidCallback? onPressed;

  const Button5(
      {super.key, required this.label, this.onPressed, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 150,
        padding: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            // backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
            foregroundColor: Colors.black,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),

            disabledForegroundColor: Colors.black.withOpacity(0.38),
            disabledBackgroundColor: Colors.black.withOpacity(0.12),
            padding: EdgeInsets.zero, // To remove padding, if needed
            elevation: 0, // Disabled text color
            minimumSize: Size(100, 40),
          ),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: Color(0xff254467), // Set the border color
                width: 1.5, // Set the border width
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff0A1933), // Transparent at top left
                  Color.fromRGBO(255, 255, 255, 0.3), // White at bottom right
                ],
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(top: 15, bottom: 15, right: 7, left: 7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(
                      iconData,
                    ),
                    width: 35,
                    height: 35,
                  ),
                  const SizedBox(height: 6.0),
                  Center(
                    child: Text(
                      label,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  const Image(
                    image: AssetImage(
                      "assets/icon/enter.png",
                    ),
                    width: 15,
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
