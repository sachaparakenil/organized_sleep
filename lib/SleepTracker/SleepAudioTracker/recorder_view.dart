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

enum RecordingState {
  UnSet,
  Set,
  Recording,
  Stopped,
}

class _RecorderViewState extends State<RecorderView> {
  IconData _recordIcon = Icons.mic;
  String _recordText = 'Click To Start';
  RecordingState _recordingState = RecordingState.Set;
  late Record audioRecord;
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final hasPermission = await audioRecord.hasPermission();
    if (hasPermission) {
      setState(() {
        _recordIcon = Icons.mic;
        _recordText = 'Record';
      });
      _recordingState = RecordingState.Set;
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
                  ? Image.asset('assets/waves_gif1.gif',
                  width: 125, height: 125)
                  : const SizedBox.shrink(),
              TextButton(
                onPressed: () async {
                  await _onRecordButtonPressed();
                  setState(() {});
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(CircleBorder()),
                ),
                child: Icon(_recordIcon),
              ),
               _recordText == "Recording..."
                  ? Image.asset('assets/waves_gif1.gif',
                  width: 125, height: 125)
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
        await _recordVoice();
        break;

      case RecordingState.Recording:
        await _stopRecording();
        _recordingState = RecordingState.Stopped;
        setState(() {
          _recordIcon = Icons.mic;
          _recordText = 'Record a new one';
        });
        break;

      case RecordingState.Stopped:
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
    final hasPermission = await audioRecord.hasPermission();
    if (hasPermission) {
      await _initRecorder();
      await _startRecording();
      setState(() {
        _recordingState = RecordingState.Recording;
        _recordIcon = Icons.mic_none;
        _recordText = 'Recording...';
      });
    } else {
      await _initRecorder();
      await _startRecording();
      setState(() {
        _recordingState = RecordingState.Recording;
        _recordIcon = Icons.mic_none;
        _recordText = 'Recording...';
      });
    }
  }

  _initRecorder() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String filePath = '${appDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
    await audioRecord.start(path: filePath);
  }

  _startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
      }
    } catch (e) {
      print('Error Start Recording : $e');
    }
  }

  _stopRecording() async {
    try {
      await audioRecord.stop();
      widget.onSaved();
    } catch (e) {
      print('Error Stopping record : $e');
    }
  }
}
