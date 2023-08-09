import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/configs/app_config.dart';
import 'package:untitled/enums/app_text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:archive/archive.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class DownloadRepository {
  DownloadRepository._privateConstructor();

  static Directory? destinationDir;
  static final DownloadRepository _instance =
      DownloadRepository._privateConstructor();

  static DownloadRepository get instance => _instance;

  BuildContext? context;

  setContext(BuildContext ctx) {
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
        ProgressDialog pd = ProgressDialog(
          context: context,
        );
        pd.show(
            max: 100,
            msg: AppTextTranslate.getTranslatedText(EnumAppText.txtFirstDownload),
            progressType: ProgressType.valuable,
            backgroundColor: AppColor.white,
            barrierColor: Colors.black.withOpacity(0.5),
            hideValue: true,
            cancel: Cancel(
                cancelImageColor: AppColor.red,
                cancelImageSize: 20,
                cancelImage: const AssetImage(
                  'assets/images/ic_dialog_cancel.png'
                ),
                cancelClicked: () {
                  pd.close();
                  Navigator.pop(context!);
                },
                autoHidden: false),
            msgColor: AppColor.blue);
        Response response =
            await dio.get(url, onReceiveProgress: (received, total) {
          if (total != -1) {
            debugPrint('=>>>>${received * 100 ~/ total}%');
            int progress = (((received / total) * 100).toInt());
            pd.update(value: progress);
            
          }
        }, options: Options(responseType: ResponseType.bytes));
        if (response.statusCode == 200) {
          file.writeAsBytesSync(response.data);
          debugPrint('=>>>>>>>>>>>>> File Saved: ${file.path}');
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
    if (zippedFile == null) return;
    var bytes = zippedFile.readAsBytesSync();
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
