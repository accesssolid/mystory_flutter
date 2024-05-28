import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mystory_flutter/global.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/media_gallery_provider.dart';

import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

import 'cache_image.dart';
import 'gallery-pkg/gallery_Item_model.dart';
import 'gallery-pkg/gallery_image_view_wrapper.dart';
import 'mediagallery_fullimage_widget.dart';
import 'no_data_yet.dart';

class StaggerWidget extends StatefulWidget {
  final data;
  final String? title;

  StaggerWidget({this.data,this.title});

  @override
  State<StaggerWidget> createState() => _StaggerWidgetState();
}

class _StaggerWidgetState extends State<StaggerWidget> {
  var utilService = locator<UtilService>();
  NavigationService? navigationService = locator<NavigationService>();

  // List<GalleryItemModel> galleryItems = <GalleryItemModel>[];
  int page = 2;
  int count = 10;
  var _scroll = ScrollController();
  var mediaImages;
  var mediaImagesNew;
  bool isLoading = false;

  // void fetchAllUserMedia() async {
  //   mediaImages =
  //       Provider.of<PostProvider>(context, listen: false).getMediaImages;
  //   setState(() {
  //     isLoading = true;
  //   });
  //   await Provider.of<PostProvider>(context, listen: false)
  //       .fetchAllMediaGallary(page: 1, count: 20);
  //   mediaImages =
  //       Provider.of<PostProvider>(context, listen: false).getMediaImages;
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
            .fetchAllMediaGallaryImages(
                page: page, count: count, context: context);
        mediaImagesNew =
            Provider.of<PostProvider>(context, listen: false).getMediaImages;

        setState(() {
          isLoading = false;
          if (mediaImagesNew.length == 0) {
            utilService.showToast("No more images", context);
          } else {
            widget.data.addAll(mediaImagesNew);
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

  var user;

  @override
  void initState() {
    user = Provider.of<AuthProviderr>(context, listen: false).user;
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

  // final ImagePicker imagePicker = ImagePicker();
  // List<XFile>? imageFileList = [];

  // void selectImages() async {
  //   final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
  //   if (selectedImages!.isNotEmpty) {
  //     imageFileList!.addAll(selectedImages);
  //   }
  //   print("Image List Length:" + imageFileList!.length.toString());
  //   setState(() {});
  // }

  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
      child: Consumer<PostProvider>(builder: (context, media, child) {
        return widget.data.length == 0
            ? NoDataYet(title: "No media yet", image: "Group 33604.png")
            : StaggeredGridView.countBuilder(
                controller: _scroll,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                crossAxisCount: 4,
                shrinkWrap: true,
                itemCount: widget.data.length + 1,
                //staticData.length,
                itemBuilder: (context, index) {
                  if (index == widget.data.length) {
                    return _buildProgressIndicator();
                  } else {
                    return Consumer<MediaGalleryProvider>(
                        builder: (context, media, child) {
                      return GestureDetector(
                        onTap: media.mediaGalleryRoute == "Create Story" ||
                                media.mediaGalleryRoute == "Journal" ||
                                media.mediaGalleryRoute == "chat screen"
                            ? () {
                                print(' in condition');
                                if (media.mediaGalleryRoute == "Create Story") {
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
                                } else if (media.mediaGalleryRoute ==
                                    "chat screen") {
                                  print('condition working fine');
                                  // Navigator.pop(context);
                                  // return widget.data[index]['url'];
                                  Provider.of<MediaGalleryProvider>(context,
                                          listen: false)
                                      .ImageUrlForChat = widget.data[index]['url'];
                                  Navigator.pop(context);
                                }

                                Navigator.pop(context);
                              }
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ShowFullImage(
                                            data: widget.data,
                                            ind: index,
                                        title: widget.title,
                                          )),
                                );
                              },
                        child: CacheImage(
                          placeHolder: "fdsf (2).png",
                          imageUrl: widget.data[index]["url"],
                          //  imageUrl: widget.data[index]["url"],
                          width: 250,
                          height: 250,
                          radius: 6.0,
                        ),
                        //  Container(
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10),
                        //       image: DecorationImage(
                        //           image: NetworkImage(
                        //               widget.data[index]["url"].toString()),
                        //           fit: BoxFit.cover)),
                        // ),
                      );
                    });
                  }
                },
                staggeredTileBuilder: (index) {
                  if (index == 0) return StaggeredTile.count(4, 2);
                  if (index == widget.data.length - 1)
                    return StaggeredTile.count(4, 2);
                  if (index > 0 && index < widget.data.length)
                    return StaggeredTile.count(2, index.isEven ? 2 : 2.5);
                },
                // staggeredTileBuilder: (index) =>
                //     StaggeredTile.count(2, index.isEven ? 2 : 2.5),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
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

// _showSecondPage({int? index}) {
//   return Column(children: [
//     InkWell(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//           Navigator.of(context).pop();
//         },
//         child: Icon(Icons.arrow_back)),
//     // Row(
//     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //   children: [
//     //     InkWell(
//     //         onTap: () {
//     //           FocusScope.of(context).unfocus();
//     //           Navigator.of(context).pop();
//     //         },
//     //         child: Icon(Icons.arrow_back)),
//     //     // IconButton(
//     //     //     onPressed: () async {
//     //     //       showLoadingAnimation(context);
//     //     //       await Provider.of<MediaGalleryProvider>(context, listen: false)
//     //     //           .deleteMedia(
//     //     //         media: [
//     //     //           {
//     //     //             "url": widget.data[index]['url'],
//     //     //             "thumbnail": widget.data[index]['url'],
//     //     //             "fileName": widget.data[index]['fileName'],
//     //     //             "contentType": widget.data[index]['contentType'],
//     //     //             "entityType": widget.data[index]['contentType'],
//     //     //             "id": widget.data[index]['id'],
//     //     //             "userId": user.id
//     //     //           }
//     //     //         ],
//     //     //       );
//     //     //       widget.data.removeAt(index);
//     //     //       navigationService!.navigateTo(MediaGalleryScreenRoute);
//     //     //     },
//     //     //     icon: Icon(Icons.delete)),
//     //     InkWell(
//     //         onTap: () {
//     //           FocusScope.of(context).unfocus();
//     //           Navigator.of(context).pop();
//     //         },
//     //         child: Icon(Icons.arrow_back)),
//     //   ],
//     // ),
//     Expanded(
//       child: PhotoViewGallery.builder(
//         scrollPhysics: const BouncingScrollPhysics(),

//         builder: (BuildContext context, int index) {
//           return PhotoViewGalleryPageOptions(
//             imageProvider: NetworkImage(widget.data[index]['url']),
//             initialScale: PhotoViewComputedScale.contained,
//             minScale: PhotoViewComputedScale.contained * 0.8,
//             maxScale: PhotoViewComputedScale.covered * 8,
//             heroAttributes:
//                 PhotoViewHeroAttributes(tag: widget.data[index]['id']),
//           );
//         },
//         itemCount: widget.data.length,
//         loadingBuilder: (context, event) => Center(
//           child: Container(
//             width: MediaQuery.of(context).size.width * 8,
//             height: MediaQuery.of(context).size.height * 8,
//             child: Image.asset(
//               "assets/images/fdsf (2).png",
//               // fit: BoxFit.fill,
//             ),
//           ),
//         ),
//         // backgroundDecoration: widget.backgroundDecoration,
//         // pageController: widget.pageController,
//         // onPageChanged: onPageChanged,
//       ),
//     )
//   ]);

//   // WillPopScope(
//   //     // ignore: missing_return
//   //     onWillPop: () async {
//   //       FocusScope.of(context!).unfocus();
//   //       Navigator.of(context).pop();
//   //       return true;
//   //     },
//   //     child: Scaffold(
//   //         backgroundColor: Colors.white,
//   //         appBar: AppBar(
//   //           backgroundColor: Colors.black,
//   //           actions: [
//   //             IconButton(
//   //                 onPressed: () async {
//   //                   showLoadingAnimation(context!);
//   //                   await Provider.of<MediaGalleryProvider>(context,
//   //                           listen: false)
//   //                       .deleteMedia(
//   //                     media: [
//   //                       {
//   //                         "url": widget.data[index]['url'],
//   //                         "thumbnail": widget.data[index]['url'],
//   //                         "fileName": widget.data[index]['fileName'],
//   //                         "contentType": widget.data[index]['contentType'],
//   //                         "entityType": widget.data[index]['contentType'],
//   //                         "id": widget.data[index]['id'],
//   //                         "userId": user.id
//   //                       }
//   //                     ],
//   //                   );
//   //                   widget.data.removeAt(index);
//   //                   navigationService!.navigateTo(MediaGalleryScreenRoute);
//   //                 },
//   //                 icon: Icon(Icons.delete))
//   //           ],
//   //           leading: InkWell(
//   //               onTap: () {
//   //                 FocusScope.of(context!).unfocus();
//   //                 Navigator.of(context).pop();
//   //               },
//   //               child: Icon(Icons.arrow_back)),
//   //         ),
//   //         body: Container(
//   //           color: Colors.white,
//   //           height: double.infinity,
//   //           width: double.infinity,
//   //           child: PhotoView(
//   //             imageProvider: NetworkImage(imageUrl!),
//   //             basePosition: Alignment(0.5, 0.0),
//   //           ),
//   //         )));
// }
}
