import 'package:flutter/material.dart';
import 'package:mystory_flutter/global.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/screens/post_comments_screen.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/cache_image.dart';
import 'package:mystory_flutter/widgets/no_data_yet.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserMediaVideosWidget extends StatefulWidget {
  final data;
  UserMediaVideosWidget({this.data});
  @override
  _UserMediaVideosWidgetState createState() => _UserMediaVideosWidgetState();
}

class _UserMediaVideosWidgetState extends State<UserMediaVideosWidget> {
  var utilService = locator<UtilService>();
  var _scroll = ScrollController();
  int page = 2;
  int count = 20;
  var user;
  bool isLoading = false;
  List newVideosData = [];
  @override
  void initState() {
    super.initState();

    // videosData =
    //     Provider.of<AuthProvider>(context, listen: false).getUserVideos;
    user = Provider.of<AuthProviderr>(context, listen: false).user;
    // getMedia();
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
  }

  // getMedia() async {
  //   await Provider.of<AuthProvider>(context, listen: false)
  //       .fetchUserMediaGallery(id: user.id, count: 10, page: 1);
  //   videosData =
  //       Provider.of<AuthProvider>(context, listen: false).getUserVideos;
  // }
  void getMoreData({int? count, int? page}) async {
    try {
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });

        await Provider.of<AuthProviderr>(context, listen: false)
            .fetchUserMediaGalleryVideos(id: user.id, count: count, page: page,context:context);
        newVideosData =
            Provider.of<AuthProviderr>(context, listen: false).getUserVideos;
        setState(() {
          isLoading = false;
          if (newVideosData.length == 0) {
            utilService.showToast("No more images",context);
          } else {
            widget.data.addAll(newVideosData);
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
      utilService.showToast(err.toString(),context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviderr>(builder: (context, vide_os, child) {
      return Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(top: 12, left: 1, right: 1),
          child: widget.data.length == 0
              ? NoDataYet(title: "No media tree yet", image: "Video.png")
              : GridView.builder(
                  controller: _scroll,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  addRepaintBoundaries: false,
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.data.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    childAspectRatio: 1.5 / 1.6,
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (contxt, i) {
                    if (i == widget.data.length) {
                      return _buildProgressIndicator();
                    } else {
                      return Stack(children: [
                        CacheImage(
                          placeHolder: "fdsf (2).png",
                          imageUrl: widget.data[i]["url"],
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
                                      widget.data[i]["createdOnDate"]));
                              showLoadingAnimation(context);
                              await Provider.of<PostProvider>(context,
                                      listen: false)
                                  .getPostById(id: widget.data[i]["id"],context: context)
                                  .then((_) async {
                                Navigator.pop(context);
                                var storageService = locator<StorageService>();
                                await storageService.setData(
                                    "route", "/myprofile-screen");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PostCommentsScreen(
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
                  }));
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
