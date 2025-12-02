import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/extensions/snackbar_extension.dart';
import 'package:mobile/core/localization/app_localizations.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/web_responsive.dart';
import 'package:mobile/core/utils/slippery_scroll_physics.dart';
import 'package:mobile/core/widgets/netflix_logo.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/content/domain/entities/content.dart';
import 'package:mobile/features/content/presentation/providers/content_notifier.dart';
import 'package:mobile/features/content/presentation/providers/content_providers.dart';
import 'package:mobile/features/content/presentation/providers/hover_preview_provider.dart';
import 'package:mobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:mobile/features/content/presentation/widgets/web/web_hover_preview_card.dart';
import 'package:mobile/features/content/presentation/widgets/web/web_home_shimmer.dart';
import 'package:mobile/features/content/presentation/widgets/web/hero_section.dart';
import 'package:mobile/features/content/presentation/widgets/web/content_list_row.dart';
import 'package:mobile/features/content/presentation/widgets/web/top10_list_row.dart';

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
    _scrollOffsetNotifier.value = _scrollController.offset;
  }

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
    final scaler = context.responsive;

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
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const SlipperyScrollPhysics(),
                    slivers: [
                      if (contentState.featuredContents.isNotEmpty)
                        SliverToBoxAdapter(
                          child: RepaintBoundary(
                            child: HeroSection(
                              content: contentState.featuredContents.first,
                              localizations: localizations,
                            ),
                          ),
                        ),

                      SliverPadding(
                        padding: scaler.paddingOnly(top: 20, bottom: 40),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            if (contentState.contents.isNotEmpty)
                              RepaintBoundary(
                                child: Top10ListRow(
                                  title: localizations.trendingNow,
                                  contents: _getTrendingContents(
                                    contentState.contents,
                                  ),
                                ),
                              ),
                            if (contentState.tvSeries.isNotEmpty)
                              RepaintBoundary(
                                child: ContentListRow(
                                  title: localizations.tvSeries,
                                  contents: contentState.tvSeries,
                                ),
                              ),
                            if (contentState.movies.isNotEmpty)
                              RepaintBoundary(
                                child: ContentListRow(
                                  title: localizations.popularMovies,
                                  contents: contentState.movies,
                                ),
                              ),
                            if (contentState.contents.isNotEmpty)
                              RepaintBoundary(
                                child: ContentListRow(
                                  title: localizations.newReleases,
                                  contents: _getNewReleases(
                                    contentState.contents,
                                  ),
                                ),
                              ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),

                // Optimized AppBar
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
                      width: scaler.w(WebDimensions.previewWidth),
                      child: WebHoverPreviewCard(
                        content: previewState.activeContent!,
                        onExit: () {
                          ref.read(hoverPreviewProvider.notifier).hidePreview();
                        },
                        onTap: () {},
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}

/// Optimize edilmiş AppBar
class _OptimizedAppBar extends StatelessWidget {
  final ValueNotifier<double> scrollOffsetNotifier;
  final AppLocalizations localizations;

  const _OptimizedAppBar({
    required this.scrollOffsetNotifier,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    final scaler = context.responsive;

    return ValueListenableBuilder<double>(
      valueListenable: scrollOffsetNotifier,
      builder: (context, scrollOffset, child) {
        final double opacity = (scrollOffset / 100).clamp(0.0, 1.0);

        return Container(
          height: scaler.h(WebDimensions.appBarHeight),
          alignment: Alignment.centerLeft,
          color: Colors.black.withValues(alpha: opacity),
          padding: scaler.paddingSymmetric(
            horizontal: WebDimensions.appBarPadding,
          ),
          child: child,
        );
      },
      child: SafeArea(
        child: Row(
          children: [
            SizedBox(
              height: scaler.h(WebDimensions.logoHeight),
              child: const NetflixLogo(),
            ),
            scaler.horizontalSpace(40),

            _NavLink(title: localizations.home, isActive: true),
            _NavLink(title: localizations.tvSeries, isActive: false),
            _NavLink(title: localizations.movies, isActive: false),
            _NavLink(title: localizations.newAndPopular, isActive: false),
            _NavLink(title: localizations.myList, isActive: false),

            const Spacer(),

            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              iconSize: scaler.s(24),
              onPressed: () {},
            ),
            scaler.horizontalSpace(WebDimensions.navIconSpacing),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              iconSize: scaler.s(24),
              onPressed: () {},
            ),
            scaler.horizontalSpace(WebDimensions.navIconSpacing),
            Container(
              width: scaler.s(WebDimensions.profileIconSize),
              height: scaler.s(WebDimensions.profileIconSize),
              decoration: BoxDecoration(
                borderRadius: scaler.borderRadius(4),
                color: Colors.blue,
              ),
              child: Icon(
                Icons.person,
                size: scaler.s(20),
                color: Colors.white,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
              size: scaler.s(24),
            ),
          ],
        ),
      ),
    );
  }
}

/// Nav link widget
class _NavLink extends StatelessWidget {
  final String title;
  final bool isActive;

  const _NavLink({required this.title, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final scaler = context.responsive;

    return Padding(
      padding: scaler.paddingSymmetric(
        horizontal: WebDimensions.navLinkPadding,
      ),
      child: TextButton(
        onPressed: () {},
        child: Text(
          title,
          style: TextStyle(
            color: isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.7),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: scaler.sp(WebDimensions.navLinkFontSize),
          ),
        ),
      ),
    );
  }
}
