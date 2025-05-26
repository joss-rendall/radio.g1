/*
 *  duration_extension.dart
 *
 *  Created by Ilia Chirkunov <contact@cheebeez.com> on January 25, 2022.
 *  *
 *  Modified by JossRendall, g1liberty.org, on May 2025
 *  *
 */

extension DurationExtension on Duration {
  String format() {
    final hours = inHours;
    final minutes = inMinutes % 60;
    final seconds = inSeconds % 60;

    return '${hours.toString().padLeft(2, "0")}:'
        '${minutes.toString().padLeft(2, "0")}:'
        '${seconds.toString().padLeft(2, "0")}';
  }
}
