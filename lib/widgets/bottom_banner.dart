/*
 *  bottom_banner.dart
 *
 *  Created by Ilia Chirkunov <contact@cheebeez.com> on January 25, 2022.
 *  *
 *  Modified by JossRendall, g1liberty.org, on May 2025
 *  *
 */

import 'package:flutter/material.dart';
import 'package:radio_g1/services/admob_service.dart';

class BottomBanner extends StatelessWidget {
  const BottomBanner({
    super.key,
    this.width = 320,
    this.height = 50,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ConsentDialog(
      loading: BottomBannerStub(
        width: width,
        height: height,
      ),
      builder: () {
        return Container(
          alignment: Alignment.center,
          width: width,
          height: height,
          child: AdmobService.banner(
            width.toInt(),
            height.toInt(),
          ),
        );
      },
    );
  }
}

class BottomBannerStub extends StatelessWidget {
  const BottomBannerStub({
    super.key,
    this.width = 320,
    this.height = 50,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
