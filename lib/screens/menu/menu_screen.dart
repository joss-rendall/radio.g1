import 'package:flutter/material.dart';
import 'package:radio_g1/theme.dart';
import 'package:radio_g1/language.dart';
import 'package:radio_g1/widgets/sidebar.dart';
import 'package:radio_g1/screens/support/support_view.dart';
import 'package:radio_g1/widgets/privacy_dialog.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Sidebar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: AppTheme.foregroundColor),
                    title: Text(Language.aboutUs, style: const TextStyle(color: AppTheme.foregroundColor)),
                    onTap: () => _showAboutDialog(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.favorite_outline, color: AppTheme.foregroundColor),
                    title: Text(Language.support, style: const TextStyle(color: AppTheme.foregroundColor)),
                    onTap: () => Navigator.pushNamed(context, SupportView.routeName),
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined, color: AppTheme.foregroundColor),
                    title: Text(Language.privacyPolicy, style: const TextStyle(color: AppTheme.foregroundColor)),
                    onTap: () => _showPrivacyDialog(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AboutDialog(),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const PrivacyDialog(),
    );
  }
} 