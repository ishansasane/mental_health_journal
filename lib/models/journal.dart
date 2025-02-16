class Journal {
  int? id;
  String uuid;
  DateTime createdAt;
  String? journalNote;
  double? sentimentScore;

  // Constructor
  Journal({
    this.id,
    required this.uuid,
    DateTime? createdAt,
    this.journalNote,
    this.sentimentScore,
  }) : createdAt = createdAt ?? DateTime.now();

  // From JSON
  factory Journal.fromJson(Map<String, dynamic> json) {
    return Journal(
      id: json['id'] as int?,
      uuid: json['user'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      journalNote: json['journal_note'] as String?,
      sentimentScore:
          (json['sentiment_score'] as num?)?.toDouble(), // Convert to double
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'user': uuid,
      'journal_note': journalNote,
      'sentiment_score': sentimentScore,
    };
  }
}
