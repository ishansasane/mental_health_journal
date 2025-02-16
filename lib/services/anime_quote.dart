import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:menatal_health_journal/models/quotes.dart';

class QuoteService {
  static const String _apiUrl = "http://api.quotable.io/random";

  Future<Quote> fetchQuote() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      print("API Response: ${response.body}"); // Debug: Print the API response

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Quote.fromJson(data);
      } else {
        throw Exception('Failed to load quote: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching quote: $e"); // Debug: Print any errors
      throw Exception('Failed to load quote: $e');
    }
  }
}
