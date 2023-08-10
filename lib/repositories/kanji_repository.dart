
import 'package:untitled/models/kanji.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/repositories/download_repository.dart';

import '../configs/app_config.dart';

class KanjiRepository {
  KanjiRepository._privateConstructor();

  static final KanjiRepository _instance = KanjiRepository._privateConstructor();

  static KanjiRepository get instance => _instance;

  final DownloadRepository repo = DownloadRepository.instance;
  String url =  AppConfig.getUrlFileZipKanji(AppConfig.kanjiLessonId);
  String folder = 'kanji';
  downloadFile() async {
    await repo.downloadFileAndSave(AppConfig.kanjiLessonId, url, folder);
  }
  Future<List<Kanji>> getKanjis() async {
    var listKanji= <Kanji>[];
    final List<Map<String, dynamic>> result = await repo
        .getJsonData(AppConfig.kanjiLessonId, folder);
    for (var item in result) {
      if (result.isNotEmpty) {
        listKanji.add(Kanji.fromJson(item));
      }
    }
    return listKanji;
  }

  String getUrlImageById(String id)  {
    return repo.getUrlImageById(id , AppConfig.kanjiLessonId, folder);
  }

  String getUrlAudioById(String id)  {
    return repo.getUrlAudioById(id, AppConfig.kanjiLessonId, folder);
  }
  Future insertKanjiHighLight(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedList = prefs.getStringList('list_highlight_kanji') ?? [];
    if(!savedList.contains(value)) {
      savedList.add(value);
    }
    await prefs.setStringList('list_highlight_kanji', savedList);
  }
  Future removeKanjiHighLight(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedList = prefs.getStringList('list_highlight_kanji') ?? [];
    if(savedList.contains(value)) {
      savedList.remove(value);
    }
    await prefs.setStringList('list_highlight_kanji', savedList);
  }
  Future<bool> checkKanjiHighLight(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedList = prefs.getStringList('list_highlight_kanji') ?? [];
    if(savedList.contains(value)){
     return true;
    }
    return false;
  }
}