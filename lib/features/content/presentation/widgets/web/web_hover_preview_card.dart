import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/theme/app_colors.dart';
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
      duration: const Duration(milliseconds: 200), // Daha hızlı animasyon
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
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x80000000), // Sabit renk, performans için
                      blurRadius: 16,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
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
                      padding: const EdgeInsets.all(12.0),
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
                              const SizedBox(width: 8),
                              _CircleButton(
                                icon: Icons.add,
                                color: const Color(0xFF2A2A2A),
                                iconColor: Colors.white,
                                borderColor: const Color(0x80FFFFFF),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 8),
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
                          const SizedBox(height: 12),

                          // Metadata Row
                          Row(
                            children: [
                              const Text(
                                '98% Match',
                                style: TextStyle(
                                  color: Color(0xFF46D369),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0x66FFFFFF),
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: const Text(
                                  '13+',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.content.durationMinutes != null
                                    ? '${widget.content.durationMinutes}m'
                                    : '${widget.content.totalSeasons ?? 1} Seasons',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0x66FFFFFF),
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: const Text(
                                  'HD',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Genres
                          if (widget.content.genres != null &&
                              widget.content.genres!.isNotEmpty)
                            Text(
                              widget.content.genres!.join(' • '),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
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

/// Ayrı widget olarak çıkarıldı - const constructor ile optimize edildi
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
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1)
            : null,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 20, color: iconColor),
        onPressed: onPressed,
      ),
    );
  }
}
