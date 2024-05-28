// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:chewie/chewie.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:path_provider/path_provider.dart';

// import 'package:video_player/video_player.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';

// class CreatedStoryVideo extends StatefulWidget {
//   final img;
//   CreatedStoryVideo({this.img});

//   @override
//   State<StatefulWidget> createState() {
//     return _CreatedStoryVideoState();
//   }
// }

// class _CreatedStoryVideoState extends State<CreatedStoryVideo> {
//   late VideoPlayerController _videoPlayerController1;
//   ChewieController? _chewieController;
//   Uint8List? imageBytes;
//   @override
//   void initState() {
//     _generateThumbnail();
//     initializePlayer();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _videoPlayerController1.dispose();

//     _chewieController?.dispose();
//     super.dispose();
//   }

//   _generateThumbnail() async {
//     String? fileName = await VideoThumbnail.thumbnailFile(
//       video: widget.img,
//       thumbnailPath: (await getTemporaryDirectory()).path,
//       imageFormat: ImageFormat.PNG,
//       maxHeight:
//           350, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
//       quality: 75,
//     );
//     final file = File(fileName!);
//     imageBytes = file.readAsBytesSync();
//     print('----image--->>>$fileName');
//     setState(() {});
//   }

//   Future<void> initializePlayer() async {
//     if (mounted) {
//       _videoPlayerController1 = VideoPlayerController.network(widget.img);
//       await _videoPlayerController1.initialize();
//       _createChewieController();
//       setState(() {});
//     }
//   }

//   void _createChewieController() {
//     _chewieController = ChewieController(
//       videoPlayerController: _videoPlayerController1,
//       autoPlay: false,
//       autoInitialize: true,
//       allowFullScreen: true,
//       fullScreenByDefault: true,
//       looping: true,
//       aspectRatio: 1.6 / 1.6,
//       showControls: true,
//       showControlsOnInitialize: true,
//       subtitleBuilder: (context, dynamic subtitle) => Expanded(
//         child: Container(
//           padding: const EdgeInsets.all(0.0),
//           child: subtitle is InlineSpan
//               ? RichText(
//                   text: subtitle,
//                 )
//               : Text(
//                   subtitle.toString(),
//                   style: const TextStyle(color: Colors.black),
//                 ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: 350.0,
//         padding: const EdgeInsets.all(12.0),
//         color: Colors.lightBlue[50],
//         child: Column(
//           children: [
//             Expanded(
//               child: Center(
//                 child: _chewieController != null &&
//                         _chewieController!
//                             .videoPlayerController.value.isInitialized &&
//                         _chewieController!.isPlaying
//                     ? Chewie(
//                         controller: _chewieController!,
//                       )
//                     : Stack(
//                         children: [
//                           imageBytes != null
//                               ? Container(
//                                   height: 350,
//                                   width: MediaQuery.of(context).size.width,
//                                   child: Image.memory(
//                                     imageBytes!,
//                                     height: 350,
//                                     width: MediaQuery.of(context).size.width,
//                                   ),
//                                 )
//                               : Container(
//                                   height: 0,
//                                   width: 0,
//                                 ),
//                           _chewieController != null
//                               ? Align(
//                                   alignment: Alignment.center,
//                                   child: ClipOval(
//                                     child: Material(
//                                       color: Colors.white, // Button color
//                                       child: InkWell(
//                                         splashColor:
//                                             Colors.white, // Splash color
//                                         onTap: () {
//                                           _chewieController!.play();
//                                           setState(() {});
//                                         },
//                                         child: SizedBox(
//                                             width: 56,
//                                             height: 56,
//                                             child: Icon(Icons.play_arrow)),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               : Align(
//                                   alignment: Alignment.center,
//                                   child: CircularProgressIndicator())
//                         ],
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       //  Row(children: [
//       //   _chewieController != null &&
//       //           _chewieController!.videoPlayerController.value.isInitialized
//       //       ? Expanded(
//       //           child: Chewie(
//       //             controller: _chewieController!,
//       //           ),
//       //         )
//       //       : Expanded(
//       //           child: Center(
//       //             child: CircularProgressIndicator(),
//       //           ),
//       //         ),
//       //   // Positioned.fill(
//       //   //     child:
//       //   //      Align(
//       //   //     alignment: Alignment.center,
//       //   //     child: CircularProgressIndicator(),
//       //   //   )
//       //   //   ),
//       //   // Positioned.fill(
//       //   //     child: Align(
//       //   //   alignment: Alignment.center,
//       //   //   child: MaterialButton(
//       //   //     onPressed: () async {

//       //   //     },
//       //   //     color: Colors.black54,
//       //   //     textColor: Colors.white,
//       //   //     child: Icon(
//       //   //       Icons.play_arrow,
//       //   //       size: 23,
//       //   //     ),
//       //   //     // padding: EdgeInsets.all(13),
//       //   //     shape: CircleBorder(),
//       //   //   ),
//       //   // ))
//       // ]),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';

import 'package:video_player/video_player.dart';

class CreatedStoryVideo extends StatefulWidget {
  final img;
  CreatedStoryVideo({this.img});

  @override
  State<StatefulWidget> createState() {
    return _CreatedStoryVideoState();
  }
}

class _CreatedStoryVideoState extends State<CreatedStoryVideo> {
  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.network(
      widget.img,
    );
    _videoPlayerController2 = VideoPlayerController.network(
        'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4');
    await Future.wait([
      _videoPlayerController1.initialize(),
      _videoPlayerController2.initialize()
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: false,
      autoInitialize: true,
      allowFullScreen: true,
      fullScreenByDefault: true,
      looping: true,
       allowPlaybackSpeedChanging:false,
       showOptions: false,
      aspectRatio: 1.6/ 1.6,
      showControls: true,
      showControlsOnInitialize: true,
      subtitleBuilder: (context, dynamic subtitle) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(0.0),
          child: subtitle is InlineSpan
              ? RichText(
                  text: subtitle,
                )
              : Text(
                  subtitle.toString(),
                  style: const TextStyle(color: Colors.black),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? Expanded(
                child: Chewie(
                  controller: _chewieController!,
                ),
              )
            : Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
        // Positioned.fill(
        //     child:
        //      Align(
        //     alignment: Alignment.center,
        //     child: CircularProgressIndicator(),
        //   )
        //   ),
        // Positioned.fill(
        //     child: Align(
        //   alignment: Alignment.center,
        //   child: MaterialButton(
        //     onPressed: () async {

        //     },
        //     color: Colors.black54,
        //     textColor: Colors.white,
        //     child: Icon(
        //       Icons.play_arrow,
        //       size: 23,
        //     ),
        //     // padding: EdgeInsets.all(13),
        //     shape: CircleBorder(),
        //   ),
        // ))
      ]),
    );
  }
}
