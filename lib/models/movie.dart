class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String releaseDate;
  final double voteAverage;
  final int voteCount;
  final bool adult;
  final String originalLanguage;
  final String originalTitle;
  final List<int> genreIds;
  final double popularity;
  final bool video;
  final String? mediaType;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.adult,
    required this.originalLanguage,
    required this.originalTitle,
    required this.genreIds,
    required this.popularity,
    required this.video,
    this.mediaType,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'] ?? '',
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      adult: json['adult'] ?? false,
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      video: json['video'] ?? false,
      mediaType: json['media_type'],
    );
  }

  String get posterUrl => posterPath != null
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : 'https://via.placeholder.com/500x750?text=No+Image';

  String get backdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/w1280$backdropPath'
      : 'https://via.placeholder.com/1280x720?text=No+Image';

  String get year => releaseDate.isNotEmpty ? releaseDate.split('-')[0] : 'N/A';
}

class MovieDetails extends Movie {
  final int budget;
  final List<Genre> genres;
  final String? homepage;
  final String imdbId;
  final List<ProductionCompany> productionCompanies;
  final List<ProductionCountry> productionCountries;
  final int revenue;
  final int runtime;
  final List<SpokenLanguage> spokenLanguages;
  final String status;
  final String tagline;
  final List<Video> videos;
  final List<Image> images;
  final List<Cast> cast;
  final List<Crew> crew;
  final List<Movie> similar;
  final List<Movie> recommendations;
  final List<Review> reviews;
  final WatchProviders? watchProviders;

  MovieDetails({
    required super.id,
    required super.title,
    required super.overview,
    super.posterPath,
    super.backdropPath,
    required super.releaseDate,
    required super.voteAverage,
    required super.voteCount,
    required super.adult,
    required super.originalLanguage,
    required super.originalTitle,
    required super.genreIds,
    required super.popularity,
    required super.video,
    super.mediaType,
    required this.budget,
    required this.genres,
    this.homepage,
    required this.imdbId,
    required this.productionCompanies,
    required this.productionCountries,
    required this.revenue,
    required this.runtime,
    required this.spokenLanguages,
    required this.status,
    required this.tagline,
    required this.videos,
    required this.images,
    required this.cast,
    required this.crew,
    required this.similar,
    required this.recommendations,
    required this.reviews,
    this.watchProviders,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'] ?? '',
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      adult: json['adult'] ?? false,
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      video: json['video'] ?? false,
      mediaType: json['media_type'],
      budget: json['budget'] ?? 0,
      genres: (json['genres'] ?? [])
          .map<Genre>((g) => Genre.fromJson(g))
          .toList(),
      homepage: json['homepage'],
      imdbId: json['imdb_id'] ?? '',
      productionCompanies: (json['production_companies'] ?? [])
          .map<ProductionCompany>((pc) => ProductionCompany.fromJson(pc))
          .toList(),
      productionCountries: (json['production_countries'] ?? [])
          .map<ProductionCountry>((pc) => ProductionCountry.fromJson(pc))
          .toList(),
      revenue: json['revenue'] ?? 0,
      runtime: json['runtime'] ?? 0,
      spokenLanguages: (json['spoken_languages'] ?? [])
          .map<SpokenLanguage>((sl) => SpokenLanguage.fromJson(sl))
          .toList(),
      status: json['status'] ?? '',
      tagline: json['tagline'] ?? '',
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
          .map<Movie>((m) => Movie.fromJson(m))
          .toList(),
      recommendations: (json['recommendations']?['results'] ?? [])
          .map<Movie>((m) => Movie.fromJson(m))
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

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class ProductionCompany {
  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  ProductionCompany({
    required this.id,
    this.logoPath,
    required this.name,
    required this.originCountry,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) {
    return ProductionCompany(
      id: json['id'] ?? 0,
      logoPath: json['logo_path'],
      name: json['name'] ?? '',
      originCountry: json['origin_country'] ?? '',
    );
  }
}

class ProductionCountry {
  final String iso31661;
  final String name;

  ProductionCountry({required this.iso31661, required this.name});

  factory ProductionCountry.fromJson(Map<String, dynamic> json) {
    return ProductionCountry(
      iso31661: json['iso_3166_1'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class SpokenLanguage {
  final String englishName;
  final String iso6391;
  final String name;

  SpokenLanguage({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) {
    return SpokenLanguage(
      englishName: json['english_name'] ?? '',
      iso6391: json['iso_639_1'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Video {
  final String id;
  final String iso6391;
  final String iso31661;
  final String key;
  final String name;
  final String site;
  final int size;
  final String type;

  Video({
    required this.id,
    required this.iso6391,
    required this.iso31661,
    required this.key,
    required this.name,
    required this.site,
    required this.size,
    required this.type,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] ?? '',
      iso6391: json['iso_639_1'] ?? '',
      iso31661: json['iso_3166_1'] ?? '',
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      site: json['site'] ?? '',
      size: json['size'] ?? 0,
      type: json['type'] ?? '',
    );
  }

  String get youtubeUrl =>
      site == 'YouTube' ? 'https://www.youtube.com/watch?v=$key' : '';
}

class Image {
  final double aspectRatio;
  final int height;
  final String? iso6391;
  final String filePath;
  final double voteAverage;
  final int voteCount;
  final int width;

  Image({
    required this.aspectRatio,
    required this.height,
    this.iso6391,
    required this.filePath,
    required this.voteAverage,
    required this.voteCount,
    required this.width,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      aspectRatio: (json['aspect_ratio'] ?? 0.0).toDouble(),
      height: json['height'] ?? 0,
      iso6391: json['iso_639_1'],
      filePath: json['file_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      width: json['width'] ?? 0,
    );
  }

  String get imageUrl => 'https://image.tmdb.org/t/p/w1280$filePath';
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
    );
  }

  String get profileUrl => profilePath != null
      ? 'https://image.tmdb.org/t/p/w500$profilePath'
      : 'https://via.placeholder.com/500x750?text=No+Image';
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
    );
  }

  String get profileUrl => profilePath != null
      ? 'https://image.tmdb.org/t/p/w500$profilePath'
      : 'https://via.placeholder.com/500x750?text=No+Image';
}

class Review {
  final String author;
  final AuthorDetails authorDetails;
  final String content;
  final String createdAt;
  final String id;
  final String updatedAt;
  final String url;

  Review({
    required this.author,
    required this.authorDetails,
    required this.content,
    required this.createdAt,
    required this.id,
    required this.updatedAt,
    required this.url,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      author: json['author'] ?? '',
      authorDetails: AuthorDetails.fromJson(json['author_details'] ?? {}),
      content: json['content'] ?? '',
      createdAt: json['created_at'] ?? '',
      id: json['id'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class AuthorDetails {
  final String name;
  final String username;
  final String? avatarPath;
  final double? rating;

  AuthorDetails({
    required this.name,
    required this.username,
    this.avatarPath,
    this.rating,
  });

  factory AuthorDetails.fromJson(Map<String, dynamic> json) {
    return AuthorDetails(
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      avatarPath: json['avatar_path'],
      rating: json['rating']?.toDouble(),
    );
  }

  String get avatarUrl => avatarPath != null
      ? 'https://image.tmdb.org/t/p/w500$avatarPath'
      : 'https://via.placeholder.com/500x500?text=No+Image';
}

class WatchProviders {
  final Map<String, ProviderCountry> results;

  WatchProviders({required this.results});

  factory WatchProviders.fromJson(Map<String, dynamic> json) {
    Map<String, ProviderCountry> providers = {};
    json.forEach((key, value) {
      providers[key] = ProviderCountry.fromJson(value);
    });
    return WatchProviders(results: providers);
  }
}

class ProviderCountry {
  final String link;
  final List<Provider> flatrate;
  final List<Provider> rent;
  final List<Provider> buy;

  ProviderCountry({
    required this.link,
    required this.flatrate,
    required this.rent,
    required this.buy,
  });

  factory ProviderCountry.fromJson(Map<String, dynamic> json) {
    return ProviderCountry(
      link: json['link'] ?? '',
      flatrate: (json['flatrate'] ?? [])
          .map<Provider>((p) => Provider.fromJson(p))
          .toList(),
      rent: (json['rent'] ?? [])
          .map<Provider>((p) => Provider.fromJson(p))
          .toList(),
      buy: (json['buy'] ?? [])
          .map<Provider>((p) => Provider.fromJson(p))
          .toList(),
    );
  }
}

class Provider {
  final int displayPriority;
  final String? logoPath;
  final int providerId;
  final String providerName;

  Provider({
    required this.displayPriority,
    this.logoPath,
    required this.providerId,
    required this.providerName,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      displayPriority: json['display_priority'] ?? 0,
      logoPath: json['logo_path'],
      providerId: json['provider_id'] ?? 0,
      providerName: json['provider_name'] ?? '',
    );
  }

  String get logoUrl => logoPath != null
      ? 'https://image.tmdb.org/t/p/w500$logoPath'
      : 'https://via.placeholder.com/500x500?text=No+Image';
}
