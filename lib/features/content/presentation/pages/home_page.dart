import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/snackbar_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../profile/domain/entities/profile.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../domain/entities/content.dart';
import '../providers/content_notifier.dart';
import '../providers/content_providers.dart';
import '../widgets/content_horizontal_list.dart';
import 'content_detail_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;
  int _selectedTabIndex = 0; // 0: Diziler, 1: Filmler, 2: Kategoriler
  AppLocalizations? _localizations;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch contents when page loads
      ref.read(contentNotifierProvider.notifier).fetchAllContents();
      ref.read(contentNotifierProvider.notifier).fetchFeaturedContents();
      
      // Fetch profiles to get current profile name
      final authState = ref.read(authNotifierProvider);
      if (authState.authResponse?.user != null) {
        final accountId = authState.authResponse!.user.userId;
        ref.read(profileNotifierProvider.notifier).fetchProfiles(accountId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final contentState = ref.watch(contentNotifierProvider);
    _localizations ??= AppLocalizations.of(context)!;

    // Handle errors
    ref.listen<ContentState>(contentNotifierProvider, (previous, next) {
      if (next.error != null && next.error!.isNotEmpty) {
        context.showErrorSnackBar(next.error ?? '');
      }
    });

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        // Prevent back navigation to authentication pages
        if (didPop) {
          // This should not happen, but if it does, we'll handle it
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.netflixBlack,
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            contentState.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.netflixRed,
                    ),
                  )
                : _buildBody(contentState),
            // Floating Bottom Navigation Bar
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _buildFloatingBottomNavigationBar(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final profileState = ref.watch(profileNotifierProvider);
    Profile? currentProfile;
    if (profileState.profiles.isNotEmpty) {
      try {
        currentProfile = profileState.profiles.firstWhere((p) => p.isDefault);
      } catch (e) {
        currentProfile = profileState.profiles.first;
      }
    }
    final profileName = currentProfile?.profileName ?? '';

    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.netflixBlack.withValues(alpha: 0.7),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.netflixGray.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 80,
              title: profileName.isNotEmpty
                  ? Text(
                      '${_localizations!.forProfile(profileName)}',
                      style: const TextStyle(
                        color: AppColors.netflixWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : null,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.cast, color: AppColors.netflixWhite),
                  onPressed: () {
                    // TODO: Cast functionality
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.download_outlined, color: AppColors.netflixWhite),
                  onPressed: () {
                    // TODO: Navigate to downloads
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: AppColors.netflixWhite),
                  onPressed: () {
                    // TODO: Navigate to search page
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: AppColors.netflixWhite),
                  onPressed: () {
                    // TODO: Navigate to notifications
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ContentState contentState) {
    final featuredContent = contentState.featuredContents.isNotEmpty
        ? contentState.featuredContents.first
        : null;
    final profileState = ref.watch(profileNotifierProvider);
    Profile? currentProfile;
    if (profileState.profiles.isNotEmpty) {
      try {
        currentProfile = profileState.profiles.firstWhere((p) => p.isDefault);
      } catch (e) {
        currentProfile = profileState.profiles.first;
      }
    }
    final profileName = currentProfile?.profileName ?? '';

    return CustomScrollView(
      slivers: [
        // Hero Section (Featured Content)
        if (featuredContent != null)
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildHeroSection(featuredContent),
                // Tab Navigation
                _buildTabNavigation(),
              ],
            ),
          ),

        // Content Lists
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Continue Watching Section
              if (profileName.isNotEmpty && contentState.contents.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.getResponsiveHorizontalPadding(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _localizations!.continueWatching(profileName),
                        style: const TextStyle(
                          color: AppColors.netflixWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              if (profileName.isNotEmpty && contentState.contents.isNotEmpty)
                ContentHorizontalList(
                  title: '',
                  contents: _getContinueWatchingContents(contentState.contents),
                  onContentTap: _onContentTap,
                ),

              const SizedBox(height: 24),

              // Filtered Content Based on Tab
              if (_selectedTabIndex == 0 && contentState.tvSeries.isNotEmpty)
                ContentHorizontalList(
                  title: _localizations!.tvSeries,
                  contents: contentState.tvSeries,
                  onContentTap: _onContentTap,
                )
              else if (_selectedTabIndex == 1 && contentState.movies.isNotEmpty)
                ContentHorizontalList(
                  title: _localizations!.popularMovies,
                  contents: contentState.movies,
                  onContentTap: _onContentTap,
                )
              else if (contentState.contents.isNotEmpty)
                ContentHorizontalList(
                  title: _localizations!.trendingNow,
                  contents: _getTrendingContents(contentState.contents),
                  onContentTap: _onContentTap,
                ),

              const SizedBox(height: 24),

              // Featured Content
              if (contentState.featuredContents.isNotEmpty)
                ContentHorizontalList(
                  title: _localizations!.featuredContent,
                  contents: contentState.featuredContents,
                  onContentTap: _onContentTap,
                ),

              const SizedBox(height: 24),

              // New Releases
              if (contentState.contents.isNotEmpty)
                ContentHorizontalList(
                  title: _localizations!.newReleases,
                  contents: _getNewReleases(contentState.contents),
                  onContentTap: _onContentTap,
                ),

              const SizedBox(height: 100), // Space for floating bottom nav
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildTabButton(_localizations!.series, 0),
          const SizedBox(width: 12),
          _buildTabButton(_localizations!.movies, 1),
          const SizedBox(width: 12),
          _buildTabButton(_localizations!.categories, 2),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.netflixWhite
              : AppColors.netflixDarkGray.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.netflixWhite
                : AppColors.netflixGray,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppColors.netflixBlack
                    : AppColors.netflixWhite,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (index == 2) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                color: isSelected
                    ? AppColors.netflixBlack
                    : AppColors.netflixWhite,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(Content featuredContent) {
    final screenHeight = MediaQuery.of(context).size.height;
    final heroHeight = screenHeight * 0.5;

    return GestureDetector(
      onTap: () => _onContentTap(featuredContent),
      child: Stack(
        children: [
          // Background Image
          Container(
            height: heroHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.netflixBlack.withValues(alpha: 0.7),
                  AppColors.netflixBlack,
                ],
              ),
            ),
            child: featuredContent.posterUrl != null &&
                    featuredContent.posterUrl!.isNotEmpty
                ? Image.network(
                    featuredContent.posterUrl!,
                    width: double.infinity,
                    height: heroHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildHeroPlaceholder(heroHeight);
                    },
                  )
                : _buildHeroPlaceholder(heroHeight),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.netflixBlack.withValues(alpha: 0.3),
                    AppColors.netflixBlack,
                  ],
                ),
              ),
            ),
          ),

          // Content Info
          Positioned(
            left: ResponsiveHelper.getResponsiveHorizontalPadding(context),
            right: ResponsiveHelper.getResponsiveHorizontalPadding(context),
            bottom: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  featuredContent.title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.netflixWhite,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Description
                if (featuredContent.description != null)
                  Text(
                    featuredContent.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.netflixWhite.withValues(alpha: 0.9),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 16),
                // Action Buttons
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _onContentTap(featuredContent),
                      icon: const Icon(Icons.play_arrow),
                      label: Text(_localizations!.play),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.netflixWhite,
                        foregroundColor: AppColors.netflixBlack,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Add to my list
                      },
                      icon: const Icon(Icons.add),
                      label: Text(_localizations!.myList),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.netflixWhite,
                        side: const BorderSide(color: AppColors.netflixWhite),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
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
    );
  }

  Widget _buildHeroPlaceholder(double height) {
    return Container(
      height: height,
      width: double.infinity,
      color: AppColors.netflixDarkGray,
      child: Center(
        child: Icon(
          Icons.movie,
          color: AppColors.netflixLightGray,
          size: 80,
        ),
      ),
    );
  }

  Widget _buildFloatingBottomNavigationBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.netflixDarkGray.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.netflixGray.withValues(alpha: 0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth / 3;
              return Stack(
                children: [
                  // Sliding Indicator
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    left: _currentIndex * itemWidth,
                    top: 0,
                    bottom: 0,
                    width: itemWidth,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.netflixRed.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.netflixRed.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  // Navigation Items
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: _buildNavItem(
                          icon: Icons.home,
                          label: _localizations!.home,
                          index: 0,
                        ),
                      ),
                      Expanded(
                        child: _buildNavItem(
                          icon: Icons.local_fire_department,
                          label: _localizations!.newAndPopular,
                          index: 1,
                        ),
                      ),
                      Expanded(
                        child: _buildNavItem(
                          icon: Icons.account_circle,
                          label: _localizations!.myNetflix,
                          index: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        if (_currentIndex != index) {
          setState(() {
            _currentIndex = index;
          });
          // TODO: Navigate to different pages with animation
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: Icon(
                icon,
                key: ValueKey('$icon-$isSelected'),
                color: isSelected
                    ? AppColors.netflixRed
                    : AppColors.netflixWhite.withValues(alpha: 0.8),
                size: 22,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOutCubic,
              style: TextStyle(
                fontSize: 9,
                color: isSelected
                    ? AppColors.netflixRed
                    : AppColors.netflixWhite.withValues(alpha: 0.7),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Content> _getTrendingContents(List<Content> contents) {
    // Sort by view count (trending = most viewed)
    final sorted = List<Content>.from(contents);
    sorted.sort((a, b) => (b.viewCount ?? 0).compareTo(a.viewCount ?? 0));
    return sorted.take(10).toList();
  }

  List<Content> _getNewReleases(List<Content> contents) {
    // Sort by creation date (newest first)
    final sorted = List<Content>.from(contents);
    sorted.sort((a, b) {
      final aDate = a.createdAt;
      final bDate = b.createdAt;
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return bDate.compareTo(aDate);
    });
    return sorted.take(10).toList();
  }

  List<Content> _getContinueWatchingContents(List<Content> contents) {
    // Return contents that have been viewed (viewCount > 0)
    final viewed = contents.where((c) => (c.viewCount ?? 0) > 0).toList();
    if (viewed.isEmpty) {
      // If no viewed content, return trending
      return _getTrendingContents(contents).take(5).toList();
    }
    // Sort by viewCount descending
    viewed.sort((a, b) => (b.viewCount ?? 0).compareTo(a.viewCount ?? 0));
    return viewed.take(5).toList();
  }

  void _onContentTap(Content content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContentDetailPage(content: content),
      ),
    );
  }
}

