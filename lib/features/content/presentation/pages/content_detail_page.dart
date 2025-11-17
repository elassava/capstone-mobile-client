import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/content.dart';

class ContentDetailPage extends StatelessWidget {
  final Content content;

  const ContentDetailPage({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
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
                            // TODO: Play video
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
}



