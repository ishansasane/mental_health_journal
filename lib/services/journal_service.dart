import 'package:menatal_health_journal/models/journal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentiment_dart/sentiment_dart.dart';

class JournalService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> insertJournalEntry(String journalNote) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception("User not authenticated");
      }

      // Analyze sentiment
      var sentimentResult = Sentiment.analysis(journalNote);
      double sentimentScore =
          sentimentResult.score.toDouble(); // Ensure it's a double

      // Create a Journal object
      Journal journal = Journal(
        uuid: userId,
        journalNote: journalNote,
        sentimentScore: sentimentScore,
      );

      // Insert into Supabase
      await _supabase.from('Journal').insert(journal.toJson());
      print("Journal entry inserted successfully");
    } catch (e) {
      print("Error inserting journal entry: $e");
      rethrow;
    }
  }

  Future<List<Journal>> fetchJournalEntries() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception("User not authenticated");
      }

      // Fetch entries for the current user
      final response = await _supabase
          .from('Journal')
          .select()
          .eq('user', userId)
          .order('created_at', ascending: false);

      // Convert JSON to Journal objects
      List<Journal> entries =
          (response as List).map((json) => Journal.fromJson(json)).toList();

      return entries;
    } catch (e) {
      print("Error fetching journal entries: $e");
      rethrow;
    }
  }

  // Add a method to delete a journal entry
  Future<void> deleteJournalEntry(int id) async {
    try {
      await _supabase.from('Journal').delete().eq('id', id);
      print("Journal entry deleted successfully");
    } catch (e) {
      print("Error deleting journal entry: $e");
      rethrow;
    }
  }

  Future<Map<DateTime, double>> fetchAllSentimentData() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception("User not authenticated");
      }

      final response = await _supabase
          .from('Journal')
          .select('created_at, sentiment_score')
          .eq('user', userId) // Fetch all data for the user
          .order('created_at', ascending: true);

      final Map<DateTime, double> sentimentData = {};

      for (var entry in response) {
        DateTime date = DateTime.parse(entry['created_at']).toLocal();
        date = DateTime(
            date.year, date.month, date.day); // Normalize to remove time
        double sentimentScore =
            (entry['sentiment_score'] as num?)?.toDouble() ?? 0.0;

        sentimentData.update(date, (value) => value + sentimentScore,
            ifAbsent: () => sentimentScore);
      }

      return sentimentData;
    } catch (e) {
      print("Error fetching sentiment data: $e");
      return {};
    }
  }
}
