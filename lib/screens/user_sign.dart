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
        title: const Text('Account'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
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
                  autofocus: true,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(passwordFocusNode);
                  },
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    userData.add(value as String);
                  },
                  validator: (value) {
                    final bool isValid =
                        EmailValidator.validate(value as String);
                    if (!isValid) {
                      return 'Please enter a valid email adress';
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    label: const Text('Enter your password...'),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _passwordHidden = !_passwordHidden;
                        });
                      },
                      icon: Icon(
                        _passwordHidden
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  focusNode: passwordFocusNode,
                  onFieldSubmitted: (_) {
                    _saveForm();
                  },
                  textInputAction: TextInputAction.done,
                  onSaved: (value) {
                    userData.add(value as String);
                  },
                  obscureText: _passwordHidden,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a password";
                    }
                    return null;
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
