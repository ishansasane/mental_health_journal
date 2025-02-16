import 'package:flutter/material.dart';
import 'package:menatal_health_journal/pages/add_sentiment_screen.dart';
import 'package:provider/provider.dart';
import 'package:menatal_health_journal/providers/journal_provider.dart';

class JournalEntriesScreen extends StatelessWidget {
  const JournalEntriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final journalProvider = Provider.of<JournalProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Journal Entries"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              journalProvider.fetchJournalEntries();
            },
          ),
        ],
      ),
      body: journalProvider.journalEntries.isEmpty
          ? Center(
              child: Text(
                "No entries yet. Start journaling!",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: journalProvider.journalEntries.length,
              itemBuilder: (context, index) {
                final entry = journalProvider.journalEntries[index];
                return Dismissible(
                  key: Key(entry.id.toString()), // Unique key for each item
                  direction:
                      DismissDirection.endToStart, // Swipe from right to left
                  background: Container(
                    color: Colors.red, // Background color when swiping
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    // Delete the entry when swiped
                    journalProvider.deleteJournalEntry(entry.id!);

                    // Show a snackbar to confirm deletion
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Journal entry deleted"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        entry.journalNote ?? "No note",
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        "Date: ${entry.createdAt.toString()}",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          journalProvider.deleteJournalEntry(entry.id!);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddSentimentScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSentimentScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
