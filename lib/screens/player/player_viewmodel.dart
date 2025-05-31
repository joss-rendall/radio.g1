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
import 'package:radio_g1/services/azuracast_service.dart';
import 'package:radio_g1/config.dart';

class PlayerViewModel with ChangeNotifier {
  final _audioService = RadioAudioService();
  final _azuracastService = AzuracastService();
  bool isPlaying = false;
  double volume = 0;
  String? artist;
  String? track;
  String get currentTrack => track ?? Config.title;
  Image? currentArtwork;
  bool _initialized = false;

  PlayerViewModel() {
    _init();
  }

  Future<void> _init() async {
    await _audioService.initialize();
    _initialized = true;
    _initializeAudio();
    _initializeVolume();
    _listenToMetadata();
  }

  void _initializeAudio() {
    _audioService.playerStateStream.listen((state) {
      isPlaying = state.playing;
      notifyListeners();
    });
    // Autoplay au démarrage
    if (Config.autoplay) {
      play();
    }
  }

  void _initializeVolume() {
    VolumeRegulator.getVolume().then((value) {
      volume = value.toDouble();
      notifyListeners();
    });

    VolumeRegulator.volumeStream.listen((value) {
      volume = value.toDouble();
      notifyListeners();
    });
  }

  void _listenToMetadata() {
    if (!_initialized) return;
    
    // Démarrer l'écoute des métadonnées Azuracast
    _azuracastService.startListening();
    
    _azuracastService.metadataStream.listen((metadata) {
      artist = metadata['artist'];
      track = metadata['title'];
      if (metadata['art'] != null && metadata['art'].isNotEmpty) {
        currentArtwork = Image.network(metadata['art']);
      }
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

  @override
  void dispose() {
    _azuracastService.dispose();
    super.dispose();
  }
}
