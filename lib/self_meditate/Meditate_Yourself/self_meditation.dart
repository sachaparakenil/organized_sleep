import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Clock/CountDown/countdown_screen.dart';
import 'RoundButton.dart';
import 'package:audioplayers/audioplayers.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  State<CountdownPage> createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage>
    with TickerProviderStateMixin {
  late AnimationController controller;
  AudioPlayer audioPlayer = AudioPlayer();
  // AudioCache audioCache = AudioCache();
  String selectedAudio = 'Sounds/OM.mp3';
  String selectedBell = 'beep.mp3';
  bool isPlaying = false;

  String get countText {
    Duration count = controller.duration! * controller.value;
    return (controller.isDismissed)
        ? "${(controller.duration!.inHours).toString().padLeft(2, "0")}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, "0")}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, "0")}"
        : "${(count.inHours).toString().padLeft(2, "0")}:${(count.inMinutes % 60).toString().padLeft(2, "0")}:${(count.inSeconds % 60).toString().padLeft(2, "0")}";
  }

  double progress = 1.0;

  Future<void> notify() async {
    if (countText == '00:00:00') {
      await audioPlayer.play(AssetSource(selectedBell));
    }
  }

  void playAudio() {
    audioPlayer.play(AssetSource(selectedAudio));
    audioPlayer.onPlayerComplete.listen((event) {
      playAudio(); // Continue playing loop
    });
  }

  void pauseAudio() async {
    await audioPlayer.pause();
  }

  void resumeAudio() async {
    await audioPlayer.resume();
  }

  void stopAudio() async {
    await audioPlayer.stop();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 300),
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
          stopAudio();
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
          "INTERNAL MEDITATION",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: appBarHeight +topSpacing),
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
                    child: CustomPaint(
                      painter: ProgressPainter(progress: progress),
                      child: Container(
                        width: 300,
                        height: 300,
                        child: CircularProgressIndicator(
                          backgroundColor: Color(0xff091939),
                          color: Color(0xff1F53AE),
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
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27),
                border: Border.all(
                  color: Color(0xff42536C), // Set the border color
                  width: 1.5, // Set the border width
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(16),
                      color: Color(0xffD3E1F6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(CupertinoIcons.music_note_2),
                        Text(
                          'Sound',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Color(0xff07327a),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: SizedBox(
                            height: 30,
                            child: DropdownButton(
                              value: selectedAudio,
                              dropdownColor: Color(0xff07327a),
                              items: const [
                                DropdownMenuItem<String>(
                                  value: 'Sounds/OM.mp3',
                                  child: Text('OM', style: TextStyle(color: Colors.white)),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Sounds/Nature-Meditation.mp3',
                                  child: Text('Nature', style: TextStyle(color: Colors.white)),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Sounds/Birds.mp3',
                                  child: Text('Birds', style: TextStyle(color: Colors.white)),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Sounds/Ocean.mp3',
                                  child: Text('Ocean', style: TextStyle(color: Colors.white)),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Sounds/Om-Meditation-3.mp3',
                                  child: Text('Meditation', style: TextStyle(color: Colors.white)),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Sounds/Om-Meditation2.mp3',
                                  child: Text('Om Meditation', style: TextStyle(color: Colors.white)),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Sounds/Rain-Relaxing.mp3',
                                  child: Text('Rain', style: TextStyle(color: Colors.white)),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Sounds/River.mp3',
                                  child: Text('River', style: TextStyle(color: Colors.white)),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Sounds/Water-Dripping.mp3',
                                  child: Text('Water', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                              underline: Container(),
                              icon: Icon(Icons.arrow_drop_down, color: Color(0xff335796)),
                              onChanged: (value) => setState(() => selectedAudio = value!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(16),
                      color: Color(0xffD3E1F6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(CupertinoIcons.bell),
                        Text(
                          'Ending Bell',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Color(0xff07327a),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: SizedBox(
                            height: 30,
                            child: DropdownButton(
                              value: selectedBell,
                              dropdownColor: Color(0xff07327a),
                              items: const [
                                DropdownMenuItem<String>(
                                  value: 'beep.mp3',
                                  child: Text('One Shot', style: TextStyle(color: Colors.white)),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Beep1.mp3',
                                  child: Text('Grammar', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                              underline: Container(),
                              icon: Icon(Icons.arrow_drop_down, color: Color(0xff335796)),
                              onChanged: (value) => setState(() => selectedBell = value!),
                            ),
                          ),
                        ),
                      ],
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
                    if (controller.isAnimating) {
                      controller.stop();
                      pauseAudio();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      controller.reverse(
                          from:
                          controller.value == 0 ? 1.0 : controller.value);
                      setState(() async {
                        playAudio();
                        isPlaying = true;
                      });
                    }
                  }, buttonColor1: Color(0xff0A1933), buttonColor2: Color.fromRGBO(255, 255, 255, 0.1),),
                  Button4(label: 'STOP', iconData: 'assets/icon/dismiss.png',onPressed: () {
                    controller.reset();
                    setState(() {
                      isPlaying = false;
                      stopAudio();
                    });
                  }, buttonColor1: Color(0xff0A1933), buttonColor2: Color.fromRGBO(255, 255, 255, 0.1),)
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}