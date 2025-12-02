import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/localization/app_localizations.dart';
import 'package:mobile/core/utils/web_responsive.dart';
import 'package:mobile/features/content/domain/entities/content.dart';

class HeroSection extends StatelessWidget {
  final Content content;
  final AppLocalizations localizations;

  const HeroSection({
    super.key,
    required this.content,
    required this.localizations,
  });

  String _getAbsoluteUrl(String url) {
    if (url.startsWith('http')) {
      return url;
    }
    return '${ApiConstants.baseUrl}$url';
  }

  @override
  Widget build(BuildContext context) {
    final scaler = context.responsive;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Hero section takes 85% of viewport height
    final height = screenHeight * WebDimensions.heroHeightPercent;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Video/Image
            if (content.videoFilePath != null || content.trailerUrl != null)
              _HeroVideoPlayer(
                videoUrl: _getAbsoluteUrl(
                  content.videoFilePath ?? content.trailerUrl!,
                ),
                fallbackImageUrl: content.posterUrl,
              )
            else if (content.posterUrl != null)
              _buildCachedImage(
                content.posterUrl!,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              )
            else
              Container(color: AppColors.netflixDarkGray),

            // Gradient Overlay (Left + Bottom)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [AppColors.netflixBlack, Colors.transparent],
                  stops: const [0.0, 0.3],
                ),
              ),
            ),

            // Content Info - Responsive positioned
            Positioned(
              left: scaler.w(
                scaler.isSmallScreen ? 20 : WebDimensions.rowPadding,
              ),
              bottom: scaler.h(WebDimensions.heroBottomOffset),
              width: scaler.isSmallScreen
                  ? screenWidth - scaler.w(40)
                  : screenWidth * WebDimensions.heroContentWidthPercent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    content.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: scaler.sp(
                        scaler.isSmallScreen ? 40 : WebDimensions.heroTitleSize,
                      ),
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
                  ),
                  scaler.verticalSpace(20),

                  // Description
                  Text(
                    content.description ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: scaler.sp(WebDimensions.heroDescriptionSize),
                      height: 1.4,
                      shadows: const [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  scaler.verticalSpace(30),

                  // Buttons
                  Wrap(
                    spacing: scaler.w(15),
                    runSpacing: scaler.h(15),
                    children: [
                      _HeroButton(
                        icon: Icons.play_arrow,
                        label: localizations.play,
                        isPrimary: true,
                        onPressed: () {},
                      ),
                      _HeroButton(
                        icon: Icons.info_outline,
                        label: localizations.moreInfo,
                        isPrimary: false,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCachedImage(String url, {BoxFit? fit, Alignment? alignment}) {
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: fit,
        alignment: alignment ?? Alignment.center,
        errorBuilder: (context, error, stackTrace) {
          return Container(color: Colors.grey[900]);
        },
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      alignment: alignment ?? Alignment.center,
      placeholder: (context, url) => Container(color: Colors.grey[900]),
      errorWidget: (context, url, error) => Container(color: Colors.grey[900]),
      memCacheWidth: 1920,
    );
  }
}

/// Hero button widget with responsive sizing
class _HeroButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _HeroButton({
    required this.icon,
    required this.label,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final scaler = context.responsive;

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: scaler.s(WebDimensions.heroButtonIconSize),
        color: isPrimary ? Colors.black : Colors.white,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: scaler.sp(WebDimensions.heroButtonFontSize),
          fontWeight: FontWeight.bold,
          color: isPrimary ? Colors.black : Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.white : const Color(0x666D6D6E),
        padding: scaler.paddingSymmetric(
          horizontal: WebDimensions.heroButtonPaddingH,
          vertical: WebDimensions.heroButtonPaddingV,
        ),
        shape: RoundedRectangleBorder(borderRadius: scaler.borderRadius(4)),
      ),
    );
  }
}

class _HeroVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? fallbackImageUrl;

  const _HeroVideoPlayer({required this.videoUrl, this.fallbackImageUrl});

  @override
  State<_HeroVideoPlayer> createState() => _HeroVideoPlayerState();
}

class _HeroVideoPlayerState extends State<_HeroVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    try {
      await _controller.initialize();
      await _controller.setVolume(0.0);
      await _controller.setLooping(true);
      await _controller.play();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialized) {
      return RepaintBoundary(
        child: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
      );
    }

    if (widget.fallbackImageUrl != null) {
      if (widget.fallbackImageUrl!.startsWith('assets/')) {
        return Image.asset(
          widget.fallbackImageUrl!,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        );
      }
      return CachedNetworkImage(
        imageUrl: widget.fallbackImageUrl!,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        placeholder: (context, url) => Container(color: Colors.black),
        errorWidget: (context, url, error) => Container(color: Colors.black),
      );
    }

    return Container(color: Colors.black);
  }
}
