class VocabularyKanji {
  final int id;
  final int order;
  final String word;
  final String furigana;
  final String mean;

  VocabularyKanji({
    required this.id,
    required this.order,
    required this.word,
    required this.furigana,
    required this.mean,
  });

  factory VocabularyKanji.fromJson(Map<String, dynamic> json) {
    return VocabularyKanji(
      id: json['id'] ?? 0,
      order: json['order'] ?? 0,
      word: json['word'] ?? '',
      furigana: json['furigana'] ?? '',
      mean: json['mean'] ?? '',
    );
  }
}
