// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file/file.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_jigsaw_puzzle/src/level_selection/jigsaw_info.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../games_services/score.dart';
import '../settings/settings.dart';
import '../style/palette.dart';
import 'animated_hide_widget.dart';
import 'jigsaw/jigsaw_game.dart';

class PlaySessionScreen extends StatefulWidget {
  final JigsawInfo level;

  const PlaySessionScreen(this.level, {super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  static const _celebrationDuration = Duration(milliseconds: 2000);

  static const _preCelebrationDuration = Duration(milliseconds: 500);

  bool _duringCelebration = false;
  bool isLoading = true;

  late DateTime _startOfPlay;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settingsController = context.watch<SettingsController>();
    return IgnorePointer(
      ignoring: _duringCelebration,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: BackButton(onPressed: () {
            Navigator.pop(context);
          }),
          centerTitle: true,
          backgroundColor: palette.backgroundMain,
          title: Text(
            'Real Puzzle',
            style: TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 40.sp,
                color: palette.textColor),
          ),
          actions: [
            InkResponse(
              onTap: () {
                showReset();
              },
              child: Icon(
                Icons.restart_alt,
                size: 60.sp,
                color: palette.textColor,
              ),
            ),
            InkResponse(
              onTap: () {
                showImage();
              },
              child: Icon(
                Icons.image,
                size: 60.sp,
                color: palette.textColor,
              ),
            ),
            SizedBox(
              width: 16.w,
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: Stack(children: [
                  GameWidget(
                    loadingBuilder: (context) => Center(
                      child: CircularProgressIndicator(
                        color: palette.textColor,
                      ),
                    ),
                    game: JigsawGame(
                        widget.level, settingsController.soundsOn.value, () {
                      playerWon();
                    }),
                    backgroundBuilder: (context) => Container(
                      color: palette.backgroundMain,
                    ),
                  ),
                  // AnimatedHideWidget(
                  //   color: palette.backgroundMain,
                  // )
                ]),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            SizedBox(
              height: 8.h,
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _startOfPlay = DateTime.now();

    // Preload ad for the win screen.
    // final adsRemoved =
    //     context.read<InAppPurchaseController?>()?.adRemoval.active ?? false;
    // if (!adsRemoved) {
    //   final adsController = context.read<AdsController?>();
    //   adsController?.preloadAd();
    // }
  }

  void showReset() async {
    AwesomeDialog(
        dialogBackgroundColor: Palette().backgroundMain,
        btnOkColor: Palette().btnOkColor,
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.noHeader,
        headerAnimationLoop: false,
        title: 'Reset pieces?',
        btnOkText: 'Reset',
        btnCancelText: 'Cancel',
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          setState(() {});
        }).show();
  }

  void showImage() async {
    File file = await DefaultCacheManager().getSingleFile(widget.level.image);
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      dialogType: DialogType.noHeader,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20.0),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Image.file(file),
        ),
      ),
    ).show();
  }

  Future<void> playerWon() async {
//   _log.info('Level ${widget.level.number} won');
//
    final score = Score(
      DateTime.now().difference(_startOfPlay),
    );
    AwesomeDialog(
      bodyHeaderDistance: 0,
      padding: const EdgeInsets.all(0),
      dismissOnTouchOutside: false,
      context: context,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      dialogType: DialogType.noHeader,
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20.0),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: FutureBuilder<File>(
                      future: _getImage(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null) {
                          return Image.file(snapshot.data!);
                        }
                        return Container();
                      }),
                ),
                Text(
                  'Time: ${score.formattedTime}',
                  style: TextStyle(
                      fontFamily: 'Permanent Marker',
                      fontSize: 40.sp,
                      color: Palette().textColor),
                )
              ],
            ),
          ),
          Lottie.asset('assets/lottie/lottie_win.json'),
        ],
      ),
      dialogBackgroundColor: Palette().backgroundMain,
      btnOkColor: Palette().btnOkColor,
      btnOkText: "Continue",
      btnOkOnPress: () {
        GoRouter.of(context).go('/play');
      },
    ).show();

    // GoRouter.of(context).go('/play/won', extra: {'score': score});
  }

  Future<File> _getImage() async {
    File file = await DefaultCacheManager().getSingleFile(widget.level.image);
    return file;
  }
}
