// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jigsaw_puzzle/src/http/api.dart';
import 'package:flutter_jigsaw_puzzle/src/http/dio_client.dart';
import 'package:flutter_jigsaw_puzzle/src/level_selection/piece_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../style/palette.dart';
import 'jigsaw_grid_item.dart';
import 'jigsaw_info.dart';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  final PagingController<int, JigsawInfo> _pagingController =
      PagingController(firstPageKey: 1);

  initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) async {
      print("addPageRequestListener:$pageKey");
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageId) async {
    try {
      final List<JigsawInfo> newLists = [];
      DioClient.getInstance().get(Api.image,
          params: {"page": pageId, "per_page": 15}).then((value) {
        value["photos"].forEach((ele) {
          newLists.add(JigsawInfo.fromJson(ele));
        });
        final isLastPage = value["next_page"] == null;
        if (isLastPage) {
          _pagingController.appendLastPage(newLists);
        } else {
          final nextPageId = pageId + 1;
          _pagingController.appendPage(newLists, nextPageId);
        }
      }).onError((error, stackTrace) {
        _pagingController.error = error;
        CherryToast.error(title: Text(error.toString())).show(context);
        print(error);
      });
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Container(),
        centerTitle: true,
        backgroundColor: palette.backgroundMain,
        title: Text(
          'Real Puzzle',
          style: TextStyle(fontSize: 28.sp, color: palette.textColor),
        ),
        actions: [
          IconButton(
              onPressed: () {
                GoRouter.of(context).push('/settings');
              },
              icon: Icon(Icons.settings)),
        ],
      ),
      body: Center(
        child: Container(
          width: 0.9.sw,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                  child: Center(
                child: Text(
                  'Photos provided by Pexels',
                ),
              )),
              buildPagedGridView(),
              SliverToBoxAdapter(
                  child: SizedBox(
                height: 30.h,
              ))
            ],
          ),
        ),
      ),
    );
  }

  PagedSliverGrid<int, JigsawInfo> buildPagedGridView() {
    return PagedSliverGrid<int, JigsawInfo>(
      showNewPageProgressIndicatorAsGridChild: false,
      showNewPageErrorIndicatorAsGridChild: false,
      showNoMoreItemsIndicatorAsGridChild: true,
      pagingController: _pagingController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 50 / 33,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 4,
      ),
      builderDelegate: PagedChildBuilderDelegate<JigsawInfo>(
        itemBuilder: (context, item, index) => JigsawGridItem(
          info: item,
          onTap: () {
            _showDetailsDialog(context, item);
          },
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, JigsawInfo item) {
    var _gridSizeValue = 4;
    AwesomeDialog(
      dialogBackgroundColor: Palette().backgroundMain,
      btnOkColor: Palette().btnOkColor,
      context: context,
      animType: AnimType.scale,
      width: 600.w,
      dialogType: DialogType.noHeader,
      body: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  'Pieces:',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildSelectGridSize(2, _gridSizeValue, (v) {
                      setState(() {
                        _gridSizeValue = v;
                      });
                    }),
                    buildSelectGridSize(4, _gridSizeValue, (v) {
                      setState(() {
                        _gridSizeValue = v;
                      });
                    }),
                    buildSelectGridSize(5, _gridSizeValue, (v) {
                      setState(() {
                        _gridSizeValue = v;
                      });
                    }),
                    buildSelectGridSize(6, _gridSizeValue, (v) {
                      setState(() {
                        _gridSizeValue = v;
                      });
                    }),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildSelectGridSize(7, _gridSizeValue, (v) {
                      setState(() {
                        _gridSizeValue = v;
                      });
                    }),
                    buildSelectGridSize(8, _gridSizeValue, (v) {
                      setState(() {
                        _gridSizeValue = v;
                      });
                    }),
                    buildSelectGridSize(9, _gridSizeValue, (v) {
                      setState(() {
                        _gridSizeValue = v;
                      });
                    }),
                    buildSelectGridSize(10, _gridSizeValue, (v) {
                      setState(() {
                        _gridSizeValue = v;
                      });
                    })
                  ],
                ),
              ],
            ),
          );
        },
      ),
      btnOk: Center(
        child: Container(
          width: 100.w,
          child: ElevatedButton(
            onPressed: () {
              item.gridSize = _gridSizeValue;
              GoRouter.of(context).go('/play/loading/', extra: item);
            },
            child: Text("Start"),
          ),
        ),
      ),
    )..show();
  }

  Widget buildSelectGridSize(int num, int _gridSizeValue, f(v)) {
    final palette = context.watch<Palette>();
    return GestureDetector(
      onTap: () {
        f(num);
      },
      child: Container(
        width: 100.w,
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        margin: EdgeInsets.only(left: 8.w, right: 8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _gridSizeValue == num
              ? palette.tabSelectColor
              : palette.tabUnSelectColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Radio(value: num, groupValue: _gridSizeValue, onChanged: (value) {f(value);}),
            Text("${num * num}",
                style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 26.sp,
                    color: Colors.white)),
            // return ListTile(
            //     title: Container(width:30.w,height:20.h,child: Text("${num * num}")),
            //     leading:
            //         Radio(value: num, groupValue: _gridSizeValue, onChanged: (value) {f(value);}));
            // }),
          ],
        ),
      ),
    );
  }
}
