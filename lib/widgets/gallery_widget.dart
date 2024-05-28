import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mystory_flutter/global.dart';
import 'package:mystory_flutter/providers/chatProvider.dart';
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
// const List<StaggeredTile> _staggeredTiles = <StaggeredTile>[
//   StaggeredTile.count(2, 2),
//   StaggeredTile.count(2, 2),
//   StaggeredTile.count(2, 2),
//   StaggeredTile.count(2, 2),
//   StaggeredTile.count(2, 2),
//   StaggeredTile.count(2, 2),
//   StaggeredTile.count(2, 2),
//   StaggeredTile.count(2, 2),
//   StaggeredTile.count(2, 2),
//   StaggeredTile.count(2, 2),
// ];
// const List<Widget> _tiles = <Widget>[
//   _Tile(
//     'https://cdn.pixabay.com/photo/2021/09/08/09/03/book-6606414_960_720.jpg',
//   ),
//   _Tile(
//     'https://cdn.pixabay.com/photo/2021/10/03/04/21/woman-6676901__340.jpg',
//   ),
//   _Tile(
//     'https://media.istockphoto.com/photos/couple-taking-selfie-on-a-longtail-boat-picture-id951405400?b=1&k=20&m=951405400&s=170667a&w=0&h=BO2KBJI0wqppLpla72ri5Gbtsy5NHpZHLiuYfT_HZc0=',
//   ),
//   _Tile(
//     'https://cdn.pixabay.com/photo/2017/01/28/02/24/japan-2014618_960_720.jpg',
//   ),
//   _Tile(
//     'https://cdn.pixabay.com/photo/2017/06/02/15/43/tree-2366663_960_720.jpg',
//   ),
//   _Tile(
//     'https://cdn.pixabay.com/photo/2017/02/22/17/02/beach-2089936_960_720.jpg',
//   ),
//   _Tile(
//     'https://cdn.pixabay.com/photo/2015/07/09/00/29/woman-837156_960_720.jpg',
//   ),
//   _Tile(
//     'https://cdn.pixabay.com/photo/2020/01/25/18/47/lahore-4793144_960_720.jpg',
//   ),
// ];

class GalleryWidget extends StatefulWidget {
  var imageData;
  GalleryWidget({this.imageData});
  @override
  _GalleryWidgetState createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  var utilService = locator<UtilService>();
  var postByIdData;
  bool isLoading = false;
  Map<String, dynamic>? mediaData;
  List newVideosData = [];
  var _scroll = ScrollController();
  int page = 2;
  int count = 20;
  var familyData;
  @override
  void initState() {
    familyData =
        Provider.of<InviteProvider>(context, listen: false).getFAmilyData;
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

  void getMoreData({int? count, int? page}) async {
    try {
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });

        await Provider.of<InviteProvider>(context, listen: false)
            .fetchFamilyMediaGalleryImg(
                id: familyData['id'], page: page, count: count);
        mediaData = Provider.of<InviteProvider>(context, listen: false)
            .getMemberMediaImageListData;
        setState(() {
          isLoading = false;
          if (newVideosData.length == 0) {
            utilService.showToast("No more images",context);
          } else {
            widget.imageData["images"].addAll(newVideosData);
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
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InviteProvider>(builder: (context, media, child) {
      return widget.imageData["permission"] == "denied" || widget.imageData.isEmpty
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
              child: widget.imageData["images"].isEmpty ||
                      widget.imageData["posts"].isEmpty
                  ? NoDataYet(
                      title: "No media tree yet", image: "Group 33604.png")
                  : GridView.builder(
                      controller: _scroll,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                      addRepaintBoundaries: false,
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.imageData["images"].length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        childAspectRatio: 1.5 / 1.6,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (contxt, i) {
                        if (i == widget.imageData.length) {
                          return _buildProgressIndicator();
                        } else {
                          return InkWell(
                            onTap: () async {
                              var formatted = timeago.format(
                                  DateTime.fromMillisecondsSinceEpoch(widget
                                      .imageData["posts"][i]["createdOnDate"]));
                              showLoadingAnimation(context);
                              await Provider.of<PostProvider>(context,
                                      listen: false)
                                  .getPostById(
                                      id: widget.imageData["posts"][i]["id"],context: context)
                                  .then((_) async {
                                // postByIdData = Provider.of<PostProvider>(context,
                                //         listen: false)
                                //     .postById;
                                Navigator.pop(context);
                                var storageService = locator<StorageService>();
                                await storageService.setData(
                                    "route", "/family-member-profile-screen");

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PostCommentsScreen(
                                            data:
                                                //  postByIdData,
                                                context
                                                    .read<PostProvider>()
                                                    .postById,
                                            date: formatted,
                                          )),
                                );
                              });
                            },
                            child: CacheImage(
                              placeHolder: "fdsf (2).png",
                              imageUrl: widget.imageData["images"][i],
                              width: 250,
                              height: 250,
                              radius: 6.0,
                            ),

                            // Image.network(

                            //   fit: BoxFit.fill,
                            // ),
                          );
                        }
                      })
              // StaggeredGridView.countBuilder(
              //   crossAxisCount: 4,
              //   itemCount: widget.imageData["images"].length,
              //   itemBuilder: (BuildContext context, int index) {
              //     print(widget.imageData["images"][index]);
              //     return ClipRRect(
              //         borderRadius: BorderRadius.circular(10),
              //         child: Image.network(widget.imageData["images"][index]));
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


// class _Tile extends StatelessWidget {
//   final String source;

//   const _Tile(
//     this.source,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           image:
//               DecorationImage(image: NetworkImage(source), fit: BoxFit.cover)),
//     );
//   }
// }
