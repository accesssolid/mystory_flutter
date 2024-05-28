import 'package:flutter/material.dart';

import 'package:mystory_flutter/global.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/screens/post_comments_screen.dart';

import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/services/util_service.dart';

import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/cache_image.dart';
import 'package:mystory_flutter/widgets/no_data_yet.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class VideoGalleryWidget extends StatefulWidget {
  var videoData;
  VideoGalleryWidget({this.videoData});
  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoGalleryWidget> {
  var utilService = locator<UtilService>();
  List newVideosData = [];
  Map<String, dynamic>? mediaData;
  var _scroll = ScrollController();
  int page = 2;
  int count = 20;
  var familyData;
  bool isLoading = false;

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void initState() {
    setState(() {
      familyData = Provider.of<InviteProvider>(this.context, listen: false)
          .getFAmilyData;
    });

    _scroll.addListener(() {
      if (_scroll.position.pixels == _scroll.position.maxScrollExtent) {
        setState(() {
          print('Page reached end of page');
          getMoreData(page: page, count: count,);
        });
        setState(() {
          page++;
        });
      }
    });
    super.initState();
  }

  void getMoreData({int? count, int? page,}) async {
    try {
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });

        await Provider.of<InviteProvider>(this.context, listen: false)
            .fetchFamilyMediaGalleryVideos(
              context: this.context,
                id: familyData['id'], page: page, count: count);
        mediaData = Provider.of<InviteProvider>(this.context, listen: false)
            .getMemberMediaVideotData;
        setState(() {
          isLoading = false;
          if (newVideosData.length == 0) {
            utilService.showToast("No more videos",this.context,);
          } else {
            widget.videoData["videos"].addAll(newVideosData);
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
      utilService.showToast(err.toString(),this.context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InviteProvider>(builder: (context, media, child) {
      return widget.videoData["permission"] == "denied" || widget.videoData.isEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade50,
                    radius: 60,
                    backgroundImage:
                        AssetImage("assets/images/Group 33607.png"),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Container(
                    width: 300,
                    child: Text(
                      "User isn't permitted to see the posts",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          height: 1.5),
                    ),
                  ),
                )
              ],
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(top: 12, left: 1, right: 1),
              child: widget.videoData["videos"].isNotEmpty ||
                      widget.videoData["posts"].isNotEmpty
                  ? GridView.builder(
                      controller: _scroll,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                      addRepaintBoundaries: false,
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.videoData["videos"].length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        childAspectRatio: 1.5 / 1.6,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (contxt, i) {
                        if (i == widget.videoData.length) {
                          return _buildProgressIndicator();
                        } else {
                          return Stack(children: [
                            CacheImage(
                              placeHolder: "fdsf (2).png",
                              imageUrl: widget.videoData["videos"][i],
                              width: 250,
                              height: 250,
                              radius: 6.0,
                            ),
                            Positioned.fill(
                                child: Align(
                              alignment: Alignment.center,
                              child: MaterialButton(
                                onPressed: () async {
                                  var formatted = timeago.format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          widget.videoData["posts"][i]
                                              ["createdOnDate"]));
                                  showLoadingAnimation(context);
                                  await Provider.of<PostProvider>(context,
                                          listen: false)
                                      .getPostById(
                                          id: widget.videoData["posts"][i]
                                              ["id"],context: context)
                                      .then((_) async {
                                    Navigator.pop(context);
                                    var storageService =
                                        locator<StorageService>();
                                    await storageService.setData("route",
                                        "/family-member-profile-screen");
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PostCommentsScreen(
                                                data: context
                                                    .read<PostProvider>()
                                                    .postById,
                                                date: formatted,
                                              )),
                                    );
                                  });
                                },
                                color: Colors.black54,
                                textColor: Colors.white,
                                child: Icon(
                                  Icons.play_arrow,
                                  size: 25,
                                ),
                                // padding: EdgeInsets.all(13),
                                shape: CircleBorder(),
                              ),
                            ))
                          ]);
                        }
                      })
                  : NoDataYet(
                      title: "No media tree yet", image: "Group 33604.png")

              //  StaggeredGridView.countBuilder(
              //   crossAxisCount: 4,
              //   itemCount: widget.videoData["videos"].length,
              //   itemBuilder: (BuildContext context, int index) {
              //     print(widget.videoData["videos"][index]);
              //     return ClipRRect(
              //         borderRadius: BorderRadius.circular(10),
              //         child: Image.network(widget.videoData["videos"][index]));
              //     //  Container(
              //     //   decoration: BoxDecoration(
              //     //       borderRadius: BorderRadius.circular(10),
              //     //       image: DecorationImage(
              //     //           image: NetworkImage(
              //     //               widget.imageData["images"][0].toString()),
              //     //           fit: BoxFit.cover)),
              //     // );
              //   },
              //   staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
              //   mainAxisSpacing: 4.0,
              //   crossAxisSpacing: 4.0,
              // ),

              //  StaggeredGridView.count(
              //     shrinkWrap: true,
              //     crossAxisCount: 4,
              //     staggeredTiles: _staggeredTiles,
              //     mainAxisSpacing: 12,
              //     crossAxisSpacing: 12,
              //     padding: const EdgeInsets.all(4),
              //     children: widget.imageData["permission"]["images"]),
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
