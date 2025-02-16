import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menatal_health_journal/components/quottecard.dart';
import 'package:menatal_health_journal/models/journal.dart';
import 'package:menatal_health_journal/pages/add_sentiment_screen.dart';
import 'package:menatal_health_journal/pages/sentiment_heatmap.dart';
import 'package:menatal_health_journal/providers/auth_provider.dart';
import 'package:menatal_health_journal/providers/journal_provider.dart';
import 'package:menatal_health_journal/providers/quote_provider.dart';
import 'package:menatal_health_journal/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuoteProvider>().fetchQuote();
      context.read<JournalProvider>().fetchJournalEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final quoteProvider = Provider.of<QuoteProvider>(context);
    final journalProvider = Provider.of<JournalProvider>(context);
    String greeting = _getGreetingMessage();

    return Scaffold(
      appBar: AppBar(title: const Text("Mental Health Journal")),
      drawer: _buildDrawer(context, quoteProvider),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (_) => AddSentimentScreen()));
      //   },
      //   child: const Icon(Icons.add),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Greeting
              Text(
                greeting,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your mental well-being matters. How are you feeling today?",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 16),

              // Daily Quote
              if (!quoteProvider.isLoading && quoteProvider.quote != null)
                QuoteCard(quote: quoteProvider.quote!),

              const SizedBox(height: 16),

              // Mood Heatmap
              const Text("Your Mood Trends",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              const SentimentHeatmap(),

              const SizedBox(height: 20),

              // Recent Journal Entries
              const Text("Recent Journal Entries",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),

              _buildJournalEntries(journalProvider),

              const SizedBox(height: 10),

              // Quick Access Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AddSentimentScreen()));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Entry"),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, "/mood_analysis");
                    },
                    icon: const Icon(Icons.bar_chart),
                    label: const Text("View Insights"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Generate Greeting Message Based on Time
  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning ☀️";
    } else if (hour < 18) {
      return "Good Afternoon 🌤️";
    } else {
      return "Good Evening 🌙";
    }
  }

  // Build Journal Entries List
  Widget _buildJournalEntries(JournalProvider journalProvider) {
    if (journalProvider.journalEntries.isEmpty) {
      return const Center(
          child: Text("No journal entries yet. Start writing today!"));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: journalProvider.journalEntries.length > 3
          ? 3
          : journalProvider.journalEntries.length,
      itemBuilder: (context, index) {
        final Journal entry = journalProvider.journalEntries[index];
        return Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Text(entry.journalNote ?? "No Content",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMd().format(entry.createdAt)),
                Text(
                    "Sentiment Score: ${entry.sentimentScore?.toStringAsFixed(2) ?? "N/A"}"),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await journalProvider.deleteJournalEntry(entry.id!);
              },
            ),
            onTap: () {
              Navigator.pushNamed(context, "/allPage");
            },
          ),
        );
      },
    );
  }

  // Drawer with Navigation and Theme Toggle
  Widget _buildDrawer(BuildContext context, QuoteProvider quoteProvider) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: quoteProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : quoteProvider.quote != null
                    ? QuoteCard(quote: quoteProvider.quote!)
                    : const Center(child: Text("No quote available")),
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text("Journal Entries"),
            onTap: () => Navigator.pushNamed(context, '/allPage'),
          ),
          ListTile(
            leading: const Icon(Icons.insights),
            title: const Text("Mood Analysis"),
            onTap: () => Navigator.pushNamed(context, "/mood_analysis"),
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text("Log Out"),
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wb_sunny,
                    color: Provider.of<ThemeProvider>(context).isDarkMode
                        ? Colors.grey
                        : Colors.orange),
                const SizedBox(width: 10),
                CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context).isDarkMode,
                  onChanged: (value) =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(),
                ),
                const SizedBox(width: 10),
                Icon(Icons.nightlight_round,
                    color: Provider.of<ThemeProvider>(context).isDarkMode
                        ? Colors.yellow
                        : Colors.grey),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text("Version 0.0.1", style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
