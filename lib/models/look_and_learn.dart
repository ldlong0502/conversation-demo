class LookAndLearn {
  final String id;
  final String en;
  final String vi;
  String imageUrl;


  LookAndLearn(
      {required this.id,
        required this.en,
        required this.vi,
        this.imageUrl = '',});

  LookAndLearn copyWith(
      {String? id,
        String? vi,
        String? en,
        String? imageUrl,
        }) {
    return LookAndLearn(
      id: id ?? this.id,
      vi: vi ?? this.vi,
      en: en ?? this.en,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory LookAndLearn.fromJson(Map<String, dynamic> json) {
    return LookAndLearn(
      id: json['id'] ?? '',
      vi: json['vi'] ?? '',
      en: json['en'] ?? '',
    );
  }

}
