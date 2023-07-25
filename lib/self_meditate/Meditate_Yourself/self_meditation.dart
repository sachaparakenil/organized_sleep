import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  AudioCache audioCache = AudioCache();
  String selectedAudio = 'marimba.mp3';
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

  void playAudio() async {
    await audioPlayer.play(AssetSource(selectedAudio));
    audioPlayer.onPlayerComplete.listen((event) {
      audioPlayer.play(
        AssetSource(selectedAudio),
      );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Internal Meditation"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(CupertinoIcons.music_note_2),
              Text(
                'Sound',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              DropdownButton(
                value: selectedAudio,
                items: const [
                  DropdownMenuItem<String>(
                    value: 'marimba.mp3',
                    child: Text('Marimba'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'nokia.mp3',
                    child: Text('Nokia'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'mozart.mp3',
                    child: Text('Mozart'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'star_wars.mp3',
                    child: Text('Star Wars'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'one_piece.mp3',
                    child: Text('One Piece'),
                  ),
                ],
                onChanged: (value) => setState(() => selectedAudio = value!),
              ),

            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(CupertinoIcons.bell),
              Text(
                'Ending Bell',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              DropdownButton(
                value: selectedBell,
                items: const [
                  DropdownMenuItem<String>(
                    value: 'beep.mp3',
                    child: Text('One Shot'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Beep1.mp3',
                    child: Text('Grammar'),
                  ),
                ],
                onChanged: (value) => setState(() => selectedBell = value!),
              ),

            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (controller.isAnimating) {
                      controller.stop();
                      pauseAudio();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      controller.reverse(
                          from: controller.value == 0 ? 1.0 : controller.value);
                      setState(() async {
                        playAudio();
                        isPlaying = true;
                      });
                    }
                  },
                  child: RoundButton(
                    icon: isPlaying == true ? Icons.pause : Icons.play_arrow,
                  ),
                ),
                const SizedBox(width: 30,),
                GestureDetector(
                  onTap: () {
                    controller.reset();
                    setState(() {
                      isPlaying = false;
                      stopAudio();
                    });
                  },
                  child: const RoundButton(
                    icon: Icons.stop,
                  ),
                ),
              ],
            ),
          ),
          ],

      ),
    );
  }
}
