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
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Adjust the radius as needed
                        ),
                        title: const Text('Warning!',
                            style: TextStyle(color: Colors.red)),
                        content: const Text(
                            'Do you really want to delete all files!'),
                        actions: [
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  20), // Adjust the radius as needed
                              color: const Color(
                                  0xff07327a), // Set the background color
                            ),
                            child: TextButton(
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  20), // Adjust the radius as needed
                              color: const Color(
                                  0xff07327a), // Set the background color
                            ),
                            child: TextButton(
                              child: const Text(
                                'OK',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                deleteAllFilesInFolder();
                                Navigator.pop(context);
                              },
                            ),
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/icon/bg3.png"), fit: BoxFit.fill),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 6,
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
      if (mounted) {
        setState(() {});
      }
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
      if (kDebugMode) {
        print(e);
      }
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
      if (kDebugMode) {
        print('Folder does not exist');
      }
    }
  }
}
