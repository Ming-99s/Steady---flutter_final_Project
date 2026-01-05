import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quote.dart';

class QuotesRepository {
  static const String _jsonPath = 'assets/data/quotes.json';
  static List<Quote>? _cachedQuotes;

  // Load quotes from JSON file
  static Future<List<Quote>> getAllQuotes() async {
    if (_cachedQuotes != null) {
      return _cachedQuotes!;
    }

    try {
      final jsonString = await rootBundle.loadString(_jsonPath);
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _cachedQuotes = jsonList
          .map((json) => Quote.fromJson(json as Map<String, dynamic>))
          .toList();
      return _cachedQuotes!;
    } catch (e) {
      print('Error loading quotes: $e');
      return [];
    }
  }

  // Get a random quote
  static Future<Quote?> getRandomQuote() async {
    final quotes = await getAllQuotes();
    if (quotes.isEmpty) return null;
    quotes.shuffle();
    return quotes.first;
  }

  // Get quote by mood title
  static Future<Quote?> getQuoteByMood(String moodTitle) async {
    final quotes = await getAllQuotes();
    // Return quote based on index mapping to mood
    final moodIndex = _getMoodIndex(moodTitle);
    if (moodIndex >= 0 && moodIndex < quotes.length) {
      return quotes[moodIndex];
    }
    return null;
  }

  // Helper method to map mood titles to quote indices
  static int _getMoodIndex(String moodTitle) {
    const moodMap = {
      'Motivate': 0,
      'Tired': 1,
      'Normal': 2,
      'Stressed': 3,
    };
    return moodMap[moodTitle] ?? -1;
  }
}
