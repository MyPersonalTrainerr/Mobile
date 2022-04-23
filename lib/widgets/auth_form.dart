import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:my_personal_trainer/providers/auth_provider.dart';
import 'package:my_personal_trainer/models/http_error.dart';

enum AuthMode { Signup, Login }

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
    print(_authMode);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return
        // SingleChildScrollView(
        // child:
        Container(
      margin: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(60),
            child: const Text(
              "Welcome!",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: _authMode == AuthMode.Signup
                ? deviceSize.height * 0.38
                : deviceSize.height * 0.23,
            child: Stack(
              children: [
                Container(
                  // height:
                  // margin: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 20.0,
                          offset: Offset(0, 10))
                      //   color: Colors.grey.withOpacity(0.5),
                      //   spreadRadius: 0,
                      //   blurRadius: 10,
                      //   offset: const Offset(0, 4),
                      // ),
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      if (_authMode == AuthMode.Signup)
                        Container(
                          margin: const EdgeInsets.only(left: 16, right: 32),
                          child: TextFormField(
                            enabled: _authMode == AuthMode.Signup,
                            decoration:
                                const InputDecoration(labelText: 'Username'),
                            keyboardType: TextInputType.emailAddress,
                            autofocus: true,
                            validator: (value) =>
                                EmailFieldValidator.validate(value),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(usernameFocusNode);
                            },
                            onSaved: (value) {
                              _authData['email'] = value as String;
                            },
                          ),
                        ),
                      //   child: const TextField(
                      //     decoration: InputDecoration(
                      //       hintStyle: TextStyle(fontSize: 20),
                      //       border: InputBorder.none,
                      //       icon: Icon(Icons.account_circle_rounded),
                      //       hintText: "Username",
                      //     ),
                      //   ),
                      // ),
                      Container(
                        margin: const EdgeInsets.only(left: 16, right: 32),
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'Email'),
                          focusNode: usernameFocusNode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Invalid Email Address!';
                            }
                          },
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(passwordFocusNode);
                          },
                          onSaved: (value) {
                            _authData['username'] = value as String;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 16, right: 32),
                        child: TextFormField(
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
                              FocusScope.of(context)
                                  .requestFocus(confirmPassFocusNode);
                            }
                            _submit();
                          },
                          onSaved: (value) {
                            _authData['password'] = value as String;
                          },
                        ),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.only(left: 16, right: 32),
                      //   child: const TextField(
                      //     obscureText: true,
                      //     decoration: InputDecoration(
                      //       hintStyle: TextStyle(fontSize: 22),
                      //       border: InputBorder.none,
                      //       icon: Icon(Icons.account_circle_rounded),
                      //       hintText: "********",
                      //     ),
                      //   ),
                      // ),
                      if (_authMode == AuthMode.Signup)
                        Container(
                          margin: const EdgeInsets.only(left: 16, right: 32),
                          child: TextFormField(
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
                        ),
                    ],
                  ),
                ),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: Container(
                //     margin: const EdgeInsets.only(right: 15),
                //     height: 80,
                //     width: 80,
                //     decoration: BoxDecoration(
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.green[200]!.withOpacity(0.5),
                //           spreadRadius: 5,
                //           blurRadius: 7,
                //           offset: const Offset(0, 3),
                //         ),
                //       ],
                //       shape: BoxShape.circle,
                //       gradient: const LinearGradient(
                //         begin: Alignment.centerLeft,
                //         end: Alignment.centerRight,
                //         colors: [
                //           Color(0xff1bccba),
                //           Color(0xff22e2ab),
                //         ],
                //       ),
                //     ),
                //     child: const Icon(
                //       Icons.arrow_forward_outlined,
                //       color: Colors.white,
                //       size: 32,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: _submit,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(143, 148, 251, .2),
                    Color.fromRGBO(143, 148, 251, .4),
                    // Color(0xff0ce8f9),
                    // Color(0xff45b7fe),
                  ])),
              child: Center(
                child: Text(
                  _authMode == AuthMode.Login ? 'Login' : 'Signup',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Container(
          //       margin: const EdgeInsets.only(right: 16, top: 16),
          //       child: Text(
          //         "Forgot ?",
          //         style: TextStyle(
          //           fontSize: 20,
          //           fontWeight: FontWeight.w600,
          //           color: Colors.grey[400],
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _switchAuthMode,
                child: Container(
                  margin: const EdgeInsets.only(left: 16, top: 24),
                  child: Text(
                    '${_authMode == AuthMode.Login ? "Don't have account? Signup instead!" : 'Login'}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(51, 6, 6, 17),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
        // ),
      ),
    );
  }
}

class EmailFieldValidator {
  static dynamic validate(value) {
    final bool isValid = EmailValidator.validate(value as String);
    if (!isValid) {
      return 'Please enter a valid email adress';
    } else {
      return null;
    }
  }
}
