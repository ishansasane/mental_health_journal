import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:menatal_health_journal/providers/journal_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MoodAnalysisPage extends StatefulWidget {
  const MoodAnalysisPage({super.key});

  @override
  State<MoodAnalysisPage> createState() => _MoodAnalysisPageState();
}

class _MoodAnalysisPageState extends State<MoodAnalysisPage> {
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

  // Get mood data from journal entries
  Map<DateTime, int> _getHeatmapData(List journalEntries) {
    final Map<DateTime, int> heatmapData = {};
    for (var entry in journalEntries) {
      DateTime date = DateTime(
          entry.createdAt.year, entry.createdAt.month, entry.createdAt.day);
      double sentimentScore = entry.sentimentScore ?? 0.0;

      int normalizedScore = (sentimentScore + 5).clamp(0, 10).toInt();
      heatmapData.update(date, (value) => value + normalizedScore,
          ifAbsent: () => normalizedScore);
    }
    return heatmapData;
  }

  // Get mood trend data
  List<FlSpot> _getMoodTrendData(List journalEntries) {
    List<FlSpot> spots = [];
    for (var i = 0; i < journalEntries.length; i++) {
      double score = (journalEntries[i].sentimentScore ?? 0.0).toDouble();
      spots.add(FlSpot(i.toDouble(), score));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final journalProvider = Provider.of<JournalProvider>(context);
    final journalEntries = journalProvider.journalEntries;

    final heatmapData = _getHeatmapData(journalEntries);
    final moodTrendData = _getMoodTrendData(journalEntries);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood Analysis"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 HEATMAP CARD
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: HeatMap(
                  colorMode: ColorMode.opacity,
                  defaultColor: Colors.grey[300]!,
                  textColor: Colors.black,
                  startDate: accountCreationDate ??
                      DateTime.now().subtract(const Duration(days: 30)),
                  endDate: DateTime.now().add(const Duration(days: 7)),
                  datasets: heatmapData,
                  colorsets: {
                    1: Theme.of(context).brightness == Brightness.dark
                        ? Colors.green
                        : Theme.of(context).colorScheme.primary,
                  },
                  onClick: (date) {
                    double sentimentScore = (heatmapData[date] ?? 0).toDouble();
                    _showSentimentSnackBar(context, date, sentimentScore);
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 SUMMARY STATISTICS
            _buildSummaryStatistics(journalEntries),

            const SizedBox(height: 16),

            // 🔹 MOOD TREND CHART
            _buildMoodTrendChart(moodTrendData),
          ],
        ),
      ),
    );
  }

  // Summary Statistics
  Widget _buildSummaryStatistics(List journalEntries) {
    double avgSentiment = journalEntries.isNotEmpty
        ? journalEntries
                .map((e) => e.sentimentScore ?? 0.0)
                .reduce((a, b) => a + b) /
            journalEntries.length
        : 0.0;

    double bestSentiment = journalEntries.isNotEmpty
        ? journalEntries
            .map((e) => e.sentimentScore ?? 0.0)
            .reduce((a, b) => a > b ? a : b)
        : 0.0;

    double worstSentiment = journalEntries.isNotEmpty
        ? journalEntries
            .map((e) => e.sentimentScore ?? 0.0)
            .reduce((a, b) => a < b ? a : b)
        : 0.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statCard("Sentiment", avgSentiment.toStringAsFixed(1)),
        _statCard("Best Mood", bestSentiment.toStringAsFixed(1)),
        _statCard("Worst Mood", worstSentiment.toStringAsFixed(1)),
      ],
    );
  }

  // Mood Trend Chart
  Widget _buildMoodTrendChart(List<FlSpot> moodTrendData) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: moodTrendData,
                  isCurved: true,
                  color: Theme.of(context).colorScheme.primary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(
                      show: true,
                      color: Theme.of(context).primaryColor.withOpacity(0.3)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Snackbar for Sentiment Analysis
  void _showSentimentSnackBar(
      BuildContext context, DateTime date, double sentimentScore) {
    final snackBar = SnackBar(
      content: Text(
          "Date: ${date.toLocal().toString().split(' ')[0]}, Score: $sentimentScore"),
      backgroundColor: sentimentScore >= 0 ? Colors.green : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Small Stat Cards
  Widget _statCard(String title, String value) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
