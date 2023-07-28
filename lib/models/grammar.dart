class Grammar {
  final String id;
  final String levelId;
  final String inlevelId;
  final String title;
  final String video;
  final String titleVi;
  final String youtubeLink;
  final String structuresVi;
  final String usesVi;
  final String noteVi;
  final String signalVi;
  final String titleEn;
  final String structuresEn;
  final String usesEn;
  final String noteEn;
  final String signalEn;

  Grammar({
    required this.id,
    required this.levelId,
    required this.inlevelId,
    required this.title,
    required this.video,
    required this.titleVi,
    required this.youtubeLink,
    required this.structuresVi,
    required this.usesVi,
    required this.noteVi,
    required this.signalVi,
    required this.titleEn,
    required this.structuresEn,
    required this.usesEn,
    required this.noteEn,
    required this.signalEn,
  });

  factory Grammar.fromJson(Map<String, dynamic> json) {
    return Grammar(
      id: json['id'] ?? '',
      levelId: json['level_id'] ?? '',
      inlevelId: json['inlevel_id'] ?? '',
      title: json['title'] ?? '',
      video: json['_video'] ?? '',
      titleVi: json['title_vi'] ?? '',
      youtubeLink: json['youtube_link'] ?? '',
      structuresVi: json['structures_vi'] ?? '',
      usesVi: json['uses_vi'] ?? '',
      noteVi: json['note_vi'] ?? '',
      signalVi: json['signal_vi'] ?? '',
      structuresEn: json['structures_en'] ?? '',
      titleEn: json['title_en'] ?? '',
      usesEn: json['uses_en'] ?? '',
      noteEn: json['note_en'] ?? '',
      signalEn: json['signal_en'] ?? '',
    );
  }


}
