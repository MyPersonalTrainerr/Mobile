import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_personal_trainer/providers/exercises_provider.dart';
import 'package:my_personal_trainer/widgets/exercise_item_content.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ExersiceDetailsScreen extends StatefulWidget {
  const ExersiceDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/exercise-details';

  @override
  State<ExersiceDetailsScreen> createState() => _ExersiceDetailsScreenState();
}

class _ExersiceDetailsScreenState extends State<ExersiceDetailsScreen> {
  Future<void> takePicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? video = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: Duration(seconds: 3),
    );
    final File videoFile = File(video!.path);
    final appDirectory = await syspaths.getApplicationDocumentsDirectory();
    final videoName = path.basename(video.path);
    final savedVideo = await videoFile.copy('${appDirectory.path}/$videoName');
  }

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
      body: Column(
        children: <Widget>[
          ExerciseItemContent(selectedExercise),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Try Yourself'),
                Card(
                  elevation: 5,
                  child: IconButton(
                    onPressed: takePicture,
                    icon: Icon(Icons.video_camera_back_outlined),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
