import 'package:flutter/material.dart';
import 'package:menatal_health_journal/providers/journal_provider.dart';
import 'package:provider/provider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class AddSentimentScreen extends StatelessWidget {
  const AddSentimentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    final journalProvider =
        Provider.of<JournalProvider>(context, listen: false);

    // Function to show an Awesome Snackbar
    void showAwesomeSnackBar(
        BuildContext context, String title, String message, ContentType type) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: type,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

    return Scaffold(
      appBar: AppBar(title: Text("Add Sentiment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Write your thoughts:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter your journal entry...",
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final journalNote = _controller.text.trim();
                  if (journalNote.isNotEmpty) {
                    try {
                      // Insert the journal entry
                      await journalProvider.insertJournalEntry(journalNote);

                      // Show success snackbar
                      showAwesomeSnackBar(
                        context,
                        "Success!",
                        "Journal entry saved successfully!",
                        ContentType.success,
                      );

                      // Clear the text field
                      _controller.clear();

                      // Navigate back after a short delay
                      Future.delayed(Duration(seconds: 1), () {
                        Navigator.pop(context);
                      });
                    } catch (e) {
                      // Show error snackbar if something goes wrong
                      showAwesomeSnackBar(
                        context,
                        "Error!",
                        "Failed to save journal entry: $e",
                        ContentType.failure,
                      );
                    }
                  } else {
                    // Show warning snackbar if text field is empty
                    showAwesomeSnackBar(
                      context,
                      "Warning!",
                      "Please enter a journal entry.",
                      ContentType.warning,
                    );
                  }
                },
                child: Text("Save Entry"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
