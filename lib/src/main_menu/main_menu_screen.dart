// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../settings/settings.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settingsController = context.watch<SettingsController>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        mainAreaProminence: 0.45,
        squarishMainArea: Center(
          child: Transform.rotate(
            angle: -0.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Puzzle Game',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Permanent Marker',
                    fontSize: 55,
                    height: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: InkWell(
                    onTap: () {
                      launchUrlString('https://www.pexels.com');
                    },
                    child: Text(
                        'Photos provided by Pexels'
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: InkWell(
                    onTap: () {
                      launchUrlString('https://github.com/xfans/flutter_jigsaw_puzzle');
                    },
                    child: Text(
                        'https://github.com/xfans/flutter_jigsaw_puzzle'
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        rectangularMenuArea: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FilledButton(
              onPressed: () {
                // audioController.playSfx(SfxType.buttonTap);
                GoRouter.of(context).go('/play');
              },
              child: const Text('Play'),
            ),
            _gap,
            FilledButton(
              onPressed: () => GoRouter.of(context).push('/settings'),
              child: const Text('Settings'),
            ),
            _gap,
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: ValueListenableBuilder<bool>(
                valueListenable: settingsController.muted,
                builder: (context, muted, child) {
                  return IconButton(
                    onPressed: () => settingsController.toggleSoundsOn(),
                    icon: Icon(muted ? Icons.volume_off : Icons.volume_up),
                  );
                },
              ),
            ),
            _gap,
            // const Text('Music by Mr Smith'),
            // _gap,
          ],
        ),
      ),
    );
  }

  static const _gap = SizedBox(height: 10);
}
