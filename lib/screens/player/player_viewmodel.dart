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
import 'dart:async';

class PlayerViewModel extends ChangeNotifier {
  final RadioAudioService _audioService;
  final AzuracastService _azuracastService;
  bool _isPlaying = false;
  String _currentTitle = '';
  String _currentArtist = '';
  String _currentAlbum = '';
  String _currentGenre = '';
  String _currentArt = '';
  int _duration = 0;      // Durée totale en secondes
  int _elapsed = 0;       // Temps écoulé en secondes
  int _remaining = 0;     // Temps restant en secondes
  double volume = 0;
  Image? currentArtwork;
  bool _initialized = false;
  Timer? _progressTimer;

  PlayerViewModel(this._audioService, this._azuracastService) {
    _init();
  }

  bool get isPlaying => _isPlaying;
  String get currentTitle => _currentTitle;
  String get currentArtist => _currentArtist;
  String get currentAlbum => _currentAlbum;
  String get currentGenre => _currentGenre;
  String get currentArt => _currentArt;
  int get duration => _duration;
  int get elapsed => _elapsed;
  int get remaining => _remaining;
  String get currentTrack => _currentTitle.isNotEmpty ? _currentTitle : Config.title;

  Stream<Metadata> get metadataStream => _azuracastService.metadataStream;

  // Formatage du temps en MM:SS
  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
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
      _isPlaying = state.playing;
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
      _currentTitle = metadata.title;
      _currentArtist = metadata.artist;
      _currentAlbum = metadata.album;
      _currentGenre = metadata.genre;
      _currentArt = metadata.art;
      _duration = metadata.duration;
      _elapsed = metadata.elapsed;
      _remaining = metadata.remaining;
      
      if (metadata.art.isNotEmpty) {
        currentArtwork = Image.network(metadata.art);
      }
      
      // Démarrer le timer de progression
      _startProgressTimer();
      
      notifyListeners();
    });
  }

  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_elapsed < _duration) {
        _elapsed++;
        notifyListeners();
      }
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
    _progressTimer?.cancel();
    _azuracastService.dispose();
    super.dispose();
  }
}
