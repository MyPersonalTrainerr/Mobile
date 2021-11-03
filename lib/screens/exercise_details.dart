import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_personal_trainer/providers/exercises_provider.dart';
import 'package:my_personal_trainer/widgets/aspect_ratio_video.dart';
import 'package:my_personal_trainer/widgets/exercise_item_content.dart';
import 'package:my_personal_trainer/widgets/video_preview.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart';

class ExersiceDetailsScreen extends StatefulWidget {
  const ExersiceDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/exercise-details';

  @override
  State<ExersiceDetailsScreen> createState() => _ExersiceDetailsScreenState();
}

class _ExersiceDetailsScreenState extends State<ExersiceDetailsScreen> {
  void _onImageButtonPressed(ImageSource source) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    }
    final XFile? file = await _picker.pickVideo(
        source: source, maxDuration: const Duration(seconds: 10));
    await _playVideo(file);
  }

  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  Future<void> _playVideo(XFile? file) async {
    if (file != null && mounted) {
      await _disposeVideoController();
      late VideoPlayerController controller;
      if (kIsWeb) {
        controller = VideoPlayerController.network(file.path);
      } else {
        controller = VideoPlayerController.file(File(file.path));
      }
      _controller = controller;
      // In web, most browsers won't honor a programmatic call to .play
      // if the video has a sound track (and is not muted).
      // Mute the video so it auto-plays in web!
      // This is not needed if the call to .play is the result of user
      // interaction (clicking on a "play" button, for example).
      final double volume = kIsWeb ? 0.0 : 1.0;
      await controller.setVolume(volume);
      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();
    }
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller!.setVolume(0.0);
      _controller!.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  Widget _previewVideo() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_controller == null) {
      return const Text(
        'Try yourself, Pick a video!',
        textAlign: TextAlign.center,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AspectRatioVideo(_controller),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      await _playVideo(response.file);
    } else {
      _retrieveDataError = response.exception!.code;
    }
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
          Center(
            child: Container(
              padding: const EdgeInsets.all(15),
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              child: VideoPreview(
                  retrieveLostData: retrieveLostData,
                  previewVideo: _previewVideo),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.gallery);
                  },
                  heroTag: 'video0',
                  tooltip: 'Pick Video from gallery',
                  child: const Icon(Icons.video_library),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.camera);
                  },
                  heroTag: 'video1',
                  tooltip: 'Take a Video',
                  child: const Icon(Icons.videocam),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


