import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:just_audio/just_audio.dart';

class SongDetailScreen extends StatefulWidget {
  final String songPath;
  final String songTitle;
  final List songList;
  final int songIndex;

  SongDetailScreen(
      {required this.songPath,
      required this.songTitle,
      required this.songList,
      required this.songIndex});

  @override
  _SongDetailScreenState createState() => _SongDetailScreenState(
      songPath: songPath,
      songTitle: songTitle,
      songList: songList,
      songIndex: songIndex);
}

class PositionData {
  const PositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  final String songPath;
  final String songTitle;
  final List songList;
  final int songIndex;
  ValueNotifier<int> _currentSongIndexNotifier;
  late AudioPlayer _audioPlayer;
  /*final _playlist = ConcatenatingAudioSource(
    children: [
      AudioSource.asset("assets/Sounds/Bird.mp3",
          tag: MediaItem(id: '0', title: 'Bird')),
      AudioSource.asset("assets/Sounds/Birds.mp3",
          tag: MediaItem(id: '1', title: 'Birds')),
      AudioSource.asset("assets/Sounds/Campfire.mp3",
          tag: MediaItem(id: '2', title: 'Campfire')),
      AudioSource.asset("assets/Sounds/Forest.mp3",
          tag: MediaItem(id: '3', title: 'Forest')),
      AudioSource.asset("assets/Sounds/Nature.mp3",
          tag: MediaItem(id: '4', title: 'Nature')),
      AudioSource.asset("assets/Sounds/Nature Meditation.mp3",
          tag: MediaItem(id: '5', title: 'Nature Meditation')),
      AudioSource.asset("assets/Sounds/Nature Meditation2.mp3",
          tag: MediaItem(id: '6', title: 'Nature Meditation2')),
      AudioSource.asset("assets/Sounds/Ocean.mp3",
          tag: MediaItem(id: '7', title: 'Ocean')),
      AudioSource.asset("assets/Sounds/OM.mp3",
          tag: MediaItem(id: '8', title: 'OM')),
      AudioSource.asset("assets/Sounds/Om Meditation.mp3",
          tag: MediaItem(id: '9', title: 'Om Meditation')),
      AudioSource.asset("assets/Sounds/Om Meditation2.mp3",
          tag: MediaItem(id: '10', title: 'Om Meditation2')),
      AudioSource.asset("assets/Sounds/Om Meditation3.mp3",
          tag: MediaItem(id: '11', title: 'Om Meditation3')),
      AudioSource.asset("assets/Sounds/Piano.mp3",
          tag: MediaItem(id: '12', title: 'Piano')),
      AudioSource.asset("assets/Sounds/Rain.mp3",
          tag: MediaItem(id: '13', title: 'Rain')),
      AudioSource.asset("assets/Sounds/Rain & Thunder.mp3",
          tag: MediaItem(id: '14', title: 'Rain & Thunder')),
      AudioSource.asset("assets/Sounds/Rain Relaxing.mp3",
          tag: MediaItem(id: '15', title: 'Rain Relaxing')),
      AudioSource.asset("assets/Sounds/Relaxing Nature.mp3",
          tag: MediaItem(id: '16', title: 'Relaxing Nature')),
      AudioSource.asset("assets/Sounds/Relaxing Sound1.mp3",
          tag: MediaItem(id: '17', title: 'Relaxing Sound1')),
      AudioSource.asset("assets/Sounds/Relaxing Sound2.mp3",
          tag: MediaItem(id: '18', title: 'Relaxing Sound2')),
      AudioSource.asset("assets/Sounds/Relaxing Sound3.mp3",
          tag: MediaItem(id: '19', title: 'Relaxing Sound3')),
      AudioSource.asset("assets/Sounds/Relaxing Sound4.mp3",
          tag: MediaItem(id: '20', title: 'Relaxing Sound4')),
      AudioSource.asset("assets/Sounds/Relaxing Sound5.mp3",
          tag: MediaItem(id: '21', title: 'Relaxing Sound5')),
      AudioSource.asset("assets/Sounds/Relaxing Sound6.mp3",
          tag: MediaItem(id: '22', title: 'Relaxing Sound6')),
      AudioSource.asset("assets/Sounds/Relaxing Sound 6.mp3",
          tag: MediaItem(id: '23', title: 'Relaxing Sound 6')),
      AudioSource.asset("assets/Sounds/Relaxing Sound7.mp3",
          tag: MediaItem(id: '24', title: 'Relaxing Sound7')),
      AudioSource.asset("assets/Sounds/Relaxing Sound8.mp3",
          tag: MediaItem(id: '25', title: 'Relaxing Sound8')),
      AudioSource.asset("assets/Sounds/River.mp3",
          tag: MediaItem(id: '26', title: 'River')),
      AudioSource.asset("assets/Sounds/river 2.mp3",
          tag: MediaItem(id: '27', title: 'river 2')),
      AudioSource.asset("assets/Sounds/thunder.mp3",
          tag: MediaItem(id: '28', title: 'thunder')),
      AudioSource.asset("assets/Sounds/water.mp3",
          tag: MediaItem(id: '29', title: 'water')),
      AudioSource.asset("assets/Sounds/Water Dripping.mp3",
          tag: MediaItem(id: '30', title: 'Water Dripping')),
      AudioSource.asset("assets/Sounds/Waves.mp3",
          tag: MediaItem(id: '30', title: 'Waves')),
    ],
  );*/

  _SongDetailScreenState(
      {required this.songIndex,
      required this.songList,
      required this.songPath,
      required this.songTitle})
      : _currentSongIndexNotifier = ValueNotifier<int>(songIndex);

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _currentSongIndexNotifier.dispose();
    // _player.dispose();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    _audioPlayer = AudioPlayer()
      ..setAsset(songList[_currentSongIndexNotifier.value]);
    await _audioPlayer.setLoopMode(LoopMode.all);
    // await _player.setAsset(widget.songPath);
    // _player.positionStream.listen((position) {
    //   // Listen to position changes and update the UI
    //   setState(() {});
    // });
  }

  void _playNextSong() {
    if (_currentSongIndexNotifier.value + 1 < songList.length) {
      _currentSongIndexNotifier.value++;
      _audioPlayer.setAsset(songList[_currentSongIndexNotifier.value]);
      _audioPlayer.play();
    }
  }

  void _playPreviousSong() {
    if (_currentSongIndexNotifier.value - 1 >= 0) {
      _currentSongIndexNotifier.value--;
      _audioPlayer.setAsset(songList[_currentSongIndexNotifier.value]);
      _audioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'MUSIC',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: /*Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<Duration?>(
              stream: _player.durationStream,
              builder: (context, snapshot) {
                final duration = snapshot.data ?? Duration.zero;
                return Text(
                  'Duration: ${_durationToString(duration)}',
                  style: TextStyle(fontSize: 20),
                );
              },
            ),
            SizedBox(height: 20),
            StreamBuilder<Duration>(
              stream: _player.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                return Column(
                  children: [
                    Text(
                      'Position: ${_durationToString(position)}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Slider(
                      value: position.inMilliseconds.toDouble(),
                      min: 0.0,
                      max: (_player.duration ?? Duration.zero).inMilliseconds.toDouble(),
                      onChanged: (value) {
                        _player.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),*/
            Container(
          padding: EdgeInsets.all(20),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/icon/bg3.png"), fit: BoxFit.fill),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: const [],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    image: AssetImage('assets/icon/music_thumb.png'),
                    height: 300,
                    width: 300,
                  ),
                ),
              ),
              StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  final double progress = positionData?.position.inMilliseconds.toDouble() ?? 0;
                  final double totalDuration = positionData?.duration.inMilliseconds.toDouble() ?? 1;
                  final double progressValue = totalDuration > 0 ? progress / totalDuration : 0;

                  return CustomCircularProgressIndicator(
                    progress: progressValue,
                    strokeWidth: 6,
                    backgroundColor: Color(0xff091939),
                    progressColor: Color(0xff1F53AE),
                  );
                },
              ),
              SizedBox(
                height: 18,
              ),
              ValueListenableBuilder<int>(
                valueListenable: _currentSongIndexNotifier,
                builder: (context, currentSongIndex, _) {
                  // Get the current song title based on the current song index
                  final currentSongTitle = songList[currentSongIndex]
                      .split("/")
                      .last
                      .toString()
                      .split(".")
                      .first;

                  return Text(
                    currentSongTitle,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  );
                },
              ),
              SizedBox(
                height: 50,
              ),
              StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return ProgressBar(
                      barHeight: 8,
                      timeLabelTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      progress: positionData?.position ?? Duration.zero,
                      buffered: positionData?.bufferedPosition ?? Duration.zero,
                      total: positionData?.duration ?? Duration.zero,
                      onSeek: _audioPlayer.seek,
                    );
                  }),
              SizedBox(
                height: 40,
              ),
              Controls(
                audioPlayer: _audioPlayer,
                songIndexNotifier: _currentSongIndexNotifier,
                songList: songList,
                onNext: _playNextSong,
                onPrevious: _playPreviousSong,
              )
            ],
          ),
        ));
  }

  String _durationToString(Duration duration) {
    return '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}';
  }
}

class Controls extends StatelessWidget {
  const Controls({
    Key? key,
    required this.audioPlayer,
    required this.songIndexNotifier,
    required this.songList,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  final AudioPlayer audioPlayer;
  final ValueNotifier<int> songIndexNotifier;
  final List songList;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPrevious,
          iconSize: 40,
          color: Colors.white,
          icon: Icon(Icons.skip_previous_rounded),
        ),
        SizedBox(
          width: 20,
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;

            if (!(playing ?? true)) {
              return ClipOval(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff173761),
                  ),
                  child: IconButton(
                    onPressed: audioPlayer.play,
                    iconSize: 60,
                    color: Colors.white,
                    icon: Icon(Icons.play_arrow_rounded),
                  ),
                ),
              );
            } else if (processingState != ProcessingState.completed) {
              return ClipOval(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff173761),
                  ),
                  child: IconButton(
                    onPressed: audioPlayer.pause,
                    iconSize: 60,
                    color: Colors.white,
                    icon: Icon(Icons.pause_outlined),
                  ),
                ),
              );
            }
            return Icon(
              Icons.play_arrow_rounded,
              size: 60,
              color: Colors.white,
            );
          },
        ),
        SizedBox(
          width: 20,
        ),
        IconButton(
          onPressed: onNext,
          iconSize: 40,
          color: Colors.white,
          icon: Icon(Icons.skip_next_rounded),
        ),
      ],
    );
  }
}




class CustomCircularProgressIndicator extends StatelessWidget {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  CustomCircularProgressIndicator({
    required this.progress,
    this.strokeWidth = 6,
    this.backgroundColor = const Color(0xff091939),
    this.progressColor = const Color(0xff1F53AE),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CustomCircularProgressIndicatorPainter(
        progress: progress,
        strokeWidth: strokeWidth,
        backgroundColor: backgroundColor,
        progressColor: progressColor,
      ),
      size: Size.square(100), // Adjust the size of the circular indicator
    );
  }
}

class _CustomCircularProgressIndicatorPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  _CustomCircularProgressIndicatorPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);
    final startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CustomCircularProgressIndicatorPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

