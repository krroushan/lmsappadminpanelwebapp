import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:ant_media_flutter/ant_media_flutter.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class PublishLiveStream extends StatefulWidget {
  final String streamId;
  final bool isScreen;
 // final RTCVideoRenderer localRenderer;
  final bool isLandscape;

  const PublishLiveStream({
    required this.streamId,
    this.isScreen = false,
    this.isLandscape = false,
    super.key,
  });

  @override
    State<PublishLiveStream> createState() => _PublishLiveStreamState();
}

class _PublishLiveStreamState extends State<PublishLiveStream> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  bool _isMuted = false;
  bool _isStreaming = false;
  bool _isCameraOff = false;
  int _currentQuality = 1080;
  bool _isChatVisible = false;
  RTCDataChannel? _dataChannel;
  String streamId = '';

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();

  int _unreadMessages = 0;

  bool _isInitializing = true;
  String _setupStatus = 'Initializing...';

  @override
  void initState() {
    super.initState();
    streamId = widget.streamId;
    _initializeStream();
  }

  Future<void> _initializeStream() async {
    try {
      _updateStatus('Checking permissions...');
      await _checkPermissions();
      
      _updateStatus('Initializing video renderer...');
      await initRenderers();
      
      _updateStatus('Setting up stream...');
      _setupStream();
      
      setState(() => _isInitializing = false);
    } catch (e) {
      setState(() {
        _isInitializing = false;
        _setupStatus = 'Setup failed: $e';
      });
      _showErrorDialog('Stream Setup Failed', 'Error: $e');
    }
  }

  Future<void> _checkPermissions() async {
    final camera = await Permission.camera.request();
    final microphone = await Permission.microphone.request();
    
    if (camera.isDenied || microphone.isDenied) {
      throw 'Camera and microphone permissions are required';
    }
  }

  void _updateStatus(String status) {
    setState(() => _setupStatus = status);
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  initRenderers() async {
    await _localRenderer.initialize();
  }

  @override
  deactivate() {
    super.deactivate();
    if (AntMediaFlutter.anthelper != null) AntMediaFlutter.anthelper?.close();
    _localRenderer.dispose();
  }

  

  void _setupStream() {
    AntMediaFlutter.connect(
      'wss://ant.ramaanya.com:5443/LiveApp/websocket',
      streamId,
      '',  // roomId
      '',  // token
      AntMediaType.Publish,
      widget.isScreen,
      _onStateChange,
      _onLocalStream,
      (stream) {}, // onAddRemoteStream
      _onDataChannel, // Add data channel handler
      (channel, message, isReceived) => _onDataChannelMessage(channel, message, isReceived), // Fixed callback
      (streams) {}, // onUpdateConferencePerson
      (stream) {}, // onRemoveRemoteStream
      [{'url': 'stun:stun.l.google.com:19302'}],
      (command, mapData) {},
    );
  }

  void _onStateChange(HelperState state) {
    switch (state) {
      case HelperState.CallStateNew:
        setState(() {
          _isStreaming = true;
          _setupStatus = 'Stream started successfully';
        });
        break;
      case HelperState.ConnectionOpen:
        _updateStatus('Connecting to stream...');
        break;
      case HelperState.ConnectionClosed:
        _updateStatus('Connection closed');
        break;
      case HelperState.CallStateBye:
        setState(() {
          _isStreaming = false;
          _localRenderer.srcObject = null;
          _setupStatus = 'Stream ended';
        });
        break;
      case HelperState.ConnectionError:
        _updateStatus('Connection error');
        break;
    }
  }

  void _onLocalStream(MediaStream stream) {
    setState(() => _localRenderer.srcObject = stream);
  }

  void _onDataChannel(RTCDataChannel? channel) {
    
    setState(() => _dataChannel = channel);
  }

  void _onDataChannelMessage(RTCDataChannel? channel, RTCDataChannelMessage message, bool isReceived) {
    if (isReceived) {
      setState(() {
        _messages.add({
          'message': message.text,
          'isReceived': true,
        });
        if (!_isChatVisible) {
          _unreadMessages++;
        }
      });
      _scrollToBottom();
    }
  }

  void _toggleQuality() {
    int newQuality = _currentQuality == 720 ? 480 : 720;
    AntMediaFlutter.anthelper?.forceStreamQuality(widget.streamId, newQuality);
    setState(() => _currentQuality = newQuality);
  }

  void _toggleChat() {
    setState(() {
      _isChatVisible = !_isChatVisible;
      if (_isChatVisible) {
        _unreadMessages = 0;
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final message = _messageController.text;
      // Create RTCDataChannelMessage object
      AntMediaFlutter.anthelper?.sendMessage(RTCDataChannelMessage(message));
      
      setState(() {
        _messages.add({
          'message': message,
          'isReceived': false,
        });
        _messageController.clear();
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(
                  _setupStatus,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video View
          RTCVideoView(
            _localRenderer,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
          
          // Live Status Indicator and Stream ID Container
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Live Status
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _isStreaming ? Colors.red : Colors.grey,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isStreaming ? Icons.circle : Icons.circle_outlined,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isStreaming ? 'LIVE' : 'OFF AIR',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Stream ID
                  Text(
                    'Stream ID: ${widget.streamId}',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          
          // Stream Controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side - Info button
                  _buildControlButton(
                    icon: Icons.info_outline,
                    label: 'Info',
                    onPressed: _showStreamInfo,
                    isActive: true,
                  ),
                  
                  // Center - Main controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildControlButton(
                        icon: _isMuted ? Icons.mic_off : Icons.mic,
                        label: _isMuted ? 'Unmute' : 'Mute',
                        onPressed: () {
                          setState(() {
                            _isMuted = !_isMuted;
                            AntMediaFlutter.anthelper?.muteMic(_isMuted);
                          });
                        },
                        isActive: !_isMuted,
                      ),
                      const SizedBox(width: 16),
                      _buildControlButton(
                        icon: _isStreaming ? Icons.stop : Icons.play_arrow,
                        label: _isStreaming ? 'Stop' : 'Start',
                        onPressed: () {
                          if (!_isStreaming) {
                            AntMediaFlutter.anthelper?.publish(
                              streamId,
                              "",
                              null,
                              null,
                              null,
                              null,
                              null,
                            );
                          } else {
                            AntMediaFlutter.anthelper?.bye();
                          }
                        },
                        isActive: _isStreaming,
                        isMain: true,
                      ),
                      const SizedBox(width: 16),
                      _buildControlButton(
                        icon: Icons.hd,
                        label: 'Quality',
                        onPressed: _toggleQuality,
                        isActive: _currentQuality == 720,
                      ),
                    ],
                  ),
                  
                  // Right side - Chat button
                  _buildControlButton(
                    icon: Icons.chat,
                    label: 'Chat',
                    onPressed: _toggleChat,
                    isActive: _isChatVisible,
                    badge: _unreadMessages > 0 ? _unreadMessages.toString() : null,
                  ),
                ],
              ),
            ),
          ),
          
          // Chat overlay (updated positioning and styling)
          if (_isChatVisible)
            Positioned(
              right: 16,
              bottom: 100,
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.black.withOpacity(0.85),
                child: SizedBox(
                  width: 350,
                  height: 500,
                  child: Column(
                    children: [
                      // Chat header with updated styling
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade900,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.chat, color: Colors.white, size: 24),
                                const SizedBox(width: 12),
                                const Text(
                                  'Live Chat',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white, size: 24),
                              onPressed: _toggleChat,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      // Chat messages with improved styling
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final message = _messages[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Align(
                                alignment: message['isReceived'] 
                                    ? Alignment.centerLeft 
                                    : Alignment.centerRight,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.65,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: message['isReceived']
                                        ? Colors.white.withOpacity(0.15)
                                        : Colors.blue.shade700,
                                    borderRadius: BorderRadius.circular(20).copyWith(
                                      bottomRight: message['isReceived'] ? Radius.circular(20) : Radius.circular(6),
                                      bottomLeft: message['isReceived'] ? Radius.circular(6) : Radius.circular(20),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    message['message'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Message input with improved styling
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade900.withOpacity(0.8),
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                                decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  hintStyle: TextStyle(color: Colors.white70),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: Colors.white.withOpacity(0.1),
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue.shade600,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.send, color: Colors.white, size: 22),
                                onPressed: _sendMessage,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isActive = true,
    bool isMain = false,
    String? badge,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              height: isMain ? 64 : 48,
              width: isMain ? 64 : 48,
              margin: const EdgeInsets.only(bottom: 8),
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                  backgroundColor: isMain
                      ? (isActive ? Colors.red : Colors.green)
                      : (isActive ? Colors.white24 : Colors.white12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: isMain ? 32 : 24,
                ),
              ),
            ),
            if (badge != null)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _showStreamInfo() {

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stream Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow('Stream ID', widget.streamId),
            _infoRow('Screen Share', widget.isScreen ? 'Yes' : 'No'),
            _infoRow('Status', _isStreaming ? 'Live' : 'Off Air'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    AntMediaFlutter.anthelper?.bye();
    super.dispose();
  }
} 