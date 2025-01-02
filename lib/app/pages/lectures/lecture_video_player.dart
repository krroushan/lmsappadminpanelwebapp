import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LectureVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const LectureVideoPlayer({super.key, required this.videoUrl});
  @override
  _LectureVideoPlayerState createState() => _LectureVideoPlayerState();
}

class _LectureVideoPlayerState extends State<LectureVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse('https://avtshare01.rz.tu-ilmenau.de/avt-vqdb-uhd-1/test_1/segments/bigbuck_bunny_8bit_15000kbps_1080p_60.0fps_h264.mp4'))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Video Player Widget
          AspectRatio(
            aspectRatio: 16 / 9,
            child: VideoPlayer(_controller),
          ),
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying ? _controller.pause() : _controller.play();
                  });
                },
              ),
              // Add a progress bar and volume control here
              // Example: Progress bar
              Expanded(
                child: VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                ),
              ),
              // Volume control can be added here
              
            ],
          ),
        ],
      ),
    );
  }
}