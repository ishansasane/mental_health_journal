import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:menatal_health_journal/providers/journal_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class SentimentHeatmap extends StatefulWidget {
  const SentimentHeatmap({super.key});

  @override
  State<SentimentHeatmap> createState() => _SentimentHeatmapState();
}

class _SentimentHeatmapState extends State<SentimentHeatmap> {
  DateTime? accountCreationDate;

  @override
  void initState() {
    super.initState();
    _fetchUserCreationDate();
    Provider.of<JournalProvider>(context, listen: false).fetchJournalEntries();
  }

  void _fetchUserCreationDate() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null && user.createdAt.isNotEmpty) {
      setState(() {
        accountCreationDate = DateTime.parse(user.createdAt);
      });
    }
  }

  // Show an Awesome Snackbar
  void showSentimentSnackBar(
      BuildContext context, DateTime date, double sentimentScore) {
    ContentType contentType;

    if (sentimentScore < 0) {
      contentType = ContentType.failure; // Negative sentiment (Red)
    } else if (sentimentScore == 0) {
      contentType = ContentType.warning; // Neutral sentiment (Yellow)
    } else {
      contentType = ContentType.success; // Positive sentiment (Green)
    }

    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Sentiment Analysis',
        message:
            "Date: ${date.toLocal().toString().split(' ')[0]}, Score: $sentimentScore",
        contentType: contentType,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final journalProvider = Provider.of<JournalProvider>(context);
    final journalEntries = journalProvider.journalEntries;

    // Convert journal data into heatmap format
    final Map<DateTime, int> heatmapData = {};

    for (var entry in journalEntries) {
      DateTime date = DateTime(
          entry.createdAt.year, entry.createdAt.month, entry.createdAt.day);
      double sentimentScore = entry.sentimentScore ?? 0.0;

      // Normalize sentiment scores to be non-negative
      int normalizedScore = (sentimentScore + 5).clamp(0, 10).toInt();

      heatmapData.update(date, (value) => value + normalizedScore,
          ifAbsent: () => normalizedScore);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: HeatMap(
                  colorMode: ColorMode.opacity,
                  defaultColor: Colors.grey[300]!, // Light grey for no data
                  textColor: Colors.black, // Ensure text remains readable
                  startDate: accountCreationDate ??
                      DateTime.now().subtract(const Duration(days: 30)),
                  endDate: DateTime.now().add(const Duration(days: 7)),
                  datasets: heatmapData,
                  onClick: (date) {
                    double sentimentScore = (heatmapData[date] ?? 0).toDouble();
                    showSentimentSnackBar(context, date, sentimentScore);
                  },
                  colorsets: {
                    1: Theme.of(context).brightness == Brightness.dark
                        ? Colors.red // Dark mode → Green
                        : Theme.of(context)
                            .colorScheme
                            .primary, // Light mode → Primary theme co
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
