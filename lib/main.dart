import 'package:flutter/material.dart';
import 'package:menatal_health_journal/pages/all_entry_page.dart';
import 'package:menatal_health_journal/pages/home_page.dart';

import 'package:menatal_health_journal/pages/login_screen.dart';
import 'package:menatal_health_journal/pages/mood_analysis.dart';
import 'package:menatal_health_journal/providers/auth_provider.dart';
import 'package:menatal_health_journal/providers/journal_provider.dart';
import 'package:menatal_health_journal/providers/quote_provider.dart';
import 'package:menatal_health_journal/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: "https://fogiwkyfdlnghdfsijlx.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZvZ2l3a3lmZGxuZ2hkZnNpamx4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk1NDE1NzgsImV4cCI6MjA1NTExNzU3OH0.-i8ptGmcqi4omtmwbD3WMmKxWAJdm29-ESrJ66FPuCg",
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => QuoteProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => JournalProvider())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? initialScreen;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  void _checkAuthState() {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      setState(() {
        initialScreen = const HomePage(); // Redirect to home
      });
    } else {
      setState(() {
        initialScreen = LoginScreen(); // Stay on login
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: initialScreen ??
          const Scaffold(
              body: Center(
                  child:
                      CircularProgressIndicator())), // Show loader while checking auth
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        '/login': (context) => LoginScreen(),
        '/allPage': (context) => const JournalEntriesScreen(),
        '/mood_analysis': (context) => MoodAnalysisPage(),
      },
    );
  }
}
