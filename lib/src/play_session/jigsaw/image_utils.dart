import 'dart:math';

import 'package:flame/components.dart';

class ImageUtils {
  static double calculateScale(double targetSizeWidth, double targetSizeHeight,
      double imageSizeWidth, double imageSizeHeight) {
    double scale = 1.0;
    if (imageSizeWidth > targetSizeWidth ||
        imageSizeHeight > targetSizeHeight) {
      scale = min(
          targetSizeWidth / imageSizeWidth, targetSizeHeight / imageSizeHeight);
    } else {
      scale = max(
          targetSizeWidth / imageSizeWidth, targetSizeHeight / imageSizeHeight);
    }
    return scale;
  }

  static Vector2 fitCenter(
      double width, double height, double targetWidth, double targetHeight) {
    print("image.width:${width} image.height:${height}");

    double original_aspect_ratio = 1.0;
    double target_aspect_ratio = 1.0;
    double new_width = 0.0;
    double new_height = 0.0;

    // 计算原始图像和目标尺寸的宽高比
    original_aspect_ratio = width / height;
    target_aspect_ratio = targetWidth / targetHeight;

    // 如果原始宽高比大于目标宽高比，则需要缩放宽度
    if (original_aspect_ratio > target_aspect_ratio) {
      new_width = targetWidth;
      new_height = targetWidth / original_aspect_ratio;
    } else {
      //否则，需要缩放高度
      new_height = targetHeight;
      new_width = targetHeight * original_aspect_ratio;
    }
    print("image.new_width:${new_width} image.new_height:${new_height}");
    return Vector2(new_width, new_height);
  }
}
