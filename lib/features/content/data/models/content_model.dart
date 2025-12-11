import 'package:mobile/features/content/domain/entities/content.dart';

class ContentModel extends Content {
  const ContentModel({
    required super.id,
    required super.title,
    super.description,
    required super.contentType,
    super.releaseYear,
    super.durationMinutes,
    super.videoFilePath,
    super.posterUrl,
    super.thumbnailUrl,
    super.trailerUrl,
    super.rating,
    super.ageRating,
    super.language,
    required super.status,
    super.isFeatured,
    super.viewCount,
    super.totalSeasons,
    required super.isActive,
    super.createdAt,
    super.updatedAt,
    super.genres,
    super.castCrew,
    super.seasons,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    // Handle date parsing
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          return null;
        }
      }
      return null;
    }

    // Handle genres list - backend returns List<GenreResponse>
    List<String>? parseGenres(dynamic value) {
      if (value == null) return null;
      if (value is List) {
        return value.map((e) {
          if (e is Map && e['name'] != null) {
            return e['name'].toString();
          }
          return e.toString();
        }).toList();
      }
      return null;
    }

    // Safe integer parsing (handles Long from backend)
    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is num) return value.toInt();
      return null;
    }

    // Safe string parsing (handles enum strings from backend)
    String? parseString(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      return value.toString();
    }

    // Safe UUID/ID string parsing (handles UUID from backend)
    String parseId(dynamic value) {
      if (value == null) return '';
      return value.toString();
    }

    // Safe boolean parsing
    bool? parseBool(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      return null;
    }

    return ContentModel(
      id: parseId(json['id']),
      title: parseString(json['title']) ?? '',
      description: parseString(json['description']),
      contentType: parseString(json['contentType']) ?? 'MOVIE',
      releaseYear: parseInt(json['releaseYear']),
      durationMinutes: parseInt(json['durationMinutes']),
      videoFilePath: parseString(json['videoFilePath']),
      posterUrl: parseString(json['posterUrl']),
      thumbnailUrl: parseString(json['thumbnailUrl']),
      trailerUrl: parseString(json['trailerUrl']),
      rating: (json['rating'] as num?)?.toDouble(),
      ageRating: parseString(json['ageRating']),
      language: parseString(json['language']),
      status: parseString(json['status']) ?? 'DRAFT',
      isFeatured: parseBool(json['isFeatured']),
      viewCount: parseInt(json['viewCount']),
      totalSeasons: parseInt(json['totalSeasons']),
      isActive: parseBool(json['isActive']) ?? true,
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      genres: parseGenres(json['genres']),
      castCrew: _parseListOfMaps(json['castCrew']),
      seasons: _parseListOfMaps(json['seasons']),
    );
  }

  // Safe list of maps parsing helper
  static List<Map<String, dynamic>>? _parseListOfMaps(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      try {
        return value
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'contentType': contentType,
      'releaseYear': releaseYear,
      'durationMinutes': durationMinutes,
      'videoFilePath': videoFilePath,
      'posterUrl': posterUrl,
      'thumbnailUrl': thumbnailUrl,
      'trailerUrl': trailerUrl,
      'rating': rating,
      'ageRating': ageRating,
      'language': language,
      'status': status,
      'isFeatured': isFeatured,
      'viewCount': viewCount,
      'totalSeasons': totalSeasons,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'genres': genres,
      'castCrew': castCrew,
      'seasons': seasons,
    };
  }

  factory ContentModel.fromEntity(Content content) {
    return ContentModel(
      id: content.id,
      title: content.title,
      description: content.description,
      contentType: content.contentType,
      releaseYear: content.releaseYear,
      durationMinutes: content.durationMinutes,
      videoFilePath: content.videoFilePath,
      posterUrl: content.posterUrl,
      thumbnailUrl: content.thumbnailUrl,
      trailerUrl: content.trailerUrl,
      rating: content.rating,
      ageRating: content.ageRating,
      language: content.language,
      status: content.status,
      isFeatured: content.isFeatured,
      viewCount: content.viewCount,
      totalSeasons: content.totalSeasons,
      isActive: content.isActive,
      createdAt: content.createdAt,
      updatedAt: content.updatedAt,
      genres: content.genres,
      castCrew: content.castCrew,
      seasons: content.seasons,
    );
  }
}

