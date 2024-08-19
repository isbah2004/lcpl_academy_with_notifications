import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String title, url;
  const VideoPlayerScreen({super.key, required this.title, required this.url});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
      ),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
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
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: FlickVideoPlayer(
            flickManager: flickManager,
          ),
        ),
      ),
    );
  }
}
