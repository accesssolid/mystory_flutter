import 'package:flutter/material.dart';
import 'package:mystory_flutter/global.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/media_gallery_provider.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class ShowFullImage extends StatefulWidget {
  final data;
  int? ind;
  String? title;
  ShowFullImage({Key? key, this.data, this.ind,this.title}) : super(key: key);

  @override
  _ShowFullImageState createState() => _ShowFullImageState();
}

class _ShowFullImageState extends State<ShowFullImage> {
  NavigationService? navigationService = locator<NavigationService>();
  var user;
  @override
  void initState() {
    super.initState();
    user = Provider.of<AuthProviderr>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey key1 = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          widget.title!="search"?IconButton(
              onPressed: () async {
                showLoadingAnimation(context);
                await Provider.of<MediaGalleryProvider>(context, listen: false)
                    .deleteMedia(
                  context: context,
                  media: [
                    {
                      "url": widget.data[widget.ind]['url'],
                      "thumbnail": widget.data[widget.ind]['thumbnail'],
                      "fileName": widget.data[widget.ind]['fileName'],
                      "contentType": widget.data[widget.ind]['contentType'],
                      "entityType": widget.data[widget.ind]['entityType'],
                      "id": widget.data[widget.ind]['id'],
                      "userId": user.id
                    }
                  ],
                );
                widget.data.removeAt(widget.ind);
          //      navigationService!.navigateTo(MediaGalleryScreenRoute); // commented by chetu
                Navigator.pop(context,true);     // implemented by chetu
                Navigator.pop(context,true);// implemented by chetu
                 Navigator.pushReplacementNamed(context, MediaGalleryScreenRoute);// implemented by chetu
              },
              icon: Icon(Icons.delete)):SizedBox(),
        ],
        leading: InkWell(
            onTap: () {
              // widget.data[widget.ind]['url'] = "";
              // navigationService!.closeScreen();
              Navigator.of(context).pop();
              // navigationService!.navigateTo(MediaGalleryScreenRoute);
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const NeverScrollableScrollPhysics(),

        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            // key: key1,
            imageProvider: NetworkImage(
                // index == widget.ind
                //   ? widget.data[widget.ind]['url']
                // :
                widget.data[widget.ind]['url']),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 8,
            heroAttributes:
                PhotoViewHeroAttributes(tag: widget.data[index]['id']),
          );
        },
        itemCount: widget.data.length,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 8,
            height: MediaQuery.of(context).size.height * 8,
            child: Image.asset(
              "assets/images/fdsf (2).png",
              // fit: BoxFit.fill,
            ),
          ),
        ),
        backgroundDecoration: BoxDecoration(color: Colors.black),
        // pageController: widget.pageController,
        // onPageChanged: onPageChanged,
      ),
    );
  }
}
