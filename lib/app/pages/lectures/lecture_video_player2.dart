import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:video_player_web/video_player_web.dart';

/// Stateful widget to fetch and then display video content.
class LectureVideoPlayer2 extends StatefulWidget {
  final String lectureId;
  const LectureVideoPlayer2({super.key, required this.lectureId});

  @override
  _LectureVideoPlayer2State createState() => _LectureVideoPlayer2State();
}

class _LectureVideoPlayer2State extends State<LectureVideoPlayer2> {
  late VideoPlayerController _controller;
  bool _showControls = true;
  Timer? _controlsTimer;
  double _volume = 1.0;
  bool _showVolumeSlider = false;
  bool _isBuffering = false;
  double _playbackSpeed = 1.0;

  // Add new overlay position control
  final LayerLink _volumeLayerLink = LayerLink();
  OverlayEntry? _volumeOverlay;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://ant.wizzyweb.in:5443/LiveApp/streams/LiveStreamFromLocal_2092_480p1000kbps_1.mp4'))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.addListener(_onControllerUpdate);
      }).catchError((error) {
        // Handle initialization error
        debugPrint('Video initialization error: $error');
      });
    
    // Remove SystemChrome calls
    _initializeVideoControls();
  }

  void _initializeVideoControls() {
    _controlsTimer?.cancel();
    // Only start the timer if controls are showing
    if (_showControls) {
      _controlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _showControls = false);
        }
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  // Update volume control methods
  void _showVolumeControl() {
    _volumeOverlay?.remove();
    _volumeOverlay = OverlayEntry(
      builder: (context) => Positioned(
        width: 150,
        child: CompositedTransformFollower(
          link: _volumeLayerLink,
          offset: const Offset(-120, -40),
          child: GestureDetector(
            onTap: () {},
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Icon(
                      _volume == 0
                          ? Icons.volume_off
                          : _volume < 0.5
                              ? Icons.volume_down
                              : Icons.volume_up,
                      color: Colors.white,
                      size: 20,
                    ),
                    Expanded(
                      child: Slider(
                        value: _volume,
                        onChanged: (value) {
                          setState(() {
                            _volume = value;
                            _controller.setVolume(_volume);
                          });
                        },
                        activeColor: Colors.white,
                        inactiveColor: Colors.white24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_volumeOverlay!);
  }

  void _hideVolumeControl() {
    _volumeOverlay?.remove();
    _volumeOverlay = null;
  }

  void _onControllerUpdate() {
    final bool isBuffering = _controller.value.isBuffering;
    if (isBuffering != _isBuffering) {
      setState(() => _isBuffering = isBuffering);
    }
  }

  // Add method for playback speed control
  void _showPlaybackSpeedMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: Colors.black87,
        child: ListView(
          shrinkWrap: true,
          children: [
            for (var speed in [0.5, 0.75, 1.0, 1.25, 1.5, 2.0])
              ListTile(
                title: Text('${speed}x',
                    style: TextStyle(color: Colors.white)),
                selected: _playbackSpeed == speed,
                selectedTileColor: Colors.white24,
                onTap: () {
                  setState(() => _playbackSpeed = speed);
                  _controller.setPlaybackSpeed(speed);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: MouseRegion(
        onHover: (_) {
          if (!_showControls) {
            setState(() {
              _showControls = true;
              _initializeVideoControls();
            });
          }
        },
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: (_) {
            setState(() {
              _showControls = true;
              _initializeVideoControls();
            });
          },
          child: Stack(
            children: [
              // Video Player with buffering indicator
              Center(
                child: _controller.value.isInitialized
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                          if (_isBuffering)
                            const CircularProgressIndicator(color: Colors.white),
                          // Add large center play/pause button
                          if (_showControls)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                });
                                _initializeVideoControls();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(20),
                                child: Icon(
                                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ),
                        ],
                      )
                    : const CircularProgressIndicator(color: Colors.white),
              ),

              // Bottom controls
              if (_showControls)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black87, Colors.transparent],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Video Progress Slider
                        VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          colors: const VideoProgressColors(
                            playedColor: Colors.white,
                            bufferedColor: Colors.white24,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        
                        Row(
                          children: [
                            // Time Display
                            Text(
                              '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            
                            const Spacer(),
                            
                            // Playback Speed Button
                            TextButton(
                              onPressed: _showPlaybackSpeedMenu,
                              child: Text(
                                '${_playbackSpeed}x',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            
                            // Volume Controls
                            CompositedTransformTarget(
                              link: _volumeLayerLink,
                              child: IconButton(
                                icon: Icon(
                                  _volume == 0
                                      ? Icons.volume_off
                                      : _volume < 0.5
                                          ? Icons.volume_down
                                          : Icons.volume_up,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if (_volumeOverlay == null) {
                                    _showVolumeControl();
                                  } else {
                                    _hideVolumeControl();
                                  }
                                  _initializeVideoControls();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controlsTimer?.cancel();
    _hideVolumeControl();
    _controller.dispose();
    super.dispose();
  }
}