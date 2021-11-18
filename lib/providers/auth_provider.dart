import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token = '';

  bool get isAuth {
    return token != '';
  }

  String get token {
    return _token;
  }

  Future<void> signup(String email, String username, String password) async {
    const url = 'https://awatef.pythonanywhere.com/signUpApi/';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          "email": email,
          "password": password,
          "username": username,
        },
      );
      _token = response.body;
      notifyListeners();
      print(response.body);
    } catch (error) {
      throw error;
      print(error);
    }
  }

  Future<void> signIn(String username, String password) async {
    const url = 'https://awatef.pythonanywhere.com/signInApi/';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          "password": password,
          "username": username,
        },
      );
      _token = response.body;
      notifyListeners();
      print(response.body);
    } catch (error) {
      throw error;
      print(error);
    }
  }
}
