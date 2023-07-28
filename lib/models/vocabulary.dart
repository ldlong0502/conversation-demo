class Vocabulary {
  final String id;
  final String order2;
  final String word;
  final String furigana;
  final String vi;

  Vocabulary({
    required this.id,
    required this.order2,
    required this.word,
    required this.furigana,
    required this.vi,
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      id: json['id'] ?? '',
      order2: json['order2'] ?? '',
      word: json['word'] ?? '',
      furigana: json['furigana'] ?? '',
      vi: json['vi'] ?? '',
    );
  }
}
