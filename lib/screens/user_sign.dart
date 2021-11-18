import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_personal_trainer/widgets/app_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:email_validator/email_validator.dart';

class UserSignScreen extends StatefulWidget {
  const UserSignScreen({Key? key}) : super(key: key);
  static const routeName = '/user-sign';

  @override
  State<UserSignScreen> createState() => _UserSignScreenState();
}

class _UserSignScreenState extends State<UserSignScreen> {
  late FocusNode passwordFocusNode;
  final _formKey = GlobalKey<FormState>();
  final List<String> userData = [];
  late bool _passwordHidden;

  @override
  void initState() {
    passwordFocusNode = FocusNode();
    _passwordHidden = true;
    super.initState();
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    super.dispose();
  }

  void _postRequest(List data) async {
    const url = "https://awatef.pythonanywhere.com/signUpApi/";
    final response = await http.post(
      Uri.parse(url),
      body: {
        "email": data[0],
        "username": "khhhh",
        "password": data[1],
      },
    );
  }

  Future<List<dynamic>> _fetchRequest() async {
    const url = "https://awatef.pythonanywhere.com/signUpApi/l";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      return data;
    } else {
      return [];
    }
  }

  void _saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      _postRequest(userData);
      print(userData);
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Account'),
      ),
      drawer: AppDrawer(),
    );
  }
}
