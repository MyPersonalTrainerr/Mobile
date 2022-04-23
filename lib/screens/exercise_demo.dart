// import 'dart:html';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:my_personal_trainer/screens/exercise_details.dart';
// import 'package:my_personal_trainer/value_notifiers/value_notifiers.dart';
// import 'package:my_personal_trainer/widgets/position_custom_paint.dart';
// import 'package:path/path.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';

// class ExerciseDemo extends StatefulWidget {
//   const ExerciseDemo({Key? key}) : super(key: key);
//   static const routeName = '/exercise-demo';
//   @override
//   State<ExerciseDemo> createState() => _ExerciseDemoState();
// }

// class _ExerciseDemoState extends State<ExerciseDemo> {
//   VideoPlayerController? controller;
//   final ImagePicker picker = ImagePicker();
//   XFile? file;

//   void _onImageButtonPressed(ImageSource source, double height, double width,
//       Function uploadFile, Function getData, BuildContext context) async {
//     if (controller != null) {
//       await controller!.setVolume(0.0);
//     }
//     file = await picker.pickVideo(
//         source: source, maxDuration: const Duration(seconds: 10));
//     print("upload?");
//     await uploadFile(file as XFile);

//     // Navigator.push(
//     //   context,
//     //   MaterialPageRoute(
//     //     builder: (context) => ExersiceDetailsScreen(
//     //         controller: controller, file: file, picker: picker),
//     //   ),
//     // );
//     // await _playVideo(_file);
//     // drawing.value = true;
//     // await getData(width, height, context);
//     // print("drawing in main ${drawing.value}");
//   }

//   @override
//   Widget build(BuildContext context) {
//     final videoData = Provider.of<ExcerciseVideoData>(context, listen: false);
//     final double height = MediaQuery.of(context).size.height;
//     final double width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "LET'S DO IT!",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Column(
//         children: [
//           Container(
//             height: height * 0.7,
//             child: Image.asset('images/squat_demo.gif', fit: BoxFit.cover),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 child: Text("OPEN YOUR CAMERA"),
//                 onPressed: () {
//                   // showModalBottomSheet<void>(
//                   //     context: context,
//                   //     builder: (BuildContext context) {
//                   //       return Container(
//                   //         height: 200,
//                   //       );
//                   //     });
//                   _onImageButtonPressed(ImageSource.camera, height, width,
//                       videoData.uploadFile, videoData.getData, context);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ExersiceDetailsScreen(
//                           controller: controller, file: file, picker: picker),
//                     ),
//                   );
//                 },
//                 style: ButtonStyle(),
//               ),
//               ElevatedButton(
//                   child: Text("CHOOSE LOCAL VIDEO"),
//                   onPressed: () async {
//                     // showModalBottomSheet<void>(
//                     //     context: context,
//                     //     builder: (BuildContext context) {
//                     //       return Container(
//                     //         height: 200,
//                     //       );
//                     //     });
//                     _onImageButtonPressed(ImageSource.gallery, height, width,
//                         videoData.uploadFile, videoData.getData, context);
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ExersiceDetailsScreen(
//                               controller: controller,
//                               file: file,
//                               picker: picker),
//                         ));
//                   }),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
