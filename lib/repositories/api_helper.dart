import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
class ApiHelper {
  static const apiKey = "http://173.199.127.90:3000/api/v1/mobile/static/get/?token=6f0108183566ebcef2f8723984dccc8d473ff4a47f41339688f40403a87c28d1c36b728b4e2d8a222ab770ac18be872b7b18937f5d86288d3cdf691a5bcf4c8d&name=";
  static const endpoint = "http://173.199.127.90:3000";

  ApiHelper._privateConstructor();
  static final ApiHelper instance = ApiHelper._privateConstructor();
  // for feature listening
  String getLinkMp3(String file){
    print(apiKey + file);
    return apiKey + file;
  }
  //for feature kanji
  String getLinkMp3Vocabulary(String idVoc){
    const SOUND_TOKEN =
        "cde4c3cffe3325227b74709b0736515ce708aac4927da6d2ec4eaf1c4d46ba0da0a3472c9f2aa7ebef3641e225f50c33aacd9f16aa3328ad4bfbffd86e27ea82";
    return "$endpoint/api/v1/mobile/static/get/?token=$SOUND_TOKEN&name=$idVoc.mp3";
  }

  String sizeScreen(BuildContext context) {
    double density = MediaQuery.of(context).devicePixelRatio;
    if (density >= 4.0) return "xxxhdpi";
    if (density >= 3.0) return "xxhdpi";
    if (density >= 2.0) return "xhdpi";
    // if (density >= 1.5)
    return "hdpi";
  }
  String getImageUsageKanji(String id , BuildContext context){
    const token =
    "cde4c3cffe3325227b74709b0736515ce708aac4927da6d2ec4eaf1c4d46ba0d629294f26bb199873395f4542ee71458d56f9236e01d9c62c7535519b9ab1a15";
    return "${"$endpoint/api/v1/mobile/static/get/?token=$token"}&name=$id.png&density=${sizeScreen(context)}";
  }
  Future<String> getLocalFilePath() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    return appDir.path;
  }

  Future<String> getPathFileImageUsageKanji(String id, BuildContext context) async {
    String localFilePath = await getLocalFilePath();
    final destinationDir = Directory('$localFilePath/images');
    destinationDir.createSync(recursive: true);
    File file = File('$localFilePath/images/$id.png');
    if (await file.exists()) {
      return file.path; // Trả về đường dẫn tệp nếu nó đã tồn tại
    } else {
      try {
        Dio dio = Dio();
        Response response = await dio.get(getImageUsageKanji(id, context),
            options: Options(responseType: ResponseType.bytes));
        await file.writeAsBytes(response.data);
        return file.path; // Trả về đường dẫn tệp sau khi đã tải xuống
      } catch (e) {
        print('Lỗi khi tải xuống tệp: $e');
        return 'null';
      }
    }
  }

}