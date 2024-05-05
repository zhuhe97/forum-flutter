import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'dart:async';

import 'package:forum_app/service/services.dart';

class UserModel extends ChangeNotifier {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final Dio _dio = Dio();
  late StreamController<bool> _authStreamController;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;
  Stream<bool> get authStream => _authStreamController.stream;

  UserModel() {
    print("UserModel created");
    _authStreamController = StreamController<bool>.broadcast();
    checkLoginStatus();
  }

  Future<void> login(String email, String password) async {
    try {
      final response =
          await Services.asyncRequest('POST', '/users/login', payload: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        await _storage.write(key: 'auth_token', value: response.data['token']);
        _isLoggedIn = true;
        _authStreamController.add(true);
        notifyListeners();
      } else {
        throw Exception('Invalid username or password');
      }
    } catch (e) {
      _authStreamController.addError(e);
      throw e;
    }
  }

  Future<void> checkLoginStatus() async {
    print("Checking login status");

    String? token = await _storage.read(key: 'auth_token');
    _isLoggedIn = token != null;
    _authStreamController.add(_isLoggedIn);
    print("Login status added to stream: $_isLoggedIn");

    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    _isLoggedIn = false;
    _authStreamController.add(false);
    notifyListeners();
  }

  @override
  void dispose() {
    print('dispose!!!!!!!!!');
    _authStreamController.close();
    super.dispose();
  }
}
