import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class VideoPreview extends StatefulWidget {
  // const VideoPreview({Key? key}) : super(key: key);

  final Function retrieveLostData;
  final Function previewVideo;

  VideoPreview({required this.retrieveLostData, required this.previewVideo});

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  @override
  Widget build(BuildContext context) {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? FutureBuilder<void>(
            future: widget.retrieveLostData(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Text(
                    'Please Pick a video.',
                    textAlign: TextAlign.center,
                  );
                case ConnectionState.done:
                  return widget.previewVideo();
                default:
                  if (snapshot.hasError) {
                    return Text(
                      'Pick video error: ${snapshot.error}}',
                      textAlign: TextAlign.center,
                    );
                  } else {
                    return const Text(
                      'Please Pick a video.',
                      textAlign: TextAlign.center,
                    );
                  }
              }
            },
          )
        : widget.previewVideo();
  }
}
