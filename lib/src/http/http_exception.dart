import 'package:flutter/material.dart';

///app的http异常与提示信息
class HttpException {
  String? message;
  HttpExceptionType _type;
  static String code401 = "401";
  static String code403 = "403";

  HttpException(this._type, {this.message = ""});

  get type => _type;

  @override
  String toString() {
    switch (_type) {
      case HttpExceptionType.noNetWork:
        return '暂无网络，请检查网络';
      case HttpExceptionType.timeout:
        return '请求超时，请检查网络';
      case HttpExceptionType.requestError:
        return '网络异常，请稍后重试';
      case HttpExceptionType.responseError:
        return "网络异常，请稍后重试";
      case HttpExceptionType.cancel:
        return '请求取消';
      case HttpExceptionType.netWorkCode:
      case HttpExceptionType.urlError:
        return '网络异常，请稍后重试';
      case HttpExceptionType.unauthorized:
        return "登录已过期，请重新登录";
      case HttpExceptionType.other:
        return '网络异常，请稍后重试';
      case HttpExceptionType.responseStatus:
        return message ?? "服务异常，请稍后重试";
    }
  }
}

enum HttpExceptionType {
  ///URL错误
  urlError,

  ///网络无连接
  noNetWork,

  ///暂无网络，请检查网络
  timeout,

  ///请求超时，请检查网络
  requestError,

  ///服务异常，请稍后重试
  responseError,

  ///code错误妈
  netWorkCode,

  ///服务端返回status错误
  responseStatus,

  ///服务异常，请稍后重试
  cancel,

  ///请求取消
  other,

  ///没权限
  unauthorized,
}
