import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../helpers/cache_helper.dart';

class DioManager {
  Dio? _dioInstance;

  Dio? get dio {
    _dioInstance ??= initDio();
    return _dioInstance;
  }

  Dio initDio() {
    final Dio dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3)));

    if (!kReleaseMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        request: true,
        responseBody: true,
        responseHeader: true,
        compact: true,
        maxWidth: 120,
      ));
    }

    String token = CacheHelper.get(key: "access_token") ?? "";

    token.isNotEmpty ? dio.options.headers["Authorization"] = "Bearer $token" : null;

    return dio;
  }

  void update() => _dioInstance = initDio();

  Future<Response> get(
    String url, {
    dynamic data,
    Map<String, dynamic>? header,
    Map<String, dynamic>? json,
  }) {
    return dio!.get(url,
        data: data, queryParameters: json, options: Options(headers: header));
  }

  Future<Response> post(String url,
      {Map<String, dynamic>? header,
      Map<String, dynamic>? json,
        dynamic data}) {
    return dio!.post(url,
        data: data, queryParameters: json, options: Options(headers: header));
  }


  Future<Response> put(String url,
      {Map<String, dynamic>? header, dynamic data}) {
    return dio!.put(url, data: data, options: Options(headers: header));
  }

  Future<Response> delete(String url,
      {Map<String, dynamic>? header, dynamic data}) {
    return dio!.delete(url, data: data, options: Options(headers: header));
  }

  void setBaseUrl(String baseUrl) {
    dio!.options.baseUrl = baseUrl;
  }
}
