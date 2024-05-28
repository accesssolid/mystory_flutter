import 'package:flutter/material.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/widgets/audio_player_widget.dart';
import 'package:mystory_flutter/widgets/audio_widget.dart';
import 'package:mystory_flutter/widgets/video-player.dart';
import 'package:provider/src/provider.dart';

import './gallery_Item_model.dart';
import './gallery_Item_thumbnail.dart';
import './gallery_image_view_wrapper.dart';
import './util.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class GalleryImage extends StatefulWidget {
  final List? imageUrls;
  final String? titileGallery;

  const GalleryImage({@required this.imageUrls, this.titileGallery, Key? key})
      : super(key: key);

  @override
  _GalleryImageState createState() => _GalleryImageState();
}

class _GalleryImageState extends State<GalleryImage> {
  List<GalleryItemModel> galleryItems = <GalleryItemModel>[];
  List images = [];

  // @override
  // void initState() {
  //   this.images = Provider.of<PostProvider>(context, listen: false).getFeeds;
  //   buildItemsList(this.images);
  //   //   this.galleryItems.clear();
  //   //   this.images.forEach((item) {
  //   //     this.galleryItems.add(
  //   //           GalleryItemModel(id: item, imageUrl: item),
  //   //         );
  //   //   });
  //   super.initState();
  //   // setState(() {
  //   //   this.galleryItems.clear();
  //   //   this.images.forEach((item) {
  //   //     this.galleryItems.add(
  //   //           GalleryItemModel(id: item, imageUrl: item),
  //   //         );
  //   //   });
  //   //   // buildItemsList(this.images);
  //   // });
  // }

  // @override
  // void didChangeDependencies() {
  //   this.images = Provider.of<PostProvider>(context, listen: false).getFeeds;
  //   buildItemsList(this.images);
  //   // setState(() {
  //   //   this.galleryItems.clear();
  //   //   this.images.forEach((item) {
  //   //     this.galleryItems.add(
  //   //           GalleryItemModel(id: item, imageUrl: item),
  //   //         );
  //   //   });
  //   //   // buildItemsList(this.images);
  //   // });
  //   super.didChangeDependencies();
  // }

  // @override
  // void didUpdateWidget(covariant GalleryImage oldWidget) {
  //   this.images = Provider.of<PostProvider>(context, listen: false).getFeeds;
  //   buildItemsList(this.images);
  //   // setState(() {
  //   //   this.galleryItems.clear();
  //   //   this.images.forEach((item) {
  //   //     this.galleryItems.add(
  //   //           GalleryItemModel(id: item, imageUrl: item),
  //   //         );
  //   //   });
  //   // buildItemsList(this.images);
  //   // });
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    // this.images = Provider.of<PostProvider>(context, listen: false).getFeeds;
    // buildItemsList(this.images);
    for (var i = 0; i < widget.imageUrls!.length; i++) {
      images.add(widget.imageUrls![i]["contentType"] == "video"
          ? widget.imageUrls![i]["thumbnail"]
          : widget.imageUrls![i]["url"]);
    }
    // images = Provider.of<PostProvider>(context, listen: false).getFeeds;
    buildItemsList(images);

    return Padding(
        padding: EdgeInsets.all(0),
        child: this.galleryItems.isEmpty
            ? getEmptyWidget()
            : this.galleryItems.length == 1
                ? StaggeredGridView.countBuilder(
                    physics: NeverScrollableScrollPhysics(),
                    // primary: false,
                    crossAxisCount: 4,
                    // reverse: true,
                    itemCount: this.galleryItems.length >= 1
                        ? 1
                        : this.galleryItems.length,
                    // padding: EdgeInsets.all(0),
                    // semanticChildCount: 1,
                    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 3, mainAxisSpacing: 0, crossAxisSpacing: 5),
                    staggeredTileBuilder: (int index) => (index == 0)
                        ? new StaggeredTile.count(4, 2.4)
                        : (index % 2 == 0)
                            ? new StaggeredTile.count(1, 1.4)
                            : new StaggeredTile.count(2, 2.2),
                    // staggeredTileBuilder: (int index) {
                    //   return StaggeredTile.count(
                    //     2,
                    //     index == 0 ? 4 : 2,
                    //   );
                    // },
                    mainAxisSpacing: 2.0,
                    crossAxisSpacing: 2.0,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(17)),
                          // if have less than 4 image w build GalleryItemThumbnail
                          // if have mor than 4 build image number 3 with number for other images
                          child: this.galleryItems.length > 3 && index == 2
                              ? buildImageNumbers(index)
                              : widget.imageUrls![index]["contentType"] ==
                                      "video"
                                  ? Stack(
                                      alignment: AlignmentDirectional.center,
                                      fit: StackFit.expand,
                                      children: [
                                          GalleryItemThumbnail(
                                            galleryItem:
                                                this.galleryItems[index],
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        GalleryVideoplayerWidget(
                                                            img: widget
                                                                    .imageUrls![
                                                                index]["url"])),
                                              );
                                            },
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        GalleryVideoplayerWidget(
                                                            img: widget
                                                                    .imageUrls![
                                                                index]["url"])),
                                              );
                                            },
                                            child: Icon(
                                              Icons.play_arrow,
                                              size: 50,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ])
                                  : widget.imageUrls![index]["contentType"] ==
                                          "audio"
                                      ? GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      GalleryVideoplayerWidget(
                                                          img: widget
                                                                  .imageUrls![
                                                              index]["url"])),
                                            );
                                          },
                                          child: Container(
                                            color: Colors.grey[300],
                                            child: Icon(
                                              Icons.play_circle_filled,
                                              size: 50,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : GalleryItemThumbnail(
                                          galleryItem: this.galleryItems[index],
                                          onTap: () {
                                            openImageFullScreen(index);
                                          },
                                        ));
                    })
                : this.galleryItems.length == 2
                    ? StaggeredGridView.countBuilder(
                        physics: NeverScrollableScrollPhysics(),
                        // primary: false,
                        crossAxisCount: 4,
                        // reverse: true,
                        itemCount: this.galleryItems.length > 2
                            ? 2
                            : this.galleryItems.length,
                        // padding: EdgeInsets.all(0),
                        // semanticChildCount: 1,
                        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //     crossAxisCount: 3, mainAxisSpacing: 0, crossAxisSpacing: 5),
                        staggeredTileBuilder: (int index) => (index == 0)
                            ? new StaggeredTile.count(2, 2.4)
                            : (index % 2 == 0)
                                ? new StaggeredTile.count(1, 1.4)
                                : new StaggeredTile.count(2, 2.4),
                        // staggeredTileBuilder: (int index) {
                        //   return StaggeredTile.count(
                        //     2,
                        //     index == 0 ? 4 : 2,
                        //   );
                        // },
                        mainAxisSpacing: 2.0,
                        crossAxisSpacing: 5.0,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(17)),
                              // if have less than 4 image w build GalleryItemThumbnail
                              // if have mor than 4 build image number 3 with number for other images
                              child: this.galleryItems.length > 3 && index == 2
                                  ? buildImageNumbers(index)
                                  : widget.imageUrls![index]["contentType"] ==
                                          "video"
                                      ? Stack(
                                          alignment:
                                              AlignmentDirectional.center,
                                          fit: StackFit.expand,
                                          children: [
                                              GalleryItemThumbnail(
                                                galleryItem:
                                                    this.galleryItems[index],
                                                onTap: () {
                                                  openImageFullScreen(index);
                                                },
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  openImageFullScreen(index);
                                                },
                                                child: Icon(
                                                  Icons.play_arrow,
                                                  size: 50,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ])
                                      : widget.imageUrls![index]
                                                  ["contentType"] ==
                                              "audio"
                                          ? GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          GalleryVideoplayerWidget(
                                                              img: widget
                                                                      .imageUrls![
                                                                  index]["url"])),
                                                );
                                              },
                                              child: Container(
                                                color: Colors.grey[300],
                                                child: Icon(
                                                  Icons.play_circle_filled,
                                                  size: 50,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          : GalleryItemThumbnail(
                                              galleryItem:
                                                  this.galleryItems[index],
                                              onTap: () {
                                                openImageFullScreen(index);
                                              },
                                            ));
                        })
                    : StaggeredGridView.countBuilder(
                        physics: NeverScrollableScrollPhysics(),
                        // primary: false,
                        crossAxisCount: 4,
                        // reverse: true,
                        itemCount: this.galleryItems.length > 3
                            ? 3
                            : this.galleryItems.length,
                        // padding: EdgeInsets.all(0),
                        // semanticChildCount: 1,
                        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //     crossAxisCount: 3, mainAxisSpacing: 0, crossAxisSpacing: 5),
                        staggeredTileBuilder: (int index) => (index == 0)
                            ? new StaggeredTile.count(3, 3)
                            : (index % 2 == 0)
                                ? new StaggeredTile.count(1, 1.5)
                                : new StaggeredTile.count(1, 1.5),
                        // staggeredTileBuilder: (int index) {
                        //   return StaggeredTile.count(
                        //     2,
                        //     index == 0 ? 4 : 2,
                        //   );
                        // },
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(17)),
                                // if have less than 4 image w build GalleryItemThumbnail
                                // if have mor than 4 build image number 3 with number for other images
                                child: this.galleryItems.length > 3 &&
                                        index == 2
                                    ? buildImageNumbers(index)
                                    : widget.imageUrls![index]["contentType"] ==
                                            "video"
                                        ? Stack(
                                            alignment:
                                                AlignmentDirectional.center,
                                            fit: StackFit.expand,
                                            children: [
                                                GalleryItemThumbnail(
                                                  galleryItem:
                                                      this.galleryItems[index],
                                                  onTap: () {
                                                    openImageFullScreen(index);
                                                  },
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    openImageFullScreen(index);
                                                  },
                                                  child: Icon(
                                                    Icons.play_arrow,
                                                    size: 50,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ])
                                        : widget.imageUrls![index]
                                                    ["contentType"] ==
                                                "audio"
                                            ? GestureDetector(
                                                onTap: () {
                                                  openImageFullScreen(index);
                                                },
                                                child: Container(
                                                  color: Colors.grey[300],
                                                  child: Icon(
                                                    Icons.play_circle_filled,
                                                    size: 50,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            : GalleryItemThumbnail(
                                                galleryItem:
                                                    this.galleryItems[index],
                                                onTap: () {
                                                  openImageFullScreen(index);
                                                },
                                              )),
                          );
                        }));
  }

// build image with number for other images
  Widget buildImageNumbers(int index) {
    return GestureDetector(
      onTap: () {
        openImageFullScreen(index);
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: <Widget>[
          GalleryItemThumbnail(
            galleryItem: this.galleryItems[index],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 0),
            color: Colors.black.withOpacity(.7),
            child: Center(
              child: Text(
                // "+${context.read<PostProvider>().tempNewsFeedMedia.length - index}",
                "+${this.galleryItems.length - index}",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

// to open gallery image in full screen
  void openImageFullScreen(final int indexOfImage) {
    print('Image Url: ${ widget.imageUrls![indexOfImage]["contentType"] }');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            widget.imageUrls![indexOfImage]["contentType"] == "video" ||
                    widget.imageUrls![indexOfImage]["contentType"] == "audio"
                ? GalleryVideoplayerWidget(
                    img: widget.imageUrls![indexOfImage]["url"])
                : GalleryImageViewWrapper(
                    imageUrls: widget.imageUrls,
                    titileGallery: widget.titileGallery,
                    galleryItems: this.galleryItems,
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    initialIndex: indexOfImage,
                    scrollDirection: Axis.horizontal,
                  ),
      ),
    );
  }

// clear and build list
  buildItemsList(List items) {
    this.galleryItems.clear();
    this.galleryItems = [];
    items.forEach((item) {
      this.galleryItems.add(
            GalleryItemModel(id: item, imageUrl: item),
          );
    });
  }
}
