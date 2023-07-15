import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({Key? key}) : super(key: key);

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  @override
  void initState() {
    initRecorder();
    super.initState();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  final recorder = FlutterSoundRecorder();

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Permission not granted';
    }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future startRecord() async {
    await recorder.startRecorder(toFile: "audio");
  }

  Future stopRecorder() async {
    final audioFile = await recorder.stopRecorder();

    final directory = await getExternalStorageDirectory();
    print(directory!.path);

    // var _completeFileName =
    //     await File("${directory.path}/${DateTime.now()}.mp3").create();

    File(directory.path + '/' + '${directory.path}/${DateTime.now()}.mp3')
        .create(recursive: true)
        .then((File file) async {
      //write to file

      Uint8List bytes = await file.readAsBytes();
      file.writeAsBytes(bytes);
      print(file.path);
    });

    // create audio file
    // final audioPath = await File("${directory.path}/${DateTime.now()}.mp3").create();
    // print('Recorded file path: $audioPath');

    // final file = File(filePath!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sleep Analyser"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<RecordingDisposition>(
                builder: (context, snapshot) {
                  final duration = snapshot.hasData
                      ? snapshot.data!.duration
                      : Duration.zero;

                  String twoDigits(int n) => n.toString().padLeft(2, '0');

                  final twoDigitMinutes =
                      twoDigits(duration.inMinutes.remainder(60));
                  final twoDigitSeconds =
                      twoDigits(duration.inSeconds.remainder(60));

                  return Text(
                    '$twoDigitMinutes:$twoDigitSeconds',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
                stream: recorder.onProgress,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (recorder.isRecording) {
                    await stopRecorder();
                    setState(() {});
                  } else {
                    await startRecord();
                    setState(() {});
                  }
                },
                child: Icon(
                  recorder.isRecording ? Icons.stop : Icons.mic,
                  size: 100,
                ),
              ),
            ],
          ),
        ));
  }
}
