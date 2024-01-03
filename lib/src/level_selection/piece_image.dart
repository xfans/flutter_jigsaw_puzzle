import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/palette.dart';

typedef DoubleCallback = void Function(double? p);

class PieceImage extends StatelessWidget {
  const PieceImage({
    super.key,
    required this.pictureUrl,
    this.progress,
    this.progressIndicatorBuilder,
  });

  final String pictureUrl;
  final Function? progress;
  final ProgressIndicatorBuilder? progressIndicatorBuilder;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return CachedNetworkImage(
      imageUrl: pictureUrl,
      imageBuilder: (context, imageProvider) {
        progress?.call();
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        );
      },
      progressIndicatorBuilder: progressIndicatorBuilder ??
          (context, url, downloadProgress) {
            return Center(
                child: CircularProgressIndicator(
              color: palette.textColor,
              value: downloadProgress.progress,
            ));
          },
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
