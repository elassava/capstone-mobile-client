import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/extensions/snackbar_extension.dart';
import 'package:mobile/core/localization/app_localizations.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/netflix_logo.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/content/domain/entities/content.dart';
import 'package:mobile/features/content/presentation/providers/content_notifier.dart';
import 'package:mobile/features/content/presentation/providers/content_providers.dart';
import 'package:mobile/features/content/presentation/providers/hover_preview_provider.dart';
import 'package:mobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:mobile/features/content/presentation/widgets/web/web_content_card.dart';
import 'package:mobile/features/content/presentation/widgets/web/web_hover_preview_card.dart';
import 'package:mobile/features/content/presentation/widgets/web/web_home_shimmer.dart';

class WebHomePage extends ConsumerStatefulWidget {
  const WebHomePage({super.key});

  @override
  ConsumerState<WebHomePage> createState() => _WebHomePageState();
}

class _WebHomePageState extends ConsumerState<WebHomePage> {
  final ScrollController _scrollController = ScrollController();
  
  // ValueNotifier kullanarak sadece AppBar'ı yeniden oluşturuyoruz
  final ValueNotifier<double> _scrollOffsetNotifier = ValueNotifier(0.0);
  
  // Memoized content listeler
  List<Content>? _cachedTrendingContents;
  List<Content>? _cachedNewReleases;
  List<Content>? _lastContents;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(contentNotifierProvider.notifier).fetchAllContents();
      ref.read(contentNotifierProvider.notifier).fetchFeaturedContents();

      final authState = ref.read(authNotifierProvider);
      if (authState.authResponse?.user != null) {
        final accountId = authState.authResponse!.user.userId;
        ref.read(profileNotifierProvider.notifier).fetchProfiles(accountId);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollOffsetNotifier.dispose();
    super.dispose();
  }

  void _onScroll() {
    // setState yerine ValueNotifier kullan - sadece AppBar yeniden oluşturulur
    _scrollOffsetNotifier.value = _scrollController.offset;
  }

  // Memoized trending contents
  List<Content> _getTrendingContents(List<Content> contents) {
    if (identical(contents, _lastContents) && _cachedTrendingContents != null) {
      return _cachedTrendingContents!;
    }
    _lastContents = contents;
    final sorted = List<Content>.from(contents);
    sorted.sort((a, b) => (b.viewCount ?? 0).compareTo(a.viewCount ?? 0));
    _cachedTrendingContents = sorted.take(10).toList();
    return _cachedTrendingContents!;
  }

  // Memoized new releases
  List<Content> _getNewReleases(List<Content> contents) {
    if (identical(contents, _lastContents) && _cachedNewReleases != null) {
      return _cachedNewReleases!;
    }
    final sorted = List<Content>.from(contents);
    sorted.sort((a, b) {
      final aDate = a.createdAt;
      final bDate = b.createdAt;
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return bDate.compareTo(aDate);
    });
    _cachedNewReleases = sorted.take(10).toList();
    return _cachedNewReleases!;
  }

  @override
  Widget build(BuildContext context) {
    final contentState = ref.watch(contentNotifierProvider);
    final localizations = AppLocalizations.of(context)!;

    // Error handling
    ref.listen<ContentState>(contentNotifierProvider, (previous, next) {
      if (next.error != null && next.error!.isNotEmpty) {
        context.showErrorSnackBar(next.error ?? '');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.netflixBlack,
      extendBodyBehindAppBar: true,
      body: contentState.isLoading
          ? const WebHomeShimmer()
          : Stack(
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollStartNotification) {
                      ref
                          .read(hoverPreviewProvider.notifier)
                          .setScrollActive(true);
                    } else if (notification is ScrollEndNotification) {
                      ref
                          .read(hoverPreviewProvider.notifier)
                          .setScrollActive(false);
                    }
                    return false;
                  },
                  // CustomScrollView + Slivers kullanımı - Performans artışı
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      // Hero Section
                      if (contentState.featuredContents.isNotEmpty)
                        SliverToBoxAdapter(
                          child: RepaintBoundary(
                            child: _buildHeroSection(
                              contentState.featuredContents.first,
                              localizations,
                            ),
                          ),
                        ),

                      // Content Rows - Padding wrapper
                      SliverPadding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            if (contentState.contents.isNotEmpty)
                              RepaintBoundary(
                                child: _buildTop10Row(
                                  localizations.trendingNow,
                                  _getTrendingContents(contentState.contents),
                                ),
                              ),
                            if (contentState.tvSeries.isNotEmpty)
                              RepaintBoundary(
                                child: _buildHorizontalContentRow(
                                  localizations.tvSeries,
                                  contentState.tvSeries,
                                ),
                              ),
                            if (contentState.movies.isNotEmpty)
                              RepaintBoundary(
                                child: _buildHorizontalContentRow(
                                  localizations.popularMovies,
                                  contentState.movies,
                                ),
                              ),
                            if (contentState.contents.isNotEmpty)
                              RepaintBoundary(
                                child: _buildHorizontalContentRow(
                                  localizations.newReleases,
                                  _getNewReleases(contentState.contents),
                                ),
                              ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // AppBar - ValueListenableBuilder ile sadece gerektiğinde yeniden oluşturulur
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _OptimizedAppBar(
                    scrollOffsetNotifier: _scrollOffsetNotifier,
                    localizations: localizations,
                  ),
                ),
                
                // Global Hover Preview Layer
                Consumer(
                  builder: (context, ref, child) {
                    final previewState = ref.watch(hoverPreviewProvider);
                    if (previewState.activeContent == null ||
                        previewState.position == null) {
                      return const SizedBox.shrink();
                    }

                    return Positioned(
                      left: previewState.position!.dx,
                      top: previewState.position!.dy,
                      width: 350,
                      child: WebHoverPreviewCard(
                        content: previewState.activeContent!,
                        onExit: () {
                          ref.read(hoverPreviewProvider.notifier).hidePreview();
                        },
                        onTap: () {
                          // TODO: Navigate to details
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }

  Widget _buildHeroSection(Content content, AppLocalizations localizations) {
    // Hero section takes 85% of viewport height
    final height = MediaQuery.of(context).size.height * 0.85;
    final width = MediaQuery.of(context).size.width;

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

            // Content Info
            Positioned(
              left: width < 600 ? 20 : 60,
              bottom: 150,
              width: width < 600 ? width - 40 : width * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width < 600 ? 40 : 60,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    content.description ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.4,
                      shadows: [
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
                  const SizedBox(height: 30),

                  Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.play_arrow,
                          size: 28,
                          color: Colors.black,
                        ),
                        label: Text(
                          localizations.play,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.info_outline,
                          size: 28,
                          color: Colors.white,
                        ),
                        label: Text(
                          localizations.moreInfo,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0x666D6D6E),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
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

  Widget _buildHorizontalContentRow(String title, List<Content> contents) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 60.0,
              vertical: 10.0,
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFFE5E5E5),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 130,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              scrollDirection: Axis.horizontal,
              itemCount: contents.length,
              // Performans optimizasyonları
              cacheExtent: 500, // Görünür alan dışında da widget'ları cache'le
              addAutomaticKeepAlives: false, // Manuel kontrol
              addRepaintBoundaries: true,
              itemBuilder: (context, index) {
                final content = contents[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: WebContentCard(
                    key: ValueKey('content_${content.id}'),
                    content: content,
                    aspectRatio: 16 / 9,
                    onTap: () {
                      // TODO: Navigate to details or play
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTop10Row(String title, List<Content> contents) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 60.0,
              vertical: 10.0,
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFFE5E5E5),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              scrollDirection: Axis.horizontal,
              itemCount: contents.length,
              // Performans optimizasyonları
              cacheExtent: 500,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: true,
              itemBuilder: (context, index) {
                final content = contents[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: RepaintBoundary(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Big Number - const Text yerine CustomPaint kullanılabilir ama şimdilik RepaintBoundary ile sarıyoruz
                        Stack(
                          children: [
                            Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                                height: 0.8,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 4
                                  ..color = const Color(0xFF595959),
                              ),
                            ),
                            Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                                height: 0.8,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        WebContentCard(
                          key: ValueKey('top10_${content.id}'),
                          content: content,
                          isTop10: true,
                          top10Index: index + 1,
                          aspectRatio: 2 / 3,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getAbsoluteUrl(String url) {
    if (url.startsWith('http')) {
      return url;
    }
    return '${ApiConstants.baseUrl}$url';
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
      memCacheWidth: 1920, // Max cache size for large images
    );
  }
}

/// Optimize edilmiş AppBar - Sadece scroll değiştiğinde yeniden oluşturulur
class _OptimizedAppBar extends StatelessWidget {
  final ValueNotifier<double> scrollOffsetNotifier;
  final AppLocalizations localizations;

  const _OptimizedAppBar({
    required this.scrollOffsetNotifier,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: scrollOffsetNotifier,
      builder: (context, scrollOffset, child) {
        final double opacity = (scrollOffset / 100).clamp(0.0, 1.0);
        
        return Container(
          height: 100,
          alignment: Alignment.centerLeft,
          color: Colors.black.withValues(alpha: opacity),
          padding: const EdgeInsets.symmetric(horizontal: 60.0),
          child: child,
        );
      },
      child: SafeArea(
        child: Row(
          children: [
            const SizedBox(
              height: 40,
              child: NetflixLogo(),
            ),
            const SizedBox(width: 40),

            _NavLink(title: localizations.home, isActive: true),
            _NavLink(title: localizations.tvSeries, isActive: false),
            _NavLink(title: localizations.movies, isActive: false),
            _NavLink(title: localizations.newAndPopular, isActive: false),
            _NavLink(title: localizations.myList, isActive: false),

            const Spacer(),

            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {},
            ),
            const SizedBox(width: 20),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blue,
              ),
              child: const Icon(Icons.person, size: 20, color: Colors.white),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

/// Nav link widget - const constructor ile optimize edildi
class _NavLink extends StatelessWidget {
  final String title;
  final bool isActive;

  const _NavLink({required this.title, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextButton(
        onPressed: () {},
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.7),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
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
