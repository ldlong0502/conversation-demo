
import 'package:untitled/configs/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word.dart';
import 'download_repository.dart';

class WordRepository {

  WordRepository._privateConstructor();

  static final WordRepository _instance = WordRepository._privateConstructor();

  static WordRepository get instance => _instance;

  final DownloadRepository repo = DownloadRepository.instance;


  String url =  AppConfig.getUrlFileZipVocabulary(AppConfig.lesson_id);
  String folder = 'vocabulary';
  downloadFile() async {
    await repo.downloadFileAndSave(AppConfig.lesson_id, url, folder);
  }
  Future<List<Word>> getWords() async {
    var listWord = <Word>[];
    final List<Map<String, dynamic>> result = await repo
        .getJsonData(AppConfig.lesson_id, folder);
    for (var item in result) {
      if (result.isNotEmpty) {
        listWord.add(Word.fromJson(item));
      }
    }
    return listWord;
  }

  String getUrlImageById(String id )  {
    return repo.getUrlImageById(id , AppConfig.lesson_id, folder);
  }

  String getUrlAudioById(String id)  {
    return repo.getUrlAudioById(id, AppConfig.lesson_id, folder);
  }

  Future insertWordFlashcardHighLight(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedList = prefs.getStringList('list_word_flashcard_highlight') ?? [];
    if(!savedList.contains(value)) {
      savedList.add(value);
    }
    await prefs.setStringList('list_word_flashcard_highlight', savedList);
  }
  Future removeWordFlashcardHighLight(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedList = prefs.getStringList('list_word_flashcard_highlight') ?? [];
    if(savedList.contains(value)) {
      savedList.remove(value);
    }
    await prefs.setStringList('list_word_flashcard_highlight', savedList);
  }
  Future<bool> checkKanjiHighLight(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedList = prefs.getStringList('list_word_flashcard_highlight') ?? [];
    if(savedList.contains(value)){
      return true;
    }
    return false;
  }
  Future<List<String>> getListWordFlashcard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedList = prefs.getStringList('list_word_flashcard_highlight') ?? [];
    return savedList;
  }

}
