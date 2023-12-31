import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        title: const Text(
          "COUNTDOWN",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
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
                    child: CustomPaint(
                      painter: ProgressPainter(progress: progress),
                      child: SizedBox(
                        width: 300,
                        height: 300,
                        child: CircularProgressIndicator(
                          backgroundColor: const Color(0xff091939),
                          color: const Color(0xff1F53AE),
                          value: progress,
                          strokeWidth: 6,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
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
                  Button4(
                    label: isPlaying == true ? 'PAUSE' : 'START',
                    iconData: isPlaying == true
                        ? 'assets/icon/pause.png'
                        : 'assets/icon/play.png',
                    onPressed: () {
                      if (countText == '00:00:00') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Adjust the radius as needed
                              ),
                              title: const Text('Warning!',
                                  style: TextStyle(color: Colors.red)),
                              content:
                                  const Text('Please Select CountDown Time'),
                              actions: [
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        20), // Adjust the radius as needed
                                    color: const Color(
                                        0xff07327a), // Set the background color
                                  ),
                                  child: TextButton(
                                    child: const Text(
                                      'Ok',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
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
                    },
                    buttonColor1: const Color(0xff0A1933),
                    buttonColor2: const Color.fromRGBO(255, 255, 255, 0.1),
                  ),
                  Button4(
                    label: 'STOP',
                    iconData: 'assets/icon/dismiss.png',
                    onPressed: () {
                      controller.reset();
                      setState(() {
                        isPlaying = false;
                      });
                    },
                    buttonColor1: const Color(0xff0A1933),
                    buttonColor2: const Color.fromRGBO(255, 255, 255, 0.1),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
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
  final Color buttonColor1;
  final Color buttonColor2;

  const Button4(
      {super.key,
      required this.label,
      this.onPressed,
      required this.iconData,
      required this.buttonColor1,
      required this.buttonColor2});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 60,
        width: 90,
        padding: const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 0),
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
            minimumSize: const Size(100, 40),
          ),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xff254467), // Set the border color
                width: 1.5, // Set the border width
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  buttonColor1,
                  buttonColor2,
                ],
              ),
            ),
            child: Container(
              padding:
                  const EdgeInsets.only(top: 15, bottom: 15, right: 7, left: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(
                      iconData,
                    ),
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 6.0),
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
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double progress;

  ProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint shadePaint = Paint()
      ..color =
          Colors.white.withOpacity(0.05) // Adjust the color of the shading here
      ..style = PaintingStyle.fill;

    // Draw circular dot
    final Offset center = Offset(size.width / 2, size.height / 2);
    // canvas.drawCircle(center, radius, dotPaint);

    // Draw color shading based on the progress
    double angle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      -pi / 2,
      angle,
      true,
      shadePaint,
    );

    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var radius = min(centerX, centerY);

    var dashBrush = Paint()
      ..color = const Color(0xff4B5E7D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    var outerRadius = radius - 3;
    var innerRadius = radius * 0.94;
    var innerRadius1 = radius * 0.88;
    for (var i = 0; i < 360; i += 5) {
      var x1 = centerX + outerRadius * cos(i * pi / 180);
      var y1 = centerY + outerRadius * sin(i * pi / 180);

      var x2 = centerX + innerRadius * cos(i * pi / 180);
      var y2 = centerY + innerRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
    for (var i = 0; i < 360; i += 20) {
      var x1 = centerX + outerRadius * cos(i * pi / 180);
      var y1 = centerY + outerRadius * sin(i * pi / 180);

      var x2 = centerX + innerRadius1 * cos(i * pi / 180);
      var y2 = centerY + innerRadius1 * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
