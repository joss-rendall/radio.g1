/*
 *  markdown.dart
 *
 *  Created by Ilia Chirkunov <contact@cheebeez.com> on January 25, 2022.
 *  *
 *  Modified by JossRendall, g1liberty.org, on May 2025
 *  *
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:radio_g1/language.dart';
import 'package:radio_g1/theme.dart';
import 'package:logging/logging.dart';

/// Shows the dialog box containing the MarkdownText.
class MarkdownDialog extends StatelessWidget {
  const MarkdownDialog({
    super.key,
    required this.filename,
  });

  final String filename;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Container(
        height: 500,
        padding: const EdgeInsets.only(left: 15, right: 15, top: 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: MarkdownText(
                    filename: filename,
                    isDialog: true,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  child: Text(
                    Language.privacyPolicyClose,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.lerp(
                        FontWeight.w500,
                        FontWeight.w700,
                        AppTheme.fontWeight,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays formatted text.
class MarkdownText extends StatelessWidget {
  const MarkdownText({
    super.key,
    required this.filename,
    this.isDialog = false,
  });

  static final _logger = Logger('MarkdownText');
  final String filename;
  final bool isDialog;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: rootBundle.loadString(filename),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          _logger.severe('Error loading markdown file: ${snapshot.error}');
          return Center(
            child: Text('Erreur de chargement: ${snapshot.error}'),
          );
        }
        
        if (snapshot.hasData == true) {
          _logger.info('Markdown file loaded successfully: $filename');
          return Container(
            padding: const EdgeInsets.all(8),
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.foregroundColor,
                height: 1.5,
                fontWeight: FontWeight.lerp(
                  FontWeight.w500,
                  FontWeight.w700,
                  AppTheme.fontWeight,
              ),
            ),
              child: MarkdownWidget(
                data: snapshot.data!,
                selectable: true,
                shrinkWrap: true,
              ),
            ),
          );
        } else {
          _logger.info('Loading markdown file: $filename');
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
