import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter/services.dart' show rootBundle;
class DataHelper {
  static const _databaseName = "data.sqlite";


  DataHelper._privateConstructor();
  static final DataHelper instance = DataHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var databasePath = await getDatabasesPath();
    final String path = p.join(databasePath, _databaseName);
    if (!await File(path).exists()) {
      final data = await rootBundle.load('assets/data.sqlite');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await Directory(databasePath).create(recursive: true);
      await File(path).writeAsBytes(bytes, flush: true);
    }
    return await openDatabase(path);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String sql) async {
    Database db = await instance.database;
    return await db.rawQuery(sql);
  }


}