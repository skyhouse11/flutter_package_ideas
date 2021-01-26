import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trawell/enum/http_types.dart';
import 'package:trawell/service/localization_service.dart';
import 'package:trawell/service/user_service.dart';

class HttpService {
  // Constructor
  static final String link = "https://core.dev.ai-trawell.devlits.com/api/";

  HttpService._privateConstructor();

  static final HttpService _instance = HttpService._privateConstructor();

  static HttpService get instance => _instance;

  // Link building
  String buildUrl({
    @required String path,
    Map<String, dynamic> params,
  }) {
    String returnUrl = link;
    returnUrl += path;

    if (params == null) {
      params = {};
    }
    String queryString = '';
    params.forEach(
      (
        String key,
        dynamic value,
      ) {
        queryString +=
            (queryString == '' ? '?' : '&') + key + '=' + value.toString();
      },
    );

    print('URL => ${returnUrl + queryString}');

    return returnUrl + queryString;
  }

  Future<http.Response> request(
    HttpType type, {
    @required String url,
    dynamic bodyParams,
    Map<String, dynamic> headers,
    bool toEncode = true,
    bool authenticate = true,
  }) async {
    Map<String, String> _headers = {};
    String _encodedBodyParams = "";

    if (headers != null) {
      _headers = Map.from(headers);
    }

    if (authenticate) {
      final token = await UserService.instance.userToken;

      _headers.addAll({
        "Authorization": "Bearer $token",
      });
    }

    if (toEncode) {
      _encodedBodyParams = jsonEncode(bodyParams);
    }

    _headers.putIfAbsent(
      "Accept-Language",
      () => LocalizationService.instance.currentLocale,
    );

    try {
      switch (type) {
        case HttpType.GET:
          return await http
              .get(
            url,
            headers: _headers,
          )
              .then((http.Response resp) {
            return resp;
          });

        case HttpType.POST:
          return await http
              .post(
            url,
            headers: _headers,
            body: toEncode ? _encodedBodyParams : bodyParams,
          )
              .then((http.Response resp) {
            return resp;
          });

        case HttpType.PUT:
          return await http
              .put(
            url,
            headers: _headers,
            body: toEncode ? _encodedBodyParams : bodyParams,
          )
              .then((http.Response resp) {
            return resp;
          });

        case HttpType.DELETE:
          return await http
              .delete(
            url,
            headers: _headers,
          )
              .then((http.Response resp) {
            return resp;
          });
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
