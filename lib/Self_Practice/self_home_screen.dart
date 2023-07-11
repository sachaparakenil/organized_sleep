import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class AudioPlayerPage extends StatelessWidget {
   AudioPlayerPage({super.key});

  AudioPlayer audioPlayer = AudioPlayer();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playing Audio'),
      ),
      body: Center(
        child: Row(
          children: [
            ElevatedButton(onPressed: (){
              audioPlayer.play(AssetSource('summer.mp3'));
            }, child: Text("Play")),
            ElevatedButton(onPressed: (){
              audioPlayer.resume();
            }, child: Text("Resume")),
            ElevatedButton(onPressed: (){
              audioPlayer.stop();
            }, child: Text("Stop"))
          ],
        ),
      ),
    );
  }
}
