import 'package:untitled/models/sentences.dart';

class Lesson {
  final String mean;
  final List<Sentences> sentences;
  final int id;
  final String title;
  final int lessonId;
  bool isLoading = false;

  Lesson(
      {required this.mean,
      required this.sentences,
      required this.id,
      required this.title,
      required this.lessonId,
      isLoading = false});

  Lesson copyWith(
      {String? mean,
      List<Sentences>? sentences,
      int? id,
      String? title,
      int? lessonId,
      bool? isLoading}) {
    return Lesson(
        mean: mean ?? this.mean,
        sentences: sentences ?? this.sentences,
        id: id ?? this.id,
        lessonId: lessonId ?? this.lessonId,
        title: title ?? this.title,
        isLoading: isLoading ?? this.isLoading);
  }
  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
        mean: json['mean'] ?? '',
        sentences:  List<Sentences>.from(json["sentences"].map((x) => Sentences.fromJson(x))) ?? [],
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        lessonId: json['lesson_id'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mean'] = mean;
    data['sentences'] = sentences.map((v) => v.toJson()).toList();
    data['id'] = id;
    data['title'] = title;
    data['lesson_id'] = lessonId;
    return data;
  }
}
