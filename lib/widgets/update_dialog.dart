import 'package:flutter/material.dart';
import 'package:radio_g1/theme.dart';

class UpdateDialog extends StatelessWidget {
  final String newVersion;
  final String releaseUrl;
  final VoidCallback onUpdate;

  const UpdateDialog({
    super.key,
    required this.newVersion,
    required this.releaseUrl,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.backgroundColor,
      title: const Text(
        'Mise à jour disponible',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Une nouvelle version ($newVersion) est disponible.',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Voulez-vous mettre à jour l\'application maintenant ?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Plus tard',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onUpdate();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.controlButtonColor,
          ),
          child: const Text(
            'Mettre à jour',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
} 