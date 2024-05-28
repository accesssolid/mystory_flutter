import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);
  final videoUrl;
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController controller;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(widget.videoUrl);
    chewieController = ChewieController(
      videoPlayerController: controller,
      allowPlaybackSpeedChanging: false,
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: Chewie(
            controller: chewieController,
          ),
        ),
      );
}
