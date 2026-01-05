import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../repository/quotes_repos.dart';

class QuoteWidget extends StatefulWidget {
  const QuoteWidget({super.key});

  @override
  State<QuoteWidget> createState() => _QuoteWidgetState();
}

class _QuoteWidgetState extends State<QuoteWidget> {
  Quote? _currentQuote;

  @override
  void initState() {
    super.initState();
    _loadRandomQuote();
  }

  Future<void> _loadRandomQuote() async {
    final quote = await QuotesRepository.getRandomQuote();
    setState(() {
      _currentQuote = quote;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _currentQuote == null
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        '"${_currentQuote!.text}"',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '— ${_currentQuote!.author}',
                        textAlign: TextAlign.right,
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _loadRandomQuote,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Get New Quote'),
                ),
              ],
            ),
          );
  }
}
