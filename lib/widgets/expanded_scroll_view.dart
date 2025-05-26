/*
 *  expanded_scroll_view.dart
 *
 *  Created by Ilia Chirkunov <contact@cheebeez.com> on January 25, 2022.
 *  *
 *  Modified by JossRendall, g1liberty.org, on May 2025
 *  *
 */

import 'package:flutter/material.dart';

class ExpandedScrollView extends StatelessWidget {
  const ExpandedScrollView({
    super.key,
    required this.child,
    this.hideOverscrollIndicator = false,
  });

  final Widget child;
  final bool hideOverscrollIndicator;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: hideOverscrollIndicator ? const ClampingScrollPhysics() : null,
          child: child,
    );
  }
}
