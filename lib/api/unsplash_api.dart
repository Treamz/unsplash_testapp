import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:unsplash_testapp/api/unsplash_image.dart';

abstract class RestAPI {
  void _checkStatusCode(int statusCode) {
    if (statusCode > 400 || statusCode < 200 || json == null) {
      throw new Exception("[RestAPI]: Error to fetch data!");
    }
  }

  Future<dynamic> get(String url, Map<String, String> headers) async {
    final response = await http.get(url, headers: headers);
    _checkStatusCode(response.statusCode);

    return json.decode(response.body);
  }
}

class UnsplashAPI extends RestAPI {
  UnsplashAPI._internal();

  static final UnsplashAPI _instance = UnsplashAPI._internal();

  factory UnsplashAPI() => _instance;

  static const baseUrl = 'https://api.unsplash.com/';
  final _baseHeaders = {
    'Accept-Version': 'v1',
    'Authorization':
        'Client-ID 896d4f52c589547b2134bd75ed48742db637fa51810b49b607e37e46ab2c0043'
  };

  Future<List<UnsplashImage>> getPictures(int count, [int page]) async {
    final String url = baseUrl +
        (page == null
            ? '/photos/random?count=$count'
            : 'photos?page=$page&per_page=$count');

    List<UnsplashImage> result = List();

    final Object responseJSON = await get(url, _baseHeaders) as Iterable;

    for (var img in responseJSON) result.add(UnsplashImage.fromJson(img));

    return result;
  }
}
