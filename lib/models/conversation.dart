class Conversation {
  final int id;
  final int lesson;
  final String character;
  final String furigana;
  final String vi;
  final String phonetic;
  final int start;
  final int end;
  bool isHighLight = false;

  Conversation({required this.id,
    required this.lesson,
    required this.character,
    required this.vi,
    required this.furigana,
    required this.phonetic,
    required this.start,
    required this.end,
    this.isHighLight = false
  });

  Conversation copyWith({int? id,
    int? lesson,
    String? character,
    String? vi,
    String? furigana,
    String? phonetic,
    int? start,
    int? end,
    bool? isHighLight,
  }) {
    return Conversation(
      id: id ?? this.id,
      lesson: lesson ?? this.lesson,
      character: character ?? this.character,
      vi: vi ?? this.vi,
      furigana: furigana ?? this.furigana,
      isHighLight: isHighLight ?? this.isHighLight,
      phonetic: phonetic ?? this.phonetic,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      lesson: json['lesson'],
      character: json['character'],
      vi: json['vi'],
      phonetic: json['phonetic'],
      start: json['start'],
      end: json['end'],
      furigana: json['furigana'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lesson'] = lesson;
    data['character'] = character;
    data['vi'] = vi;
    data['phonetic'] = phonetic;
    data['start'] = start;
    data['end'] = end;
    data['furigana'] = furigana;
    return data;
  }
}
