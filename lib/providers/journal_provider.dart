import 'package:flutter/material.dart';
import 'package:menatal_health_journal/models/journal.dart';
import 'package:menatal_health_journal/services/journal_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JournalProvider with ChangeNotifier {
  final JournalService _journalService = JournalService();
  List<Journal> _journalEntries = [];

  List<Journal> get journalEntries => _journalEntries;

  // Fetch all journal entries
  Future<void> fetchJournalEntries() async {
    try {
      _journalEntries = await _journalService.fetchJournalEntries();
      notifyListeners();
    } catch (e) {
      print("Error fetching entries: $e");
      rethrow;
    }
  }

  Future<void> clearEntries() async {
    try {
      await Supabase.instance.client
          .from('journal_entries')
          .delete()
          .neq('id', 0);
      _journalEntries.clear();
      notifyListeners();
    } catch (error) {
      debugPrint("Error clearing journal entries: $error");
    }
  }

  // Insert a new journal entry
  Future<void> insertJournalEntry(String journalNote) async {
    try {
      await _journalService.insertJournalEntry(journalNote);
      await fetchJournalEntries(); // Refresh the list after insertion
    } catch (e) {
      print("Error inserting entry: $e");
      rethrow;
    }
  }

  // Delete a journal entry
  Future<void> deleteJournalEntry(int id) async {
    try {
      await _journalService.deleteJournalEntry(id);
      await fetchJournalEntries(); // Refresh the list after deletion
    } catch (e) {
      print("Error deleting entry: $e");
      rethrow;
    }
  }
}
