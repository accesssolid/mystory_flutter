// import 'package:flutter/material.dart';
// import 'package:mystory_flutter/services/util_service.dart';
// import 'package:mystory_flutter/utils/service_locator.dart';

// class GalleryOptionsPopupWidget extends StatefulWidget {
//   var url;
//   List mediaImages;
//   List newMediaImages;
//   GalleryOptionsPopupWidget(
//       {this.url, required this.mediaImages, required this.newMediaImages});

//   @override
//   _GalleryOptionsPopupWidgetState createState() =>
//       _GalleryOptionsPopupWidgetState();
// }

// class _GalleryOptionsPopupWidgetState extends State<GalleryOptionsPopupWidget> {
//   UtilService? utilService = locator<UtilService>();
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
//       content: Container(
//         height: 160,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: Text(
//                 'Choose Photo & Video',
//                 style: TextStyle(fontWeight: FontWeight.w500),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Divider(),
//             Container(
//               margin: EdgeInsets.only(top: 10),
//               child: new ListTile(
//                 leading: Container(
//                   height: 38,
//                   width: 35,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(0),
//                       border: Border.all(color: Colors.black12, width: 0.1),
//                       boxShadow: [
//                         BoxShadow(
//                           color:
//                               Theme.of(context).indicatorColor.withOpacity(0.2),
//                           spreadRadius: 3,
//                           blurRadius: 10,
//                           offset: Offset(0, 3), // changes position of shadow
//                         ),
//                       ],
//                       image: DecorationImage(
//                           image: AssetImage("assets/images/gallery.png"),
//                           fit: BoxFit.fill)),
//                 ),
//                 title: new Text("Photo Library",
//                     // 'Browse',
//                     style: Theme.of(context).textTheme.subtitle2),
//                 onTap: () {
//                   setState(() {
//                     // isLoadingProgress = true;
//                     utilService!
//                         .postBrowseImage(folder: "post")
//                         .then((String value) => setState(() {
//                               // isLoadingProgress = false;
//                               widget.url = value;
//                               if (widget.url != "") {
//                                 widget.newMediaImages.add(
//                                   {
//                                     "url": widget.url,
//                                     "thumbnail": widget.url,
//                                     "fileName": utilService!.fileName,
//                                     "contentType": "image",
//                                     "entityType": "story"
//                                   },
//                                 );
//                                 widget.mediaImages.add(
//                                   {
//                                     "url": widget.url,
//                                     "thumbnail": widget.url,
//                                     "fileName": utilService!.fileName,
//                                     "contentType": "image",
//                                     "entityType": "story"
//                                   },
//                                 );
//                                 // Provider.of<CategoryProvider>(context,
//                                 //         listen: false)
//                                 //     .setImages(
//                                 //   {
//                                 //     "url": url,
//                                 //     "fileName": utilService!.fileName,
//                                 //     "contentType": contentType,
//                                 //     "entityType": "story"
//                                 //   },
//                                 // );
//                               }
//                             }));
//                   });
//                   // isLoadingProgress = false;

//                   Navigator.of(context).pop();
//                 },
//               ),
//             ),
//             new ListTile(
//               leading: Container(
//                 height: 38,
//                 width: 35,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(0),
//                     border: Border.all(color: Colors.black12, width: 0.1),
//                     boxShadow: [
//                       BoxShadow(
//                         color:
//                             Theme.of(context).indicatorColor.withOpacity(0.2),
//                         spreadRadius: 3,
//                         blurRadius: 10,
//                         offset: Offset(0, 3), // changes position of shadow
//                       ),
//                     ],
//                     image: DecorationImage(
//                         image: AssetImage("assets/images/gallery.png"),
//                         fit: BoxFit.fill)),
//               ),
//               title: new Text("Video Library",
//                   style: Theme.of(context).textTheme.subtitle2),
//               onTap: () async {
//                 // Navigator.pop(context);
//                 // setState(() {
//                 //   contentType = "video";
//                 //   isLoadingProgress = true;
//                 // });

//                 // await utilService!
//                 //     .postPickVideos(folder: "post")
//                 //     .then((String value) => setState(() {
//                 //           url = value;
//                 //         }));
//                 // if (url != "") {
//                 //   String? fileName = await VideoThumbnail.thumbnailFile(
//                 //     video: url,
//                 //     thumbnailPath: (await getTemporaryDirectory()).path,
//                 //     imageFormat: ImageFormat.PNG,
//                 //     maxHeight:
//                 //         64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
//                 //     quality: 75,
//                 //   );
//                 //   var date = DateTime.now().microsecondsSinceEpoch;
//                 //   firebase_storage.Reference storageReference;

//                 //   final file = File(fileName!);

//                 //   storageReference = firebase_storage
//                 //       .FirebaseStorage.instance
//                 //       .ref()
//                 //       .child("post/$date");
//                 //   final firebase_storage.UploadTask uploadTask =
//                 //       storageReference.putFile(file);
//                 //   final firebase_storage.TaskSnapshot downloadUrl =
//                 //       (await uploadTask.whenComplete(() => null));
//                 //   var urlasset = (await downloadUrl.ref.getDownloadURL());
//                 //   newMediaImages.add(
//                 //     {
//                 //       "url": url,
//                 //       "thumbnail": urlasset,
//                 //       "fileName": utilService!.fileName,
//                 //       "contentType": contentType,
//                 //       "entityType": "story"
//                 //     },
//                 //   );
//                 //   mediaImages.add(
//                 //     {
//                 //       "url": url,
//                 //       "thumbnail": urlasset,
//                 //       "fileName": utilService!.fileName,
//                 //       "contentType": contentType,
//                 //       "entityType": "story"
//                 //     },
//                 //   );
//                 // }

//                 // setState(() {
//                 //   isLoadingProgress = false;
//                 // });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
