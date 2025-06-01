import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:radio_g1/config.dart';
import 'package:radio_g1/widgets/update_dialog.dart';

class UpdateService {
  Future<void> checkForUpdates(BuildContext context) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      debugPrint('Version actuelle: $currentVersion');

      final response = await http.get(Uri.parse(Config.releasesUrl));
      if (response.statusCode == 200) {
        final releases = json.decode(response.body) as List;
        if (releases.isNotEmpty) {
          final latestRelease = releases.first;
          final latestVersion = latestRelease['tag_name'] as String;
          debugPrint('Dernière version disponible: $latestVersion');

          if (_compareVersions(latestVersion, currentVersion) > 0) {
            if (context.mounted) {
              showDialog(
                context: context,
                builder: (context) => UpdateDialog(
                  newVersion: latestVersion,
                  releaseUrl: latestRelease['html_url'] as String,
                  onUpdate: () => downloadUpdate(latestVersion),
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Erreur lors de la vérification des mises à jour: $e');
    }
  }

  int _compareVersions(String version1, String version2) {
    final v1Parts = version1.split('.');
    final v2Parts = version2.split('.');

    for (var i = 0; i < v1Parts.length && i < v2Parts.length; i++) {
      final v1 = int.tryParse(v1Parts[i].replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final v2 = int.tryParse(v2Parts[i].replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

      if (v1 > v2) return 1;
      if (v1 < v2) return -1;
    }

    return v1Parts.length.compareTo(v2Parts.length);
  }

  Future<void> downloadUpdate(String version) async {
    final url = '${Config.apkDownloadUrl}v$version/app-release.apk';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
} 