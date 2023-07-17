import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class RecorderView extends StatefulWidget {
  final Function onSaved;

  const RecorderView({Key? key, required this.onSaved}) : super(key: key);

  @override
  State<RecorderView> createState() => _RecorderViewState();
}

// different states of recordings
enum RecordingState {
  UnSet,
  Set,
  Recording,
  Stopped,
}

class _RecorderViewState extends State<RecorderView> {
  IconData _recordIcon = Icons.mic;
  String _recordText = 'Click To Start';

  // RecordingState - Inbuilt variable for handling recording's state
  RecordingState _recordingState = RecordingState.Set;

  // Recorder properties
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = '';

  @override
  void initState() {
    super.initState();
    audioRecord = Record();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final hasPermission = await audioRecord.hasPermission();
    if (hasPermission) {
      _recordingState = RecordingState.Set;
      setState(() {
        _recordIcon = Icons.mic;
        _recordText = 'Record';
      });
    }
  }

  @override
  void dispose() {
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
                  ? Image.asset('assets/waves_gif1.gif',width: 125, height: 125,)
                  : const SizedBox.shrink(),
              IconButton(
                onPressed: () async {
                  await _onRecordButtonPressed();
                  setState(() {});
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(const CircleBorder()),
                ),
                icon: Icon(_recordIcon),
              ),
              _recordText == "Recording..."
                  ? Image.asset('assets/waves_gif1.gif',width: 125, height: 125,)
                  : const SizedBox.shrink(),
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
        setState(() {
          _recordIcon = Icons.mic_none;
          _recordText = 'Recording...';
        });
        await _recordVoice();
        break;

      case RecordingState.Recording:
        setState(() {
          _recordIcon = Icons.mic;
          _recordText = 'Record a new one';
        });
        await _stopRecording();
        _recordingState = RecordingState.Stopped;
        break;

      case RecordingState.Stopped:
        setState(() {
          _recordIcon = Icons.mic_none;
          _recordText = 'Recording...';
        });
        await _recordVoice();
        break;

      case RecordingState.UnSet:
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please allow recording from settings.'),
          ),
        );
        break;
    }
  }

  Future<void> _recordVoice() async {
    bool hasPermission = await audioRecord.hasPermission();
    if (!hasPermission) {
      await _initRecorder();
      await _startRecording();
      setState(() {
        _recordingState = RecordingState.Recording;
        _recordIcon = Icons.mic;
        _recordText = 'Recording...';
      });
    } else {
      await _initRecorder();
      await _startRecording();
      setState(() {
        _recordingState = RecordingState.Recording;
        _recordIcon = Icons.mic;
        _recordText = 'Recording...';
      });
    }
  }


Future<void> _initRecorder() async {
  Directory appDirectory = await getApplicationDocumentsDirectory();
  String filePath =
      '${appDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
  print(filePath);
  await audioRecord.start(path: filePath);
}

Future<void> _startRecording() async {
  await audioRecord.start();
}

Future<void> _stopRecording() async {
  await audioRecord.stop();
  widget.onSaved();
}
}
