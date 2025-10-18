class Account {
  final String id;
  final String name;
  final String username;
  final String? avatarPath;
  final String? avatarHash;

  Account({
    required this.id,
    required this.name,
    required this.username,
    this.avatarPath,
    this.avatarHash,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      avatarPath: json['avatar']?['tmdb']?['avatar_path'],
      avatarHash: json['avatar']?['tmdb']?['avatar_path']?.split('/').last,
    );
  }

  String get avatarUrl => avatarPath != null
      ? 'https://image.tmdb.org/t/p/w500$avatarPath'
      : 'https://via.placeholder.com/500x500?text=No+Avatar';
}

class AccountStates {
  final bool favorite;
  final bool watchlist;
  final bool rated;
  final double? rating;

  AccountStates({
    required this.favorite,
    required this.watchlist,
    required this.rated,
    this.rating,
  });

  factory AccountStates.fromJson(Map<String, dynamic> json) {
    return AccountStates(
      favorite: json['favorite'] ?? false,
      watchlist: json['watchlist'] ?? false,
      rated: json['rated'] ?? false,
      rating: json['rated'] is Map ? json['rated']['value']?.toDouble() : null,
    );
  }
}

class ListItem {
  final int id;
  final String name;
  final String description;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final String? firstAirDate;
  final double voteAverage;
  final int voteCount;
  final String? mediaType;
  final bool adult;
  final String originalLanguage;
  final String? originalTitle;
  final String? originalName;
  final List<int>? genreIds;
  final double popularity;
  final bool? video;

  ListItem({
    required this.id,
    required this.name,
    required this.description,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
    this.mediaType,
    required this.adult,
    required this.originalLanguage,
    this.originalTitle,
    this.originalName,
    this.genreIds,
    required this.popularity,
    this.video,
  });

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['title'] ?? '',
      description: json['description'] ?? json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'],
      firstAirDate: json['first_air_date'],
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      mediaType: json['media_type'],
      adult: json['adult'] ?? false,
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'],
      originalName: json['original_name'],
      genreIds: json['genre_ids'] != null
          ? List<int>.from(json['genre_ids'])
          : null,
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      video: json['video'],
    );
  }

  String get posterUrl => posterPath != null
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : 'https://via.placeholder.com/500x750?text=No+Image';

  String get backdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/w1280$backdropPath'
      : 'https://via.placeholder.com/1280x720?text=No+Image';

  String get year {
    if (releaseDate != null && releaseDate!.isNotEmpty) {
      return releaseDate!.split('-')[0];
    } else if (firstAirDate != null && firstAirDate!.isNotEmpty) {
      return firstAirDate!.split('-')[0];
    }
    return 'N/A';
  }
}

class CustomList {
  final int id;
  final String name;
  final String description;
  final String? posterPath;
  final String? backdropPath;
  final int itemCount;
  final String language;
  final String? iso31661;
  final String? iso6391;
  final String createdBy;
  final String createdAt;
  final String updatedAt;
  final List<ListItem> items;

  CustomList({
    required this.id,
    required this.name,
    required this.description,
    this.posterPath,
    this.backdropPath,
    required this.itemCount,
    required this.language,
    this.iso31661,
    this.iso6391,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory CustomList.fromJson(Map<String, dynamic> json) {
    return CustomList(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      itemCount: json['item_count'] ?? 0,
      language: json['language'] ?? '',
      iso31661: json['iso_3166_1'],
      iso6391: json['iso_639_1'],
      createdBy: json['created_by'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      items: (json['items'] ?? [])
          .map<ListItem>((item) => ListItem.fromJson(item))
          .toList(),
    );
  }

  String get posterUrl => posterPath != null
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : 'https://via.placeholder.com/500x750?text=No+Image';

  String get backdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/w1280$backdropPath'
      : 'https://via.placeholder.com/1280x720?text=No+Image';
}

class RatedItem extends ListItem {
  final double rating;

  RatedItem({
    required super.id,
    required super.name,
    required super.description,
    super.posterPath,
    super.backdropPath,
    super.releaseDate,
    super.firstAirDate,
    required super.voteAverage,
    required super.voteCount,
    super.mediaType,
    required super.adult,
    required super.originalLanguage,
    super.originalTitle,
    super.originalName,
    super.genreIds,
    required super.popularity,
    super.video,
    required this.rating,
  });

  factory RatedItem.fromJson(Map<String, dynamic> json) {
    return RatedItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['title'] ?? '',
      description: json['description'] ?? json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'],
      firstAirDate: json['first_air_date'],
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      mediaType: json['media_type'],
      adult: json['adult'] ?? false,
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'],
      originalName: json['original_name'],
      genreIds: json['genre_ids'] != null
          ? List<int>.from(json['genre_ids'])
          : null,
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      video: json['video'],
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }
}
