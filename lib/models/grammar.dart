class Grammar {
  final String note;
  final String mean;
  final String structures;
  final String uses;
  final int id;
  final String title;
  final int lessonId;

  Grammar({
    required this.note,
    required this.mean,
    required this.structures,
    required this.uses,
    required this.id,
    required this.title,
    required this.lessonId,
  });

  factory Grammar.fromJson(Map<String, dynamic> json) {
    return Grammar(
      note: json['note'] ?? '',
      mean: json['mean'] ?? '',
      structures: json['structures'] ?? '',
      uses: json['uses'] ?? '',
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      lessonId: json['lessonId'] ?? 0,
    );
  }


}
