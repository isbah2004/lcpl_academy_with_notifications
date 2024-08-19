import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:lcpl_academy/theme/theme.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String url;
  final String title;

  const AudioPlayerScreen({super.key, required this.url, required this.title});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer audioPlayer;
  Stream<Position> get positionDataStream => Rx.combineLatest3(
        audioPlayer.positionStream,
        audioPlayer.bufferedPositionStream,
        audioPlayer.durationStream,
        (position, bufferedPosition, duration) {
          return Position(
              position: position,
              bufferPosition: bufferedPosition,
              duration: duration ?? Duration.zero);
        },
      );
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer()..setUrl(widget.url);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: GoogleFonts.ubuntu(),
        ),
      ),
      body: StreamBuilder(
        stream: positionDataStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final positionData = snapshot.data;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProgressBar(
                  barHeight: 8,
                  baseBarColor: AppTheme.greyColor,
                  bufferedBarColor: AppTheme.accentColor,
                  progressBarColor: AppTheme.primaryColor,
                  thumbColor: AppTheme.primaryColor,
                  timeLabelTextStyle:
                      GoogleFonts.ubuntu(color: AppTheme.blackColor),
                  progress: positionData?.position ?? Duration.zero,
                  buffered: positionData?.bufferPosition ?? Duration.zero,
                  total: positionData?.duration ?? Duration.zero,
                  onSeek: audioPlayer.seek,
                ),
                Controls(audioPlayer: audioPlayer),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Position {
  final Duration position;
  final Duration bufferPosition;
  final Duration duration;

  Position(
      {required this.position,
      required this.bufferPosition,
      required this.duration});
}

class Controls extends StatelessWidget {
  final AudioPlayer audioPlayer;
  const Controls({super.key, required this.audioPlayer});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: audioPlayer.playerStateStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final playerState = snapshot.data;
        final processingData = playerState?.processingState;
        final playing = playerState?.playing;
        if (!(playing ?? false)) {
          return IconButton(
            onPressed: audioPlayer.play,
            icon: const Icon(Icons.play_arrow_rounded),
          );
        } else if (processingData != ProcessingState.completed) {
          return IconButton(
            onPressed: () {
              audioPlayer.pause();
            },
            icon: const Icon(Icons.pause),
          );
        }
        return const Icon(Icons.play_arrow_rounded);
      },
    );
  }
}
