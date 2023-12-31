
class AppConfig {
  static const endpoint = "http://173.199.127.90:3000";
  static const tokenZip = '6f0108183566ebcef2f8723984dccc8d473ff4a47f41339688f40403a87c28d1cc5fb3ad54ae9410f5500074ed5209c87139b50b8af11c1ffe33d9b838567ed3';
  static const passwordUnzip = 'Aa@12345';
  static const lesson_id = '10501';
  static const listeningLessonId = '100534';
  static const grammarLessonId = '100507';
  static const kanjiLessonId = '100513';
  static String getUrlFileZipVocabulary(String lessonId) {
    return '$endpoint/api/v1/mobile/static/get/?token=$tokenZip&name=vocabulary_$lessonId.zip';
  }
  static String getUrlFileZipListening(String lessonId){
    return '$endpoint/api/v1/mobile/static/get/?token=$tokenZip&name=listening_$lessonId.zip';
  }
  static String getUrlFileZipGrammar(String lessonId){
    return '$endpoint/api/v1/mobile/static/get/?token=$tokenZip&name=grammar_$lessonId.zip';
  }
  static String getUrlFileZipKanji(String lessonId){
    return '$endpoint/api/v1/mobile/static/get/?token=$tokenZip&name=kanji_$lessonId.zip';
  }
}