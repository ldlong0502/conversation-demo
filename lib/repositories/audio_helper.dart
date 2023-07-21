import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:untitled/repositories/api_helper.dart';

class AudioHelper {
  AudioHelper._privateConstructor();

  static final AudioHelper _instance = AudioHelper._privateConstructor();

  static AudioHelper get instance => _instance;
  final ApiHelper api = ApiHelper.instance;
  Future<String> getLocalFilePath() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    return appDir.path;
  }

  Future<String> getPathFileAudio(String mp3) async {
    String localFilePath = await getLocalFilePath();
    File file = File('$localFilePath/$mp3');
    if (await file.exists()) {
      return file.path; // Trả về đường dẫn tệp nếu nó đã tồn tại
    } else {
      try {
        Dio dio = Dio();
        Response response = await dio.get(api.getLinkMp3(mp3),
            options: Options(responseType: ResponseType.bytes));
        await file.writeAsBytes(response.data);
        return file.path; // Trả về đường dẫn tệp sau khi đã tải xuống
      } catch (e) {
        print('Lỗi khi tải xuống tệp: $e');
        return 'null';
      }
    }
  }

  Future<Duration> getDuration(String mp3) async {
    AudioPlayer audioPlayer = AudioPlayer();
    String localFilePath = await getLocalFilePath();
    File file = File('$localFilePath/$mp3');
    if (await file.exists()) {
      await audioPlayer.setFilePath(file.path);
      return audioPlayer.duration!; // Trả về đường dẫn tệp nếu nó đã tồn tại
    } else {
      try {
        Dio dio = Dio();
        Response response = await dio.get(api.getLinkMp3(mp3),
            options: Options(responseType: ResponseType.bytes));
        await file.writeAsBytes(response.data);
        await audioPlayer.setFilePath(file.path);
        return audioPlayer.duration!; // Trả về đường dẫn tệp sau khi đã tải xuống
      } catch (e) {
        print('Lỗi khi tải xuống tệp: $e');
        return const Duration(seconds: 0);
      }
    }
  }
}
