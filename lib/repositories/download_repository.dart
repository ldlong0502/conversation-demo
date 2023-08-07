import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/blocs/download_cubit/download_cubit.dart';
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
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:archive/archive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class DownloadRepository {
  DownloadRepository._privateConstructor();

  static Directory? destinationDir;
  static final DownloadRepository _instance =
      DownloadRepository._privateConstructor();

  static DownloadRepository get instance => _instance;

  final DatabaseWordHelper dataHelper = DatabaseWordHelper.instance;


  BuildContext? context;

  void setContext(BuildContext ctx) {
    context = ctx;
  }
  Future<File?> _downloadZipFile(
      String lessonId, String url, String folder) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    destinationDir =
        Directory('${appDocumentDir.path}/unzipped_files/$lessonId');
    destinationDir!.createSync(recursive: true);
    var file = File('${destinationDir!.path}/$folder.zip');
    if (await file.exists()) {
      return file; // Trả về đường dẫn tệp nếu nó đã tồn tại
    } else {
      try {
        Dio dio = Dio();
        Response response = await dio.get(url,
            onReceiveProgress: (received, total) {
          if (total != -1) {
            debugPrint('=>>>>${received * 100 ~/ total}%');
            if(context != null) {
              context!.read<DownloadCubit>().updateProgress(received * 100 ~/ total);
            }

          }
        },
            options: Options(responseType: ResponseType.bytes));
        if(response.statusCode == 200) {
          file.writeAsBytesSync(response.data);
          return file;
        }
       // Trả về đường dẫn tệp sau khi đã tải xuống
      } catch (e) {
        print('Lỗi khi tải xuống tệp: $e');
        return null;
      }
    }
  }

  Future<void> downloadFileAndSave(
      String lessonId, String url, String folder) async {
    var zippedFile = await _downloadZipFile(lessonId, url, folder);
    var bytes = zippedFile!.readAsBytesSync();
    var archive =
        ZipDecoder().decodeBytes(bytes, password: AppConfig.passwordUnzip);

    for (final file in archive) {
      if (file.isFile) {
        final data = file.content as List<int>;
        final filePath =
            '${destinationDir!.path}/$lessonId/$folder/${file.name}';
        if (!File(filePath).existsSync()) {
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        }
      }
    }
  }

  Future<List<Map<String, dynamic>>> getJsonData(
      String lessonId, String folder) async {
    final jsonData =
        await File('${destinationDir!.path}/$lessonId/$folder/$folder.json')
            .readAsString();
    return List<Map<String, dynamic>>.from(json.decode(jsonData));
  }

  String getUrlImageById(int id, String lessonId, String folder) {
    return File('${destinationDir!.path}//$lessonId/$folder/$id.png').path;
  }

  String getUrlAudioById(int id, String lessonId, String folder) {
    return File('${destinationDir!.path}//$lessonId/$folder/$id.mp3').path;
  }
}
