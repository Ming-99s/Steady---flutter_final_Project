class Quote {
  final String id;
  final String text;

  Quote({
    required this.id,
    required this.text,
  });

  // Factory constructor to create Quote from JSON
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] as String,
      text: json['text'] as String,
    );
  }

  // Convert Quote to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }
}
