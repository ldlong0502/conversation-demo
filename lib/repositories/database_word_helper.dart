import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:archive/archive.dart';
import 'package:flutter/services.dart' show rootBundle , ByteData;
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
class DatabaseWordHelper {
  static const urlVocabulary = "http://173.199.127.90:3000/api/v1/mobile/static/get/?token=6f0108183566ebcef2f8723984dccc8d473ff4a47f41339688f40403a87c28d1cc5fb3ad54ae9410f5500074ed5209c87139b50b8af11c1ffe33d9b838567ed3&name=vocabulary_10501.zip";
  static const fileZip = 'vocabulary.zip';
  static const passwordUnzip = 'Aa@12345';
  DatabaseWordHelper._privateConstructor();
  static Directory? destinationDir;
  static final DatabaseWordHelper instance = DatabaseWordHelper._privateConstructor();

  Future<File?> _downloadFile() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    destinationDir = Directory('${appDocumentDir.path}/unzipped_files');
    destinationDir!.createSync(recursive: true);
    var file = File('${destinationDir!.path}/$fileZip');
    if (await file.exists()) {
      return file; // Trả về đường dẫn tệp nếu nó đã tồn tại
    } else {
      try {
        Dio dio = Dio();
        Response response = await dio.get(urlVocabulary,
            options: Options(responseType: ResponseType.bytes));
        file.writeAsBytesSync(response.data);
        return file; // Trả về đường dẫn tệp sau khi đã tải xuống
      } catch (e) {
        print('Lỗi khi tải xuống tệp: $e');
        return null;
      }
    }
  }
  Future<void> unzipFileWord() async {
    var zippedFile = await _downloadFile();
    var bytes = zippedFile!.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes , password: passwordUnzip);

    for (final file in archive) {
      if (file.isFile) {
        final data = file.content as List<int>;
        final filePath = '${destinationDir!.path}/vocabulary/${file.name}';
        if (!File(filePath).existsSync()) {
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        }

      }
    }
  }
  Future<List<Map<String, dynamic>>> getVocabularyData() async {
    final jsonData = await File('${destinationDir!.path}/vocabulary/vocabulary.json').readAsString();
    return  List<Map<String, dynamic>>.from(json.decode(jsonData));
  }
  String getUrlImageById(int id)  {
    return File('${destinationDir!.path}/vocabulary/$id.png').path;
  }
  String getUrlAudioById(int id)  {
    return File('${destinationDir!.path}/vocabulary/$id.mp3').path;
  }
}
