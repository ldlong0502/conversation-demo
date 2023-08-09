import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SoundService {
  SoundService._privateConstructor();

  static final SoundService _instance = SoundService._privateConstructor();

  static SoundService get instance => _instance;

  bool isMute = false;
  AudioPlayer? _player;
  AudioPlayer? get player => _player;

  AudioPlayer newPlayer() {
    if (_player != null) {
      if (_player!.processingState == ProcessingState.ready ||
          _player!.processingState == ProcessingState.buffering) {
        _player!.stop();
      }
    }

    _player = AudioPlayer();
    if(isMute) {
      _player!.setVolume(0);
    }
    return _player!;
  }

  bool checkExist() {
    return _player != null;
  }

  stop() {
    _player?.stop();
  }

  seek(Duration position) async {
    await _player?.seek(position);
  }

  playSound(String sound ,[Duration positionNow = Duration.zero]) async {
    var player = newPlayer();
    player.stop();
    await player.setFilePath(sound , initialPosition: positionNow);
    debugPrint('=>>>>>: ${player.duration}');
    player.play();
  }

  playSoundNotCreateNew(String sound ,[Duration positionNow = Duration.zero]) async {
    player?.stop();
    await player?.setFilePath(sound , initialPosition: positionNow);
    debugPrint('=>>>>>: ${player?.duration}');
    player?.play();
  }
  playAsset(String asset) async {
    var player = newPlayer();
    player.stop();
    await player.setAsset(asset);
    debugPrint('=>>>>>: ${player.duration}');
    player.play();
  }
  pause() {
    _player?.pause();
  }
  resume() {
    _player?.play();
  }

  mute() {
    isMute = true;
  }
  unMute() {
    isMute = false;
  }
}
