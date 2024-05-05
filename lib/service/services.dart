// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('Sending request to ${options.uri.toString()}');

    String? token = await _storage.read(key: 'auth_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Common-Header'] = 'common-value';
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('Received response for ${response.requestOptions.uri.toString()}');
    if (response.statusCode != 200) {
      print("Unexpected status code: ${response.statusCode}");
    }
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('Error occurred: ${err.message}');
    print('Error type: ${err.type}');
    handler.next(err);
  }
}

class Services {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: "http://10.0.2.2:8888/api/v1",
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  Services() {
    _dio.interceptors.add(CustomInterceptor());
    _dio.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: true));
  }

  static dynamic asyncRequest(String method, String url,
      {dynamic payload, Map<String, dynamic>? params, String? otp}) async {
    try {
      Response? response;
      switch (method) {
        case 'POST':
          response = await _dio.post<dynamic>(url,
              queryParameters: params, data: payload);

          break;
        case 'GET':
          response = await _dio.get<dynamic>(
            url,
            queryParameters: params,
          );

          break;
        case 'PUT':
          response = await _dio.put<dynamic>(url,
              queryParameters: params, data: payload);

          break;
        case 'DELETE':
          response = await _dio.delete<dynamic>(
            url,
            queryParameters: params,
          );

          break;
      }
      return response;
    } on DioError catch (error) {
      //get error code and msg
      String message = 'Unknown error occurred';
      String code = error.response?.statusCode.toString() ?? 'Unknown status';

      if (error.response?.data != null) {
        try {
          Map<String, dynamic> errorData = error.response!.data is String
              ? json.decode(error.response!.data)
              : error.response!.data;

          message = errorData['reason'] ?? errorData['error'] ?? message;
        } catch (e) {
          print('Failed to parse error response: $e');
          message = 'Error parsing response';
        }
      }

      // if (code == '403') {
      //   Navigator.pushNamed(context, '/login');
      // }

      // show error code and msg to users
      Fluttertoast.showToast(
          msg: '$code: $message',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 18.0);
      rethrow;
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'unknown error',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 18.0);
    }
  }
}
