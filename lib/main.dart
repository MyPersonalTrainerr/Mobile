import 'package:flutter/material.dart';
import 'package:my_personal_trainer/providers/auth_provider.dart';
import 'package:my_personal_trainer/providers/exercises_provider.dart';
import 'package:my_personal_trainer/screens/auth_screen.dart';
import 'package:my_personal_trainer/screens/exercise_details.dart';
import 'package:my_personal_trainer/screens/exercises_overview.dart';
import 'package:my_personal_trainer/screens/account_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ExercisesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, _) => MaterialApp(
            title: 'Your Personal Trainer',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.amber,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.purple,
              accentColor: Colors.amber,
            ),
            home: authData.isAuth ? ExersicesOverviewScreen() : AuthScreen(),
            // home: ExersicesOverviewScreen(),
            routes: {
              ExersiceDetailsScreen.routeName: (context) =>
                  ExersiceDetailsScreen(),
              AccountScreen.routeName: (context) => AccountScreen(),
            }),
      ),
    );
  }
}
