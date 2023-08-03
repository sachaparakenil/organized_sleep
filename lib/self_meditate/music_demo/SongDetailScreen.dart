import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class SongDetailScreen extends StatefulWidget {
  final String songPath;
  final String songTitle;

  SongDetailScreen({required this.songPath, required this.songTitle});

  @override
  _SongDetailScreenState createState() =>
      _SongDetailScreenState(songPath: songPath, songTitle: songTitle);
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
  // final AudioPlayer _player = AudioPlayer();
  late AudioPlayer _audioPlayer;
  // final _playlist = ConcatenatingAudioSource(children: []);

  _SongDetailScreenState({required this.songPath, required this.songTitle});

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
    // _player.dispose();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    _audioPlayer = AudioPlayer()..setAsset(songPath);
    await _audioPlayer.setLoopMode(LoopMode.all);
    // await _player.setAsset(widget.songPath);
    // _player.positionStream.listen((position) {
    //   // Listen to position changes and update the UI
    //   setState(() {});
    // });
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
              SizedBox(
                height: 18,
              ),
              Text(
                widget.songTitle,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
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
              Controls(audioPlayer: _audioPlayer)
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
    super.key,
    required this.audioPlayer,
  });
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: audioPlayer.seekToPrevious,
            iconSize: 40,
            color: Colors.white,
            icon: Icon(Icons.skip_previous_rounded)),
        StreamBuilder<PlayerState>(
            stream: audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;

              if (!(playing ?? false)) {
                return ClipOval(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff173761),
                    ),
                    child: IconButton(
                        onPressed: audioPlayer.play,
                        iconSize: 60,
                        color: Colors.white,
                        icon: Icon(Icons.play_arrow_rounded)),
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
                        icon: Icon(Icons.pause_outlined)),
                  ),
                );
              }
              return Icon(
                Icons.play_arrow_rounded,
                size: 60,
                color: Colors.white,
              );
            }),
        IconButton(
            onPressed: (audioPlayer.seekToNext),
            iconSize: 40,
            color: Colors.white,
            icon: Icon(Icons.skip_next_rounded)),
      ],
    );
  }
}
