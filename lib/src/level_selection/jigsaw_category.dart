class JigsawCategory {
  late String categoryEnname;
  late int id;
  late String categoryName;

  JigsawCategory(
    this.categoryEnname,
    this.id,
    this.categoryName,
  );

  JigsawCategory.fromJson(dynamic json) {
    print("json:${json}");
    categoryEnname = json['category_enname'];
    id = json['id'];
    categoryName = json['category_cnname'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['category_enname'] = categoryEnname;
    map['id'] = id;
    map['category_cnname'] = categoryName;
    return map;
  }
}
