class Version {
  Version({
    required this.version,
    required this.versionName,
    required this.url,
    required this.playUrl,
  });

  Version.fromJson(dynamic json) {
    version = json['version'];
    versionName = json['versionName'];
    url = json['url'];
    playUrl = json['playUrl'];
  }

  late int version;
  late String versionName;
  late String url;
  late String playUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['version'] = version;
    map['versionName'] = versionName;
    map['url'] = url;
    map['playUrl'] = playUrl;
    return map;
  }
}
