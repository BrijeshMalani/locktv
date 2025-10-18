class Person {
  final int id;
  final String name;
  final String? profilePath;
  final bool adult;
  final double popularity;
  final String knownForDepartment;
  final String originalName;
  final int gender;
  final String? mediaType;

  Person({
    required this.id,
    required this.name,
    this.profilePath,
    required this.adult,
    required this.popularity,
    required this.knownForDepartment,
    required this.originalName,
    required this.gender,
    this.mediaType,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      profilePath: json['profile_path'],
      adult: json['adult'] ?? false,
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      knownForDepartment: json['known_for_department'] ?? '',
      originalName: json['original_name'] ?? '',
      gender: json['gender'] ?? 0,
      mediaType: json['media_type'],
    );
  }

  String get profileUrl => profilePath != null
      ? 'https://image.tmdb.org/t/p/w500$profilePath'
      : 'https://via.placeholder.com/500x750?text=No+Image';
}

class PersonDetails extends Person {
  final String? alsoKnownAs;
  final String? biography;
  final String? birthday;
  final String? deathday;
  final String? homepage;
  final String imdbId;
  final String placeOfBirth;

  PersonDetails({
    required super.id,
    required super.name,
    super.profilePath,
    required super.adult,
    required super.popularity,
    required super.knownForDepartment,
    required super.originalName,
    required super.gender,
    super.mediaType,
    this.alsoKnownAs,
    this.biography,
    this.birthday,
    this.deathday,
    this.homepage,
    required this.imdbId,
    required this.placeOfBirth,
  });

  factory PersonDetails.fromJson(Map<String, dynamic> json) {
    return PersonDetails(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      profilePath: json['profile_path'],
      adult: json['adult'] ?? false,
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      knownForDepartment: json['known_for_department'] ?? '',
      originalName: json['original_name'] ?? '',
      gender: json['gender'] ?? 0,
      mediaType: json['media_type'],
      alsoKnownAs: json['also_known_as']?.join(', '),
      biography: json['biography'],
      birthday: json['birthday'],
      deathday: json['deathday'],
      homepage: json['homepage'],
      imdbId: json['imdb_id'] ?? '',
      placeOfBirth: json['place_of_birth'] ?? '',
    );
  }

  int get age {
    if (birthday == null) return 0;
    final birth = DateTime.tryParse(birthday!);
    if (birth == null) return 0;

    final now = DateTime.now();
    int age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }
}

class PersonCredits {
  final List<Cast> cast;
  final List<Crew> crew;

  PersonCredits({required this.cast, required this.crew});

  factory PersonCredits.fromJson(Map<String, dynamic> json) {
    return PersonCredits(
      cast: (json['cast'] ?? []).map<Cast>((c) => Cast.fromJson(c)).toList(),
      crew: (json['crew'] ?? []).map<Crew>((c) => Crew.fromJson(c)).toList(),
    );
  }
}

class Cast {
  final bool adult;
  final int gender;
  final int id;
  final String knownForDepartment;
  final String name;
  final String originalName;
  final double popularity;
  final String? profilePath;
  final int castId;
  final String character;
  final String creditId;
  final int order;
  final String? mediaType;
  final String? title;
  final String? originalTitle;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final String? firstAirDate;
  final double? voteAverage;
  final int? voteCount;
  final List<int>? genreIds;
  final String? originalLanguage;
  final List<String>? originCountry;

  Cast({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    this.profilePath,
    required this.castId,
    required this.character,
    required this.creditId,
    required this.order,
    this.mediaType,
    this.title,
    this.originalTitle,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.firstAirDate,
    this.voteAverage,
    this.voteCount,
    this.genreIds,
    this.originalLanguage,
    this.originCountry,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      adult: json['adult'] ?? false,
      gender: json['gender'] ?? 0,
      id: json['id'] ?? 0,
      knownForDepartment: json['known_for_department'] ?? '',
      name: json['name'] ?? '',
      originalName: json['original_name'] ?? '',
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      profilePath: json['profile_path'],
      castId: json['cast_id'] ?? 0,
      character: json['character'] ?? '',
      creditId: json['credit_id'] ?? '',
      order: json['order'] ?? 0,
      mediaType: json['media_type'],
      title: json['title'],
      originalTitle: json['original_title'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'],
      firstAirDate: json['first_air_date'],
      voteAverage: json['vote_average']?.toDouble(),
      voteCount: json['vote_count'],
      genreIds: json['genre_ids'] != null
          ? List<int>.from(json['genre_ids'])
          : null,
      originalLanguage: json['original_language'],
      originCountry: json['origin_country'] != null
          ? List<String>.from(json['origin_country'])
          : null,
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

  String get displayTitle => title ?? name ?? 'Unknown';
}

class Crew {
  final bool adult;
  final int gender;
  final int id;
  final String knownForDepartment;
  final String name;
  final String originalName;
  final double popularity;
  final String? profilePath;
  final String creditId;
  final String department;
  final String job;
  final String? mediaType;
  final String? title;
  final String? originalTitle;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final String? firstAirDate;
  final double? voteAverage;
  final int? voteCount;
  final List<int>? genreIds;
  final String? originalLanguage;
  final List<String>? originCountry;

  Crew({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    this.profilePath,
    required this.creditId,
    required this.department,
    required this.job,
    this.mediaType,
    this.title,
    this.originalTitle,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.firstAirDate,
    this.voteAverage,
    this.voteCount,
    this.genreIds,
    this.originalLanguage,
    this.originCountry,
  });

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      adult: json['adult'] ?? false,
      gender: json['gender'] ?? 0,
      id: json['id'] ?? 0,
      knownForDepartment: json['known_for_department'] ?? '',
      name: json['name'] ?? '',
      originalName: json['original_name'] ?? '',
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      profilePath: json['profile_path'],
      creditId: json['credit_id'] ?? '',
      department: json['department'] ?? '',
      job: json['job'] ?? '',
      mediaType: json['media_type'],
      title: json['title'],
      originalTitle: json['original_title'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'],
      firstAirDate: json['first_air_date'],
      voteAverage: json['vote_average']?.toDouble(),
      voteCount: json['vote_count'],
      genreIds: json['genre_ids'] != null
          ? List<int>.from(json['genre_ids'])
          : null,
      originalLanguage: json['original_language'],
      originCountry: json['origin_country'] != null
          ? List<String>.from(json['origin_country'])
          : null,
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

  String get displayTitle => title ?? name ?? 'Unknown';
}
