import 'package:untitled/models/lesson.dart';
import 'package:untitled/repositories/download_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../configs/app_config.dart';

class LessonRepository {
  LessonRepository._privateConstructor();

  static final LessonRepository _instance = LessonRepository._privateConstructor();

  static LessonRepository get instance => _instance;

  final DownloadRepository repo = DownloadRepository.instance;
  String url =  AppConfig.getUrlFileZipListening(AppConfig.listeningLessonId);
  String folder = 'listening';
  downloadFile() async {
    await repo.downloadFileAndSave(AppConfig.listeningLessonId, url, folder);
  }
  Future<List<Lesson>> getLessons() async {
    var listLesson = <Lesson>[];
    final List<Map<String, dynamic>> result = await repo
        .getJsonData(AppConfig.listeningLessonId, folder);
    for (var item in result) {
      if (result.isNotEmpty) {
        listLesson.add(Lesson.fromJson(item));
      }
    }
    return listLesson;
  }

  String getUrlImageById(String id )  {
    return repo.getUrlImageById(id , AppConfig.listeningLessonId, folder);
  }

  String getUrlAudioById(String id)  {
    return repo.getUrlAudioById(id, AppConfig.listeningLessonId, folder);
  }
  Future setBlur(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('blur', value);
  }
  Future<bool> getBlur() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isBlur;
    isBlur = prefs.getBool('blur') ?? true;
    setBlur(isBlur);
    return isBlur;
  }
  Future setTranslate(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('translate', value);
  }
  Future<bool> getTranslate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isTranslate;
    isTranslate = prefs.getBool('translate') ?? true;
    setTranslate(isTranslate);
    return isTranslate;
  }
  Future setPhonetic(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('phonetic', value);
  }
  Future<bool> getPhonetic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isPhonetic;
    isPhonetic = prefs.getBool('phonetic') ?? true;
    setPhonetic(isPhonetic);
    return isPhonetic;
  }
}