class Word {
  final String phonetic;
  final String hiragana;
  final String mean;
  final String example_mean;
  final int id;
  final String type;
  final int lesson_id;
  final String word;
  final String example;

  Word({
    required this.phonetic,
    required this.hiragana,
    required this.mean,
    required this.example_mean,
    required this.id,
    required this.type,
    required this.lesson_id,
    required this.word,
    required this.example,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      phonetic: json['phonetic'] ?? '',
      hiragana: json['hiragana'] ?? '',
      mean: json['mean'] ?? '',
      example_mean: json['example_mean'] ?? '',
      id: json['id'] ?? -1,
      type: json['type'] ?? '',
      lesson_id: json['lesson_id'] ?? -1,
      word: json['word'] ?? '',
      example: json['example'] ?? '',
    );
  }
}
