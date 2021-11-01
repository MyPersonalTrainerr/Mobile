import 'package:flutter/material.dart';
import 'package:my_personal_trainer/providers/exercises_provider.dart';
import 'package:my_personal_trainer/widgets/exersice_item.dart';
import 'package:my_personal_trainer/screens/exersice_details.dart';
import 'package:provider/provider.dart';
import 'package:my_personal_trainer/providers/exercise.dart';

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
    );
  }
}
