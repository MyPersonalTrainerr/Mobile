import 'package:flutter/material.dart';
import 'package:my_personal_trainer/providers/exercises_provider.dart';
import 'package:my_personal_trainer/screens/exercise_details.dart';
import 'package:my_personal_trainer/screens/exercises_overview.dart';
import 'package:my_personal_trainer/screens/user_sign.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExercisesProvider(),
      child: MaterialApp(
          title: 'Your Personal Trainer',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
          ),
          home: ExersicesOverviewScreen(),
          routes: {
            ExersiceDetailsScreen.routeName: (context) =>
                ExersiceDetailsScreen(),
            UserSignScreen.routeName: (context) => UserSignScreen(),
          }),
    );
  }
}
