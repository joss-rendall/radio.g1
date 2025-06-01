/*
 *  main.dart
 *
 *  Created by Ilia Chirkunov <contact@cheebeez.com> on January 25, 2022.
 *  *
 *  Modified by JossRendall, g1liberty.org, on May 2025
 *  *
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:radio_g1/theme.dart';
import 'package:radio_g1/config.dart';
import 'package:radio_g1/routing/route_generator.dart';
import 'package:radio_g1/providers/app_providers.dart';
import 'package:radio_g1/services/fcm_service.dart';
import 'package:logging/logging.dart';
import 'package:radio_g1/services/update_service.dart';
import 'package:radio_g1/screens/player/player_view.dart';

void main() {
  // Configuration du logger
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  SingleRadio.create().then(runApp);
}

/// Root widget, use 'create' for instantiation.
class SingleRadio extends StatelessWidget {
  const SingleRadio({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.createProviders(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Config.title,
        theme: AppTheme.themeData,
        onGenerateRoute: RouteGenerator.onGenerateRoute,
        home: const HomeWrapper(),
      ),
    );
  }

  // Initializes app with services and returns its widget.
  static Future<Widget> create() async {
    await _initApp();
    await _initServices();

    return const SingleRadio();
  }

  // Performs initial setup for the app.
  static Future<void> _initApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Set device orientation.
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  // Initializes key services like Firebase and KeyValue.
  static Future<void> _initServices() async {
    await FcmService.init();
  }
}

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});
  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  bool _checkedForUpdates = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_checkedForUpdates) {
      _checkedForUpdates = true;
      UpdateService().checkForUpdates(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const PlayerView();
  }
}
