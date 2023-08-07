
import 'dart:io';

import 'package:untitled/configs/app_config.dart';
import 'package:untitled/models/choice.dart';
import 'package:untitled/models/kanji.dart';
import 'package:untitled/models/lesson.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show rootBundle;
import 'package:untitled/models/look_and_learn.dart';
import 'package:untitled/models/vocabulary.dart';
import 'package:untitled/repositories/database_kanji_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/repositories/database_word_helper.dart';

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

  String getUrlImageById(int id )  {
    return repo.getUrlImageById(id , AppConfig.lesson_id, folder);
  }

  String getUrlAudioById(int id)  {
    return repo.getUrlAudioById(id, AppConfig.lesson_id, folder);
  }
}
