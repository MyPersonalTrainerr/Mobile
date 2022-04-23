import 'package:flutter/material.dart';
import 'package:my_personal_trainer/providers/exercise.dart';

class ExerciseItemContent extends StatefulWidget {
  final Exercise exerciseData;
  ExerciseItemContent(this.exerciseData);

  @override
  State<ExerciseItemContent> createState() => _ExerciseItemContentState();
}

class _ExerciseItemContentState extends State<ExerciseItemContent> {
  var _isLoading = false;

  // Future<void> _loadImage(){
  // }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      // shape:
      //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            // borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              widget.exerciseData.imageUrl,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            bottom: 25,
            right: 5,
            child: Container(
              width: 300,
              child: Text(
                widget.exerciseData.title,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        ],
      ),
    );
  }
}