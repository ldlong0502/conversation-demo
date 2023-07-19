import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:just_audio/just_audio.dart';

class AudioHelper {
  AudioHelper._privateConstructor();

  static final AudioHelper _instance = AudioHelper._privateConstructor();

  static AudioHelper get instance => _instance;

  Future<String> getLocalFilePath() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    return appDir.path;
  }

  Future<String> getPathFileAudio(String mp3) async {
    String localFilePath = await getLocalFilePath();
    File file = File('$localFilePath/$mp3');
    String url = 'http://173.199.127.90:3000/api/v1/mobile/static/get/?token=20091b79085688768ac737092b5cb786d253e857a46b7573520df228e1a9900d23f7ee71292132d9dbdb6e5679f06dae8175c19c273e0bc5e901e72fa9c0f134&name=307684e15ca40c778e19e88156e1a727';
    if (await file.exists()) {
      return file.path; // Trả về đường dẫn tệp nếu nó đã tồn tại
    } else {
      try {
        Dio dio = Dio();
        Response response = await dio.get(url,
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
    String url = 'http://173.199.127.90:3000/api/v1/mobile/static/get/?token=20091b79085688768ac737092b5cb786d253e857a46b7573520df228e1a9900d23f7ee71292132d9dbdb6e5679f06dae8175c19c273e0bc5e901e72fa9c0f134&name=307684e15ca40c778e19e88156e1a727';
    if (await file.exists()) {
      await audioPlayer.setFilePath(file.path);
      return audioPlayer.duration!; // Trả về đường dẫn tệp nếu nó đã tồn tại
    } else {
      try {
        Dio dio = Dio();
        Response response = await dio.get(url,
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
