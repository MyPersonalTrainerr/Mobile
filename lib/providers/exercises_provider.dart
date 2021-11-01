import 'package:flutter/material.dart';
import 'package:my_personal_trainer/providers/exercise.dart';
import 'package:my_personal_trainer/providers/exercises_provider.dart';
import 'package:provider/provider.dart';

class ExercisesProvider with ChangeNotifier {
  List<Exercise> _items = [
    Exercise(
      id: 'w1',
      title: 'Squat',
      imageUrl: 'images/squat.jpg',
    ),
    Exercise(
      id: 'w2',
      title: 'Push Up',
      imageUrl: 'images/pushup.jpg',
    ),
    Exercise(
      id: 'w3',
      title: 'Split',
      imageUrl: 'images/split.jpg',
    ),
  ];

  List<Exercise> get items {
    return [..._items];
  }

  Exercise findItemById(String exerciseId) {
    return _items.firstWhere((item) => item.id == exerciseId);
  }

  
}
