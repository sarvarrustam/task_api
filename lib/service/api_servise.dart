import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:task_api/models/post_model.dart';

class DioServise {
  static final _dio = Dio(BaseOptions(
      baseUrl: _Urls.base,
      headers: {
        "Authorization": "Client-ID mT8hj53DywChJkbscZAN5aHio9v2M9impW_i-VIc7vs"
      },
      sendTimeout: 5000,
      connectTimeout: 15000,
      receiveTimeout: 15000));

  static Future<Post?> getPostResponse() async {
    try {
      final response = await _dio.getUri(Uri.tryParse(_Urls.api)!);
      if (response.statusCode == 200) {
        debugPrint(response.data.toString());
        return Post.fromJson(response.data);
      }
      return Post.fromJson({});
    } on DioError catch (e) {
      log(e.toString());
    }
    return Post.fromJson({});
  }
}

class _Urls {
  static const base = 'https://api.unsplash.com';
  static const api = '/photos/random';
}
