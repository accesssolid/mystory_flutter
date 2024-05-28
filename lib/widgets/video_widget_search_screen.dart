import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mystory_flutter/global.dart';
import 'package:mystory_flutter/providers/media_gallery_provider.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/video-player.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import 'cache_image.dart';
import 'no_data_yet.dart';

class VideoWidgetSearchScreen extends StatefulWidget {
  final data;
  final String? title;

  VideoWidgetSearchScreen({this.data, this.title});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidgetSearchScreen> {
  var utilService = locator<UtilService>();
  NavigationService? navigationService = locator<NavigationService>();
  int page = 2;
  int count = 10;
  var _scroll = ScrollController();
  var mediaVideos;
  var mediaVideosNew;
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
            .fetchAllMediaGallaryVideos(
            page: page, count: count, context: context);
        mediaVideosNew =
            Provider.of<PostProvider>(context, listen: false).getMediaVideos;

        setState(() {
          isLoading = false;
          if (mediaVideosNew.length == 0) {
            utilService.showToast("No more videos", context);
          } else {
            widget.data.addAll(mediaVideosNew);
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
    return Consumer<PostProvider>(builder: (context, media, child) {
      return widget.data.length == 0
          ? NoDataYet(title: "No media tree yet", image: "Video.png")
          : StaggeredGridView.countBuilder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        controller: _scroll,
        padding: const EdgeInsets.all(8.0),
        crossAxisCount: 4,
        itemCount: widget.data.length + 1,
        //staticData.length,
        itemBuilder: (context, index) {
          if (index == widget.data.length) {
            return _buildProgressIndicator();
          } else {
            return Stack(
              children: [
                CacheImage(
                  placeHolder: "fdsf (2).png",
                  imageUrl: widget.data[index]["thumbnail"],
                  width: widget.data.length > 0 ? 400 : 250,
                  height: 250,
                  radius: 6.0,
                ),
                // Container(
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       image: DecorationImage(
                //           image: NetworkImage(widget.data[index]
                //                   ["thumbnail"]
                //               .toString()),
                //           fit: BoxFit.cover)),
                // ),
                Consumer<MediaGalleryProvider>(
                    builder: (context, media, child) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                            child: InkWell(
                                onTap: media.mediaGalleryRoute ==
                                    "Create Story" ||
                                    media.mediaGalleryRoute == "Journal"
                                    ? () {
                                  if (media.mediaGalleryRoute ==
                                      "Create Story") {
                                    if (media.postTitle ==
                                        "Edit Story") {
                                      media.addNewMediaImage(
                                        {
                                          "url": widget.data[index]
                                          ['url'],
                                          "thumbnail":
                                          widget.data[index]
                                          ['thumbnail'],
                                          "fileName":
                                          widget.data[index]
                                          ['fileName'],
                                          "contentType":
                                          widget.data[index]
                                          ['contentType'],
                                          "entityType":
                                          widget.data[index]
                                          ['entityType']
                                        },
                                      );

                                      media.addMediaImage(
                                        {
                                          "url": widget.data[index]
                                          ['url'],
                                          "thumbnail":
                                          widget.data[index]
                                          ['thumbnail'],
                                          "fileName":
                                          widget.data[index]
                                          ['fileName'],
                                          "contentType":
                                          widget.data[index]
                                          ['contentType'],
                                          "entityType":
                                          widget.data[index]
                                          ['entityType']
                                        },
                                      );

                                      Navigator.pop(context);
                                    } else {
                                      media.addMediaImage(
                                        {
                                          "url": widget.data[index]
                                          ['url'],
                                          "thumbnail":
                                          widget.data[index]
                                          ['thumbnail'],
                                          "fileName":
                                          widget.data[index]
                                          ['fileName'],
                                          "contentType":
                                          widget.data[index]
                                          ['contentType'],
                                          "entityType":
                                          widget.data[index]
                                          ['entityType']
                                        },
                                      );

                                      Navigator.pop(context);
                                    }
                                  } else if (media
                                      .mediaGalleryRoute ==
                                      "Journal") {
                                    media.addJournalMediaImage(
                                      {
                                        "url": widget.data[index]
                                        ['url'],
                                        "thumbnail": widget
                                            .data[index]['thumbnail'],
                                        "fileName": widget.data[index]
                                        ['fileName'],
                                        "contentType":
                                        widget.data[index]
                                        ['contentType'],
                                        "entityType": widget
                                            .data[index]['entityType']
                                      },
                                    );
                                    media.addJournalNewMediaImage(
                                      {
                                        "url": widget.data[index]
                                        ['url'],
                                        "thumbnail": widget
                                            .data[index]['thumbnail'],
                                        "fileName": widget.data[index]
                                        ['fileName'],
                                        "contentType":
                                        widget.data[index]
                                        ['contentType'],
                                        "entityType": widget
                                            .data[index]['entityType']
                                      },
                                    );
                                    Navigator.pop(context);
                                  }

                                  Navigator.pop(context);
                                }
                                    : () {
                                  context
                                      .read<MediaGalleryProvider>()
                                      .mediaGalleryRoute =
                                  "Media Video";
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
                                              ["url"],
                                              title:widget.title,
                                            )),
                                  );
                                },
                                child: Image.asset(
                                  "assets/images/play.png",
                                  scale: 1.5,
                                ))),
                      );
                    }),
              ],
            );
          }
        },
        staggeredTileBuilder: (index) {
          if (index == 0) return StaggeredTile.count(4, 2);
          if (index == widget.data.length - 1)
            return StaggeredTile.count(4, 2);
          if (index > 0 && index < widget.data.length)
            return StaggeredTile.count(2, index.isEven ? 2 : 2.5);
        },

        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      );
    });
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
