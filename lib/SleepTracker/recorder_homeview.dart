import 'dart:io';
import 'package:flutter/material.dart';
import 'package:organized_sleep/SleepTracker/recorder_listview.dart';
import 'package:organized_sleep/SleepTracker/recorder_view.dart';
import 'package:path_provider/path_provider.dart';

import 'constants.dart';

class RecorderHomeView extends StatefulWidget {
  final String _title;

  const RecorderHomeView({Key? key, required String title})
      : _title = title,
        super(key: key);

  @override
  _RecorderHomeViewState createState() => _RecorderHomeViewState();
}

class _RecorderHomeViewState extends State<RecorderHomeView> {
  Directory appDirectory = Directory("");
  List<String> records = [];

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      appDirectory.list().listen((onData) {
        if (onData.path.contains('.aac')) records.add(onData.path);
      }).onDone(() {
        records = records.reversed.toList();
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    appDirectory.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
                icon: Image.asset("assets/images/d1.png"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Warning!',
                            style: TextStyle(color: Colors.red)),
                        content:
                        const Text('Do you really want to delete all files!'),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              deleteAllFilesInFolder();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                  setState(() {});
                }),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Image.asset(
              'assets/images/back.png',
              height: 28,
              width: 28,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "Voice Recorder",
            style: kAppbarStyle,
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: RecordListView(
              records: records,
              appDirectory: appDirectory,
            ),
          ),
          Expanded(
            flex: 1,
            child: RecorderView(
              onSaved: _onRecordComplete,
            ),
          ),
        ],
      ),
    );
  }

  _onRecordComplete() {
    records.clear();
    appDirectory.list().listen((onData) {
      if (onData.path.contains('.aac')) records.add(onData.path);
    }).onDone(() {
      records.sort();
      records = records.reversed.toList();
      setState(() {});
    });
  }

  Future<void> deleteAllFiles(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        print(file);
        setState(() {
          records.remove(file);
          records.removeRange(
              0, (records.length - 1)); // Remove the deleted file from the list
        });
      }
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  Future<void> deleteAllFilesInFolder() async {
    String folderPath = "/data/user/0/com.example.jay_sound_meter/app_flutter/";
    Directory folder = Directory(folderPath);
    if (await folder.exists()) {
      List<FileSystemEntity> entities = folder.listSync();
      for (FileSystemEntity entity in entities) {
        if (entity is File) {
          await entity.delete();
          print('Deleted file: ${entity.path}');
        }
      }
      setState(() {
        records.removeRange(
            0, records.length); // Clear the file list after deletion
      });
      print('All files in folder deleted successfully');
    } else {
      print('Folder does not exist');
    }
  }
}
