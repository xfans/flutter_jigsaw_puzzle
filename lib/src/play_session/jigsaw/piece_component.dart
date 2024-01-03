import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jigsaw_puzzle/src/play_session/jigsaw/jigsaw_game.dart';

import '../collision/PuzzleHitbox.dart';
import '../shape_type.dart';
import 'piece_group.dart';

class PieceComponent extends PositionComponent
    with DragCallbacks, CollisionCallbacks {
  bool isDebug = false;
  Shape shape = Shape();
  SpriteComponent? sprite;
  late Path _path;
  late double _pieceSize;
  int xSort = -1;
  int ySort = -1;

  Offset topLeft = Offset(0, 0);
  Offset topRight = Offset(0, 0);
  Offset bottomRight = Offset(0, 0);
  Offset bottomLeft = Offset(0, 0);

  late PieceGroup group;

  PuzzleHitbox? topHitbox = null;
  PuzzleHitbox? rightHitbox = null;
  PuzzleHitbox? bottomHitbox = null;
  PuzzleHitbox? leftHitbox = null;

  List<PieceComponent> hitOthers = [];

  PieceComponent(SpriteComponent sprite, Shape shape, double pieceSize,
      this.xSort, this.ySort)
      : super(size: sprite.size) {
    this.shape = shape;
    this.sprite = sprite;
    add(sprite);
    _path = Path();
    this._pieceSize = pieceSize;
    // print("PieceComponent:" + _pieceSize.toString());
    topLeft = Offset(0, 0);
    topRight = Offset(size.x, 0);
    bottomRight = Offset(size.x, size.y);
    bottomLeft = Offset(0, size.y);

    topLeft = Offset(shape.leftTab != 0 ? _pieceSize : 0,
            (shape.topTab != 0) ? _pieceSize : 0) +
        topLeft;
    topRight = Offset(shape.rightTab != 0 ? -_pieceSize : 0,
            (shape.topTab != 0) ? _pieceSize : 0) +
        topRight;
    bottomRight = Offset(shape.rightTab != 0 ? -_pieceSize : 0,
            (shape.bottomTab != 0) ? -_pieceSize : 0) +
        bottomRight;
    bottomLeft = Offset(shape.leftTab != 0 ? _pieceSize : 0,
            (shape.bottomTab != 0) ? -_pieceSize : 0) +
        bottomLeft;
    _path.moveTo(topLeft.dx, topLeft.dy);
    if (shape.topTab != 0) {
      _path.extendWithPath(
          _calculatePoint(ShapeType.top, topLeft, topRight), Offset.zero);
    }
    _path.lineTo(topRight.dx, topRight.dy);
    if (shape.rightTab != 0) {
      _path.extendWithPath(
          _calculatePoint(ShapeType.right, topRight, bottomRight), Offset.zero);
    }
    _path.lineTo(bottomRight.dx, bottomRight.dy);
    if (shape.bottomTab != 0) {
      _path.extendWithPath(
          _calculatePoint(ShapeType.bottom, bottomRight, bottomLeft),
          Offset.zero);
    }
    _path.lineTo(bottomLeft.dx, bottomLeft.dy);
    if (shape.leftTab != 0) {
      _path.extendWithPath(
          _calculatePoint(ShapeType.left, bottomLeft, topLeft), Offset.zero);
    }
    _path.lineTo(topLeft.dx, topLeft.dy);
    _path.close();
    group = PieceGroup(this);
  }

  @override
  void render(Canvas canvas) => canvas.clipPath(_path);

  @override
  void onLoad() {}

  @override
  void onDragUpdate(DragUpdateEvent event) {
    Vector2 p = event.delta;
    setPosition(p);
    event.continuePropagation = false;
    setPriority(2);
  }

  //set priority to child
  //是调用者所有孩子的setPriority方法
  setPriority(int priority) {
    // this.priority = priority;
    for (PieceComponent child in group.children) {
      child.priority = priority;
    }
  }

  //set position to child
  setPosition(Vector2 p) {
    // this.position = p;
    // this.position.add(p);
    for (PieceComponent child in group.children) {
      child.position.add(p);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    PieceComponent o = other as PieceComponent;
    if (priority != 2) return;

    if (!hitOthers.contains(o)) {
      print("onCollision: add:" + this.toString() + " other:" + o.toString());
      hitOthers.add(o);
    }
  }

  //将匹配的piece关联
  bool _linkOther(PieceComponent o) {
    if (xSort == o.xSort) {
      //top
      if (ySort - 1 == o.ySort && position.y > o.position.y) {
        this.topHitbox?.inactive();
        o.bottomHitbox?.inactive();
        var toPosition =
            o.position + o.bottomLeft.toVector2() - topLeft.toVector2();
        setPosition(toPosition - this.position);
        // this.group.add(o);
        print("onCollision top " + this.child());
        return true;
      }
      //bottom
      if (ySort + 1 == o.ySort && position.y < o.position.y) {
        this.bottomHitbox?.inactive();
        o.topHitbox?.inactive();
        var toPosition =
            o.position + o.topLeft.toVector2() - bottomLeft.toVector2();
        setPosition(toPosition - this.position);
        // this.group.add(o);
        print("onCollision bottom " + this.child());
        return true;
      }
    }
    if (ySort == o.ySort) {
      //left
      if (xSort - 1 == o.xSort && position.x > o.position.x) {
        this.leftHitbox?.inactive();
        o.rightHitbox?.inactive();
        var toPosition =
            o.position + o.topRight.toVector2() - topLeft.toVector2();
        setPosition(toPosition - this.position);
        // this.group.add(o);
        print("onCollision left " + this.child());
        return true;
      }
      //right
      if (xSort + 1 == o.xSort && position.x < o.position.x) {
        this.rightHitbox?.inactive();
        o.leftHitbox?.inactive();
        var toPosition =
            o.position + o.topLeft.toVector2() - topRight.toVector2();
        setPosition(toPosition - this.position);
        // this.group.add(o);
        print("onCollision right " + this.child());
        return true;
      }
    }
    return false;
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    print("onCollisionEnd");
    hitOthers.clear();
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    setPriority(0);
    List<PieceComponent> willAdd = [];
    for (PieceComponent o in group.children) {
      willAdd.addAll(o.dragEnd());
    }
    for (PieceComponent o in willAdd) {
      this.group.add(o);
    }
    print('onDragEnd:${willAdd.length}');
    final root = findParent() as JigsawGame;
    root.getResult(this.group.children.length,willAdd.length>0);
    print("root:${root.toString()}");
  }

  List<PieceComponent> dragEnd() {
    List<PieceComponent> willAdd = [];
    if (hitOthers.length > 0) {
      for (PieceComponent o in hitOthers) {
        if (_linkOther(o)) {
          willAdd.add(o);
        }
      }
      hitOthers.clear();
    }
    return willAdd;
  }

  Path _calculatePoint(ShapeType axis, Offset start, Offset end) {
    final Path path = Path();

    List<Offset> list = [];

    if (axis == ShapeType.top) {
      final double topMiddleY = shape.topTab == 0
          ? end.dy
          : (shape.topTab > 0
              ? end.dy - _pieceSize / 5 * 4
              : end.dy + _pieceSize / 5 * 4);
      var centerX =
          (end.dx - start.dx) / 2 + (shape.leftTab != 0 ? _pieceSize : 0);
      topHitbox = PuzzleHitbox(ShapeType.top, shape.topTab,
          position: Vector2(centerX, end.dy),
          size: Vector2(_pieceSize, _pieceSize / 2),
          anchor: Anchor.center)
        ..renderShape = isDebug
        ..paint.color = Colors.red;
      add(topHitbox!);
      path.moveTo(start.dx, start.dy);
      list.add(start);
      list.add(Offset(centerX - _pieceSize / 3, start.dy));
      list.add(
          Offset(centerX - _pieceSize / 2 + _pieceSize.abs() / 5, topMiddleY));
      list.add(Offset(centerX + _pieceSize / 2, topMiddleY));
      list.add(Offset(centerX + _pieceSize / 3, start.dy));
      list.add(end);
      final spline = CatmullRomSpline(list);
      for (final Curve2DSample c2dSample in spline.generateSamples()) {
        path.lineTo(c2dSample.value.dx, c2dSample.value.dy);
      }
    } else if (axis == ShapeType.bottom) {
      var centerX =
          (start.dx - end.dx) / 2 + (shape.leftTab != 0 ? _pieceSize : 0);
      final double bottomMiddleY = shape.bottomTab == 0
          ? end.dy
          : (shape.bottomTab > 0
              ? end.dy + _pieceSize / 5 * 4
              : end.dy - _pieceSize / 5 * 4);
      bottomHitbox = PuzzleHitbox(ShapeType.bottom, shape.bottomTab,
          position: Vector2(centerX, end.dy),
          size: Vector2(_pieceSize, _pieceSize / 2),
          anchor: Anchor.center)
        ..renderShape = isDebug
        ..paint.color = Colors.red;
      add(bottomHitbox!);
      path.moveTo(start.dx, start.dy);
      list.add(start);
      list.add(Offset(centerX + _pieceSize / 3, start.dy));
      list.add(Offset(centerX + _pieceSize / 2, bottomMiddleY));
      list.add(Offset(
          centerX - _pieceSize / 2 + _pieceSize.abs() / 5, bottomMiddleY));
      list.add(Offset(centerX - _pieceSize / 3, start.dy));
      list.add(end);
      final spline = CatmullRomSpline(list);
      for (final Curve2DSample c2dSample in spline.generateSamples()) {
        path.lineTo(c2dSample.value.dx, c2dSample.value.dy);
      }
    } else if (axis == ShapeType.right) {
      final double rightMiddleX = shape.rightTab == 0
          ? start.dx
          : (shape.rightTab > 0
              ? start.dx + _pieceSize / 5 * 4
              : start.dx - _pieceSize / 5 * 4);
      var centerY =
          (end.dy - start.dy) / 2 + (shape.topTab != 0 ? _pieceSize : 0);
      rightHitbox = PuzzleHitbox(ShapeType.right, shape.rightTab,
          position: Vector2(end.dx, centerY),
          size: Vector2(_pieceSize / 2, _pieceSize),
          anchor: Anchor.center)
        ..renderShape = isDebug
        ..paint.color = Colors.red;
      add(rightHitbox!);
      path.moveTo(start.dx, start.dy);
      list.add(start);
      list.add(Offset(start.dx, centerY - _pieceSize / 3));
      list.add(Offset(
          rightMiddleX, centerY - _pieceSize / 2 + _pieceSize.abs() / 5));
      list.add(Offset(rightMiddleX, centerY + _pieceSize / 2));
      list.add(Offset(start.dx, centerY + _pieceSize / 3));
      list.add(end);
      final spline = CatmullRomSpline(list);
      for (final Curve2DSample c2dSample in spline.generateSamples()) {
        path.lineTo(c2dSample.value.dx, c2dSample.value.dy);
      }
    } else if (axis == ShapeType.left) {
      var centerY =
          (start.dy - end.dy) / 2 + (shape.topTab != 0 ? _pieceSize : 0);
      final double leftMiddleX = shape.leftTab == 0
          ? start.dx
          : (shape.leftTab > 0
              ? start.dx - _pieceSize / 5 * 4
              : start.dx + _pieceSize / 5 * 4);
      leftHitbox = PuzzleHitbox(ShapeType.left, shape.leftTab,
          position: Vector2(end.dx, centerY),
          size: Vector2(_pieceSize / 2, _pieceSize),
          anchor: Anchor.center)
        ..renderShape = isDebug
        ..paint.color = Colors.red;
      add(leftHitbox!);
      path.moveTo(start.dx, start.dy);
      list.add(start);
      list.add(Offset(start.dx, centerY + _pieceSize / 3));
      list.add(Offset(leftMiddleX, centerY + _pieceSize / 2));
      list.add(
          Offset(leftMiddleX, centerY - _pieceSize / 2 + _pieceSize.abs() / 5));
      list.add(Offset(start.dx, centerY - _pieceSize / 3));
      list.add(end);
      final spline = CatmullRomSpline(list);
      for (final Curve2DSample c2dSample in spline.generateSamples()) {
        path.lineTo(c2dSample.value.dx, c2dSample.value.dy);
      }
    }

    return path;
  }

  String child() {
    return "PieceComponent: ${group.children.length}";
  }

  @override
  String toString() {
    return "PieceComponent :$xSort-$ySort";
  }
}
