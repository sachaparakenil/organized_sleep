import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';

class RecorderView extends StatefulWidget {
  final Function onSaved;

  const RecorderView({Key? key, required this.onSaved}) : super(key: key);

  @override
  _RecorderViewState createState() => _RecorderViewState();
}

// different states of recordings
enum RecordingState {
  UnSet,
  Set,
  Recording,
  Stopped,
}

class _RecorderViewState extends State<RecorderView> {
   Image _recordIcon = Image.asset(
    'assets/images/mic.png',
    height: 80,
    width: 80,
  );
  String _recordText = 'Click To Start';

  // RecordingState - Inbuilt variable for handling recording's state
  RecordingState _recordingState = RecordingState.Set;

  // Recorder properties
  late FlutterAudioRecorder2 audioRecorder;

  @override
  void initState() {
    super.initState();
    FlutterAudioRecorder2.hasPermissions.then((hasPermission) {
      if (hasPermission!) {
        _recordingState = RecordingState.Set;
        setState(() {
          _recordIcon = Image.asset(
            'assets/images/mic.png',
            height: 80,
            width: 80,
          );
          _recordText = 'Record';
        });
      }
      // else{

      // }
    });
  }

  @override
  void dispose()  {
     _stopRecording();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _recordText == "Recording..."
                  ? Image.asset("assets/images/waves_gif1.gif", width: 125,height: 125,)
                  : SizedBox.shrink(),
              TextButton(
                onPressed: () async {
                  await _onRecordButtonPressed();
                  setState(() {});
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(CircleBorder()),
                  // padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                  // backgroundColor:
                  // MaterialStateProperty.all(Colors.blue), // <-- Button color
                  // overlayColor:
                  // MaterialStateProperty.resolveWith<Color?>((states) {
                  //   if (states.contains(MaterialState.pressed)) {
                  //     return Colors.red; // <-- Splash color
                  //   }
                  //   return null;
                  // }),
                ),
                child: _recordIcon,
              ),
              _recordText == "Recording..."
                  ? Image.asset("assets/images/waves_gif1.gif", width: 125,)
                  : SizedBox.shrink(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(_recordText),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRecordButtonPressed() async {
    switch (_recordingState) {
      case RecordingState.Set:
        await _recordVoice();
        break;

      case RecordingState.Recording:
        await _stopRecording();
        _recordingState = RecordingState.Stopped;
        setState(() {
          _recordIcon = Image.asset(
            'assets/images/mic.png',
            height: 80,
            width: 80,
          );
          _recordText = 'Record a new one';
        });
        break;

      case RecordingState.Stopped:
        await _recordVoice();
        break;

      case RecordingState.UnSet:
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please allow recording from settings.'),
        ));
        break;
    }
  }

  _initRecorder() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String filePath = appDirectory.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.aac';
    print(filePath);
    audioRecorder =
        FlutterAudioRecorder2(filePath, audioFormat: AudioFormat.AAC);
    await audioRecorder.initialized;
  }

  _startRecording() async {
    await audioRecorder.start();
  }

  _stopRecording() async {
    await audioRecorder.stop();
    widget.onSaved();
  }

  Future<void> _recordVoice() async {
    final hasPermission = await FlutterAudioRecorder2.hasPermissions;
    if (hasPermission ?? false) {
      await _initRecorder();
      await _startRecording();
      setState(() {
        _recordingState = RecordingState.Recording;
        _recordIcon = Image.asset(
          'assets/images/mic.png',
          height: 80,
          width: 80,
        );
        _recordText = 'Recording...';
      });
    } else {
      await _initRecorder();
      await _startRecording();
      setState(() {
        _recordingState = RecordingState.Recording;
        _recordIcon = Image.asset(
          'assets/images/mic.png',
          height: 80,
          width: 80,
        );
        _recordText = 'Recording...';
      });
    }
  }
}
