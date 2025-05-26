/*
 *  language.dart
 *
 *  Created by Ilia Chirkunov <contact@cheebeez.com> on January 25, 2022.
 *  *
 *  Modified by JossRendall, g1liberty.org, on May 2025
 *  *
 */

import 'package:flutter/material.dart';

class Language {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'about': 'About',
      'support': 'Support us',
      'howToSupport': 'How to ?',
      'privacy': 'Privacy Policy',
      'settings': 'Settings',
      'language': 'Language',
      'volume': 'Volume',
      'autoplay': 'Autoplay',
      'english': 'English',
      'french': 'French',
    },
    'fr': {
      'about': 'À propos',
      'support': 'Nous soutenir',
      'howToSupport': 'Comment ?',
      'privacy': 'Politique de confidentialité',
      'settings': 'Paramètres',
      'language': 'Langue',
      'volume': 'Volume',
      'autoplay': 'Lecture automatique',
      'english': 'Anglais',
      'french': 'Français',
    },
  };

  static String of(BuildContext context, String key) {
    final locale = Localizations.localeOf(context).languageCode;
    return _localizedValues[locale]?[key] ?? _localizedValues['en']![key]!;
  }

  // Salutations
  static const goodMorning = 'Bonjour';
  static const goodAfternoon = 'Bon après-midi';
  static const goodEvening = 'Bonsoir';

  // Minuteur de sommeil
  static const sleepTimer = 'Minuteur de sommeil';
  static const timeLeft = 'Temps restant';
  static const startTimer = 'Démarrer le minuteur';
  static const stopTimer = 'Arrêter le minuteur';

  // À propos
  static const aboutUs = 'À propos';
  static const support = 'Nous soutenir';
  static const howToSupport = 'Comment nous soutenir';
  static const profile = 'Profil';
  static const description = 'Description';

  // Barre latérale
  static const timer = 'Minuteur';
  static const instagram = 'Instagram';
  static const twitter = 'Twitter';
  static const facebook = 'Facebook';
  static const website = 'Site web';
  static const email = 'E-mail';
  static const podcasts = 'Podcasts';
  static const comingSoon = 'Bientôt disponible';
  static const privacyPolicy = 'Politique de confidentialité';
  static const privacyPolicyClose = 'Fermer';
  static const share = 'Partager';
}
