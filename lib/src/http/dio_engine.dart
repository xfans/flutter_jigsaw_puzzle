import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:game_template/src/http/api.dart';

import 'http_engine.dart';


class DioEngine extends HttpEngine {
  late Dio _dio;

  DioEngine() {
    var options = BaseOptions(
      connectTimeout: Duration(seconds: 5000),
      headers: Api.header,
      contentType: Headers.jsonContentType,
    );
    _dio = Dio(options);
    // _dio.options.headers.addAll(AppConfig.headerMap);
    _dio.interceptors.add(LogInterceptor(
        requestHeader: false,
        responseHeader: false,
        requestBody: true,
        responseBody: true,
        request: false)); //开启请求日志
  }

  @override
  void setProxy(String proxy) {
    if (proxy.isNotEmpty) {

    }
  }

  @override
  Future get(String url, {Map<String, dynamic>? params}) async {
    await checkRequest(url);
    CancelToken token = addUrlToken(url);
    try {
      var response =
          await _dio.get(url, queryParameters: params, cancelToken: token);

      Map<String, dynamic> map = json.decode(response.toString());
      return map;
    } catch (error) {
      catchError(error);
    } finally {
      removeUrlToken(url);
    }
  }

  @override
  Future post(String url, {Map<String, dynamic>? params}) async {
    await checkRequest(url);
    CancelToken token = addUrlToken(url);
    // _dio.options.headers = await AppConfig.headerMap();
    try {
      var response = await _dio.post(url, data: params, cancelToken: token);
      Map<String, dynamic> map = json.decode(response.toString());
      return map;
    } catch (error) {
      catchError(error);
    } finally {
      removeUrlToken(url);
    }
  }

  @override
  Future download(String url, String filePath, progressBack) async {
    await checkRequest(url);
    CancelToken token = addUrlToken(url);
    // _dio.options.headers = await AppConfig.headerMap();
    try {
      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (count, total) {
          progressBack(count / total);
        },
        cancelToken: token,
      );
      return true;
    } catch (error) {
      catchError(error);
    } finally {
      removeUrlToken(url);
    }
  }

  @override
  getEngine() {
    return _dio;
  }
}
