import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class PositionData {
  PositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key, required this.songIndex});
  final int songIndex;

  @override
  State<AudioPlayerScreen> createState() =>
      _AudioPlayerScreenState(songIndex: songIndex);
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  final int songIndex;
  final ValueNotifier<int> _currentSongIndexNotifier;
  final _playlist = ConcatenatingAudioSource(
    children: [
      AudioSource.asset("assets/Sounds/Bird.mp3",
          tag: const MediaItem(
              id: '0', title: 'Bird', artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Birds.mp3",
          tag: const MediaItem(
              id: '1', title: 'Birds', artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Campfire.mp3",
          tag: const MediaItem(
              id: '2', title: 'Campfire', artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Forest.mp3",
          tag: const MediaItem(
              id: '3', title: 'Forest', artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Nature-Meditation.mp3",
          tag: const MediaItem(
              id: '4',
              title: 'Nature Meditation',
              artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Nature-Meditation2.mp3",
          tag: const MediaItem(
              id: '5',
              title: 'Nature Meditation2',
              artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Nature.mp3",
          tag: const MediaItem(
              id: '6', title: 'Nature', artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/OM.mp3",
          tag: const MediaItem(
              id: '7', title: 'OM', artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Ocean.mp3",
          tag: const MediaItem(
              id: '8', title: 'Ocean', artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Om-Meditation-3.mp3",
          tag: const MediaItem(
              id: '9', title: 'Om Meditation3', artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Om-Meditation.mp3",
          tag: const MediaItem(
              id: '10', title: 'Om Meditation', artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Om-Meditation2.mp3",
          tag: const MediaItem(
              id: '11',
              title: 'Om Meditation2',
              artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Piano.mp3",
          tag: const MediaItem(
              id: '12', title: 'Piano', artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Rain & Thunder.mp3",
          tag: const MediaItem(
              id: '13',
              title: 'Rain & Thunder',
              artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Rain-Relaxing.mp3",
          tag: const MediaItem(
              id: '14', title: 'Rain Relaxing', artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Rain.mp3",
          tag: const MediaItem(
              id: '15', title: 'Rain', artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Relaxing-Nature.mp3",
          tag: const MediaItem(
              id: '16',
              title: 'Relaxing Nature',
              artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Relaxing-Sound-6.mp3",
          tag: const MediaItem(
              id: '17',
              title: 'Relaxing Sound 6',
              artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Relaxing-Sound1.mp3",
          tag: const MediaItem(
              id: '18',
              title: 'Relaxing Sound1',
              artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Relaxing-Sound2.mp3",
          tag: const MediaItem(
              id: '19',
              title: 'Relaxing Sound2',
              artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Relaxing-Sound3.mp3",
          tag: const MediaItem(
              id: '20',
              title: 'Relaxing Sound3',
              artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Relaxing-Sound4.mp3",
          tag: const MediaItem(
              id: '21',
              title: 'Relaxing Sound4',
              artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Relaxing-Sound5.mp3",
          tag: const MediaItem(
              id: '22',
              title: 'Relaxing Sound5',
              artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Relaxing-Sound6.mp3",
          tag: const MediaItem(
              id: '23',
              title: 'Relaxing Sound6',
              artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Relaxing-Sound7.mp3",
          tag: const MediaItem(
              id: '24',
              title: 'Relaxing Sound7',
              artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Relaxing-Sound8.mp3",
          tag: const MediaItem(
              id: '25',
              title: 'Relaxing Sound8',
              artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/River.mp3",
          tag: const MediaItem(
              id: '26', title: 'River', artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Water-Dripping.mp3",
          tag: const MediaItem(
              id: '27',
              title: 'Water Dripping',
              artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/Waves.mp3",
          tag: const MediaItem(
              id: '28', title: 'Waves', artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/river-2.mp3",
          tag: const MediaItem(
              id: '29', title: 'river 2', artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/thunder.mp3",
          tag: const MediaItem(
              id: '30', title: 'thunder', artist: 'Natural Environment')),
      AudioSource.asset("assets/Sounds/water.mp3",
          tag: const MediaItem(
              id: '31', title: 'water', artist: 'Natural Environment')),
    ],
  );

  _AudioPlayerScreenState({
    required this.songIndex,
  }) : _currentSongIndexNotifier = ValueNotifier<int>(songIndex);

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
                position,
                bufferedPosition,
                duration ?? Duration.zero,
              ));

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(_playlist[_currentSongIndexNotifier.value]);
    _audioPlayer.play();
  }

  void _playNextSong() {
    if (_currentSongIndexNotifier.value + 1 < _playlist.length) {
      _currentSongIndexNotifier.value++;
      _audioPlayer.setAudioSource(_playlist[_currentSongIndexNotifier.value]);
      _audioPlayer.play();
    }
  }

  void _playPreviousSong() {
    if (_currentSongIndexNotifier.value - 1 >= 0) {
      _currentSongIndexNotifier.value--;
      _audioPlayer.setAudioSource(_playlist[_currentSongIndexNotifier.value]);
      _audioPlayer.play();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
    _currentSongIndexNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'MUSIC MELODIES',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/icon/bg3.png"), fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    final double progress =
                        positionData?.position.inMilliseconds.toDouble() ?? 0;
                    final double totalDuration =
                        positionData?.duration.inMilliseconds.toDouble() ?? 1;
                    final double progressValue =
                        totalDuration > 0 ? progress / totalDuration : 0;

                    return CustomCircularProgressIndicator(
                      progress: progressValue,
                      strokeWidth: 6,
                      backgroundColor: const Color(0xff091939),
                      progressColor: const Color(0xff1F53AE),
                    );
                  },
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: const [],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const Image(
                      image: AssetImage('assets/icon/music_thumb.png'),
                      height: 240, // Adjust the height of the image
                      width: 240, // Adjust the width of the image
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder<SequenceState?>(
              stream: _audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return const SizedBox();
                }
                final metadata = state!.currentSource!.tag as MediaItem;
                return MediaMetadata(
                    title: metadata.title, artist: metadata.artist ?? '');
              },
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return ProgressBar(
                    barHeight: 8,
                    timeLabelTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    thumbRadius: 9,
                    thumbColor: Colors.white,
                    baseBarColor: const Color(0xff102349),
                    progressBarColor: const Color(0xff1F53AE),
                    bufferedBarColor: const Color(0xff091939),
                    progress: positionData?.position ?? Duration.zero,
                    buffered: positionData?.bufferedPosition ?? Duration.zero,
                    total: positionData?.duration ?? Duration.zero,
                    onSeek: _audioPlayer.seek,
                  );
                }),
            const SizedBox(
              height: 45,
            ),
            Controls(audioPlayer: _audioPlayer, onNext: _playPreviousSong, onPrevious:_playNextSong ,),
          ],
        ),
      ),
    );
  }
}

class MediaMetadata extends StatelessWidget {
  const MediaMetadata({super.key, required this.title, required this.artist});

  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          artist,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}

class Controls extends StatelessWidget {
  const Controls({super.key, required this.audioPlayer, required this.onNext, required this.onPrevious});
  final AudioPlayer audioPlayer;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: onNext,
            color: Colors.white,
            iconSize: 50,
            icon: const Icon(Icons.skip_previous_rounded)),
        const SizedBox(width: 20,),
        StreamBuilder<PlayerState>(
            stream: audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (!(playing ?? false)) {
                return ClipOval(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xff196EFF),
                    ),
                    child: IconButton(
                      onPressed: audioPlayer.play,
                      icon: const Icon(Icons.play_arrow_rounded),
                      iconSize: 60,
                      color: Colors.white,
                    ),
                  ),
                );
              } else if (processingState != ProcessingState.completed) {
                return ClipOval(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xff196EFF),
                    ),
                    child: IconButton(
                      onPressed: audioPlayer.pause,
                      icon: const Icon(Icons.pause_rounded),
                      iconSize: 60,
                      color: Colors.white,
                    ),
                  ),
                );
              }
              return ClipOval(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xff196EFF),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              );
            }),
        const SizedBox(width: 20,),
        IconButton(
            onPressed: onPrevious,
            color: Colors.white,
            iconSize: 50,
            icon: const Icon(Icons.skip_next_rounded)),
      ],
    );
  }
}

class CustomCircularProgressIndicator extends StatelessWidget {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  const CustomCircularProgressIndicator({super.key,
    required this.progress,
    this.strokeWidth = 6,
    this.backgroundColor = const Color(0xff061CCE),
    this.progressColor = const Color(0xff091E40),
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
      size: const Size.square(300),
      child: Container(
        width: 280,
        height: 280,
        alignment: Alignment.center,
        child: Transform.translate(
          offset: Offset(
            (280 / 2 - strokeWidth / 2) * cos(2 * pi * progress - pi / 2),
            (280 / 2 - strokeWidth / 2) * sin(2 * pi * progress - pi / 2),
          ),
          child: Container(
            width: 16, // Adjust the size of the thumb indicator
            height: 16, // Adjust the size of the thumb indicator
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
          ),
        ),
      ),
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
    const startAngle = -pi / 2;
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
