/*
 *  app_providers.dart
 *
 *  Created by Ilia Chirkunov <contact@cheebeez.com> on January 25, 2022.
 *  *
 *  Modified by JossRendall, g1liberty.org, on May 2025
 *  *
 */

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:radio_g1/screens/screens.dart';
import 'package:radio_g1/services/audio_service.dart';
import 'package:radio_g1/services/azuracast_service.dart';

class AppProviders {
  static List<SingleChildWidget> createProviders() {
    final audioService = RadioAudioService();
    final azuracastService = AzuracastService();
    late final playerViewModel = PlayerViewModel(audioService, azuracastService);
    late final timerViewModel = TimerViewModel(onTimer: playerViewModel.pause);

    return [
      ChangeNotifierProvider<PlayerViewModel>.value(value: playerViewModel),
      ChangeNotifierProvider<TimerViewModel>.value(value: timerViewModel),
    ];
  }
}
