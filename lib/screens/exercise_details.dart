import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_personal_trainer/models/my_painter.dart';
import 'package:my_personal_trainer/providers/exercises_provider.dart';
import 'package:my_personal_trainer/widgets/aspect_ratio_video.dart';
import 'package:my_personal_trainer/widgets/exercise_item_content.dart';
import 'package:my_personal_trainer/widgets/video_preview.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExersiceDetailsScreen extends StatefulWidget {
  const ExersiceDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/exercise-details';

  @override
  State<ExersiceDetailsScreen> createState() => _ExersiceDetailsScreenState();
}

class _ExersiceDetailsScreenState extends State<ExersiceDetailsScreen> {
  XFile? _file;
  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;
  bool _uploaded = false;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  List<Map> jsonList = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("django/env/Backend/MyPersonalTrainer/Points.json");
    List jsonData = json.decode(data);
    // print(jsonData);
    jsonData.forEach((element) {
      element.forEach((key, value) {
        jsonList.add(value);
      });
    });
    print(jsonList.length);
  }

  void _showErrorDialog(String errorMsg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('An error Ocuured!'),
        content: Text(errorMsg),
        actions: <Widget>[
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('okay'),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadFile(XFile file) async {
    var uri = Uri.parse('http://192.168.1.4:8000/fileUploadApi/');
    // var uri = Uri.parse('http://awatef.pythonanywhere.com/fileUploadApi/');
    // try {
    var filename = file.path;
    var request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('file_uploaded', filename));
    var response = await request.send();
    print(json.decode(response.toString()));
    if (response.statusCode == 200) {
      print('Uploaded!');
      _uploaded = true;
    }
    // } catch (error) {
    //   var errorMsg = "Can't conncet to the Server! Try again later.";
    //   _showErrorDialog(errorMsg);
    // }
  }

  void _onImageButtonPressed(ImageSource source) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    }
    _file = await _picker.pickVideo(
        source: source, maxDuration: const Duration(seconds: 3));
    // await _uploadFile(_file as XFile);
    await _playVideo(_file);
    await _uploadFile(_file as XFile);
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
      return Text(
        'Try yourself, Pick a video!',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      );
    }
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

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments;
    final exerciseId = routeArgs;

    final exercisesData =
        Provider.of<ExercisesProvider>(context, listen: false);
    final selectedExercise = exercisesData.findItemById(exerciseId as String);

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Exercise Details',
        ),
        // actions: <Widget>[
        //   IconButton(
        //     onPressed: () async {
        //       _uploadFile(_file as XFile);
        //     },
        //     icon: Icon(Icons.save),
        //   ),
        // ],
      ),
      body: Column(
        children: <Widget>[
          ExerciseItemContent(selectedExercise),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: FloatingActionButton(
                        // backgroundColor: Theme.of(context).primaryColor,
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
                        // backgroundColor: Theme.of(context).primaryColor,
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
              ),
              Container(
                margin: EdgeInsets.all(5),
                child: Card(
                  elevation: 5,
                  child: Container(
                    // color: Colors.grey.shade400,
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      width: width * 0.65,
                      height: height * 0.5,
                      child: Stack(
                        children: <Widget>[
                          VideoPreview(
                            retrieveLostData: retrieveLostData,
                            previewVideo: _previewVideo,
                          ),
                          Stack(
                              children: jsonList
                                  .map((element) => CustomPaint(
                                        painter: CirclePainter(
                                          x: element['x'] * width,
                                          y: element['y'] * height,
                                        ),
                                      ))
                                  .toList()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
