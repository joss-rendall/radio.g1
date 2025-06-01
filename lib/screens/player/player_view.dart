/*
 *  player_view.dart
 *
 *  Created by Ilia Chirkunov <contact@cheebeez.com> on January 25, 2022.
 *  *
 *  Modified by JossRendall, g1liberty.org, on May 2025
 *  *
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:radio_g1/config.dart';
import 'package:radio_g1/theme.dart';
import 'package:radio_g1/widgets/screen.dart';
import 'package:radio_g1/widgets/faded_box.dart';
import 'package:radio_g1/screens/player/player_viewmodel.dart';
import 'dart:math';

class PlayerView extends StatefulWidget {
  const PlayerView({super.key});
  static const routeName = '/';

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> with SingleTickerProviderStateMixin {
  late final viewModel = Provider.of<PlayerViewModel>(context, listen: true);
  late final AnimationController _controller;
  final _random = Random();
  double get padding => MediaQuery.of(context).size.width * 0.08;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildSquigglyWave(BuildContext context) {
    return SizedBox(
      height: 20,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size(MediaQuery.of(context).size.width - 40, 50),
            painter: SquigglyWavePainter(
              progress: _controller.value,
              color: Colors.white,
              random: _random,
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, PlayerViewModel viewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Visualiseur audio
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: _buildSquigglyWave(context),
        ),
        // Temps écoulé et durée totale
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                viewModel.formatDuration(viewModel.elapsed),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              Text(
                viewModel.formatDuration(viewModel.duration),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = screenHeight * 0.08; // Augmenté de 5% à 8%
    final coverToInfoSpacing = screenHeight * 0.15; // Augmenté de 4% à 6%

    return Screen(
      title: Config.title,
      home: true,
      backgroundImage: AppTheme.backgroundImage,
      hideOverscrollIndicator: true,
      child: Column(
        children: [
          SizedBox(height: topPadding),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _Cover(
              key: ValueKey(viewModel.currentTrack),
              size: MediaQuery.of(context).size.width - padding * 2,
              image: viewModel.currentArtwork ??
                  Image.asset(
                    'assets/images/cover.jpg',
                    fit: BoxFit.cover,
                  ),
            ),
          ),
          SizedBox(height: coverToInfoSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Title(
                artist: viewModel.currentArtist,
                track: viewModel.currentTitle,
              ),
              const SizedBox(width: 20),
              _ControlButton(
                isPlaying: viewModel.isPlaying,
                play: viewModel.play,
                pause: viewModel.pause,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildInfoSection(context, viewModel),
          Slider(
            value: viewModel.volume,
            min: 0,
            max: 100,
            divisions: 100,
            label: viewModel.volume.round().toString(),
            onChanged: viewModel.setVolume,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({
    super.key,
    required this.image,
    required this.size,
  });

  final Image image;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              color: AppTheme.artworkShadowColor,
              offset: AppTheme.artworkShadowOffset,
              blurRadius: AppTheme.artworkShadowRadius,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: image,
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    required this.artist,
    required this.track,
  });

  final String? artist;
  final String? track;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FadedBox(
        height: 65,
        alignment: AlignmentDirectional.centerEnd,
        gradientWidth: 20,
        colors: [
          AppTheme.backgroundColor.withValues(alpha: 0),
          AppTheme.backgroundColor
              .withValues(alpha: AppTheme.backgroundImage ? 0 : 1),
        ],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Config.textScrolling)
              TextScroll(
                artist ?? Config.title,
                numberOfReps: null,
                intervalSpaces: 7,
                velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),
                delayBefore: const Duration(seconds: 1),
                pauseBetween: const Duration(seconds: 2),
                style: TextStyle(
                  fontSize: 24,
                  color: AppTheme.artistFontColor,
                  fontWeight: FontWeight.lerp(
                    FontWeight.w700,
                    FontWeight.w800,
                    AppTheme.fontWeight,
                  ),
                ),
              )
            else
              Text(
                artist ?? Config.title,
                style: TextStyle(
                  fontSize: 24,
                  color: AppTheme.artistFontColor,
                  fontWeight: FontWeight.lerp(
                    FontWeight.w700,
                    FontWeight.w800,
                    AppTheme.fontWeight,
                  ),
                ),
              ),
            if (Config.textScrolling)
              TextScroll(
                track ?? '',
                numberOfReps: null,
                intervalSpaces: 10,
                velocity: const Velocity(pixelsPerSecond: Offset(40, 0)),
                delayBefore: const Duration(seconds: 1),
                pauseBetween: const Duration(seconds: 2),
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.trackFontColor,
                  fontWeight: FontWeight.lerp(
                    FontWeight.w700,
                    FontWeight.w800,
                    AppTheme.fontWeight,
                  ),
                ),
              )
            else
              Text(
                track ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.trackFontColor,
                  fontWeight: FontWeight.lerp(
                    FontWeight.w700,
                    FontWeight.w800,
                    AppTheme.fontWeight,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.isPlaying,
    required this.play,
    required this.pause,
  });

  final bool isPlaying;
  final VoidCallback play;
  final VoidCallback pause;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: AppTheme.controlButtonColor,
        child: InkWell(
          splashColor: AppTheme.controlButtonSplashColor,
          splashFactory: InkRipple.splashFactory,
          child: SizedBox(
            width: 70,
            height: 70,
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 38,
              color: AppTheme.controlButtonIconColor,
            ),
          ),
          onTap: () => isPlaying ? pause() : play(),
        ),
      ),
    );
  }
}

class SquigglyWavePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Random random;

  SquigglyWavePainter({
    required this.progress,
    required this.color,
    required this.random,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    final width = size.width;
    final height = size.height;
    final midHeight = height / 2;
    final maxAmplitude = height * 0.4; // 80% de la hauteur totale (40% de chaque côté)

    // Début du tracé à droite
    path.moveTo(width, midHeight);

    // Génération de l'onde avec des variations aléatoires
    for (double x = width; x >= 0; x -= 1) { // Réduit l'espacement pour plus de détails
      // Amplitude de base
      double amplitude = maxAmplitude * 0.5; // 50% de l'amplitude maximale
      
      // Ajout de variations aléatoires pour simuler la musique
      if (random.nextDouble() < 0.3) { // 30% de chance d'avoir un pic
        amplitude *= random.nextDouble() * 2.0; // Pic aléatoire jusqu'à 2x l'amplitude
      }
      
      // Ajout d'une composante sinusoïdale pour la fluidité avec une fréquence plus élevée
      final y = midHeight + 
                sin((x / width * 16 * pi) + (progress * 8 * pi)) * amplitude + // Doublé la fréquence
                (random.nextDouble() - 0.5) * (maxAmplitude * 0.3); // Augmenté le bruit à 30%
      
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(SquigglyWavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
