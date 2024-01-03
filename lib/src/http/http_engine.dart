import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import 'http_exception.dart';

typedef HttpProgressBack = void Function(double progress);

abstract class HttpEngine {
  Map<String, CancelToken> _cancelToken = {};

  dynamic getEngine();

  void setProxy(String proxy);

  Future get(String url, {Map<String, dynamic>? params});

  Future post(String url, {Map<String, dynamic>? params});

  Future download(
    String url,
    String filePath,
    HttpProgressBack progressBack,
  );

  getFileName(String filePath) {
    return filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length);
  }

  Future checkRequest(String url) async {
    if (url.isEmpty) {
      throw HttpException(HttpExceptionType.noNetWork);
    }
    bool available = await isNetworkConnect();
    if (!available) {
      throw HttpException(HttpExceptionType.noNetWork);
    }
  }

  static Future<bool> isNetworkConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  void cancelRequest(String url) {
    if (_cancelToken.containsKey(url)) {
      _cancelToken[url]?.cancel('cancel');
    }
  }

  void catchError(error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          throw HttpException(HttpExceptionType.timeout,
              message: error.message);
        case DioExceptionType.badCertificate:
        case DioExceptionType.badResponse:
          if (error.response?.statusCode == 401) {
            throw HttpException(HttpExceptionType.unauthorized,
                message: error.message);
          } else {
            throw HttpException(HttpExceptionType.netWorkCode,
                message: error.message);
          }
        case DioExceptionType.cancel:
          throw HttpException(HttpExceptionType.cancel, message: error.message);
        case DioExceptionType.unknown:
          throw HttpException(HttpExceptionType.other, message: error.message);
          break;
      }
    } else {
      throw HttpException(HttpExceptionType.responseError,
          message: error.message);
    }
  }

  CancelToken addUrlToken(String url) {
    CancelToken token = CancelToken();
    _cancelToken[url] = token;
    return token;
  }

  void removeUrlToken(String url) {
    if (_cancelToken.containsKey(url)) {
      _cancelToken.remove(url);
    }
  }
}
