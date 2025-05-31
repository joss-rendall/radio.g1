import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AzuracastService {
  static const String _baseUrl = 'http://radio.g1liberty.org:8100';
  static const String _stationId = 'radio_june';
  final _metadataController = StreamController<Map<String, dynamic>>.broadcast();
  Timer? _pollingTimer;
  String? _lastTitle;
  String? _lastArtist;

  Stream<Map<String, dynamic>> get metadataStream => _metadataController.stream;

  Future<void> startListening() async {
    print('Démarrage de l\'écoute des métadonnées...');
    _pollingTimer?.cancel();
    
    // Première requête immédiate
    await _fetchMetadata();
    
    // Puis polling toutes les 5 secondes
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await _fetchMetadata();
    });
  }

  Future<void> _fetchMetadata() async {
    try {
      print('Récupération des métadonnées...');
      final response = await http.get(Uri.parse('$_baseUrl/api/nowplaying/$_stationId'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['now_playing'] != null && data['now_playing']['song'] != null) {
          final song = data['now_playing']['song'];
          final title = song['title'] ?? '';
          final artist = song['artist'] ?? '';
          
          // Ne mettre à jour que si les données ont changé
          if (title != _lastTitle || artist != _lastArtist) {
            print('Nouvelles métadonnées détectées');
            _lastTitle = title;
            _lastArtist = artist;
            
            final metadata = {
              'artist': artist,
              'title': title,
              'art': song['art'] ?? '',
              'album': song['album'] ?? '',
              'genre': song['genre'] ?? '',
            };
            print('Métadonnées: $metadata');
            _metadataController.add(metadata);
          }
        }
      } else {
        print('Erreur lors de la récupération des métadonnées: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la récupération des métadonnées: $e');
    }
  }

  void dispose() {
    print('Arrêt du service Azuracast');
    _pollingTimer?.cancel();
    _metadataController.close();
  }
} 