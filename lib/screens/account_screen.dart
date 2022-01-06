import 'package:flutter/material.dart';
import 'package:my_personal_trainer/widgets/app_drawer.dart';


class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);
  static const routeName = '/user-sign';

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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
