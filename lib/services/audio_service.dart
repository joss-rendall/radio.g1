/*
 *  audio_service.dart
 *
 *  Created by Ilia Chirkunov <contact@cheebeez.com> on January 25, 2022.
 *  *
 *  Modified by JossRendall, g1liberty.org, on May 2025
 *  *
 */

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radio_g1/config.dart';
import 'package:logging/logging.dart';

class RadioAudioService {
  static final RadioAudioService _instance = RadioAudioService._internal();
  factory RadioAudioService() => _instance;
  RadioAudioService._internal();

  late AudioPlayer _audioPlayer;
  late AudioHandler _audioHandler;
  bool _isInitialized = false;
  bool _isInitializing = false;
  final _logger = Logger('RadioAudioService');

  Future<void> initialize() async {
    if (_isInitialized) return;
    if (_isInitializing) {
      _logger.info('Initialization already in progress');
      return;
    }

    _isInitializing = true;
    try {
      _logger.info('Initializing RadioAudioService');
      _audioPlayer = AudioPlayer();
      _audioHandler = await AudioService.init(
        builder: () => RadioAudioHandler(_audioPlayer),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.cheebeez.single_radio.audio',
          androidNotificationChannelName: 'Radio Ğ1 Liberty',
          androidNotificationOngoing: true,
          androidStopForegroundOnPause: true,
        ),
      );

      await _audioPlayer.setUrl(Config.streamUrl);
      _isInitialized = true;
      _logger.info('RadioAudioService initialized successfully');
    } catch (e) {
      _logger.severe('Error initializing RadioAudioService: $e');
      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> play() async {
    if (!_isInitialized) await initialize();
    _logger.info('Starting playback');
    await _audioHandler.play();
  }

  Future<void> pause() async {
    if (!_isInitialized) await initialize();
    _logger.info('Pausing playback');
    await _audioHandler.pause();
  }

  Future<void> stop() async {
    if (!_isInitialized) await initialize();
    _logger.info('Stopping playback');
    await _audioHandler.stop();
  }

  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<Duration?> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get bufferedPositionStream => _audioPlayer.bufferedPositionStream;
  Stream<double?> get speedStream => _audioPlayer.speedStream;
  Stream<double?> get volumeStream => _audioPlayer.volumeStream;
}

class RadioAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player;
  final _logger = Logger('RadioAudioHandler');

  RadioAudioHandler(this._player) {
    _loadPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
  }

  Future<void> _loadPlaylist() async {
    try {
      await _player.setUrl(Config.streamUrl);
    } catch (e) {
      _logger.severe("Error loading playlist: $e");
    }
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.rewind,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.fastForward,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) {
      var index = _player.currentIndex;
      var queue = _player.sequence;
      if (index != null && queue != null) {
        mediaItem.add(MediaItem(
          id: 'radio_g1',
          album: "Radio Ğ1 Liberty",
          title: Config.title,
          artist: "Radio Ğ1 Liberty",
          duration: duration,
        ));
      }
    });
  }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) {
      var queue = _player.sequence;
      if (index != null && queue != null) {
        mediaItem.add(MediaItem(
          id: 'radio_g1',
          album: "Radio Ğ1 Liberty",
          title: Config.title,
          artist: "Radio Ğ1 Liberty",
        ));
      }
    });
  }

  void _listenForSequenceStateChanges() {
    _player.sequenceStateStream.listen((SequenceState? sequenceState) {
      if (sequenceState == null) return;
      final queue = sequenceState.effectiveSequence;
      if (queue.isEmpty) return;
      final items = queue.map((source) => MediaItem(
            id: 'radio_g1',
            album: "Radio Ğ1 Liberty",
            title: Config.title,
            artist: "Radio Ğ1 Liberty",
          )).toList();
      this.queue.add(items);
    });
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();
} 