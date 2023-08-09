import 'package:untitled/models/grammar.dart';
import 'package:untitled/repositories/download_repository.dart';
import '../configs/app_config.dart';

class GrammarRepository {
  GrammarRepository._privateConstructor();

  static final GrammarRepository _instance = GrammarRepository._privateConstructor();

  static GrammarRepository get instance => _instance;

  final DownloadRepository repo = DownloadRepository.instance;

  String url =  AppConfig.getUrlFileZipGrammar(AppConfig.grammarLessonId);
  String folder = 'grammar';
  downloadFile() async {
    await repo.downloadFileAndSave(AppConfig.grammarLessonId, url, folder);
  }
  Future<List<Grammar>> getGrammars() async {
    var listGrammar= <Grammar>[];
    final List<Map<String, dynamic>> result = await repo
        .getJsonData(AppConfig.grammarLessonId, folder);
    for (var item in result) {
      if (result.isNotEmpty) {
        listGrammar.add(Grammar.fromJson(item));
      }
    }
    return listGrammar;
  }

  String getUrlImageById(int id )  {
    return repo.getUrlImageById(id , AppConfig.grammarLessonId, folder);
  }

  String getUrlAudioById(int id)  {
    return repo.getUrlAudioById(id, AppConfig.grammarLessonId, folder);
  }
}