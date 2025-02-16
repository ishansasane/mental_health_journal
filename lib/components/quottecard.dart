import 'package:flutter/material.dart';
import 'package:menatal_health_journal/models/quotes.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;

  const QuoteCard({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quote Content
              Text(
                "\"${quote.content}\"",
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                maxLines: 5, // Limit number of lines for overflow
                overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
              ),
              SizedBox(height: 1),
              // Author Name
              Text(
                "- ${quote.author}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
