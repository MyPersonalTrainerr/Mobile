import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_personal_trainer/providers/exercise_video_data.dart';
import 'package:my_personal_trainer/value_notifiers/value_notifiers.dart';
import 'package:my_personal_trainer/widgets/position_custom_paint.dart';
import 'package:my_personal_trainer/providers/exercises_provider.dart';
import 'package:my_personal_trainer/widgets/aspect_ratio_video.dart';
import 'package:my_personal_trainer/widgets/video_preview.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart';

class ExersiceDetailsScreen extends StatefulWidget {
  static const routeName = '/exercise-details';
  // VideoPlayerController? controller;
  // XFile? file;
  // final ImagePicker picker;
  // VideoPlayerController? _toBeDisposed;
  // String? _retrieveDataError;
  // final TextEditingController maxWidthController;
  // final TextEditingController maxHeightController;
  // final TextEditingController qualityController;

  // ExersiceDetailsScreen({
  // required this.controller,
  // required this.file,
  // required this.picker,
  // required this._toBeDisposed,
  // required this._retrieveDataError,
  // required this.maxHeightController,
  // required this.maxWidthController,
  // required this.qualityController,
  // });

  @override
  State<ExersiceDetailsScreen> createState() => _ExersiceDetailsScreenState();
}

class _ExersiceDetailsScreenState extends State<ExersiceDetailsScreen> {
  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  final ImagePicker _picker = ImagePicker();
  XFile? _file;
  String? _retrieveDataError;
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  bool isUploading = false;

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
    // _disposeVideoController();
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
      await controller.setLooping(false);
      await controller.play();
      setState(() {});
    }
  }

  void _onImageButtonPressed(ImageSource source, double height, double width,
      Function uploadFile, Function getData, BuildContext context) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    }
    _file = await _picker.pickVideo(
        source: source, maxDuration: const Duration(seconds: 10));
    print("upload?");
    await uploadFile(_file as XFile);
    // await Future.delayed(Duration(seconds: 1));
    setState(() {
      isUploading = false;
    });
    await _playVideo(_file);
    drawing.value = true;
    await getData(width, height, context);
    print("drawing in main ${drawing.value}");
  }

  Widget _previewVideo() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    // if (widget.controller == null) {
    //   return const Text(
    //     'Try yourself, Pick a video!',
    //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //     textAlign: TextAlign.center,
    //   );
    // }
    return AspectRatioVideo(_controller);
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

  // AppBar appBarWidget(
  //     double height, double width, Function uploadFile, Function getData) {
  //   AppBar appBar = AppBar(
  //     title: Text(
  //       "LET'S DO IT!",
  //       style: TextStyle(fontWeight: FontWeight.bold),
  //     ),
  //     actions: <Widget>[
  // IconButton(
  //   onPressed: () async {
  //     setState(() {});
  //     _onImageButtonPressed(
  //         ImageSource.gallery, height, width, uploadFile, getData);
  //     await uploadFile(_file as XFile);
  //     await _playVideo(_file);
  //     drawing.value = true;
  //     await getData(width, height, context);
  //     print("drawing in main ${drawing.value}");
  //   },
  //   icon: const Icon(Icons.video_library),
  // ),
  // IconButton(
  //   onPressed: () {
  //     setState(() {});
  //     _onImageButtonPressed(
  //         ImageSource.camera, height, width, uploadFile, getData);
  //   },
  //   icon: const Icon(Icons.videocam),
  // ),
  // IconButton(
  //   onPressed: () async {
  //56 for appBar
  // drawing.value = true;
  // print("drawing in main ${drawing.value}");
  // videoData.getData(width, height - 56, context);
  // await Future.delayed(Duration(seconds: 5));
  // },
  // icon: const Icon(Icons.run_circle),
  // ),
  // ],
  // );
  // final double appBarHeight = appBar.preferredSize.height;
  // print("appbar height is $appBarHeight");
  // return appBar;
  // }

  @override
  Widget build(BuildContext context) {
    // final videoFileProvider =
    //     Provider.of<ExerciseVideo>(context, listen: false);
    // XFile videoFile = videoFileProvider.getVideoFile;

    // final routeArgs = ModalRoute.of(context)!.settings.arguments;
    // final exerciseId = routeArgs;

    // final exercisesData =
    // Provider.of<ExercisesProvider>(context, listen: false);
    // final selectedExercise = exercisesData.findItemById(exerciseId as String);

    final videoData = Provider.of<ExcerciseVideoData>(context, listen: false);
    final AppBar appBar = AppBar(
      title: Text(
        "LET'S DO IT!",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appBar,
      body: Container(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // ExerciseItemContent(selectedExercise),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(143, 148, 251, .2),
                    Color.fromRGBO(143, 148, 251, .4),
                  ],
                ),
              ),
              width: width,
              height: height -
                  (appBar.preferredSize.height +
                      MediaQuery.of(context).viewPadding.top),
              child: isUploading
                  ? Container(
                      // height: height,
                      // width: width,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "GETTING YOUR RESULTS READY.. PLEASE WAIT..",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          CircularProgressIndicator(strokeWidth: 7),
                        ],
                      ))
                  : Container(
                      height: height,
                      // width: width,
                    child: Stack(
                        children: <Widget>[
                          Card(
                            // elevation: 5,
                            child: Container(
                                width: width,
                              height: height,
                              child: ValueListenableBuilder(
                                  valueListenable: videoUploaded,
                                  builder: (BuildContext context, bool isUploaded,
                                      __) {
                                    if (isUploaded) {
                                      return VideoPreview(
                                        retrieveLostData: retrieveLostData,
                                        previewVideo: _previewVideo,
                                      );
                                    } else {
                                      return Container(
                                        height: height,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              height: height * 0.7,
                                              child: Image.asset(
                                                  'images/squat_demo.gif',
                                                  fit: BoxFit.cover),
                                            ),
                                            // SizedBox(
                                            //                             height: height * 0.2,
                                            // child:
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                    child:
                                                        Text("OPEN YOUR CAMERA"),
                                                    onPressed: () async {
                                                      setState(() {
                                                        isUploading = true;
                                                      });
                                                      _onImageButtonPressed(
                                                          ImageSource.camera,
                                                          height,
                                                          width,
                                                          videoData.uploadFile,
                                                          videoData.getData,
                                                          context);
                                                    }),
                                                ElevatedButton(
                                                    child: Text(
                                                        "CHOOSE LOCAL VIDEO"),
                                                    onPressed: () async {
                                                      setState(() {
                                                        isUploading = true;
                                                      });
                                                      _onImageButtonPressed(
                                                          ImageSource.gallery,
                                                          height,
                                                          width,
                                                          videoData.uploadFile,
                                                          videoData.getData,
                                                          context);
                                                    }),
                                              ],
                                            ),
                                            // ),
                                          ],
                                        ),
                                      );
                                    }
                                  }),
                            ),
                          ),
                          PositionCustomPaint(),
                        ],
                      ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
