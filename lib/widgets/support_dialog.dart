import 'package:flutter/material.dart';
import 'package:radio_g1/theme.dart';
import 'package:radio_g1/widgets/markdown.dart';

class SupportDialog extends StatelessWidget {
  const SupportDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.backgroundColor,
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Nous soutenir',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.foregroundColor,
              ),
            ),
            const SizedBox(height: 16),
            Image.asset(
              'assets/images/qr_code.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 16),
            const MarkdownText(filename: 'assets/text/support.md'),
          ],
        ),
      ),
    );
  }
} 