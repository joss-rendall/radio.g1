import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class Metadata {
  final String title;
  final String artist;
  final String album;
  final String genre;
  final String art;
  final int duration;    // Durée totale en secondes
  final int elapsed;     // Temps écoulé en secondes
  final int remaining;   // Temps restant en secondes

  Metadata({
    required this.title,
    required this.artist,
    required this.album,
    required this.genre,
    required this.art,
    required this.duration,
    required this.elapsed,
    required this.remaining,
  });

  @override
  String toString() {
    return 'Metadata{title: $title, artist: $artist, album: $album, genre: $genre, art: $art, duration: $duration, elapsed: $elapsed, remaining: $remaining}';
  }
}

class AzuracastService {
  static const String _baseUrl = 'http://radio.g1liberty.org:8100';
  static const String _stationId = 'radio_june';
  final _metadataController = StreamController<Metadata>.broadcast();
  final _logger = Logger('AzuracastService');
  Timer? _pollingTimer;
  String? _lastTitle;
  String? _lastArtist;

  AzuracastService() {
    _logger.info('Initialisation du service Azuracast');
  }

  Stream<Metadata> get metadataStream => _metadataController.stream;

  Future<void> startListening() async {
    _logger.info('Démarrage de l\'écoute des métadonnées...');
    _pollingTimer?.cancel();
    
    await _fetchMetadata();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await _fetchMetadata();
    });
  }

  Future<void> _fetchMetadata() async {
    try {
      _logger.fine('Récupération des métadonnées...');
      final response = await http.get(Uri.parse('$_baseUrl/api/nowplaying/$_stationId'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final metadata = _parseMetadata(data);
        
        if (metadata.title != _lastTitle || metadata.artist != _lastArtist) {
          _logger.info('Nouvelles métadonnées détectées: $metadata');
          _lastTitle = metadata.title;
          _lastArtist = metadata.artist;
          _metadataController.add(metadata);
        }
      } else {
        _logger.warning('Erreur HTTP: ${response.statusCode}');
      }
    } catch (e) {
      _logger.severe('Erreur lors de la récupération des métadonnées', e);
    }
  }

  Metadata _parseMetadata(Map<String, dynamic> data) {
    try {
      final nowPlaying = data['now_playing'];
      if (nowPlaying == null) {
        throw Exception('Données de lecture manquantes');
      }

      final song = nowPlaying['song'];
      if (song == null) {
        throw Exception('Informations sur la chanson manquantes');
      }

      return Metadata(
        title: song['title'] ?? 'Titre inconnu',
        artist: song['artist'] ?? 'Artiste inconnu',
        album: song['album'] ?? 'Album inconnu',
        genre: song['genre'] ?? 'Genre inconnu',
        art: song['art'] ?? '',
        duration: nowPlaying['duration'] ?? 0,
        elapsed: nowPlaying['elapsed'] ?? 0,
        remaining: nowPlaying['remaining'] ?? 0,
      );
    } catch (e) {
      _logger.severe('Erreur lors du parsing des métadonnées', e);
      rethrow;
    }
  }

  void dispose() {
    _logger.info('Arrêt du service Azuracast');
    _pollingTimer?.cancel();
    _metadataController.close();
  }
} 