import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/rendering.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({
    Key? key,
    required this.audioUrl,
  }) : super(key: key);
  final audioUrl;
  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  String currentTime = "0:00:00";
  String completeTime = "0:00:00";
  // late VideoPlayerController controller;

  // late ChewieAudioController chewieAudioController = ChewieAudioController(
  //     autoInitialize: true,
  //     videoPlayerController: controller,
  //     allowMuting: false,
  //     allowPlaybackSpeedChanging: false);

  @override
  void initState() {
    super.initState();
    player.play(widget.audioUrl);
    //player.setSourceUrl(widget.audioUrl);
    //player.onAudioPositionChanged
    // player.onAudioPositionChanged.listen((Duration duration) {
    //   setState(() {
    //     currentTime = duration.toString().split(".")[0];
    //   });
    // });

    player.onDurationChanged.listen((Duration duration) {
      setState(() {
        completeTime = duration.toString().split(".")[0];
      });
    });
    // controller = VideoPlayerController.network(widget.audioUrl);
  }

  @override
  void dispose() {
    // controller.dispose();
    // chewieAudioController.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
      width: 240,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.orange[300],
        borderRadius: BorderRadius.circular(80),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        // mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              icon: Icon(
                isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                if (isPlaying) {
                  player.pause();

                  setState(() {
                    isPlaying = false;
                  });
                } else {
                  player.resume();
                  setState(() {
                    isPlaying = true;
                  });
                }
              }),
          IconButton(
            icon: Icon(
              Icons.stop,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              player.stop();

              setState(() {
                isPlaying = false;
              });
            },
          ),
          Text(
            "   " + currentTime,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            " | ",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          Text(
            completeTime,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ],
      ));
}
