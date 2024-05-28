import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mystory_flutter/widgets/create_story_video_widget.dart';
import 'package:mystory_flutter/widgets/video-player.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import './gallery_Item_model.dart';

// to view image in full screen
class GalleryImageViewWrapper extends StatefulWidget {
  final LoadingBuilder? loadingBuilder;
  final Decoration? backgroundDecoration;
  final int? initialIndex;
  final PageController? pageController;
  final List<GalleryItemModel>? galleryItems;
  final Axis scrollDirection;
  final String? titileGallery;
  final List? imageUrls;
  GalleryImageViewWrapper({
    this.loadingBuilder,
    this.titileGallery,
    this.backgroundDecoration,
    this.initialIndex,
    this.imageUrls,
    @required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex!);

  @override
  State<StatefulWidget> createState() {
    return _GalleryImageViewWrapperState();
  }
}

class _GalleryImageViewWrapperState extends State<GalleryImageViewWrapper> {
  int? currentIndex;
  final minScale = PhotoViewComputedScale.contained * 0.8;
  final maxScale = PhotoViewComputedScale.covered * 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.titileGallery ?? ""),
      ),
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: _buildImage,
          itemCount: widget.galleryItems!.length,
          loadingBuilder: widget.loadingBuilder,
          // backgroundDecoration: widget.backgroundDecoration,

          pageController: widget.pageController,
          scrollDirection: widget.scrollDirection,
        ),
      ),
    );
  }

// build image with zooming
  PhotoViewGalleryPageOptions _buildImage(BuildContext context, int index) {
    final GalleryItemModel item = widget.galleryItems![index];
    return PhotoViewGalleryPageOptions.customChild(
      child: Stack(
          alignment: AlignmentDirectional.center,
          fit: StackFit.expand,
          children: [
            if(widget.imageUrls![index]["contentType"] != "audio")
            CachedNetworkImage(
              fit: BoxFit.contain,
              imageUrl: item.imageUrl!,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            if (widget.imageUrls![index]["contentType"] == "video")
              Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GalleryVideoplayerWidget(
                                img: widget.imageUrls![index]["url"],
                              )),
                    );
                  },
                  child: Icon(
                    Icons.play_arrow,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            if(widget.imageUrls![index]["contentType"] == "audio")
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
                child: Container(
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.play_circle_filled,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              )
          ]),
      initialScale: PhotoViewComputedScale.contained,
      minScale: minScale,
      maxScale: maxScale,
      heroAttributes: PhotoViewHeroAttributes(tag: item.id!),
    );
  }
}
