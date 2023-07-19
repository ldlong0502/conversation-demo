import 'dart:io';

import 'package:untitled/models/lesson.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show rootBundle;
class LessonRepository {
  LessonRepository._privateConstructor();

  static final LessonRepository _instance = LessonRepository._privateConstructor();

  static LessonRepository get instance => _instance;

  Future<List<Lesson>> getAllLessons() async{
    var databasePath = await getDatabasesPath();
    final String path = p.join(databasePath, 'data.sqlite');
    if (!await File(path).exists()) {
      final data = await rootBundle.load('assets/data.sqlite');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await Directory(databasePath).create(recursive: true);
      await File(path).writeAsBytes(bytes, flush: true);
    }

    final Database database = await openDatabase(path);

    final List<Map<String, dynamic>> result = await database.rawQuery('SELECT * FROM lesson where level = 51');
    final listLessons = result.map((row) => Lesson.fromJson(row)).toList();
    await database.close();
    return listLessons;
  }
}