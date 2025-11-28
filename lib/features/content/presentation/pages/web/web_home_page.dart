import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/extensions/snackbar_extension.dart';
import 'package:mobile/core/localization/app_localizations.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/netflix_logo.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/content/domain/entities/content.dart';
import 'package:mobile/features/content/presentation/providers/content_notifier.dart';
import 'package:mobile/features/content/presentation/providers/content_providers.dart';
import 'package:mobile/features/profile/presentation/providers/profile_providers.dart';

class WebHomePage extends ConsumerStatefulWidget {
  const WebHomePage({super.key});

  @override
  ConsumerState<WebHomePage> createState() => _WebHomePageState();
}

class _WebHomePageState extends ConsumerState<WebHomePage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

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
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
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
      appBar: _buildWebAppBar(localizations),
      body: contentState.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.netflixRed),
            )
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // Hero Section
                  if (contentState.featuredContents.isNotEmpty)
                    _buildHeroSection(
                      contentState.featuredContents.first,
                      localizations,
                    ),

                  // Content Rows
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (contentState.contents.isNotEmpty)
                          _buildContentRow(
                            localizations.trendingNow,
                            _getTrendingContents(contentState.contents),
                          ),
                        if (contentState.tvSeries.isNotEmpty)
                          _buildContentRow(
                            localizations.tvSeries,
                            contentState.tvSeries,
                          ),
                        if (contentState.movies.isNotEmpty)
                          _buildContentRow(
                            localizations.popularMovies,
                            contentState.movies,
                          ),
                        if (contentState.contents.isNotEmpty)
                          _buildContentRow(
                            localizations.newReleases,
                            _getNewReleases(contentState.contents),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  PreferredSizeWidget _buildWebAppBar(AppLocalizations localizations) {
    // Calculate opacity based on scroll offset
    // 0 to 1 opacity between 0 and 100 scroll offset
    final double opacity = (_scrollOffset / 100).clamp(0.0, 1.0);

    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        color: Colors.black.withValues(
          alpha: opacity,
        ), // Use withValues as per guidelines
        padding: const EdgeInsets.symmetric(
          horizontal: 60.0,
        ), // Netflix web padding
        child: SafeArea(
          child: Row(
            children: [
              // Logo
              const SizedBox(height: 35, child: NetflixLogo()),
              const SizedBox(width: 40),

              // Navigation Links
              _buildNavLink(localizations.home, true),
              _buildNavLink(localizations.tvSeries, false),
              _buildNavLink(localizations.movies, false),
              _buildNavLink(localizations.newAndPopular, false),
              _buildNavLink(localizations.myList, false),

              const Spacer(),

              // Right Side Icons
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
              // Profile Dropdown (Simplified for now)
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.blue, // Placeholder color
                ),
                child: const Icon(Icons.person, size: 20, color: Colors.white),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavLink(String title, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextButton(
        onPressed: () {},
        child: Text(
          title,
          style: TextStyle(
            color: isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.7),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(Content content, AppLocalizations localizations) {
    // Hero section takes 85% of viewport height
    final height = MediaQuery.of(context).size.height * 0.85;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          if (content.posterUrl != null)
            Image.network(
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
            left: 60,
            bottom: 150,
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title (using text for now, ideally logo image)
                Text(
                  content.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 20),

                // Description
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

                // Buttons
                Row(
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
                    const SizedBox(width: 15),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.info_outline,
                        size: 28,
                        color: Colors.white,
                      ),
                      label: Text(
                        localizations
                            .moreInfo, // Assuming this exists or using 'Daha Fazla Bilgi'
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0x666D6D6E,
                        ), // Semi-transparent gray
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
    );
  }

  Widget _buildContentRow(String title, List<Content> contents) {
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
            height: 160, // Height for web cards
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              scrollDirection: Axis.horizontal,
              itemCount: contents.length,
              itemBuilder: (context, index) {
                final content = contents[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        image: DecorationImage(
                          image: NetworkImage(content.posterUrl ?? ''),
                          fit: BoxFit.cover,
                        ),
                      ),
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

  List<Content> _getTrendingContents(List<Content> contents) {
    final sorted = List<Content>.from(contents);
    sorted.sort((a, b) => (b.viewCount ?? 0).compareTo(a.viewCount ?? 0));
    return sorted.take(10).toList();
  }

  List<Content> _getNewReleases(List<Content> contents) {
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
}
