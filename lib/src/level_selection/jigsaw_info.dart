/// id : ""
/// difficulty : ""
/// pictureUrl : ""
/// title : ""
/// type : ""

class JigsawInfo {
  late int id;
  late int gridSize;
  late String image;
  late String smallimage;
  late String title;
  late String photographer;

  JigsawInfo(this.image,this.smallimage ,this.title,);

  JigsawInfo.fromJson(dynamic json) {
    id = json['id'];
    image = json['src']['large'];
    smallimage = json['src']['medium'];
    title = json['alt'];
    photographer = json['photographer'];
  }
}
