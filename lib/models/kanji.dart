import 'look_and_learn.dart';

class Kanji {
  final String id;
  final String lessonId;
  final String kanji;
  final String order1;
  final String vocabularies;
  final String radicalId;
  final String radical;
  final String parts;
  final String kunyomi;
  final String onyomi;
  final String vi;
  final String search;
  final String path;
  bool isHighLight;
  LookAndLearn? lookAndLearn;
  Kanji({
    required this.id,
    required this.lessonId,
    required this.kanji,
    required this.order1,
    required this.vocabularies,
    required this.radicalId,
    required this.radical,
    required this.parts,
    required this.kunyomi,
    required this.onyomi,
    required this.vi,
    required this.search,
    required this.path,
    this.isHighLight = false,
    this.lookAndLearn
  });

  Kanji copyWith({
     String? id,
     String? lessonId,
     String? kanji,
     String? order1,
     String? vocabularies,
     String? radicalId,
     String? radical,
     String? parts,
     String? kunyomi,
     String? onyomi,
     String? vi,
     String? search,
     String? path,
    bool? isHighLight,
    LookAndLearn? lookAndLearn
  }) {
    return Kanji(
        id: id ?? this.id,
        lessonId: lessonId ?? this.lessonId,
        kanji: kanji ?? this.kanji,
        order1: order1 ?? this.order1,
        vocabularies: vocabularies ?? this.vocabularies,
        radicalId: radicalId ?? this.radicalId,
        radical: radical ?? this.radical,
        parts: parts ?? this.parts,
        kunyomi: kunyomi ?? this.kunyomi,
        onyomi: onyomi ?? this.onyomi,
        vi: vi ?? this.vi,
        search: search ?? this.search,
        path: path ?? this.path,
      isHighLight: isHighLight ?? this.isHighLight,
      lookAndLearn: lookAndLearn ?? this.lookAndLearn
      ,);
  }

  factory Kanji.fromJson(Map<String, dynamic> json) {
    return Kanji(
      id: json['id'] ?? '',
      lessonId: json['lesson_id'] ?? '',
      kanji: json['kanji'] ?? '',
      order1: json['order1'] ?? '',
      vocabularies: json['vocabularies'] ?? '',
      radicalId: json['radical_id'] ?? '',
      radical: json['radical'] ?? '',
      parts: json['parts'] ?? '',
      kunyomi: json['kunyomi'] ?? '',
      onyomi: json['onyomi'] ?? '',
      vi: json['vi'] ?? '',
      search: json['search'] ?? '',
      path: json['path'] ?? '',
    );
  }
}
