// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'constants.dart';

class RecordListView extends StatefulWidget {
  final List<String> records;
  final Directory appDirectory;

  const RecordListView({
    Key? key,
    required this.records,
    required this.appDirectory,
  }) : super(key: key);

  @override
  State<RecordListView> createState() => _RecordListViewState();
}

class _RecordListViewState extends State<RecordListView>
    with WidgetsBindingObserver {
  _RecordListViewState();

  AudioPlayer audioPlayer = AudioPlayer();

  TextEditingController renameController = TextEditingController();

  bool isRenamePressed = false;
  late int _totalDuration;
  late int _currentDuration;
  double _completedPercentage = 0.0;
  bool _isPlaying = false;
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.stop();
  }

  FutureBuilder<DateTime> dateAndTime(int i) {
    return FutureBuilder<DateTime>(
      future: getFileLastModified(widget.records.elementAt(i)),
      builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          DateTime lastModified = snapshot.data!;

          String time = DateFormat.jm().format(lastModified); // Format the time
          String date =
              DateFormat.yMMMd().format(lastModified); // Format the date

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Date: $date', style: const TextStyle(fontSize: 16)),

              // SizedBox(height: 2),
              Text('Time: $time', style: const TextStyle(fontSize: 16)),
              // Text(time, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          );
        } else {
          return const Text('File does not exist.');
        }
      },
    );
  }

  IconButton renameIcon(BuildContext context, File file, int position) {
    return IconButton(
      iconSize: 43,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20), // Adjust the radius as needed
              ),
              title: const Text('Rename!',
                  style: TextStyle(color: Color(0xff07327a))),
              content: const Text('Do you really want to rename this file!'),
              actions: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff07327a)),
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Enter New Name',
                    helperText: 'Keep it meaningful',
                    labelText: 'Rename',
                    prefixIcon: const Icon(
                      Icons.drive_file_rename_outline_rounded,
                      color: Color(0xff07327a),
                    ),
                  ),
                  controller: renameController,
                ),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        20), // Adjust the radius as needed
                    color: const Color(0xff07327a), // Set the background color
                  ),
                  child: TextButton(
                    child: const Text(
                      'Rename',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);

                      await changeFileNameOnly(
                          file, "${renameController.text}.aac");
                      // records.clear();
                      var path = file.path;
                      var lastSeparator =
                          path.lastIndexOf(Platform.pathSeparator);
                      var newPath =
                          "${path.substring(0, lastSeparator + 1)}${renameController.text}.aac";
                      widget.records[position] = newPath;

                      setState(() {});
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(Icons.edit),
    );
  }

  IconButton deleteIcon(BuildContext context, int i) {
    return IconButton(
        iconSize: 43,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Adjust the radius as needed
                ),
                title:
                    const Text('Warning!', style: TextStyle(color: Colors.red)),
                content: const Text('Do you really want to delete this file!'),
                actions: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          20), // Adjust the radius as needed
                      color:
                          const Color(0xff07327a), // Set the background color
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
                      color:
                          const Color(0xff07327a), // Set the background color
                    ),
                    child: TextButton(
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        deleteFile(File(widget.records.elementAt(i)), i);
                        // deleteAllFilesInFolder();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              );
            },
          );

          setState(() {});
        },
        icon: const Icon(Icons.delete));
  }

  IconButton resetIcon() {
    return IconButton(
      iconSize: 43,
      onPressed: () {
        _onStop();
      },
      icon: const Icon(Icons.stop),
    );
  }

  IconButton playPauseIcon(int i) {
    return IconButton(
      iconSize: 43,
      icon: _selectedIndex == i
          ? _isPlaying
              ? const Icon(Icons.pause)
              : const Icon(Icons.play_arrow)
          : const Icon(Icons.play_arrow),
      onPressed: () {
        if (_isPlaying) {
          _onPause();
        } else {
          _onPlay(filePath: widget.records.elementAt(i), index: i);
        }
      },
    );
  }

  Future<void> deleteFile(File file, int index) async {
    try {
      if (await file.exists()) {
        await file.delete();
        setState(() {
          widget.records.remove(file);
          widget.records
              .removeAt(index); // Remove the deleted file from the list
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    setState(() {});
  }

  Future<void> _onPlay({required String filePath, required int index}) async {
    if (!_isPlaying) {
      await audioPlayer.stop();
      audioPlayer.play(UrlSource(filePath));
      setState(() {
        _selectedIndex = index;
        _completedPercentage = 0.0;
        _isPlaying = true;
      });

      audioPlayer.onPlayerComplete.listen((_) {
        setState(() {
          _isPlaying = false;
          _completedPercentage = 0.0;
        });
      });

      audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _totalDuration = duration.inMilliseconds;
        });
      });

      audioPlayer.onPositionChanged.listen((duration) {
        setState(() {
          _currentDuration = duration.inMilliseconds;
          _completedPercentage =
              _currentDuration.toDouble() / _totalDuration.toDouble();
        });
      });
    }
  }

  Future<void> _onStop() async {
    audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      // isRecording = false;
      _completedPercentage = 0.0;
    });
  }

  Future<void> _onPause() async {
    audioPlayer.pause();
    setState(() {
      _isPlaying = false;
      // isRecording = false;
    });
  }

  Future<File> replaceFile(File file, String newFileName) async {
    var path = file.path;

    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return await file.rename(newPath);
  }

  Future<File?> changeFileNameOnly(File file, String newFileName) async {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;

    // Check if the new file name already exists
    var newFile = File(newPath);
    if (await newFile.exists()) {
      // Show an alert dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('File Name Already Exists'),
            content: const Text('The specified file name already exists.'),
            actions: [
              // Cancel button
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
              ),
              // Replace button
              TextButton(
                child: const Text('Replace'),
                onPressed: () {
                  replaceFile(file, "${renameController.text}.aac");
                  Navigator.of(context).pop(file);
                  setState(() {});
                },
              ),
            ],
          );
        },
      );
      return null; // Return null to indicate failure
    }

    // Rename the file
    await file.rename(newPath);
    return newFile;
  }

  Future<DateTime> getFileLastModified(String filepath) async {
    File file = File(filepath);

    if (await file.exists()) {
      DateTime lastModified = await file.lastModified();
      return lastModified;
    } else {
      throw Exception('File does not exist.');
    }
  }

  var isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return widget.records.isEmpty
        ? const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/icon/snore_thumb.png'),
                height: 200,
                width: 200,
              ),
              Text(
                'No Sound Yet...',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          )
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                itemCount: widget.records.length,
                shrinkWrap: true,
                reverse: false,
                itemBuilder: (BuildContext context, int i) {
                  File file = File(widget.records.elementAt(i));

                  String fileName = file.path.split('/').last;
                  // print("File Name:${renameController}");
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: kListCardBackGroundColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Shadow color
                            spreadRadius: 1, // Spread radius
                            blurRadius: 2.5, // Blur radius
                            offset: const Offset(
                                0, 2), // Offset in x and y direction
                          ),
                        ],
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(bottom: 8, left: 8, top: 8),
                        child: ExpansionTile(
                          // this new index is for getting new recording first
                          // title: Text('New recoding ${widget.records.length - i}'),
                          title: Text(
                            fileName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2),
                              dateAndTime(i),
                            ],
                          ),
                          trailing: _selectedIndex == i && isExpanded
                              ? const Icon(Icons.keyboard_arrow_up)
                              : const Icon(Icons.keyboard_arrow_down),

                          onExpansionChanged: (bool expanded) {
                            setState(() {
                              isExpanded = expanded;
                              _selectedIndex = i;
                            });
                          },

                          children: [
                            // dropDown container
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTapDown: (TapDownDetails details) {
                                      // Calculate the new audio position based on the tap position
                                      double tapPosition =
                                          details.localPosition.dx;
                                      double totalWidth =
                                          MediaQuery.of(context).size.width;
                                      int newAudioPosition = (tapPosition /
                                              totalWidth *
                                              _totalDuration)
                                          .toInt();

                                      // Update the audio player's position
                                      audioPlayer.seek(Duration(
                                          milliseconds: newAudioPosition));
                                    },
                                    child: LinearProgressIndicator(
                                      semanticsLabel: fileName,
                                      minHeight: 6,
                                      backgroundColor: const Color(0xFFCED3D9),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Color(0xFF1C95FF)),
                                      value: _selectedIndex == i
                                          ? _completedPercentage
                                          : 0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      playPauseIcon(i),
                                      resetIcon(),
                                      deleteIcon(context, i),
                                      renameIcon(context, file, i),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }
}
