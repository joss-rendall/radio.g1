/*
 *  admob_service.dart
 *
 *  Created by Ilia Chirkunov <contact@cheebeez.com> on January 25, 2022.
 *  *
 *  Modified by JossRendall, g1liberty.org, on May 2025
 *  *
 */

import 'package:flutter/material.dart';

class AdmobService {
  static const isEnabled = false;

  static Widget banner(int width, int height) {
    return const SizedBox.shrink();
  }
}

class ConsentDialog extends StatelessWidget {
  const ConsentDialog({
    super.key,
    required this.loading,
    required this.builder,
  });

  final Widget loading;
  final Function builder;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
