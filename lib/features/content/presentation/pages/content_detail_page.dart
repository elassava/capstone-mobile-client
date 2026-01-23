import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/content/domain/entities/content.dart';
import 'package:mobile/features/content/presentation/pages/web/web_video_player.dart';

class ContentDetailPage extends ConsumerWidget {
  final Content content;

  const ContentDetailPage({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get JWT token from auth state
    final authState = ref.watch(authNotifierProvider);
    final jwtToken = authState.authResponse?.token;

    return Scaffold(
      backgroundColor: AppColors.netflixBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.netflixWhite),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Image
            if (content.posterUrl != null && content.posterUrl!.isNotEmpty)
              Image.network(
                content.posterUrl!,
                width: double.infinity,
                height: 400,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 400,
                    color: AppColors.netflixDarkGray,
                    child: const Center(
                      child: Icon(
                        Icons.movie,
                        color: AppColors.netflixLightGray,
                        size: 80,
                      ),
                    ),
                  );
                },
              )
            else
              Container(
                height: 400,
                color: AppColors.netflixDarkGray,
                child: const Center(
                  child: Icon(
                    Icons.movie,
                    color: AppColors.netflixLightGray,
                    size: 80,
                  ),
                ),
              ),

            // Content Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    content.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.netflixWhite,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Meta Info
                  Row(
                    children: [
                      if (content.releaseYear != null)
                        Text(
                          '${content.releaseYear}',
                          style: const TextStyle(
                            color: AppColors.netflixLightGray,
                          ),
                        ),
                      if (content.durationMinutes != null) ...[
                        const Text(' • ', style: TextStyle(color: AppColors.netflixLightGray)),
                        Text(
                          '${content.durationMinutes} dk',
                          style: const TextStyle(
                            color: AppColors.netflixLightGray,
                          ),
                        ),
                      ],
                      if (content.rating != null) ...[
                        const Text(' • ', style: TextStyle(color: AppColors.netflixLightGray)),
                        Text(
                          '⭐ ${content.rating!.toStringAsFixed(1)}',
                          style: const TextStyle(
                            color: AppColors.netflixLightGray,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _playVideo(context, jwtToken);
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Oynat'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.netflixWhite,
                            foregroundColor: AppColors.netflixBlack,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Add to my list
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Listeme Ekle'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.netflixWhite,
                            side: const BorderSide(color: AppColors.netflixWhite),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Description
                  if (content.description != null)
                    Text(
                      content.description!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.netflixWhite,
                        height: 1.5,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Play video with JWT token authentication
  void _playVideo(BuildContext context, String? jwtToken) {
    if (content.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İçerik ID bulunamadı')),
      );
      return;
    }

    // Construct video URL (DASH manifest)
    // Format: http://baseUrl/api/stream/dash/{contentId}/manifest.mpd
    final videoUrl = '${ApiConstants.baseUrl}/api/stream/dash/${content.id}/bbb_30fps.mpd';

    if (kIsWeb) {
      // Web platformunda WebVideoPlayer kullan (JWT token ile)
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => WebVideoPlayer(
            videoUrl: videoUrl,
            jwtToken: jwtToken,
          ),
        ),
      );
    } else {
      // Mobil platformlar için native video player (gelecekte eklenecek)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mobil video player henüz eklenmedi. Web sürümünü kullanın.'),
        ),
      );
    }
  }
}
