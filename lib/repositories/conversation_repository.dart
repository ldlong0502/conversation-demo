import 'dart:io';

import 'package:untitled/models/conversation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show rootBundle;
class ConversationRepository {
  ConversationRepository._privateConstructor();

  static final ConversationRepository _instance = ConversationRepository._privateConstructor();

  static ConversationRepository get instance => _instance;

  Future<List<Conversation>> getAllLessons(int lesson) async{
    var databasePath = await getDatabasesPath();
    final String path = p.join(databasePath, 'data.sqlite');
    if (!await File(path).exists()) {
      final data = await rootBundle.load('assets/data.sqlite');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await Directory(databasePath).create(recursive: true);
      await File(path).writeAsBytes(bytes, flush: true);
    }

    final Database database = await openDatabase(path);

    final List<Map<String, dynamic>> result = await database.rawQuery('SELECT * FROM sentence where lesson = $lesson');
    final listConservations = result.map((row) => Conversation.fromJson(row)).toList();
    await database.close();
    return listConservations;
  }
}