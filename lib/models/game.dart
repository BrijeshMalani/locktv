class Game {
  final String code;
  final String url;
  final String name;
  final String description;
  final bool isPortrait;
  final GameAssets assets;
  final List<String> categories;
  final List<String> tags;
  final int width;
  final int height;
  final String colorMuted;
  final String colorVibrant;
  final bool privateAllowed;
  final double rating;
  final int numberOfRatings;
  final int gamePlays;
  final bool hasIntegratedAds;

  Game({
    required this.code,
    required this.url,
    required this.name,
    required this.description,
    required this.isPortrait,
    required this.assets,
    required this.categories,
    required this.tags,
    required this.width,
    required this.height,
    required this.colorMuted,
    required this.colorVibrant,
    required this.privateAllowed,
    required this.rating,
    required this.numberOfRatings,
    required this.gamePlays,
    required this.hasIntegratedAds,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      code: json['code'] ?? '',
      url: json['url'] ?? '',
      name: json['name']?['en'] ?? '',
      description: json['description']?['en'] ?? '',
      isPortrait: json['isPortrait'] ?? false,
      assets: GameAssets.fromJson(json['assets'] ?? {}),
      categories: (json['categories']?['en'] ?? [])
          .map<String>((cat) => cat.toString())
          .toList(),
      tags: (json['tags']?['en'] ?? [])
          .map<String>((tag) => tag.toString())
          .toList(),
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      colorMuted: json['colorMuted'] ?? '#000000',
      colorVibrant: json['colorVibrant'] ?? '#000000',
      privateAllowed: json['privateAllowed'] ?? false,
      rating: (json['rating'] ?? 0.0).toDouble(),
      numberOfRatings: json['numberOfRatings'] ?? 0,
      gamePlays: json['gamePlays'] ?? 0,
      hasIntegratedAds: json['hasIntegratedAds'] ?? false,
    );
  }
}

class GameAssets {
  final String cover;
  final String thumb;
  final String square;
  final List<String> screens;

  GameAssets({
    required this.cover,
    required this.thumb,
    required this.square,
    required this.screens,
  });

  factory GameAssets.fromJson(Map<String, dynamic> json) {
    return GameAssets(
      cover: json['cover'] ?? '',
      thumb: json['thumb'] ?? '',
      square: json['square'] ?? '',
      screens: (json['screens'] ?? [])
          .map<String>((screen) => screen.toString())
          .toList(),
    );
  }
}
