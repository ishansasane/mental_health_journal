import 'package:flutter/material.dart';
import 'package:menatal_health_journal/models/quotes.dart';
import 'package:menatal_health_journal/services/anime_quote.dart';

class QuoteProvider with ChangeNotifier {
  Quote? _quote;
  bool _isLoading = false;

  Quote? get quote => _quote;
  bool get isLoading => _isLoading;

  Future<void> fetchQuote() async {
    _isLoading = true;
    notifyListeners();

    try {
      _quote = await QuoteService().fetchQuote();
      print(
          "Quote fetched: ${_quote?.content}"); // Debug: Print the fetched quote
    } catch (e) {
      print('Error fetching quote: $e');
      _quote = null; // Ensure quote is null if there's an error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
