import 'package:untitled/models/vocabulary_kanji.dart';

class Kanji {
  final List<VocabularyKanji> vocabularies;
  final String onyomi;
  final int lookAndLearnId;
  final String radical;
  final String kanji;
  final String lookAndLearn;
  final int lessonId;
  final String path;
  final String search;
  final String mean;
  final String parts;
  final int id;
  final String kunyomi;
  final int order;
  final int radicalId;
  bool isHighLight;

  Kanji({
    required this.vocabularies,
    required this.onyomi,
    required this.lookAndLearnId,
    required this.radical,
    required this.kanji,
    required this.lookAndLearn,
    required this.lessonId,
    required this.path,
    required this.search,
    required this.mean,
    required this.parts,
    required this.id,
    required this.kunyomi,
    required this.order,
    required this.radicalId,
    this.isHighLight = false,
  });

  Kanji copyWith({
    List<VocabularyKanji>? vocabularies,
    String? onyomi,
    int? lookAndLearnId,
    String? radical,
    String? kanji,
    String? lookAndLearn,
    int? lessonId,
    String? path,
    String? search,
    String? mean,
    String? parts,
    int? id,
    String? kunyomi,
    int? order,
    int? radicalId,
    bool? isHighLight,
  }) {
    return Kanji(
      vocabularies: vocabularies ?? this.vocabularies,
      onyomi: onyomi ?? this.onyomi,
      lookAndLearnId: lookAndLearnId ?? this.lookAndLearnId,
      radical: radical ?? this.radical,
      kanji: kanji ?? this.kanji,
      lookAndLearn: lookAndLearn ?? this.lookAndLearn,
      lessonId: lessonId ?? this.lessonId,
      path: path ?? this.path,
      search: search ?? this.search,
      mean: mean ?? this.mean,
      parts: parts ?? this.parts,
      id: id ?? this.id,
      kunyomi: kunyomi ?? this.kunyomi,
      order: order ?? this.order,
      radicalId: radicalId ?? this.radicalId,
      isHighLight: isHighLight ?? this.isHighLight,
    );
  }

  factory Kanji.fromJson(Map<String, dynamic> json) {
    return Kanji(
      vocabularies: List<VocabularyKanji>.from(json["vocabularies"].map((x) => VocabularyKanji.fromJson(x))) ?? [],
      onyomi: json['onyomi'] ?? '',
      lookAndLearnId: json['look_and_learn_id'] ?? '',
      radical: json['radical'] ?? '',
      kanji: json['kanji'] ?? '',
      lookAndLearn: json['look_and_learn'] ?? '',
      lessonId: json['lesson_id'] ?? '',
      path: json['path'] ?? '',
      search: json['search'] ?? '',
      mean: json['mean'] ?? '',
      parts: json['parts'] ?? '',
      id: json['id'] ?? '',
      kunyomi: json['kunyomi'] ?? '',
      order: json['order'] ?? '',
      radicalId: json['radical_id'] ?? '',
    );
  }
}
