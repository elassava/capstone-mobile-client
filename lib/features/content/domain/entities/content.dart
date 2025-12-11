class Content {
  final String id;
  final String title;
  final String? description;
  final String contentType; // MOVIE, TV_SERIES
  final int? releaseYear;
  final int? durationMinutes;
  final String? videoFilePath;
  final String? posterUrl;
  final String? thumbnailUrl;
  final String? trailerUrl;
  final double? rating;
  final String? ageRating;
  final String? language;
  final String status; // DRAFT, PUBLISHED, COMING_SOON, ARCHIVED
  final bool? isFeatured;
  final int? viewCount;
  final int? totalSeasons;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String>? genres;
  final List<Map<String, dynamic>>? castCrew;
  final List<Map<String, dynamic>>? seasons;

  const Content({
    required this.id,
    required this.title,
    this.description,
    required this.contentType,
    this.releaseYear,
    this.durationMinutes,
    this.videoFilePath,
    this.posterUrl,
    this.thumbnailUrl,
    this.trailerUrl,
    this.rating,
    this.ageRating,
    this.language,
    required this.status,
    this.isFeatured,
    this.viewCount,
    this.totalSeasons,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.genres,
    this.castCrew,
    this.seasons,
  });

  bool get isMovie => contentType == 'MOVIE';
  bool get isTvSeries => contentType == 'TV_SERIES';
  bool get isPublished => status == 'PUBLISHED';
}



