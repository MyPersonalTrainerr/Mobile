import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:my_personal_trainer/models/http_error.dart';

class Auth with ChangeNotifier {
  String _token = '';

  bool get isAuth {
    return _token != '';
  }

  // String get token {
  //   if (_token != '') {
  //     return _token;
  //   }
  //   return '';
  // }

  Future<void> signup(String email, String username, String password) async {
    // const url = 'http://192.168.1.2:8000/signUpApi/';
    const url = 'http://awatef.pythonanywhere.com/registration/';
    // try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        "email": email,
        "password": password,
        "username": username,
      },
    );
    final responseData = response.body;
    if (!responseData.contains("key")) {
      _token = '';
      throw HttpError(responseData);
    } else {
      _token = responseData;
    }
    notifyListeners();
    print("TOKEN IS: $_token");
    // } catch(Invalid) {
    //   rethrow;
    // }
  }

  Future<void> signIn(String username, String password) async {
    // const url = 'http://192.168.1.2:8000/rest-auth/login/';
    const url = 'http://awatef.pythonanywhere.com/rest-auth/login/';

    // try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        "password": password,
        "username": username,
      },
    );
    final responseData = response.body;
    if (!responseData.contains("key")) {
      _token = '';
      throw HttpError(responseData);
    } else {
      _token = responseData;
    }
    print("TOKEN IS: $_token");
    print(responseData);
    print(isAuth);
    notifyListeners();
    // } catch (error) {
    //   rethrow;
    // }
  }
}
