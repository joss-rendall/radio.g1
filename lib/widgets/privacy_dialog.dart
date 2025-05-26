import 'package:flutter/material.dart';
import 'package:radio_g1/theme.dart';
import 'package:radio_g1/language.dart';
import 'package:radio_g1/widgets/markdown.dart';

class PrivacyDialog extends StatelessWidget {
  const PrivacyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Language.privacyPolicy,
                  style: TextStyle(
                    color: AppTheme.foregroundColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppTheme.foregroundColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SizedBox(
              height: 400,
              child: SingleChildScrollView(
                child: MarkdownText(
                  filename: 'assets/text/privacy.md',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 