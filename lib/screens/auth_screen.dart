import 'package:flutter/material.dart';
import 'package:my_personal_trainer/widgets/auth_card.dart';




class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.5),
                  Colors.amber.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          Center(
            child: Container(
              height: deviceSize.height * 0.5,
              child: AuthCard(),
            ),
          )
        ],
      ),
    );
  }
}


