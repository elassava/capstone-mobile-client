import 'dart:async';
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

class WebVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final String? jwtToken; // JWT token for authentication

  const WebVideoPlayer({
    super.key,
    required this.videoUrl,
    this.autoPlay = true,
    this.jwtToken,
  });

  @override
  State<WebVideoPlayer> createState() => _WebVideoPlayerState();
}

class _WebVideoPlayerState extends State<WebVideoPlayer> {
  late String _viewId;
  web.HTMLVideoElement? _videoElement;

  @override
  void initState() {
    super.initState();
    _viewId = 'video-player-${DateTime.now().millisecondsSinceEpoch}';

    // Register the view factory
    ui.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      final video = web.document.createElement('video') as web.HTMLVideoElement;
      video.style.width = '100%';
      video.style.height = '100%';
      video.controls = true;
      video.autoplay = widget.autoPlay;

      _videoElement = video;

      // Initialize dash.js after a short delay to ensure element is ready
      Timer(const Duration(milliseconds: 100), () {
        _initializeDash(video);
      });

      return video;
    });
  }

  void _initializeDash(web.HTMLVideoElement video) {
    // Access dashjs from global scope using js_interop
    final window = web.window as JSObject;
    if (window.hasProperty('dashjs'.toJS).toDart) {
      final dashjs = window.getProperty('dashjs'.toJS) as JSObject;
      final mediaPlayer = dashjs.callMethod('MediaPlayer'.toJS) as JSObject;
      final player = mediaPlayer.callMethod('create'.toJS) as JSObject;

      // Add JWT token to request headers if available
      if (widget.jwtToken != null && widget.jwtToken!.isNotEmpty) {
        // Create a request modifier to add Authorization header
        player.callMethod(
          'extend'.toJS,
          'RequestModifier'.toJS,
          _createRequestModifier(widget.jwtToken!).toJS,
        );
      }

      player.callMethod(
        'initialize'.toJS,
        video as JSAny,
        widget.videoUrl.toJS,
        widget.autoPlay.toJS,
      );
    } else {
      print('Dash.js not found!');
    }
  }

  /// Create request modifier function to add JWT token
  JSFunction _createRequestModifier(String token) {
    return (() {
      return {
        'modifyRequestHeader': (JSObject xhr) {
          // Add Authorization header with JWT token
          xhr.callMethod(
            'setRequestHeader'.toJS,
            'Authorization'.toJS,
            'Bearer $token'.toJS,
          );
          return xhr;
        }.toJS,
      }.jsify();
    }.toJS) as JSFunction;
  }

  @override
  void dispose() {
    if (_videoElement != null) {
      final dashjs = (web.window as dynamic).dashjs;
      if (dashjs != null) {
        // Cleanup if necessary, though dash.js usually handles this attached to element
      }
      _videoElement = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Center(child: HtmlElementView(viewType: _viewId)),
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
