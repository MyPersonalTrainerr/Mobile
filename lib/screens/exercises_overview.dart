import 'package:flutter/material.dart';
import 'package:my_personal_trainer/providers/exercises_provider.dart';
import 'package:my_personal_trainer/widgets/app_drawer.dart';
import 'package:my_personal_trainer/widgets/exersice_item.dart';
import 'package:provider/provider.dart';

class ExersicesOverviewScreen extends StatelessWidget {
  const ExersicesOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final exercisesData =
        Provider.of<ExercisesProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Personal Trainer'),
      ),
      body: ListView.builder(
        itemBuilder: (context, idx) {
          return ChangeNotifierProvider.value(
            value: exercisesData.items[idx], child: ExerciseItem(),);
        },
        itemCount: exercisesData.items.length,
      ),
      drawer: AppDrawer(),
    );
  }
}
