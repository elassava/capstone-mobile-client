import 'dart:async';
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

class WebVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;

  const WebVideoPlayer({
    super.key,
    required this.videoUrl,
    this.autoPlay = true,
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
