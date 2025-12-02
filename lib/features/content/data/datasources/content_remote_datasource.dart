// import 'package:mobile/core/di/service_locator.dart';
// import 'package:mobile/core/network/dio_client.dart';
import 'package:mobile/features/content/data/models/content_model.dart';

abstract class ContentRemoteDataSource {
  Future<List<ContentModel>> getAllContents();
  Future<ContentModel?> getContentById(int contentId);
  Future<List<ContentModel>> getContentsByType(String contentType);
  Future<List<ContentModel>> getFeaturedContents();
}

class ContentRemoteDataSourceImpl implements ContentRemoteDataSource {
  // final DioClient _dioClient = serviceLocator.get<DioClient>();

  @override
  Future<List<ContentModel>> getAllContents() async {
    // Force dummy data
    return _getDummyContents();
  }

  @override
  Future<ContentModel?> getContentById(int contentId) async {
    // Force dummy data
    return _getDummyContents().firstWhere(
      (c) => c.id == contentId,
      orElse: () => _getDummyContents().first,
    );
  }

  @override
  Future<List<ContentModel>> getContentsByType(String contentType) async {
    // Force dummy data
    return _getDummyContents()
        .where((c) => c.contentType == contentType)
        .toList();
  }

  @override
  Future<List<ContentModel>> getFeaturedContents() async {
    // Force dummy data
    return _getDummyContents().where((c) => c.isFeatured == true).toList();
  }

  List<ContentModel> _getDummyContents() {
    return [
      ContentModel(
        id: 1,
        title: 'Stranger Things',
        description:
            'When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces, and one strange little girl.',
        contentType: 'TV_SERIES',
        releaseYear: 2016,
        durationMinutes: 50,
        posterUrl: 'assets/images/web_background.jpeg',
        thumbnailUrl: 'assets/images/web_background.jpeg',
        videoFilePath:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        trailerUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        rating: 8.7,
        ageRating: '16+',
        language: 'English',
        status: 'PUBLISHED',
        isFeatured: true,
        viewCount: 1000000,
        totalSeasons: 4,
        isActive: true,
        createdAt: DateTime.now(),
        genres: ['Sci-Fi', 'Horror', 'Drama'],
      ),
      ContentModel(
        id: 2,
        title: 'Inception',
        description:
            'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.',
        contentType: 'MOVIE',
        releaseYear: 2010,
        durationMinutes: 148,
        posterUrl:
            'https://image.tmdb.org/t/p/original/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg',
        thumbnailUrl:
            'https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg',
        rating: 8.8,
        ageRating: '13+',
        language: 'English',
        status: 'PUBLISHED',
        isFeatured: true,
        viewCount: 2000000,
        totalSeasons: 0,
        isActive: true,
        createdAt: DateTime.now(),
        genres: ['Action', 'Sci-Fi', 'Thriller'],
      ),
      ContentModel(
        id: 5,
        title: 'Breaking Bad',
        description:
            'A high school chemistry teacher diagnosed with inoperable lung cancer turns to manufacturing and selling methamphetamine in order to secure his family\'s future.',
        contentType: 'TV_SERIES',
        releaseYear: 2008,
        durationMinutes: 49,
        posterUrl:
            'https://image.tmdb.org/t/p/original/ggFHVNu6YYI5L9pCfOacjizRGt.jpg',
        thumbnailUrl:
            'https://image.tmdb.org/t/p/w500/ggFHVNu6YYI5L9pCfOacjizRGt.jpg',
        rating: 9.5,
        ageRating: '18+',
        language: 'English',
        status: 'PUBLISHED',
        isFeatured: false,
        viewCount: 3000000,
        totalSeasons: 5,
        isActive: true,
        createdAt: DateTime.now(),
        genres: ['Crime', 'Drama', 'Thriller'],
      ),

      ContentModel(
        id: 3,
        title: 'Squid Game',
        description:
            'Hundreds of cash-strapped players accept a strange invitation to compete in children\'s games. Inside, a tempting prize awaits with deadly high stakes.',
        contentType: 'TV_SERIES',
        releaseYear: 2021,
        durationMinutes: 55,
        posterUrl:
            'https://image.tmdb.org/t/p/original/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg',
        thumbnailUrl:
            'https://image.tmdb.org/t/p/w500/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg',
        rating: 8.0,
        ageRating: '18+',
        language: 'Korean',
        status: 'PUBLISHED',
        isFeatured: true,
        viewCount: 2500000,
        totalSeasons: 1,
        isActive: true,
        createdAt: DateTime.now(),
        genres: ['Action', 'Drama', 'Mystery'],
      ),
      ContentModel(
        id: 4,
        title: 'The Dark Knight',
        description:
            'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
        contentType: 'MOVIE',
        releaseYear: 2008,
        durationMinutes: 152,
        posterUrl:
            'https://image.tmdb.org/t/p/original/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
        thumbnailUrl:
            'https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
        rating: 9.0,
        ageRating: '13+',
        language: 'English',
        status: 'PUBLISHED',
        isFeatured: false,
        viewCount: 2200000,
        totalSeasons: 0,
        isActive: true,
        createdAt: DateTime.now(),
        genres: ['Action', 'Crime', 'Drama'],
      ),
      ContentModel(
        id: 5,
        title: 'Avengers: Endgame',
        description:
            'After the devastating events of Infinity War, the universe is in ruins. With the help of remaining allies, the Avengers assemble once more in order to reverse Thanos\' actions and restore balance to the universe.',
        contentType: 'MOVIE',
        releaseYear: 2019,
        durationMinutes: 181,
        posterUrl:
            'https://image.tmdb.org/t/p/original/or06FN3Dka5tukK1e9sl16pB3iy.jpg',
        thumbnailUrl:
            'https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg',
        rating: 8.4,
        ageRating: '13+',
        language: 'English',
        status: 'PUBLISHED',
        isFeatured: false,
        viewCount: 3000000,
        totalSeasons: 0,
        isActive: true,
        createdAt: DateTime.now(),
        genres: ['Action', 'Sci-Fi', 'Adventure'],
      ),
      ContentModel(
        id: 6,
        title: 'Peaky Blinders',
        description:
            'A gangster family epic set in 1900s England, centering on a gang who sew razor blades in the peaks of their caps, and their fierce boss Tommy Shelby.',
        contentType: 'TV_SERIES',
        releaseYear: 2013,
        durationMinutes: 60,
        posterUrl:
            'https://image.tmdb.org/t/p/original/vUUqzWa2LnHIVqkaKVlVGkVcZIW.jpg',
        thumbnailUrl:
            'https://image.tmdb.org/t/p/w500/vUUqzWa2LnHIVqkaKVlVGkVcZIW.jpg',
        rating: 8.8,
        ageRating: '18+',
        language: 'English',
        status: 'PUBLISHED',
        isFeatured: false,
        viewCount: 1200000,
        totalSeasons: 6,
        isActive: true,
        createdAt: DateTime.now(),
        genres: ['Crime', 'Drama'],
      ),
      ContentModel(
        id: 7,
        title: 'Spider-Man: Into the Spider-Verse',
        description:
            'Teen Miles Morales becomes the Spider-Man of his universe, and must join with five spider-powered individuals from other dimensions to stop a threat for all realities.',
        contentType: 'MOVIE',
        releaseYear: 2018,
        durationMinutes: 117,
        posterUrl:
            'https://image.tmdb.org/t/p/original/xnopI5Xtky18MPhK40cZAGAOVeV.jpg',
        thumbnailUrl:
            'https://image.tmdb.org/t/p/w500/xnopI5Xtky18MPhK40cZAGAOVeV.jpg',
        rating: 8.4,
        ageRating: 'PG',
        language: 'English',
        status: 'PUBLISHED',
        isFeatured: false,
        viewCount: 1900000,
        totalSeasons: 0,
        isActive: true,
        createdAt: DateTime.now(),
        genres: ['Animation', 'Action', 'Adventure'],
      ),
      ContentModel(
        id: 8,
        title: 'Black Mirror',
        description:
            'An anthology series exploring a twisted, high-tech multiverse where humanity\'s greatest innovations and darkest instincts collide.',
        contentType: 'TV_SERIES',
        releaseYear: 2011,
        durationMinutes: 60,
        posterUrl:
            'https://image.tmdb.org/t/p/original/7dFZJ2ZJJdcmkp05B9NWlqTJ5tq.jpg', // Fixed URL
        thumbnailUrl:
            'https://image.tmdb.org/t/p/w500/7dFZJ2ZJJdcmkp05B9NWlqTJ5tq.jpg',
        rating: 8.8,
        ageRating: '18+',
        language: 'English',
        status: 'PUBLISHED',
        isFeatured: false,
        viewCount: 1600000,
        totalSeasons: 6,
        isActive: true,
        createdAt: DateTime.now(),
        genres: ['Sci-Fi', 'Drama', 'Thriller'],
      ),
    ];
  }
}
