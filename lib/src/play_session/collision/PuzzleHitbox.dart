import 'package:flame/collisions.dart';

import '../shape_type.dart';

class PuzzleHitbox extends RectangleHitbox {
  ShapeType type = ShapeType.top;
  int shapeTab = 0;
  PuzzleHitbox(
    this.type,
    this.shapeTab, {
    super.position,
    super.size,
    super.anchor,
  });

   void inactive() {
    collisionType = CollisionType.inactive;
  }
}
