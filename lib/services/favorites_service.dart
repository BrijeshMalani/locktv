import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';
import '../models/tv_show.dart';

class FavoritesService {
  static const String _favoriteMoviesKey = 'favorite_movies';
  static const String _favoriteTVShowsKey = 'favorite_tv_shows';
  static const String _bookmarkedMoviesKey = 'bookmarked_movies';
  static const String _bookmarkedTVShowsKey = 'bookmarked_tv_shows';

  // Movies
  static Future<List<Movie>> getFavoriteMovies() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_favoriteMoviesKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Movie.fromJson(json)).toList();
  }

  static Future<void> addFavoriteMovie(Movie movie) async {
    final favorites = await getFavoriteMovies();
    if (!favorites.any((m) => m.id == movie.id)) {
      favorites.add(movie);
      await _saveFavoriteMovies(favorites);
    }
  }

  static Future<void> removeFavoriteMovie(int movieId) async {
    final favorites = await getFavoriteMovies();
    favorites.removeWhere((m) => m.id == movieId);
    await _saveFavoriteMovies(favorites);
  }

  static Future<bool> isFavoriteMovie(int movieId) async {
    final favorites = await getFavoriteMovies();
    return favorites.any((m) => m.id == movieId);
  }

  static Future<void> _saveFavoriteMovies(List<Movie> movies) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = movies.map((m) => m.toJson()).toList();
    await prefs.setString(_favoriteMoviesKey, json.encode(jsonList));
  }

  // TV Shows
  static Future<List<TVShow>> getFavoriteTVShows() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_favoriteTVShowsKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => TVShow.fromJson(json)).toList();
  }

  static Future<void> addFavoriteTVShow(TVShow tvShow) async {
    final favorites = await getFavoriteTVShows();
    if (!favorites.any((t) => t.id == tvShow.id)) {
      favorites.add(tvShow);
      await _saveFavoriteTVShows(favorites);
    }
  }

  static Future<void> removeFavoriteTVShow(int tvShowId) async {
    final favorites = await getFavoriteTVShows();
    favorites.removeWhere((t) => t.id == tvShowId);
    await _saveFavoriteTVShows(favorites);
  }

  static Future<bool> isFavoriteTVShow(int tvShowId) async {
    final favorites = await getFavoriteTVShows();
    return favorites.any((t) => t.id == tvShowId);
  }

  static Future<void> _saveFavoriteTVShows(List<TVShow> tvShows) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = tvShows.map((t) => t.toJson()).toList();
    await prefs.setString(_favoriteTVShowsKey, json.encode(jsonList));
  }

  // Bookmarked Movies
  static Future<List<Movie>> getBookmarkedMovies() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_bookmarkedMoviesKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Movie.fromJson(json)).toList();
  }

  static Future<void> addBookmarkedMovie(Movie movie) async {
    final bookmarks = await getBookmarkedMovies();
    if (!bookmarks.any((m) => m.id == movie.id)) {
      bookmarks.add(movie);
      await _saveBookmarkedMovies(bookmarks);
    }
  }

  static Future<void> removeBookmarkedMovie(int movieId) async {
    final bookmarks = await getBookmarkedMovies();
    bookmarks.removeWhere((m) => m.id == movieId);
    await _saveBookmarkedMovies(bookmarks);
  }

  static Future<bool> isBookmarkedMovie(int movieId) async {
    final bookmarks = await getBookmarkedMovies();
    return bookmarks.any((m) => m.id == movieId);
  }

  static Future<void> _saveBookmarkedMovies(List<Movie> movies) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = movies.map((m) => m.toJson()).toList();
    await prefs.setString(_bookmarkedMoviesKey, json.encode(jsonList));
  }

  // Bookmarked TV Shows
  static Future<List<TVShow>> getBookmarkedTVShows() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_bookmarkedTVShowsKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => TVShow.fromJson(json)).toList();
  }

  static Future<void> addBookmarkedTVShow(TVShow tvShow) async {
    final bookmarks = await getBookmarkedTVShows();
    if (!bookmarks.any((t) => t.id == tvShow.id)) {
      bookmarks.add(tvShow);
      await _saveBookmarkedTVShows(bookmarks);
    }
  }

  static Future<void> removeBookmarkedTVShow(int tvShowId) async {
    final bookmarks = await getBookmarkedTVShows();
    bookmarks.removeWhere((t) => t.id == tvShowId);
    await _saveBookmarkedTVShows(bookmarks);
  }

  static Future<bool> isBookmarkedTVShow(int tvShowId) async {
    final bookmarks = await getBookmarkedTVShows();
    return bookmarks.any((t) => t.id == tvShowId);
  }

  static Future<void> _saveBookmarkedTVShows(List<TVShow> tvShows) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = tvShows.map((t) => t.toJson()).toList();
    await prefs.setString(_bookmarkedTVShowsKey, json.encode(jsonList));
  }
}
