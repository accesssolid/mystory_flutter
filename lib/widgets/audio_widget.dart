import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mystory_flutter/global.dart';
import 'package:mystory_flutter/providers/media_gallery_provider.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/audio_player_widget.dart';
import 'package:mystory_flutter/widgets/video-player.dart';
import 'package:provider/provider.dart';

import 'cache_image.dart';
import 'no_data_yet.dart';

class AudioWidget extends StatefulWidget {
  final data;

  AudioWidget({this.data});

  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  var utilService = locator<UtilService>();
  NavigationService? navigationService = locator<NavigationService>();
  int page = 2;
  int count = 10;
  var _scroll = ScrollController();
  var mediaAudios;
  var mediaAudiosNew;
  bool isLoading = false;

  // void fetchAllUserMedia() async {
  //   mediaVideos =
  //       Provider.of<PostProvider>(context, listen: false).getMediaVideos;
  //   setState(() {
  //     isLoading = true;
  //   });
  //   await Provider.of<PostProvider>(context, listen: false)
  //       .fetchAllMediaGallary(page: 1, count: 10);
  //   mediaVideos =
  //       Provider.of<PostProvider>(context, listen: false).getMediaVideos;
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  void getMoreData({int? count, int? page}) async {
    try {
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });

        await Provider.of<PostProvider>(context, listen: false)
            .fetchAllMediaGallaryAudio(
                page: page, count: count, context: context);
        mediaAudiosNew =
            Provider.of<PostProvider>(context, listen: false).getMediaAudios;

        setState(() {
          isLoading = false;
          if (mediaAudiosNew.length == 0) {
            utilService.showToast("No more Audios", context);
          } else {
            widget.data.addAll(mediaAudiosNew);
          }
        });

        setState(() {
          isLoading = false;
        });
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      utilService.showToast(err.toString(), context);
    }
  }

  @override
  void initState() {
    // fetchAllUserMedia();

    _scroll.addListener(() {
      if (_scroll.position.pixels == _scroll.position.maxScrollExtent) {
        setState(() {
          print('Page reached end of page');
          getMoreData(page: page, count: count);
        });
        setState(() {
          page++;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      child: Consumer<PostProvider>(builder: (context, media, child) {
        return widget.data.length == 0
            ? NoDataYet(title: "No Audio tree yet", image: "audio_placeholder.png")
            : ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.all(8.0),
                itemCount: widget.data.length, //staticData.length,
                itemBuilder: (context, index) {
                  if (index == widget.data.length) {
                    return _buildProgressIndicator();
                  } else {
                    return Consumer<MediaGalleryProvider>(
                        builder: (context, media, child) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: InkWell(
                            onTap: media.mediaGalleryRoute == "Create Story" ||
                                    media.mediaGalleryRoute == "Journal"
                                ? () {
                                    if (media.mediaGalleryRoute ==
                                        "Create Story") {
                                      if (media.postTitle == "Edit Story") {
                                        media.addNewMediaImage(
                                          {
                                            "url": widget.data[index]['url'],
                                            "thumbnail": widget.data[index]
                                                ['thumbnail'],
                                            "fileName": widget.data[index]
                                                ['fileName'],
                                            "contentType": widget.data[index]
                                                ['contentType'],
                                            "entityType": widget.data[index]
                                                ['entityType']
                                          },
                                        );

                                        media.addMediaImage(
                                          {
                                            "url": widget.data[index]['url'],
                                            "thumbnail": widget.data[index]
                                                ['thumbnail'],
                                            "fileName": widget.data[index]
                                                ['fileName'],
                                            "contentType": widget.data[index]
                                                ['contentType'],
                                            "entityType": widget.data[index]
                                                ['entityType']
                                          },
                                        );

                                        Navigator.pop(context);
                                      } else {
                                        media.addMediaImage(
                                          {
                                            "url": widget.data[index]['url'],
                                            "thumbnail": widget.data[index]
                                                ['thumbnail'],
                                            "fileName": widget.data[index]
                                                ['fileName'],
                                            "contentType": widget.data[index]
                                                ['contentType'],
                                            "entityType": widget.data[index]
                                                ['entityType']
                                          },
                                        );

                                        Navigator.pop(context);
                                      }
                                    } else if (media.mediaGalleryRoute ==
                                        "Journal") {
                                      media.addJournalMediaImage(
                                        {
                                          "url": widget.data[index]['url'],
                                          "thumbnail": widget.data[index]
                                              ['thumbnail'],
                                          "fileName": widget.data[index]
                                              ['fileName'],
                                          "contentType": widget.data[index]
                                              ['contentType'],
                                          "entityType": widget.data[index]
                                              ['entityType']
                                        },
                                      );
                                      media.addJournalNewMediaImage(
                                        {
                                          "url": widget.data[index]['url'],
                                          "thumbnail": widget.data[index]
                                              ['thumbnail'],
                                          "fileName": widget.data[index]
                                              ['fileName'],
                                          "contentType": widget.data[index]
                                              ['contentType'],
                                          "entityType": widget.data[index]
                                              ['entityType']
                                        },
                                      );
                                      Navigator.pop(context);
                                    }

                                    Navigator.pop(context);
                                  }
                                : () {
                                    context
                                        .read<MediaGalleryProvider>()
                                        .mediaGalleryRoute = "Media Video";
                                    context
                                        .read<MediaGalleryProvider>()
                                        .mediaVideoData = {
                                      "data": widget.data[index],
                                      "index": index
                                    };

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GalleryVideoplayerWidget(
                                                  img: widget.data[index]
                                                      ["url"])),
                                    );
                                  },
                            child:Column(
                              children: [
                                SizedBox(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width * 0.85,
                                    child: AudioPlayerWidget(
                                      audioUrl: widget.data[index]["url"],
                                    )
                                  ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  }
                },
              );
      }),
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
