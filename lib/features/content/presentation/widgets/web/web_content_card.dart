import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/web_responsive.dart';
import 'package:mobile/features/content/domain/entities/content.dart';
import 'package:mobile/features/content/presentation/providers/hover_preview_provider.dart';

class WebContentCard extends ConsumerStatefulWidget {
  final Content content;
  final bool isTop10;
  final int? top10Index;
  final double aspectRatio;
  final VoidCallback? onTap;

  const WebContentCard({
    super.key,
    required this.content,
    this.isTop10 = false,
    this.top10Index,
    this.aspectRatio = 16 / 9,
    this.onTap,
  });

  @override
  ConsumerState<WebContentCard> createState() => _WebContentCardState();
}

class _WebContentCardState extends ConsumerState<WebContentCard> {
  Timer? _hoverTimer;
  bool _isHovering = false;

  @override
  void dispose() {
    _hoverTimer?.cancel();
    super.dispose();
  }

  void _onHover(bool isHovering) {
    if (isHovering) {
      _isHovering = true;
      _hoverTimer?.cancel();
      _hoverTimer = Timer(const Duration(milliseconds: 250), () {
        if (_isHovering && mounted) {
          _showPreview();
        }
      });
    } else {
      _isHovering = false;
      _hoverTimer?.cancel();
    }
  }

  void _showPreview() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    
    final scaler = context.responsive;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final previewWidth = scaler.w(WebDimensions.previewWidth);

    // Calculate center position relative to the screen
    final double centerLeft = offset.dx - (previewWidth - size.width) / 2;
    final double centerTop = offset.dy - (scaler.h(196) - size.height) / 2;

    ref
        .read(hoverPreviewProvider.notifier)
        .showPreview(widget.content, Offset(centerLeft, centerTop));
  }

  @override
  Widget build(BuildContext context) {
    final scaler = context.responsive;
    
    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: widget.isTop10 ? _buildTop10Card(scaler) : _buildStandardCard(scaler),
        ),
      ),
    );
  }

  Widget _buildStandardCard(WebResponsive scaler) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: scaler.borderRadius(WebDimensions.cardBorderRadius),
          color: AppColors.netflixDarkGray,
        ),
        child: ClipRRect(
          borderRadius: scaler.borderRadius(WebDimensions.cardBorderRadius),
          child: _buildImage(
            widget.content.thumbnailUrl ?? widget.content.posterUrl ?? '',
          ),
        ),
      ),
    );
  }

  Widget _buildTop10Card(WebResponsive scaler) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: scaler.borderRadius(WebDimensions.cardBorderRadius),
        color: AppColors.netflixDarkGray,
      ),
      child: ClipRRect(
        borderRadius: scaler.borderRadius(WebDimensions.cardBorderRadius),
        child: _buildImage(widget.content.posterUrl ?? ''),
      ),
    );
  }

  Widget _buildImage(String url) {
    if (url.isEmpty) {
      return Container(color: AppColors.netflixDarkGray);
    }

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
      memCacheWidth: widget.isTop10 ? 300 : 400,
      memCacheHeight: widget.isTop10 ? 450 : 225,
      placeholder: (context, url) => Container(
        color: AppColors.netflixDarkGray,
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.netflixDarkGray,
      ),
      fadeInDuration: const Duration(milliseconds: 150),
      fadeOutDuration: const Duration(milliseconds: 150),
    );
  }
}
