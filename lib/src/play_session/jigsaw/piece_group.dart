import 'package:flutter_jigsaw_puzzle/src/play_session/jigsaw/piece_component.dart';

///
/// 使用组去管理所有碎片，在一起的碎片都属于同一个组
class PieceGroup{
  List<PieceComponent> children = [];
  PieceGroup(PieceComponent child){
    children.add(child);
  }
  add(PieceComponent other){
    for (PieceComponent o in other.group.children) {
      if(!children.contains(o)){
        children.add(o);
      }
      o.group = this;
    }
  }
}