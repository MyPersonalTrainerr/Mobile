import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_personal_trainer/widgets/app_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserSignScreen extends StatefulWidget {
  const UserSignScreen({Key? key}) : super(key: key);
  static const routeName = '/user-sign';

  @override
  State<UserSignScreen> createState() => _UserSignScreenState();
}

class _UserSignScreenState extends State<UserSignScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> userData = [];

  void _postRequest(List data) async {
    const url = "http://192.168.1.4:8000/Test";
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(data),
    );
  }

  Future<List<dynamic>> _fetchTaks() async {
    const url = "http://192.168.1.4:8000/Test";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      return data;
    } else {
      return [];
    }
  }

  void _saveForm() {
    _formKey.currentState!.save();
    _postRequest(userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          IconButton(
            onPressed: () => _saveForm(),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.7,
          child: Card(
            elevation: 5,
            child: Column(
              children: <Widget>[
                Container(
                  child: const Text('Sign In'),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Enter your email...'),
                  ),
                  onFieldSubmitted: (_) {},
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    userData.add(value as String);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Enter your password...'),
                  ),
                  onFieldSubmitted: (_) {
                    _saveForm();
                  },
                  textInputAction: TextInputAction.done,
                  onSaved: (value) {
                    userData.add(value as String);
                  },
                ),
                TextButton(
                  onPressed: _saveForm,
                  child: const Text('LOGIN'),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
