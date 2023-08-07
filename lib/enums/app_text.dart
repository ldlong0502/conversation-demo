enum EnumAppText {
  txtLessonOne,
  txtListeningPractice,
  txtKanji,
  txtVocabulary,
  txtGrammar,
  txtFloatLecture,
  txtPractice,
  txtMemorize,
  txtDetail,
  txtKunyomi,
  txtOnyomi,
  txtRadical,
  txtPracticeWriting,
  txtFlashcard,
  txtMultipleChoice,
  txtChallenge1,
  txtChallenge2,
  txtFlipBehind,
  txtFlipFront,
  txtDoAgain,
  txtNote,
  txtUsage,
  txtStructure,
  txtPrimary1,
  txtBack,
  txtNotFoundLesson,
  txtSorry,
  txtChallenge
}

class AppTextTranslate {
  static String locale = 'vi';
  static Map<EnumAppText, Map<String, String>> translations = {
    //home
    EnumAppText.txtLessonOne: {'vi': 'Bài học số 1'},
    EnumAppText.txtListeningPractice: {'vi': 'Luyện nghe'},
    EnumAppText.txtKanji: {'vi': 'Chữ Hán'},
    EnumAppText.txtGrammar: {'vi': 'Ngữ pháp'},
    EnumAppText.txtVocabulary: {'vi': 'Từ vựng'},

    //kanji
    EnumAppText.txtPractice: {'vi': 'Luyện tập'},
    EnumAppText.txtMemorize: {'vi': 'CÁCH GHI NHỚ'},
    EnumAppText.txtDetail: {'vi': 'Chi tiết'},
    EnumAppText.txtKunyomi: {'vi': 'ÂM KUN'},
    EnumAppText.txtOnyomi: {'vi': 'ÂM ON'},
    EnumAppText.txtRadical: {'vi': 'BỘ THỦ'},
    EnumAppText.txtPracticeWriting: {'vi': 'Luyện viết'},
    EnumAppText.txtMultipleChoice: {'vi': 'Trắc nghiệm'},
    EnumAppText.txtChallenge1: {'vi': 'Thử thách 1'},
    EnumAppText.txtChallenge2: {'vi': 'Thử thách 2'},
    EnumAppText.txtFlashcard: {'vi': 'Flashcard'},
    EnumAppText.txtFlipBehind: {'vi': 'LẬT VỀ SAU'},
    EnumAppText.txtFlipFront: {'vi': 'LẬT VỀ TRƯỚC'},
    EnumAppText.txtDoAgain: {'vi': 'Làm lại'},

    //grammar
    EnumAppText.txtFloatLecture: {'vi': 'BÀI GIẢNG'},
    EnumAppText.txtNote: {'vi': 'Chú ý'},
    EnumAppText.txtUsage: {'vi': 'Cách dùng'},
    EnumAppText.txtStructure: {'vi': 'Cấu trúc'},
    EnumAppText.txtBack: {'vi': 'Quay lại'},
    EnumAppText.txtNotFoundLesson: {'vi': 'Không tìm thấy bài giảng'},
    EnumAppText.txtSorry: {'vi': 'Xin lỗi'},
    //listening
    EnumAppText.txtPrimary1: {'vi': 'Sơ cấp 1'},

    EnumAppText.txtChallenge: {'vi': 'Thử thách'},

  };

  static String getTranslatedText(EnumAppText key) {
    if (translations.containsKey(key)) {
      final translation = translations[key];
      if (translation!.containsKey(locale)) {
        return translation[locale]!;
      }
    }
    return translations[key]!['vi']!;
  }
}
