class Lesson {
  final int id;
  final String title;
  final int level;
  final String vi;
  final String mp3;
  bool isPlaying = false;
  bool isLoading = false;
  Duration durationMax = const Duration(seconds: 0);
  Duration durationCurrent = const Duration(seconds: 0);

  Lesson(
      {required this.id,
      required this.title,
      required this.level,
      required this.vi,
      required this.mp3,
      this.isPlaying = false,
        this.isLoading = false,
      this.durationMax = const Duration(seconds: 0),
      this.durationCurrent = const Duration(seconds: 0)});

  Lesson copyWith(
      {int? id,
      String? title,
      int? level,
      String? vi,
      String? mp3,
      bool? isPlaying,
        bool? isLoading,
      Duration? durationMax,
      Duration? durationCurrent}) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      level: level ?? this.level,
      vi: vi ?? this.vi,
      mp3: mp3 ?? this.mp3,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      durationMax: durationMax ?? this.durationMax,
      durationCurrent: durationCurrent ?? this.durationCurrent,
    );
  }

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        level: json['level'] ?? '',
        vi: json['vi'] ?? '',
        mp3: json['mp3'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['level'] = level;
    data['vi'] = vi;
    data['mp3'] = mp3;
    return data;
  }
}
