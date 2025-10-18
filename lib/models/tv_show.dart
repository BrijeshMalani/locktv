import 'movie.dart';

class TVShow {
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String firstAirDate;
  final double voteAverage;
  final int voteCount;
  final List<int> genreIds;
  final String originalLanguage;
  final String originalName;
  final List<String> originCountry;
  final double popularity;
  final String? mediaType;

  TVShow({
    required this.id,
    required this.name,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIds,
    required this.originalLanguage,
    required this.originalName,
    required this.originCountry,
    required this.popularity,
    this.mediaType,
  });

  factory TVShow.fromJson(Map<String, dynamic> json) {
    return TVShow(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      firstAirDate: json['first_air_date'] ?? '',
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      originalLanguage: json['original_language'] ?? '',
      originalName: json['original_name'] ?? '',
      originCountry: List<String>.from(json['origin_country'] ?? []),
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      mediaType: json['media_type'],
    );
  }

  String get posterUrl => posterPath != null
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : 'https://via.placeholder.com/500x750?text=No+Image';

  String get backdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/w1280$backdropPath'
      : 'https://via.placeholder.com/1280x720?text=No+Image';

  String get year =>
      firstAirDate.isNotEmpty ? firstAirDate.split('-')[0] : 'N/A';
}

class TVShowDetails extends TVShow {
  final List<CreatedBy> createdBy;
  final List<int> episodeRunTime;
  final String? homepage;
  final bool inProduction;
  final List<String> languages;
  final String lastAirDate;
  final LastEpisodeToAir? lastEpisodeToAir;
  final String? nextEpisodeToAir;
  final List<Network> networks;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<ProductionCompany> productionCompanies;
  final List<ProductionCountry> productionCountries;
  final List<Season> seasons;
  final List<SpokenLanguage> spokenLanguages;
  final String status;
  final String tagline;
  final String type;
  final List<Video> videos;
  final List<Image> images;
  final List<Cast> cast;
  final List<Crew> crew;
  final List<TVShow> similar;
  final List<TVShow> recommendations;
  final List<Review> reviews;
  final WatchProviders? watchProviders;

  TVShowDetails({
    required super.id,
    required super.name,
    required super.overview,
    super.posterPath,
    super.backdropPath,
    required super.firstAirDate,
    required super.voteAverage,
    required super.voteCount,
    required super.genreIds,
    required super.originalLanguage,
    required super.originalName,
    required super.originCountry,
    required super.popularity,
    super.mediaType,
    required this.createdBy,
    required this.episodeRunTime,
    this.homepage,
    required this.inProduction,
    required this.languages,
    required this.lastAirDate,
    this.lastEpisodeToAir,
    this.nextEpisodeToAir,
    required this.networks,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.productionCompanies,
    required this.productionCountries,
    required this.seasons,
    required this.spokenLanguages,
    required this.status,
    required this.tagline,
    required this.type,
    required this.videos,
    required this.images,
    required this.cast,
    required this.crew,
    required this.similar,
    required this.recommendations,
    required this.reviews,
    this.watchProviders,
  });

  factory TVShowDetails.fromJson(Map<String, dynamic> json) {
    return TVShowDetails(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      firstAirDate: json['first_air_date'] ?? '',
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      originalLanguage: json['original_language'] ?? '',
      originalName: json['original_name'] ?? '',
      originCountry: List<String>.from(json['origin_country'] ?? []),
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      mediaType: json['media_type'],
      createdBy: (json['created_by'] ?? [])
          .map<CreatedBy>((cb) => CreatedBy.fromJson(cb))
          .toList(),
      episodeRunTime: List<int>.from(json['episode_run_time'] ?? []),
      homepage: json['homepage'],
      inProduction: json['in_production'] ?? false,
      languages: List<String>.from(json['languages'] ?? []),
      lastAirDate: json['last_air_date'] ?? '',
      lastEpisodeToAir: json['last_episode_to_air'] != null
          ? LastEpisodeToAir.fromJson(json['last_episode_to_air'])
          : null,
      nextEpisodeToAir: json['next_episode_to_air'],
      networks: (json['networks'] ?? [])
          .map<Network>((n) => Network.fromJson(n))
          .toList(),
      numberOfEpisodes: json['number_of_episodes'] ?? 0,
      numberOfSeasons: json['number_of_seasons'] ?? 0,
      productionCompanies: (json['production_companies'] ?? [])
          .map<ProductionCompany>((pc) => ProductionCompany.fromJson(pc))
          .toList(),
      productionCountries: (json['production_countries'] ?? [])
          .map<ProductionCountry>((pc) => ProductionCountry.fromJson(pc))
          .toList(),
      seasons: (json['seasons'] ?? [])
          .map<Season>((s) => Season.fromJson(s))
          .toList(),
      spokenLanguages: (json['spoken_languages'] ?? [])
          .map<SpokenLanguage>((sl) => SpokenLanguage.fromJson(sl))
          .toList(),
      status: json['status'] ?? '',
      tagline: json['tagline'] ?? '',
      type: json['type'] ?? '',
      videos: (json['videos']?['results'] ?? [])
          .map<Video>((v) => Video.fromJson(v))
          .toList(),
      images: (json['images']?['backdrops'] ?? [])
          .map<Image>((i) => Image.fromJson(i))
          .toList(),
      cast: (json['credits']?['cast'] ?? [])
          .map<Cast>((c) => Cast.fromJson(c))
          .toList(),
      crew: (json['credits']?['crew'] ?? [])
          .map<Crew>((c) => Crew.fromJson(c))
          .toList(),
      similar: (json['similar']?['results'] ?? [])
          .map<TVShow>((t) => TVShow.fromJson(t))
          .toList(),
      recommendations: (json['recommendations']?['results'] ?? [])
          .map<TVShow>((t) => TVShow.fromJson(t))
          .toList(),
      reviews: (json['reviews']?['results'] ?? [])
          .map<Review>((r) => Review.fromJson(r))
          .toList(),
      watchProviders: json['watch/providers']?['results'] != null
          ? WatchProviders.fromJson(json['watch/providers']['results'])
          : null,
    );
  }
}

class CreatedBy {
  final int id;
  final String creditId;
  final String name;
  final int gender;
  final String? profilePath;

  CreatedBy({
    required this.id,
    required this.creditId,
    required this.name,
    required this.gender,
    this.profilePath,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['id'] ?? 0,
      creditId: json['credit_id'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? 0,
      profilePath: json['profile_path'],
    );
  }

  String get profileUrl => profilePath != null
      ? 'https://image.tmdb.org/t/p/w500$profilePath'
      : 'https://via.placeholder.com/500x750?text=No+Image';
}

class LastEpisodeToAir {
  final int id;
  final String name;
  final String overview;
  final double voteAverage;
  final int voteCount;
  final String airDate;
  final int episodeNumber;
  final String episodeType;
  final String productionCode;
  final int? runtime;
  final int seasonNumber;
  final int showId;
  final String? stillPath;

  LastEpisodeToAir({
    required this.id,
    required this.name,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.airDate,
    required this.episodeNumber,
    required this.episodeType,
    required this.productionCode,
    this.runtime,
    required this.seasonNumber,
    required this.showId,
    this.stillPath,
  });

  factory LastEpisodeToAir.fromJson(Map<String, dynamic> json) {
    return LastEpisodeToAir(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      overview: json['overview'] ?? '',
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      airDate: json['air_date'] ?? '',
      episodeNumber: json['episode_number'] ?? 0,
      episodeType: json['episode_type'] ?? '',
      productionCode: json['production_code'] ?? '',
      runtime: json['runtime'],
      seasonNumber: json['season_number'] ?? 0,
      showId: json['show_id'] ?? 0,
      stillPath: json['still_path'],
    );
  }

  String get stillUrl => stillPath != null
      ? 'https://image.tmdb.org/t/p/w500$stillPath'
      : 'https://via.placeholder.com/500x281?text=No+Image';
}

class Network {
  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  Network({
    required this.id,
    this.logoPath,
    required this.name,
    required this.originCountry,
  });

  factory Network.fromJson(Map<String, dynamic> json) {
    return Network(
      id: json['id'] ?? 0,
      logoPath: json['logo_path'],
      name: json['name'] ?? '',
      originCountry: json['origin_country'] ?? '',
    );
  }

  String get logoUrl => logoPath != null
      ? 'https://image.tmdb.org/t/p/w500$logoPath'
      : 'https://via.placeholder.com/500x500?text=No+Image';
}

class Season {
  final String airDate;
  final int episodeCount;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;
  final double voteAverage;

  Season({
    required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    this.posterPath,
    required this.seasonNumber,
    required this.voteAverage,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      airDate: json['air_date'] ?? '',
      episodeCount: json['episode_count'] ?? 0,
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      seasonNumber: json['season_number'] ?? 0,
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
    );
  }

  String get posterUrl => posterPath != null
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : 'https://via.placeholder.com/500x750?text=No+Image';
}

class Episode {
  final int id;
  final String name;
  final String overview;
  final double voteAverage;
  final int voteCount;
  final String airDate;
  final int episodeNumber;
  final String episodeType;
  final String productionCode;
  final int? runtime;
  final int seasonNumber;
  final int showId;
  final String? stillPath;

  Episode({
    required this.id,
    required this.name,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.airDate,
    required this.episodeNumber,
    required this.episodeType,
    required this.productionCode,
    this.runtime,
    required this.seasonNumber,
    required this.showId,
    this.stillPath,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      overview: json['overview'] ?? '',
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      airDate: json['air_date'] ?? '',
      episodeNumber: json['episode_number'] ?? 0,
      episodeType: json['episode_type'] ?? '',
      productionCode: json['production_code'] ?? '',
      runtime: json['runtime'],
      seasonNumber: json['season_number'] ?? 0,
      showId: json['show_id'] ?? 0,
      stillPath: json['still_path'],
    );
  }

  String get stillUrl => stillPath != null
      ? 'https://image.tmdb.org/t/p/w500$stillPath'
      : 'https://via.placeholder.com/500x281?text=No+Image';
}
