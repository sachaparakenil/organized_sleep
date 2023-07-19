/*
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({Key? key}) : super(key: key);

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = '';

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    super.initState();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      print('Error Start Recording : $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;
      });
    } catch (e) {
      print("Error Stopping record: $e");
    }
  }

  Future<void> playRecording() async {
    try {
      Source urlSource = UrlSource(audioPath);
      await audioPlayer.play(urlSource);
    } catch (e) {
      print('Error Playing Recording: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon1 = isRecording ? Icons.stop : Icons.mic;
    final text = isRecording ? 'STOP' : 'START';
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sleep Analyser"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              if (isRecording)
                Text(
                  'Recording in progress',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(120, 40),
                  maximumSize: Size(150, 50)
                ),
                onPressed: isRecording ? stopRecording : startRecording,
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon1),
                    SizedBox(width: 8),
                    Text(text),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              if (!isRecording)
                ElevatedButton(
                    onPressed: playRecording, child: Text('Play Recording'))
            ],
          ),
        ));
  }
}
*/
