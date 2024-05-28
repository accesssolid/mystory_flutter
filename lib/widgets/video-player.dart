import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/media_gallery_provider.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../global.dart';

class GalleryVideoplayerWidget extends StatefulWidget {
  final img;
  final String? title;
  GalleryVideoplayerWidget({this.img,this.title});

  @override
  State<StatefulWidget> createState() {
    return _GalleryVideoplayerWidgetState();
  }
}

class _GalleryVideoplayerWidgetState extends State<GalleryVideoplayerWidget> {
  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController;
  NavigationService? navigationService = locator<NavigationService>();
  var user;
  @override
  void initState() {
    super.initState();
    user = Provider.of<AuthProviderr>(context, listen: false).user;
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
      autoPlay: true,
      looping: true,
      subtitleBuilder: (context, dynamic subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: subtitle is InlineSpan
            ? RichText(
                text: subtitle,
              )
            : Text(
                subtitle.toString(),
                style: const TextStyle(color: Colors.black),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("CODE IS dddddRUNNING HERE HERE HERE HERE");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 25),
        ),
        actions: [
          context.read<MediaGalleryProvider>().mediaGalleryRoute ==
                  "Media Video"
              ? widget.title!="search"?IconButton(
                  onPressed: () async {
                    var data = context
                        .read<MediaGalleryProvider>()
                        .mediaVideoData["data"];
                    var index = context
                        .read<MediaGalleryProvider>()
                        .mediaVideoData["index"];
                    showLoadingAnimation(context);
                    await Provider.of<MediaGalleryProvider>(context,
                            listen: false)
                        .deleteMedia(
                          context: context,
                      media: [
                        {
                          "url": data['url'],
                          "thumbnail": data['thumbnail'],
                          "fileName": data['fileName'],
                          "contentType": data['contentType'],
                          "entityType": data['entityType'],
                          "id": data['id'],
                          "userId": user.id
                        }
                      ],
                    );
                    Provider.of<PostProvider>(context, listen: false)
                        .removeUserMediaVideos(index);
                    _videoPlayerController1.dispose();
                    _videoPlayerController2.dispose();
                    _chewieController?.dispose();
                    // data.removeAt(index);
                    navigationService!.navigateTo(MediaGalleryScreenRoute);
                  },
                  icon: Icon(Icons.delete)):SizedBox()
              : Container()
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Center(
              child: _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                  ? Chewie(
                      controller: _chewieController!,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Loading'),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
