import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/game.dart';

class GameAPIService {
  static const String baseUrl = 'https://pub.gamezop.com/v3';
  static const String publisherId = '10787';

  static Map<String, String> get _headers => {'accept': 'application/json'};

  // Helper method for making HTTP requests with retry logic
  static Future<Map<String, dynamic>> _makeRequestWithRetry(
    Future<http.Response> Function() request, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempts = 0;
    Exception? lastException;

    while (attempts < maxRetries) {
      try {
        final response = await request();

        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else if (response.statusCode == 429) {
          // Rate limit - wait longer before retry
          await Future.delayed(Duration(seconds: 2 * (attempts + 1)));
          attempts++;
          continue;
        } else {
          throw HttpException('HTTP ${response.statusCode}: ${response.body}');
        }
      } on SocketException catch (e) {
        lastException = e;
        attempts++;
        if (attempts < maxRetries) {
          await Future.delayed(delay * attempts);
        }
      } on HttpException catch (e) {
        lastException = e;
        attempts++;
        if (attempts < maxRetries) {
          await Future.delayed(delay * attempts);
        }
      } catch (e) {
        throw Exception('Unexpected error: $e');
      }
    }

    throw lastException ?? Exception('Failed after $maxRetries attempts');
  }

  static Future<List<Game>> getGames() async {
    try {
      final response = await _makeRequestWithRetry(
        () => http.get(
          Uri.parse('$baseUrl/games?id=$publisherId'),
          headers: _headers,
        ),
      );

      if (response['games'] != null) {
        final gamesList = response['games'] as List;
        return gamesList.map((game) => Game.fromJson(game)).toList();
      }

      return [];
    } catch (e) {
      // Retry automatically
      await Future.delayed(const Duration(seconds: 2));
      return getGames();
    }
  }
}
