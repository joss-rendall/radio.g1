/*
 *  timer_view.dart
 *
 *  Created by Ilia Chirkunov <contact@cheebeez.com> on January 25, 2022.
 *  *
 *  Modified by JossRendall, g1liberty.org, on May 2025
 *  *
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:radio_g1/theme.dart';
import 'package:radio_g1/language.dart';
import 'package:radio_g1/extensions/duration_extension.dart';
import 'package:radio_g1/widgets/screen.dart';
import 'package:radio_g1/screens/timer/timer_viewmodel.dart';

class TimerView extends StatefulWidget {
  const TimerView({super.key});
  static const routeName = '/timer';

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  late final viewModel = Provider.of<TimerViewModel>(context, listen: true);

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: Language.sleepTimer,
      hideOverscrollIndicator: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const _CircularSlider(),
            const SizedBox(height: 30),
            viewModel.timer?.isActive ?? false
                ? _Button(
                    title: Language.stopTimer,
                    color: AppTheme.timerStopButtonBackgroundColor,
                    textColor: AppTheme.timerStopButtonFontColor,
                    onTap: viewModel.stopTimer,
                  )
                : _Button(
                    title: Language.startTimer,
                    color: AppTheme.timerButtonBackgroundColor,
                    textColor: AppTheme.timerButtonFontColor,
                    onTap: viewModel.startTimer,
                  ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _CircularSlider extends StatelessWidget {
  const _CircularSlider();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TimerViewModel>(context, listen: true);

    return SleekCircularSlider(
      appearance: CircularSliderAppearance(
        size: 260,
        startAngle: 270,
        angleRange: 360,
        customWidths: CustomSliderWidths(
          trackWidth: 5,
          progressBarWidth: 30,
          handlerSize: 6,
          shadowWidth: 42,
        ),
        customColors: CustomSliderColors(
          trackColor: AppTheme.timerSliderTrackColor,
          progressBarColor: AppTheme.timerSliderColor,
          shadowColor: AppTheme.timerSliderColor,
          dotColor: AppTheme.timerSliderDotColor,
          shadowMaxOpacity: 0.1,
        ),
      ),
      onChange: (double value) {
        viewModel.setTimer(Duration(seconds: value.toInt()));
      },
      initialValue: viewModel.timerDuration.inSeconds.toDouble(),
      min: 0,
      max: 5400,
      innerWidget: (value) {
        return _TimeLeft(
          time: viewModel.timerDuration.format(),
        );
      },
    );
  }
}

class _TimeLeft extends StatelessWidget {
  const _TimeLeft({
    required this.time,
  });

  final String time;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Language.timeLeft,
          style: TextStyle(
            color: AppTheme.timerSliderFontColor,
            fontWeight: FontWeight.lerp(
              FontWeight.w400,
              FontWeight.w600,
              AppTheme.fontWeight,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          time,
          style: TextStyle(
            fontSize: 22,
            color: AppTheme.timerSliderFontColor,
            fontWeight: FontWeight.lerp(
              FontWeight.w500,
              FontWeight.w700,
              AppTheme.fontWeight,
            ),
          ),
        ),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.title,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  final Color textColor;
  final Color color;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(textColor),
        backgroundColor: WidgetStateProperty.all<Color>(color),
        minimumSize: WidgetStateProperty.all<Size>(const Size(180, 40)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        ),
      ),
      onPressed: onTap,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.lerp(
            FontWeight.w500,
            FontWeight.w700,
            AppTheme.fontWeight,
          ),
        ),
      ),
    );
  }
}
