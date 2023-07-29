
import 'dart:io';

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

class KanjiRepository {
  KanjiRepository._privateConstructor();

  static final KanjiRepository _instance = KanjiRepository._privateConstructor();

  static KanjiRepository get instance => _instance;

  final DatabaseKanjiHelper dataHelper = DatabaseKanjiHelper.instance;
  Future<List<Kanji>> getAllKanjis() async{

    final List<Map<String, dynamic>> result = await dataHelper.queryAllRows('SELECT * FROM kanji where lesson_id = 1');
    final listKanjis = result.map((row) => Kanji.fromJson(row)).toList();
    return listKanjis;
  }

  Future<List<Vocabulary>> getVocabularies(List<int> listId) async{
    var listVocs = <Vocabulary>[];
    for(var item in listId) {
      final List<Map<String, dynamic>> result = await dataHelper.queryAllRows('SELECT * FROM relation where id = $item');
      if(result.isNotEmpty) {
        listVocs.add(Vocabulary.fromJson(result[0]));
      }

    }

    return listVocs;
  }
  Future<LookAndLearn> getLookAndLearnById(String id) async{
    final List<Map<String, dynamic>> result = await dataHelper.queryAllRows('SELECT * FROM look_and_learn where id = $id');
    if(result.isNotEmpty) {
      return LookAndLearn.fromJson(result[0]);
    }
    return LookAndLearn(id: '', en: '', vi: '');
  }

  Future<List<Choice>> getChoices() async{
    final List<Map<String, dynamic>> result = await dataHelper.queryAllRows('SELECT * FROM jlpt ORDER BY RANDOM() LIMIT 42');
    return result.map((row) => Choice.fromJson(row)).toList();
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