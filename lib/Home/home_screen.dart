import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = AppBar().preferredSize.height;
    const double topSpacing = 50.0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, top: 40.0, right: 16.0, bottom: 0),
          child: Row(
            children: [
              const SizedBox(
                width: 40,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xff173761),
                    ),
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/icon/no_ad.png',
                      width: 30,
                      height: 30,
                    ),
                    onPressed: () {
                      // Handle button tap
                    },
                  ),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xff173761),
                    ),
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/icon/info.png',
                      width: 30,
                      height: 30,
                    ),
                    onPressed: () {
                      // Handle button tap
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icon/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.only(top: appBarHeight + topSpacing),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ButtonOne(),
                ButtonTwo(),
                ButtonThree(),
              ],
            ),
          ),
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
      label: 'Sleep\nTracker',
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
      iconData: 'assets/icon/sleep_tracker.png',
    );
  }
}

class ButtonTwo extends StatelessWidget {
  const ButtonTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Button1(
      label: 'Self\nMeditation',
      onPressed: () {
        Navigator.pushNamed(context, '/meditation');
      },
      iconData: 'assets/icon/self_medication.png',
    );
  }
}

class ButtonThree extends StatelessWidget {
  const ButtonThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Button1(
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
      iconData: 'assets/icon/alarm.png',
    );
  }
}

class Button1 extends StatelessWidget {
  final String label;
  final String iconData;
  final VoidCallback? onPressed;

  const Button1(
      {super.key, required this.label, this.onPressed, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 200, left: 30, top: 0, bottom: 15),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          // backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),

          disabledForegroundColor: Colors.black.withOpacity(0.38),
          disabledBackgroundColor: Colors.black.withOpacity(0.12),
          padding: EdgeInsets.zero, // To remove padding, if needed
          elevation: 0, // Disabled text color
          // minimumSize: Size(100, 40),
        ),
        child: Ink(
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
                Color.fromRGBO(255, 255, 255, 0.1), // White at bottom right
              ],
            ),
          ),
          child: Container(
            padding:
                const EdgeInsets.only(top: 15, bottom: 15, right: 7, left: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Image(
                  image: AssetImage(
                    iconData,
                  ),
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 16.0),
                Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
