// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../style/palette.dart';
import 'settings.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _gap = SizedBox(height: 30);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final palette = context.watch<Palette>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading:  BackButton(onPressed: () {
          Navigator.pop(context);
        }),
        centerTitle: true,
        backgroundColor: palette.backgroundMain,
        title: Text(
          'Setting',
          style: TextStyle(
              fontSize: 28.sp,
              color: palette.textColor),
        ),
      ),
      backgroundColor: palette.backgroundMain,
      body: ListView(
        children: [
          _gap,
          // const _NameChangeLine(
          //   'Name',
          // ),
          ValueListenableBuilder<bool>(
            valueListenable: settings.soundsOn,
            builder: (context, soundsOn, child) => _SettingsLine(
              'Voice',
              Switch(
                value: soundsOn,
                onChanged: (bool value) {
                  settings.toggleSoundsOn();
                },
              ), // Icon(soundsOn ? Icons.volume_up : Icons.volume_off),
              onSelected: () => settings.toggleSoundsOn(),
            ),
          ),
          _SettingsLine(
            'Policy',
            Container(),
            onSelected: () {
              _launchInBrowser(Uri.parse(
                  "https://puzzle.xfans.me/puzzle/html/app-privacy-policy.html"));
            },
          ),
          _SettingsLine(
            'About',
            Container(),
            onSelected: () {
              GoRouter.of(context).push('/settings/about');
            },
          ),
          _gap,
        ],
      ),
    );
  }
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}


class _SettingsLine extends StatelessWidget {
  final String title;

  final Widget icon;

  final VoidCallback? onSelected;

  const _SettingsLine(this.title, this.icon, {this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.black12,
        width: 1,
      ))),
      child: InkResponse(
        onTap: onSelected,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20.sp,
                  ),
                ),
              ),
              icon,
            ],
          ),
        ),
      ),
    );
  }
}
