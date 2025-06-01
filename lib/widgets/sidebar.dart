/*
 *  sidebar.dart
 *
 *  Created by Ilia Chirkunov <contact@cheebeez.com> on January 25, 2022.
 *  *
 *  Modified by JossRendall, g1liberty.org, on May 2025
 *  *
 */

import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:radio_g1/config.dart';
import 'package:radio_g1/theme.dart';
import 'package:radio_g1/language.dart';
import 'package:radio_g1/screens/about/about_view.dart';
import 'package:radio_g1/screens/timer/timer_view.dart';
import 'package:radio_g1/controllers/scaffold_controller.dart';
import 'package:radio_g1/screens/support/support_view.dart';

class Sidebar extends StatelessWidget {
  Sidebar({super.key});
  final inAppReview = InAppReview.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.drawerBackgroundColor,
      child: ListView(
        padding: const EdgeInsets.only(top: 0),
        children: [
          const _Header(),
          ..._buildItems(context),
          const _VersionFooter(),
        ],
      ),
    );
  }

  List<Widget> _buildItems(BuildContext context) {
    return [
      // Timer
      _Item(
        icon: Icons.watch_later_outlined,
        title: Language.timer,
        onTap: () {
          ScaffoldController.scaffoldKey.currentState?.closeDrawer();
          Navigator.pushNamed(context, TimerView.routeName);
        },
      ),

      // Instagram
      _Item(
        svgFileName: 'assets/icons/instagram.svg',
        title: Language.instagram,
        visible: Config.instagram.isNotEmpty,
        onTap: () async {
          ScaffoldController.scaffoldKey.currentState?.closeDrawer();
          await launchUrl(Uri.parse(Config.instagram),
              mode: LaunchMode.externalApplication);
        },
      ),

      // Twitter
      _Item(
        svgFileName: 'assets/icons/twitter.svg',
        title: Language.twitter,
        visible: Config.twitter.isNotEmpty,
        onTap: () async {
          ScaffoldController.scaffoldKey.currentState?.closeDrawer();
          await launchUrl(Uri.parse(Config.twitter),
              mode: LaunchMode.externalApplication);
        },
      ),

      // Facebook
      _Item(
        svgFileName: 'assets/icons/facebook.svg',
        title: Language.facebook,
        visible: Config.facebook.isNotEmpty,
        onTap: () async {
          ScaffoldController.scaffoldKey.currentState?.closeDrawer();
          await launchUrl(Uri.parse(Config.facebook),
              mode: LaunchMode.externalApplication);
        },
      ),

      // Website
      _Item(
        svgFileName: 'assets/icons/website.svg',
        title: Language.website,
        visible: Config.website.isNotEmpty,
        onTap: () async {
          ScaffoldController.scaffoldKey.currentState?.closeDrawer();
          await launchUrl(Uri.parse(Config.website),
              mode: LaunchMode.externalApplication);
        },
      ),

      // Email
      _Item(
        icon: Icons.email_outlined,
        title: Language.email,
        visible: Config.email.isNotEmpty,
        onTap: () async {
          ScaffoldController.scaffoldKey.currentState?.closeDrawer();
          launchUrl(
            Uri(
              scheme: 'mailto',
              path: Config.email,
              query: 'subject=${Config.title}',
            ),
          );
        },
      ),

      // Podcasts
      _Item(
        icon: Icons.podcasts_outlined,
        title: Language.podcasts,
        onTap: () {
          ScaffoldController.scaffoldKey.currentState?.closeDrawer();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(Language.comingSoon),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),

      // Support
      _Item(
        icon: Icons.favorite_outline,
        title: Language.support,
        onTap: () {
          ScaffoldController.scaffoldKey.currentState?.closeDrawer();
          Navigator.pushNamed(context, SupportView.routeName);
        },
      ),

      // About Us
      _Item(
        icon: Icons.group_outlined,
        title: Language.aboutUs,
        onTap: () {
          ScaffoldController.scaffoldKey.currentState?.closeDrawer();
          Navigator.pushNamed(context, AboutView.routeName);
        },
      ),
    ];
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      color: AppTheme.drawerHeaderBackgroundColor,
      padding: EdgeInsets.only(
        left: AppTheme.drawerTitlePadding,
        top: statusBarHeight + 16,
        right: AppTheme.drawerTitlePadding,
        bottom: 8,
      ),
      constraints: BoxConstraints(minHeight: statusBarHeight + 160.0 + 1.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              'assets/images/sidebar.png',
              width: 55,
              height: 55,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            Config.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.lerp(
                FontWeight.w500,
                FontWeight.w700,
                AppTheme.fontWeight,
              ),
              fontSize: 20,
              height: 1.5,
              color: AppTheme.drawerTitleFontColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            Config.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.lerp(
                FontWeight.w500,
                FontWeight.w700,
                AppTheme.fontWeight,
              ),
              fontSize: 14,
              height: 1.5,
              color: AppTheme.drawerDescriptionFontColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    this.icon,
    this.svgFileName,
    this.visible = true,
    required this.title,
    required this.onTap,
  });

  final IconData? icon;
  final String? svgFileName;
  final bool visible;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return visible
        ? ListTile(
            leading: icon != null
                ? Icon(
                    icon,
                    size: 24,
                    semanticLabel: '$title Icon',
                  )
                : SvgPicture.asset(
                    svgFileName!,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      AppTheme.drawerItemIconColor,
                      BlendMode.srcIn,
                    ),
                    semanticsLabel: '$title Icon',
                  ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.lerp(
                  FontWeight.w500,
                  FontWeight.w700,
                  AppTheme.fontWeight,
                ),
                fontSize: 16,
              ),
            ),
            onTap: onTap,
          )
        : const SizedBox.shrink();
  }
}

class _VersionFooter extends StatelessWidget {
  const _VersionFooter();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'v${snapshot.data!.version}',
            style: TextStyle(
              color: AppTheme.drawerDescriptionFontColor,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
