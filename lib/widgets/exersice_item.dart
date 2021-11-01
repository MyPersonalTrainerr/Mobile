import 'package:flutter/material.dart';
import 'package:my_personal_trainer/providers/exercise.dart';
import 'package:my_personal_trainer/screens/exersice_details.dart';
import 'package:my_personal_trainer/widgets/exercise_item_content.dart';
import 'package:provider/provider.dart';

class ExerciseItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final exerciseData = Provider.of<Exercise>(context, listen: false);

    return ChangeNotifierProvider.value(
      value: exerciseData,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
            ExersiceDetailsScreen.routeName,
            arguments: exerciseData.id),
        child: ExerciseItemContent(exerciseData),
      ),
    );
  }
}
