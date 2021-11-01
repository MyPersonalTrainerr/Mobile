import 'package:flutter/material.dart';
import 'package:my_personal_trainer/providers/exercises_provider.dart';
import 'package:my_personal_trainer/widgets/exercise_item_content.dart';
import 'package:my_personal_trainer/widgets/exersice_item.dart';
import 'package:provider/provider.dart';

class ExersiceDetailsScreen extends StatefulWidget {
  const ExersiceDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/exercise-details';

  @override
  State<ExersiceDetailsScreen> createState() => _ExersiceDetailsScreenState();
}

class _ExersiceDetailsScreenState extends State<ExersiceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments;
    final exerciseId = routeArgs;

    final exercisesData =
        Provider.of<ExercisesProvider>(context, listen: false);
    final selectedExercise = exercisesData.findItemById(exerciseId as String);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Exercise Details',
        ),
      ),
      body: ExerciseItemContent(selectedExercise),
    );
  }
}
