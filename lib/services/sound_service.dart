import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SoundService {
  SoundService._privateConstructor();

  static final SoundService _instance = SoundService._privateConstructor();

  static SoundService get instance => _instance;

  AudioPlayer? _player;
  AudioPlayer? get player => _player;

  Future<AudioPlayer> newPlayer() async {
    if (_player != null) {
      if (_player!.processingState == ProcessingState.ready ||
          _player!.processingState == ProcessingState.buffering) {
        await _player!.stop();
      }
    }

    _player = AudioPlayer();
    return _player!;
  }

  bool checkExist() {
    return _player != null;
  }

  stop() async {
    await _player?.stop();
  }

  seek(Duration position) async {
    await _player?.seek(position);
  }
  Future<Duration?> setUrl(String url, [Duration positionNow = Duration.zero]) async {
    var player = await newPlayer();
    return await player.setUrl(url, initialPosition: positionNow);
  }

  playUrl(String url, [Duration positionNow = Duration.zero]) async {
    var player = await newPlayer();
    await player.setUrl(url, initialPosition: positionNow);
    debugPrint('=>>>>>: ${player.duration}');
    player.play();
  }

  pause() {
    _player?.pause();
  }

  play() {
    _player?.play();
  }

  dispose() {
    _player?.dispose();
  }

}
