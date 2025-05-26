/*
 *  screen.dart
 *
 *  Created by Ilia Chirkunov <contact@cheebeez.com> on January 25, 2022.
 *  *
 *  Modified by JossRendall, g1liberty.org, on May 2025
 *  *
 */

import 'package:flutter/material.dart';
import 'package:radio_g1/services/admob_service.dart';
import 'package:radio_g1/theme.dart';
import 'package:radio_g1/widgets/sidebar.dart';
import 'package:radio_g1/widgets/expanded_scroll_view.dart';
import 'package:radio_g1/widgets/bottom_banner.dart';
import 'package:radio_g1/widgets/background_image.dart';
import 'package:radio_g1/controllers/scaffold_controller.dart';

class Screen extends StatefulWidget {
  const Screen({
    super.key,
    required this.title,
    this.home = false,
    required this.child,
    this.padding,
    this.hideOverscrollIndicator = false,
    this.backgroundImage = false,
  });

  final String title;
  final bool home;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool hideOverscrollIndicator;
  final bool backgroundImage;

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    final defaultPadding = EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.08,
    );

    return BackgroundImage(
        enable: widget.backgroundImage,
        child: Scaffold(
          key: widget.home ? ScaffoldController.scaffoldKey : null,
          appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: widget.backgroundImage ? Colors.transparent : null,
            elevation: widget.backgroundImage ? 0 : null,
          ),
          onDrawerChanged: (value) {
            ScaffoldController.isDrawerOpened = value;
            setState(() {});
          },
          drawer: widget.home ? Sidebar() : null,
          backgroundColor: widget.backgroundImage
              ? Colors.transparent
              : AppTheme.backgroundColor,
          body: ExpandedScrollView(
            hideOverscrollIndicator: widget.hideOverscrollIndicator,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                    padding: widget.padding ?? defaultPadding,
                    child: widget.child,
                ),
                if (widget.home && AdmobService.isEnabled)
                  ScaffoldController.isDrawerOpened
                      ? const BottomBannerStub()
                      : const BottomBanner(),
              ],
          ),
        ),
      ),
    );
  }
}
