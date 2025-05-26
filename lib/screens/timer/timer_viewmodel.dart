/*
 *  timer_viewmodel.dart
 *
 *  Created by Ilia Chirkunov <contact@cheebeez.com> on January 25, 2022.
 *  *
 *  Modified by JossRendall, g1liberty.org, on May 2025
 *  *
 */

import 'dart:async';
import 'package:flutter/material.dart';

class TimerViewModel with ChangeNotifier {
  TimerViewModel({
    required this.onTimer,
  });

  final VoidCallback onTimer;

  Timer? timer;
  Duration timerDuration = const Duration(hours: 0, minutes: 20);
  final timerPeriod = const Duration(seconds: 1);

  void setTimer(Duration value) {
    timerDuration = value;
    notifyListeners();
  }

  void startTimer() {
    timer = Timer.periodic(timerPeriod, onTick);
    notifyListeners();
  }

  void stopTimer() {
    timer?.cancel();
    notifyListeners();
  }

  void onTick(Timer timer) {
    if (timerDuration == Duration.zero) {
      onTimer();
      stopTimer();
    } else {
      timerDuration -= timerPeriod;
      notifyListeners();
    }
  }
}
