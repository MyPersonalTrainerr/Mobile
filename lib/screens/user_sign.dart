import 'package:flutter/material.dart';
import 'package:my_personal_trainer/widgets/app_drawer.dart';

class UserSignScreen extends StatelessWidget {
  const UserSignScreen({Key? key}) : super(key: key);
  static const routeName = '/user-sign';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
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
                  child: Text('Sign In'),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    label: Text('Enter your email...'),
                  ),
                  onFieldSubmitted: (_) {},
                  onSaved: (value) {},
                  validator: (value) {},
                ),
                TextFormField(
                  decoration: InputDecoration(
                    label: Text('Enter your password...'),
                  ),
                  onFieldSubmitted: (_) {},
                  onSaved: (value) {},
                  validator: (value) {},
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('LOGIN'),
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
