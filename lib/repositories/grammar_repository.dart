import 'dart:io';

import 'package:untitled/models/grammar.dart';
import 'package:untitled/models/lesson.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show rootBundle;
import 'package:untitled/repositories/database_grammar_helper.dart';

import 'database_listening_helper.dart';
class GrammarRepository {
  GrammarRepository._privateConstructor();

  static final GrammarRepository _instance = GrammarRepository._privateConstructor();

  static GrammarRepository get instance => _instance;

  final DatabaseGrammarHelper dataHelper = DatabaseGrammarHelper.instance;
  Future<List<Grammar>> getAllGrammars() async{

    final List<Map<String, dynamic>> result = await dataHelper.queryAllRows('SELECT * FROM grammar');
    final listGrammars= result.map((row) => Grammar.fromJson(row)).toList();
    return listGrammars;
  }
}