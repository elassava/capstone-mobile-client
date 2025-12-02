import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/web_responsive.dart';
import 'package:mobile/features/content/domain/entities/content.dart';

class WebHoverPreviewCard extends StatefulWidget {
  final Content content;
  final VoidCallback onExit;
  final VoidCallback? onTap;

  const WebHoverPreviewCard({
    super.key,
    required this.content,
    required this.onExit,
    this.onTap,
  });

  @override
  State<WebHoverPreviewCard> createState() => _WebHoverPreviewCardState();
}

class _WebHoverPreviewCardState extends State<WebHoverPreviewCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final videoUrl = widget.content.videoFilePath ?? widget.content.trailerUrl;
    if (videoUrl != null && videoUrl.isNotEmpty) {
      final uri = Uri.parse(
        videoUrl.startsWith('http')
            ? videoUrl
            : '${ApiConstants.baseUrl}$videoUrl',
      );

      _videoController = VideoPlayerController.networkUrl(uri);
      try {
        await _videoController!.initialize();
        await _videoController!.setVolume(0.0);
        await _videoController!.setLooping(true);
        await _videoController!.play();
        if (mounted) {
          setState(() {
            _isVideoInitialized = true;
          });
        }
      } catch (e) {
        debugPrint('Preview video error: $e');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaler = context.responsive;
    
    return RepaintBoundary(
      child: MouseRegion(
        onExit: (_) => widget.onExit(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.netflixDarkGray,
                  borderRadius: scaler.borderRadius(6),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x80000000),
                      blurRadius: scaler.s(16),
                      spreadRadius: scaler.s(2),
                      offset: Offset(0, scaler.h(4)),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Section: Video/Image
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (_isVideoInitialized && _videoController != null)
                            VideoPlayer(_videoController!)
                          else
                            _buildImage(
                              widget.content.thumbnailUrl ??
                                  widget.content.posterUrl ??
                                  '',
                            ),
                        ],
                      ),
                    ),

                    // Bottom Section: Info & Controls
                    Padding(
                      padding: scaler.padding(WebDimensions.previewPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Action Row
                          Row(
                            children: [
                              _CircleButton(
                                icon: Icons.play_arrow,
                                color: Colors.white,
                                iconColor: Colors.black,
                                onPressed: () {},
                              ),
                              scaler.horizontalSpace(8),
                              _CircleButton(
                                icon: Icons.add,
                                color: const Color(0xFF2A2A2A),
                                iconColor: Colors.white,
                                borderColor: const Color(0x80FFFFFF),
                                onPressed: () {},
                              ),
                              scaler.horizontalSpace(8),
                              _CircleButton(
                                icon: Icons.thumb_up_outlined,
                                color: const Color(0xFF2A2A2A),
                                iconColor: Colors.white,
                                borderColor: const Color(0x80FFFFFF),
                                onPressed: () {},
                              ),
                              const Spacer(),
                              _CircleButton(
                                icon: Icons.keyboard_arrow_down,
                                color: const Color(0xFF2A2A2A),
                                iconColor: Colors.white,
                                borderColor: const Color(0x80FFFFFF),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          scaler.verticalSpace(12),

                          // Metadata Row
                          Row(
                            children: [
                              Text(
                                '98% Match',
                                style: TextStyle(
                                  color: const Color(0xFF46D369),
                                  fontWeight: FontWeight.bold,
                                  fontSize: scaler.sp(12),
                                ),
                              ),
                              scaler.horizontalSpace(8),
                              Container(
                                padding: scaler.paddingSymmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0x66FFFFFF),
                                  ),
                                  borderRadius: scaler.borderRadius(2),
                                ),
                                child: Text(
                                  '13+',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: scaler.sp(10),
                                  ),
                                ),
                              ),
                              scaler.horizontalSpace(8),
                              Text(
                                widget.content.durationMinutes != null
                                    ? '${widget.content.durationMinutes}m'
                                    : '${widget.content.totalSeasons ?? 1} Seasons',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: scaler.sp(12),
                                ),
                              ),
                              scaler.horizontalSpace(8),
                              Container(
                                padding: scaler.paddingSymmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0x66FFFFFF),
                                  ),
                                  borderRadius: scaler.borderRadius(2),
                                ),
                                child: Text(
                                  'HD',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: scaler.sp(9),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          scaler.verticalSpace(8),

                          // Genres
                          if (widget.content.genres != null &&
                              widget.content.genres!.isNotEmpty)
                            Text(
                              widget.content.genres!.join(' • '),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: scaler.sp(12),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
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
  }

  Widget _buildImage(String url) {
    if (url.isEmpty) return Container(color: AppColors.netflixDarkGray);

    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Container(color: AppColors.netflixDarkGray),
      );
    }
    
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      memCacheWidth: 350,
      placeholder: (context, url) => Container(color: AppColors.netflixDarkGray),
      errorWidget: (context, url, error) => Container(color: AppColors.netflixDarkGray),
    );
  }
}

/// Circle button with responsive sizing
class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final Color? borderColor;
  final VoidCallback onPressed;

  const _CircleButton({
    required this.icon,
    required this.color,
    required this.iconColor,
    this.borderColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final scaler = context.responsive;
    
    return Container(
      width: scaler.s(WebDimensions.previewButtonSize),
      height: scaler.s(WebDimensions.previewButtonSize),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: scaler.s(1))
            : null,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          size: scaler.s(WebDimensions.previewIconSize),
          color: iconColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
