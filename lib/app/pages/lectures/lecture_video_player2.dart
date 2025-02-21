import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:video_player_web/video_player_web.dart';
import '../../core/api_service/lecture_service.dart';
import '../../models/lecture/lecture.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 50,
    colors: true,
    printEmojis: true,
    printTime: false
  ),
);

class LectureVideoPlayer2 extends StatefulWidget {
  final String lectureId;
  const LectureVideoPlayer2({super.key, required this.lectureId});

  @override
  _LectureVideoPlayer2State createState() => _LectureVideoPlayer2State();
}

class _LectureVideoPlayer2State extends State<LectureVideoPlayer2> {
  VideoPlayerController? _controller;
  bool _showControls = true;
  Timer? _controlsTimer;
  double _volume = 1.0;
  bool _isBuffering = false;
  double _playbackSpeed = 1.0;
  bool _isLoading = true;
  bool _videoError = false;
  String videoUrl = '';
  late Lecture lecture;
  final LayerLink _volumeLayerLink = LayerLink();
  OverlayEntry? _volumeOverlay;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.checkAuthentication();
      final token = authProvider.getToken;
      
      if (!mounted) return;

      await _fetchLecture(token);
      if (!mounted) return;

      if (lecture.recordingUrl?.isNotEmpty ?? false) {
        videoUrl = lecture.recordingUrl!;
        logger.i('Video URL: $videoUrl');
        await _initializeVideoController();
      } else {
        _handleVideoError('Recording URL is empty or null');
      }
    } catch (error) {
      _handleVideoError('Initialization error: $error');
    }
  }

  Future<void> _fetchLecture(String token) async {
    try {
      final lectureService = LectureService();
      lecture = await lectureService.getLectureById(widget.lectureId, token);
    } catch (e) {
      throw Exception('Failed to fetch lecture: $e');
    }
  }

  Future<void> _initializeVideoController() async {
    if (videoUrl.isEmpty) {
      _handleVideoError('Video URL is empty');
      return;
    }

    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse('https://api.ramaanya.com/uploads/lectures/videos/$videoUrl')
      );

      await controller.initialize();
      
      if (!mounted) return;

      setState(() {
        _controller = controller;
        _isLoading = false;
      });

      _controller?.addListener(_onControllerUpdate);
      _controller?.play();
    } catch (error) {
      _handleVideoError('Video initialization error: $error');
    }
  }

  void _handleVideoError(String message) {
    logger.e(message);
    if (mounted) {
      setState(() {
        _videoError = true;
        _isLoading = false;
      });
    }
  }

  void _onControllerUpdate() {
    if (_controller == null) return;
    if (!mounted) return;
    
    final isBuffering = _controller!.value.isBuffering;
    if (isBuffering != _isBuffering) {
      setState(() => _isBuffering = isBuffering);
    }
  }

  void _initializeVideoControls() {
    _controlsTimer?.cancel();
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
                            _controller?.setVolume(_volume);
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
                title: Text(
                  '${speed}x',
                  style: const TextStyle(color: Colors.white)
                ),
                selected: _playbackSpeed == speed,
                selectedTileColor: Colors.white24,
                onTap: () {
                  setState(() => _playbackSpeed = speed);
                  _controller?.setPlaybackSpeed(speed);
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
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_videoError) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Failed to load video',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

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
              Center(
                child: _controller?.value.isInitialized == true
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: VideoPlayer(_controller!),
                          ),
                          if (_isBuffering)
                            const CircularProgressIndicator(color: Colors.white),
                          if (_showControls)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _controller!.value.isPlaying
                                      ? _controller!.pause()
                                      : _controller!.play();
                                });
                                _initializeVideoControls();
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black45,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(20),
                                child: Icon(
                                  _controller!.value.isPlaying 
                                      ? Icons.pause 
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ),
                        ],
                      )
                    : const CircularProgressIndicator(color: Colors.white),
              ),
              if (_showControls)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black87, Colors.transparent],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_controller != null)
                          VideoProgressIndicator(
                            _controller!,
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
                            if (_controller != null)
                              Text(
                                '${_formatDuration(_controller!.value.position)} / '
                                '${_formatDuration(_controller!.value.duration)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            const Spacer(),
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
    _controller?.removeListener(_onControllerUpdate);
    _controlsTimer?.cancel();
    _volumeOverlay?.remove();
    _controller?.dispose();
    super.dispose();
  }
}