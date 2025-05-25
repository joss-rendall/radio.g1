/*
 *  expanded_box.dart
 *
 *  Created by Ilia Chirkunov <contact@cheebeez.com> on January 25, 2022.
 */

import 'package:flutter/material.dart';

class ExpandedBox extends StatelessWidget {
  const ExpandedBox({
    super.key,
    this.flex = 1,
    this.minWidth = 0.0,
    this.minHeight = 0.0,
    this.child,
  });

  final int flex;
  final double minWidth;
  final double minHeight;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minWidth,
          minHeight: minHeight,
        ),
        child: child,
      ),
    );
  }
}
