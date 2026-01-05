import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/quote.dart';

class QuotesRepository {
  static const String _boxName = 'quotes';

  // Initialize quotes box and add default quotes if empty
  static Future<void> initializeQuotes() async {
    final box = await Hive.openBox<Quote>(_boxName);

    // Add default quotes if box is empty
    if (box.isEmpty) {
      final defaultQuotes = _getDefaultQuotes();
      for (var quote in defaultQuotes) {
        await box.add(quote);
      }
    }
  }

  // Get list of default motivational quotes
  static List<Quote> _getDefaultQuotes() {
    return [
      Quote(
        id: const Uuid().v4(),
        text: "The only way to do great work is to love what you do.",
        author: "Steve Jobs",
        createdAt: DateTime.now(),
      ),
      Quote(
        id: const Uuid().v4(),
        text: "Don't watch the clock; do what it does. Keep going.",
        author: "Sam Levenson",
        createdAt: DateTime.now(),
      ),
      Quote(
        id: const Uuid().v4(),
        text:
            "Success is not final, failure is not fatal: it is the courage to continue that counts.",
        author: "Winston Churchill",
        createdAt: DateTime.now(),
      ),
      Quote(
        id: const Uuid().v4(),
        text: "Believe you can and you're halfway there.",
        author: "Theodore Roosevelt",
        createdAt: DateTime.now(),
      ),
      Quote(
        id: const Uuid().v4(),
        text: "Every accomplishment starts with the decision to try.",
        author: "John F. Kennedy",
        createdAt: DateTime.now(),
      ),
    ];
  }

  // Get all quotes
  static Future<List<Quote>> getAllQuotes() async {
    final box = Hive.box<Quote>(_boxName);
    return box.values.toList();
  }

  // Get a random quote
  static Future<Quote?> getRandomQuote() async {
    final quotes = await getAllQuotes();
    if (quotes.isEmpty) return null;
    quotes.shuffle();
    return quotes.first;
  }

  // Add a new quote
  static Future<void> addQuote(String text, String author) async {
    final box = Hive.box<Quote>(_boxName);
    final quote = Quote(
      id: const Uuid().v4(),
      text: text,
      author: author,
      createdAt: DateTime.now(),
    );
    await box.add(quote);
  }

  // Delete a quote by index
  static Future<void> deleteQuote(int index) async {
    final box = Hive.box<Quote>(_boxName);
    await box.deleteAt(index);
  }

  // Clear all quotes
  static Future<void> clearAllQuotes() async {
    final box = Hive.box<Quote>(_boxName);
    await box.clear();
  }
}
