import 'dart:io';

import 'package:untitled/models/lesson.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show rootBundle;

import 'data_helper.dart';
class LessonRepository {
  LessonRepository._privateConstructor();

  static final LessonRepository _instance = LessonRepository._privateConstructor();

  static LessonRepository get instance => _instance;

  final DataHelper dataHelper = DataHelper.instance;
  Future<List<Lesson>> getAllLessons() async{

    final List<Map<String, dynamic>> result = await dataHelper.queryAllRows('SELECT * FROM lesson where level = 51 or level = 52 or level = 53 ');
    final listLessons = result.map((row) => Lesson.fromJson(row)).toList();
    return listLessons;
  }
}