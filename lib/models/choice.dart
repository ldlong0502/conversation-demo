
class Choice {
  final String id;
  final String a;
  final String b;
  final String c;
  final String d;
  final String title;
  final String question;
  final String answer;

  Choice({
    required this.id,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.title,
    required this.question,
    required this.answer,
  });

  Choice copyWith({
    String? id,
    String? a,
    String? b,
    String? c,
    String? d,
    String? title,
    String? question,
    String? answer,
  }) {
    return Choice(
      id: id ?? this.id,
      a: a ?? this.a,
      b: b ?? this.b,
      c: c ?? this.c,
      d: d ?? this.d,
      title: title ?? this.title,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      );
  }

}
