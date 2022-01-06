import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:my_personal_trainer/providers/auth_provider.dart';
import 'package:my_personal_trainer/models/http_error.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'username': '',
    'password': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();
  late FocusNode passwordFocusNode;
  late FocusNode usernameFocusNode;
  late FocusNode confirmPassFocusNode;

  late bool _passwordHidden;
  late bool _confirmPassHidden;

  @override
  void initState() {
    passwordFocusNode = FocusNode();
    confirmPassFocusNode = FocusNode();
    usernameFocusNode = FocusNode();
    _passwordHidden = true;
    _confirmPassHidden = true;
    super.initState();
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    confirmPassFocusNode.dispose();
    usernameFocusNode.dispose();
    super.dispose();
  }

  void _showErrorDialog(String errorMsg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('An error Ocuured!'),
        content: Text(errorMsg),
        actions: <Widget>[
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('okay'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).signIn(
          _authData['username'] as String,
          _authData['password'] as String,
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'] as String,
          _authData['username'] as String,
          _authData['password'] as String,
        );
      }
      // }
    } on HttpError catch (error) {
      var errorMsg = error.toString();
      print(errorMsg);
      _showErrorDialog(errorMsg);
    } catch (error) {
      var errorMsg = error.toString();
      _showErrorDialog(errorMsg);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: const InputDecoration(labelText: 'E-Mail'),
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    validator: (value) {
                      final bool isValid =
                          EmailValidator.validate(value as String);
                      if (!isValid) {
                        return 'Please enter a valid email adress';
                      } else {
                        return null;
                      }
                    },
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(usernameFocusNode);
                    },
                    onSaved: (value) {
                      _authData['email'] = value as String;
                    },
                  ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Username'),
                  focusNode: usernameFocusNode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Invalid username!';
                    }
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(passwordFocusNode);
                  },
                  onSaved: (value) {
                    _authData['username'] = value as String;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
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
                  obscureText: _passwordHidden,
                  controller: _passwordController,
                  validator: (value) {
                    if (_authMode == AuthMode.Signup) {
                      if (value!.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                    }
                    if (value!.isEmpty) {
                      return "Password can't be empty!";
                    }
                  },
                  focusNode: passwordFocusNode,
                  textInputAction: _authMode == AuthMode.Signup
                      ? TextInputAction.next
                      : TextInputAction.done,
                  onFieldSubmitted: (_) {
                    if (_authMode == AuthMode.Signup) {
                      FocusScope.of(context).requestFocus(confirmPassFocusNode);
                    }
                    _submit();
                  },
                  onSaved: (value) {
                    _authData['password'] = value as String;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _confirmPassHidden = !_confirmPassHidden;
                          });
                        },
                        icon: Icon(
                          _passwordHidden
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    focusNode: confirmPassFocusNode,
                    onFieldSubmitted: (_) {
                      _submit();
                    },
                    textInputAction: TextInputAction.done,
                    obscureText: _confirmPassHidden,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button!.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
