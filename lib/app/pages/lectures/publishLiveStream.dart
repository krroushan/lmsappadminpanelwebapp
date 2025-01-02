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
  int _currentQuality = 720;
  bool _isChatVisible = false;
  RTCDataChannel? _dataChannel;
  String streamId = '';

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();


  @override
  void initState() {
    super.initState();
    streamId = widget.streamId;
    initRenderers();
    _setupStream();
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
      'wss://ant.wizzyweb.in:5443/LiveApp/websocket',
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
        setState(() => _isStreaming = true);
        break;
      case HelperState.CallStateBye:
        setState(() {
          _isStreaming = false;
          _localRenderer.srcObject = null;
        });
        break;
      default:
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
    setState(() => _isChatVisible = !_isChatVisible);
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
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
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Stream ID: ${widget.streamId}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.chat, color: Colors.white),
                if (_messages.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        _messages.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _toggleChat,
          ),
          IconButton(
            icon: Icon(
              Icons.hd,
              color: _currentQuality == 720 ? Colors.blue : Colors.white,
            ),
            onPressed: _toggleQuality,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => _showStreamInfo(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Video View
          RTCVideoView(
            _localRenderer,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
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
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  _buildControlButton(
                    icon: _isStreaming ? Icons.stop : Icons.play_arrow,
                    label: _isStreaming ? 'Stop' : 'Start',
                    onPressed: () {
                      if (!_isStreaming) {
                        AntMediaFlutter.anthelper?.publish(
                          "true",
                          "true",
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
                  // _buildControlButton(
                  //   icon: _isCameraOff ? Icons.videocam_off : Icons.videocam,
                  //   label: _isCameraOff ? 'Camera On' : 'Camera Off',
                  //   onPressed: _toggleCamera,
                  //   isActive: !_isCameraOff,
                  // ),
                ],
              ),
            ),
          ),
          
          // Chat overlay
          if (_isChatVisible)
            Positioned(
              right: 16,
              top: 16,
              child: Card(
                color: Colors.black.withOpacity(0.8),
                child: SizedBox(
                  width: 300,
                  height: 400,
                  child: Column(
                    children: [
                      // Chat header
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Live Chat',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: _toggleChat,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      // Chat messages
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(8),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final message = _messages[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: message['isReceived']
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.blue.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  message['message'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Message input
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  hintStyle: const TextStyle(color: Colors.white70),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  fillColor: Colors.white24,
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.send, color: Colors.white),
                              onPressed: _sendMessage,
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
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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