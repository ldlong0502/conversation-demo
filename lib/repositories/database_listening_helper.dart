import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:archive/archive.dart';
import 'package:flutter/services.dart' show rootBundle , ByteData;

class DatabaseListeningHelper {
  static const _databaseName = "listening_n5.sqlite";

  DatabaseListeningHelper._privateConstructor();

  static final DatabaseListeningHelper instance = DatabaseListeningHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase(_databaseName);
    return _database!;
  }

  Future<void> unzipFileFromAssets(String zipAssetPath) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final destinationDir = Directory('${appDocumentDir.path}/unzipped_files');

    final ByteData data = await rootBundle.load(zipAssetPath);
    final List<int> bytes = data.buffer.asUint8List();

    final archive = ZipDecoder().decodeBytes(bytes);

    // Tìm thư mục local storage của ứng dụng

    destinationDir.createSync(recursive: true);

    for (final file in archive) {
      if (file.isFile && file.name.endsWith('.sqlite')) {
        final data = file.content as List<int>;
        final filePath = '${destinationDir.path}/${file.name}';
        if (File(filePath).existsSync()) {
          return;
        }
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      }
    }
  }

  Future<Database> _initDatabase(String name) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final destinationDir = Directory('${appDocumentDir.path}/unzipped_files');
    final filePath = '${destinationDir.path}/$name';
    return await openDatabase(filePath);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String sql) async {
    Database db = await instance.database;
    return await db.rawQuery(sql);
  }
}
