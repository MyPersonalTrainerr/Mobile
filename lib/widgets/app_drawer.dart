import 'package:flutter/material.dart';
import 'package:my_personal_trainer/screens/account_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Keep It Up!'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.line_weight),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
            title: const Text('Exercises'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AccountScreen.routeName);
            },
            title: const Text('Account'),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
