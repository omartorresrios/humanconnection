class Source {
  String text;

  Source({required this.text});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}
