/*
 *  route_generator.dart
 *
 *  Created by Ilia Chirkunov <contact@cheebeez.com> on January 25, 2022.
 *  *
 *  Modified by JossRendall, g1liberty.org, on May 2025
 *  *
 */

import 'package:flutter/material.dart';
import 'package:radio_g1/screens/screens.dart';

class RouteGenerator {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case PlayerView.routeName:
        return MaterialPageRoute(
          builder: (context) => const PlayerView(),
        );
      case AboutView.routeName:
        return MaterialPageRoute(
          builder: (context) => const AboutView(),
        );
      case TimerView.routeName:
        return MaterialPageRoute(
          builder: (context) => const TimerView(),
          allowSnapshotting: false,
        );
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }
}
