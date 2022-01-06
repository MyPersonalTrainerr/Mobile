import 'package:flutter/material.dart';
import 'package:my_personal_trainer/providers/exercise.dart';
import 'package:my_personal_trainer/providers/exercises_provider.dart';
import 'package:provider/provider.dart';

class ExercisesProvider with ChangeNotifier {
  List<Exercise> _items = [
    Exercise(
      id: 'w1',
      title: 'Push Up',
      imageUrl: 'https://acewebcontent.azureedge.net/blogs/2019-AI_04_09-PerfectingPushUps_header.jpg',
    ),
    Exercise(
      id: 'w3',
      title: 'Split',
      imageUrl: 'https://www.yogiapproved.com/wp-content/uploads/2018/01/stretches-for-splits.jpg',
    ),
    Exercise(
      id: 'w4',
      title: 'lunges',
      imageUrl: 'https://s32933.pcdn.co/en-SG/blog/wp-content/uploads/2020/10/Lunge-for-runners.png',
    ),
    Exercise(
      id: 'w2',
      title: 'Squat',
      imageUrl: 'https://media.self.com/photos/5ea9bc77bb9c6b75996c7e91/16:9/w_4510,h_2537,c_limit/squats_woman_exercise.jpg',
    ),
  ];

  List<Exercise> get items {
    return [..._items];
  }

  Exercise findItemById(String exerciseId) {
    return _items.firstWhere((item) => item.id == exerciseId);
  }

  
}
