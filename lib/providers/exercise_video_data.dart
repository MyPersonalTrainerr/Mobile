import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:my_personal_trainer/value_notifiers/value_notifiers.dart';
import 'dart:convert';

class ExcerciseVideoData with ChangeNotifier {
  Future<void> uploadFile(XFile file) async {
    var uri = Uri.parse('http://192.168.1.7:8000/fileUploadApi/');
    // var uri = Uri.parse('http://awatef.pythonanywhere.com/fileUploadApi/');
    // try {
    var filename = file.path;
    var request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('file_uploaded', filename));
    // await Future.delayed(Duration(seconds: 5));
    var response = await request.send();

    // print('response is ${json.decode(response.toString())}');
    // if (response.statusCode == 200) {
    print('Uploaded!');
    videoUploaded.value = true;
    // }
    // } catch (error) {
    //   var errorMsg = "Can't conncet to the Server! Try again later.";
    //   _showErrorDialog(errorMsg);
    // }
  }

  Future<void> getData(
      double width, double height, BuildContext context) async {
    final videoData = Provider.of<ExcerciseVideoData>(context, listen: false);
    List<Offset> jsonList = [];
    String path = "django/env/Backend/MyPersonalTrainer/Points.json";
    String data = await DefaultAssetBundle.of(context).loadString(path);
    var jsonData = await json.decode(data);
    jsonData.forEach((frame) {
      frame.forEach((point, value) {
        var globalPos = Offset(
            ((value['x'] * 1.19)-5).toDouble(), (value['y'] * 1.19).toDouble());
        jsonList.add(globalPos);
      });
    });
    print('legnth of data is ${jsonList.length}');
    print("Json list is $jsonList");
    var remaining = jsonList.length;
    frame.value.clear();
    List<Offset> currentFrame;
    for (var i = 0; i < jsonList.length; i = i + 33) {
      currentFrame = [];
      for (var j = i; j <= (i + 32); j++) {
        if (remaining < 32) {
          for (var k = 0; k < remaining; k++) {
            currentFrame.add(jsonList[k]);
          }
        } else {
          currentFrame.add(jsonList[j]);
        }
      }
      frame.value = currentFrame;
      remaining = remaining - 32;
      print("Frame list in get function $frame.value");
      await Future.delayed(Duration(milliseconds: 33));
    }
    // frame.value.clear();
  }
}
