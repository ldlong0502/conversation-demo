
class Choice {
  final String id;
  final String n;
  final String a;
  final String b;
  final String c;
  final String d;
  final String title;
  final String kanjis;
  final String question;
  final String answer;

  Choice({
    required this.id,
    required this.n,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.title,
    required this.kanjis,
    required this.question,
    required this.answer,
  });

  Choice copyWith({
    String? id,
    String? n,
    String? a,
    String? b,
    String? c,
    String? d,
    String? title,
    String? kanjis,
    String? question,
    String? answer,
  }) {
    return Choice(
      id: id ?? this.id,
      n: n ?? this.n,
      a: a ?? this.a,
      b: b ?? this.b,
      c: c ?? this.c,
      d: d ?? this.d,
      title: title ?? this.title,
      kanjis: kanjis ?? this.kanjis,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      );
  }

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      id: json['id'] ?? '',
      n: json['n'] ?? '',
      a: json['a'] ?? '',
      b: json['b'] ?? '',
      c: json['c'] ?? '',
      d: json['d'] ?? '',
      title: json['title'] ?? '',
      kanjis: json['kanjis'] ?? '',
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }
}
