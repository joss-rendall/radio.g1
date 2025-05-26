/*
 *  player_viewmodel.dart
 *
 *  Created by Ilia Chirkunov <contact@cheebeez.com> on January 25, 2022.
 *  *
 *  Modified by JossRendall, g1liberty.org, on May 2025
 *  *
 */

import 'package:flutter/material.dart';
import 'package:volume_regulator/volume_regulator.dart';
import 'package:radio_g1/services/audio_service.dart';
import 'package:radio_g1/config.dart';

class PlayerViewModel with ChangeNotifier {
  final _audioService = RadioAudioService();
  bool isPlaying = false;
  double volume = 0;
  String? artist;
  String? track;
  String get currentTrack => track ?? Config.title;
  Image? currentArtwork;

  PlayerViewModel() {
    _initializeAudio();
    _initializeVolume();
  }

  Future<void> _initializeAudio() async {
    await _audioService.initialize();
    _audioService.playerStateStream.listen((state) {
      isPlaying = state.playing;
      notifyListeners();
    });
    
    // Autoplay au démarrage
    if (Config.autoplay) {
      play();
    }
  }

  Future<void> _initializeVolume() async {
    VolumeRegulator.getVolume().then((value) {
      volume = value.toDouble();
      notifyListeners();
    });

    VolumeRegulator.volumeStream.listen((value) {
      volume = value.toDouble();
      notifyListeners();
    });
  }

  void play() {
    _audioService.play();
  }

  void pause() {
    _audioService.pause();
  }

  void setVolume(double value) {
    VolumeRegulator.setVolume(value.toInt());
    notifyListeners();
  }
}
