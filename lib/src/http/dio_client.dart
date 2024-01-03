import 'package:game_template/src/http/http_engine.dart';

import 'dio_engine.dart';

class DioClient {
  static DioClient? _instance;
  late HttpEngine _engine;

  static DioClient getInstance() {
    if (_instance == null) {
      _instance = DioClient._();
    }
    return _instance!;
  }

  DioClient._() {
    _engine = DioEngine();
  }

  Future get(String url, {Map<String, dynamic>? params}) async {
    try {
      Map<String, dynamic> map = await _engine.get(url, params: params);
      return Future.value(map);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future post(String url, {Map<String, dynamic>? params}) async {
    try {
      Map<String, dynamic> map = await _engine.get(url, params: params);
      return Future.error(map);
    } catch (e) {
      return Future.error(e);
    }
  }
}
