import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:organized_sleep/SleepTracker/SleepAudioTracker/recorder_listview.dart';
import 'package:organized_sleep/SleepTracker/SleepAudioTracker/recorder_view.dart';
import 'package:path_provider/path_provider.dart';

class RecorderHomeView extends StatefulWidget {
  const RecorderHomeView({
    Key? key,
  }) : super(key: key);

  @override
  State<RecorderHomeView> createState() => _RecorderHomeViewState();
}

class _RecorderHomeViewState extends State<RecorderHomeView> {
  Directory appDirectory = Directory("");
  List<String> records = [];

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      _loadRecordsInBackground(); // Load records in the background
    });
  }

  @override
  void dispose() {
    // appDirectory.delete();
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
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Warning!',
                            style: TextStyle(color: Colors.red)),
                        content: const Text(
                            'Do you really want to delete all files!'),
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
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "Sleep Tracker",
          ),
        ),
        centerTitle: true,
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

  void _loadRecordsInBackground() {
    // Load records in the background isolate using compute.
    compute(_getRecords, appDirectory.path).then((loadedRecords) {
      setState(() {
        records = loadedRecords.reversed.toList();
      });
    });
  }

  static List<String> _getRecords(String directoryPath) {
    List<String> loadedRecords = [];
    Directory appDirectory = Directory(directoryPath);
    appDirectory.listSync().forEach((onData) {
      if (onData.path.contains('.aac')) loadedRecords.add(onData.path);
    });
    return loadedRecords;
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
    String folderPath = "/data/user/0/com.example.organized_sleep/app_flutter/";
    Directory folder = Directory(folderPath);
    if (await folder.exists()) {
      List<FileSystemEntity> entities = folder.listSync();
      for (FileSystemEntity entity in entities) {
        if (entity is File) {
          await entity.delete();
        }
      }
      setState(() {
        records.removeRange(
            0, records.length); // Clear the file list after deletion
      });
    } else {
      print('Folder does not exist');
    }
  }
}
