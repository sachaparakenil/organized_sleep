import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../self_meditate/Meditate_Yourself/RoundButton.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({Key? key}) : super(key: key);

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;

  bool isPlaying = false;

  String get countText {
    Duration count = controller.duration! * controller.value;
    return (controller.isDismissed)
        ? "${(controller.duration!.inHours).toString().padLeft(2, "0")}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, "0")}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, "0")}"
        : "${(count.inHours).toString().padLeft(2, "0")}:${(count.inMinutes % 60).toString().padLeft(2, "0")}:${(count.inSeconds % 60).toString().padLeft(2, "0")}";
  }

  double progress = 1.0;

  void notify() {
    if (countText == '00:00:00') {

      setState(() {
        isPlaying = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 00),
    );

    controller.addListener(() {
      notify();
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
      } else {
        setState(() {
          progress = 1.0;
          isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text("COUNTDOWN",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/icon/bg3.png"), fit: BoxFit.fill),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey.shade300,
                      value: progress,
                      strokeWidth: 6,
                    ),
                  ),
                  GestureDetector(
                    /*onTap: () {
                      if (controller.isDismissed) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            height: 300,
                            child: CupertinoTimerPicker(
                              initialTimerDuration: controller.duration!,
                              onTimerDurationChanged: (time) {
                                setState(() {
                                  controller.duration = time;
                                });
                              },
                            ),
                          ),
                        );
                      }
                    },*/
                    onTap: () {
                      if (controller.isDismissed) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => SizedBox(
                            height: 300,
                            child: CupertinoTimerPicker(
                              initialTimerDuration: controller.duration!,
                              onTimerDurationChanged: (time) {
                                setState(() {
                                  controller.duration = time;
                                });
                              },
                            ),
                          ),
                        );
                      }
                    },

                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) => Text(
                        countText,
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button4(label: isPlaying == true ? 'PAUSE' : 'START', iconData: isPlaying == true ? 'assets/icon/pause.png' : 'assets/icon/play.png',onPressed: () {
                    if(countText == '00:00:00'){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Warning!',
                                style: TextStyle(color: Colors.red)),
                            content: const Text(
                                'Please Select CountDown Time'),
                            actions: [
                              TextButton(
                                child: const Text('Ok'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                    if (controller.isAnimating) {
                      controller.stop();
                      setState(() {
                        isPlaying = false;
                      });
                    } else if (controller.duration != Duration.zero) {
                      controller.reverse(
                        from: controller.value == 0 ? 1.0 : controller.value,
                      );
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },),
                  Button4(label: 'RESET', iconData: 'assets/icon/dismiss.png',onPressed: () {
                    controller.reset();
                    setState(() {
                      isPlaying = false;
                    });
                  },)
                ],
              ),
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}


class Button4 extends StatelessWidget {
  final String label;
  final String iconData;
  final VoidCallback? onPressed;

  const Button4(
      {super.key, required this.label, this.onPressed, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
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
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Color(0xff254467), // Set the border color
                width: 1.5, // Set the border width
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff0A1933), // Transparent at top left
                  Color.fromRGBO(255, 255, 255, 0.1), // White at bottom right
                ],
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(top: 15, bottom: 15, right: 7, left: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(
                      iconData,
                    ),
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(width: 6.0),
                  Center(
                    child: Text(
                      label,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
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