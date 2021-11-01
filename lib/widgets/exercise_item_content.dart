import 'package:flutter/material.dart';
import 'package:my_personal_trainer/providers/exercise.dart';

class ExerciseItemContent extends StatelessWidget {
  final Exercise exerciseData;
  ExerciseItemContent(this.exerciseData);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(5),
          child: Text(
            exerciseData.title,
          ),
        ),
        Card(
          margin: const EdgeInsets.all(15),
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              exerciseData.imageUrl,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}
