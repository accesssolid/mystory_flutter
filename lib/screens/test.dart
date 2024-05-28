// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mystory_flutter/global.dart';
// import 'package:mystory_flutter/providers/media_gallery_provider.dart';
// import 'package:mystory_flutter/providers/post_provider.dart';
// import 'package:mystory_flutter/services/navigation_service.dart';
// import 'package:mystory_flutter/services/storage_service.dart';
// import 'package:mystory_flutter/services/util_service.dart';
// import 'package:mystory_flutter/utils/routes.dart';
// import 'package:mystory_flutter/utils/service_locator.dart';
// import 'package:mystory_flutter/widgets/stagger_widget.dart';
// import 'package:mystory_flutter/widgets/video_widget.dart';
// import 'package:provider/provider.dart';
// import 'dart:io';
// import 'dart:math';

// class MediaGalleryScreen extends StatefulWidget {
//   const MediaGalleryScreen({Key? key}) : super(key: key);

//   @override
//   MediaGalleryScreenState createState() => MediaGalleryScreenState();
// }

// class MediaGalleryScreenState extends State<MediaGalleryScreen> {
//   UtilService? utilService = locator<UtilService>();
//   bool? active = false;
//   bool isListloading = false;
//   bool isImageloading = false;
//   var navigationService = locator<NavigationService>();
//   List imagesData = [];
//   List videosData = [];
//   List<XFile> selectedFiles = [];
//   int value = 0;
//   @override
//   void initState() {
//     getMedia();
//     super.initState();
//   }

//   getMedia() async {
//     setState(() {
//       isListloading = true;
//     });
//     await Provider.of<PostProvider>(context, listen: false)
//         .fetchAllMediaGallaryImages(count: 10, page: 1, context: context);

//     await Provider.of<PostProvider>(context, listen: false)
//         .fetchAllMediaGallaryVideos(count: 10, page: 1, context: context);

//     imagesData =
//         Provider.of<PostProvider>(context, listen: false).getMediaImages;
//     videosData =
//         Provider.of<PostProvider>(context, listen: false).getMediaVideos;

//     setState(() {
//       isListloading = false;
//     });
//   }

//   static const _chars =
//       'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
//   Random _rnd = Random();
//   String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
//       length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
//   @override
//   Widget build(BuildContext context) {
//     final List<Tab> selectTabs = <Tab>[
//       Tab(icon: Icon(Icons.photo_sharp)
//           //      Image.asset(
//           //   "assets/images/Image.png",
//           // )
//           ),
//       Tab(
//         icon: GestureDetector(
//           child: Image.asset(
//             "assets/images/Video.png",
//             color: active! ? Colors.black : Colors.orange.shade900,
//             scale: 3,
//           ),
//         ),
//       ),
//       // Tab(
//       //   icon: Image.asset(
//       //     "assets/images/Filter.png",
//       //     color: active! ? Colors.black : Colors.orange.shade900,
//       //     scale: 3,
//       //   ),
//       // ),
//     ];
//     ScreenUtil.init(
//         BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width,
//             maxHeight: MediaQuery.of(context).size.height),
//         designSize: Size(360, 690),
//         orientation: Orientation.portrait);
//     return DefaultTabController(
//       length: selectTabs.length,
//       child: WillPopScope(
//         onWillPop:
//             context.read<MediaGalleryProvider>().postTitle != "Edit Story"
//                 ? () async {
//                     // FocusScope.of(context).unfocus();
//                     Navigator.of(context).pop();
//                     return true;
//                   }
//                 : () async {
//                     return false;
//                   },
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             backgroundColor: Colors.white,
//             elevation: 0,
//             leading: IconButton(
//               onPressed: () async {
//                 var storageService, data;
//                 storageService = locator<StorageService>();
//                 data = await storageService.getData("route");
//                 navigationService.navigateTo(data);
//                 // navigationService.navigateTo(MaindeshboardRoute);
//               },
//               icon: Icon(
//                 Icons.arrow_back,
//                 color: Colors.black38,
//                 size: 25.h,
//               ),
//             ),
//             centerTitle: true,
//             title: Text(
//               "Media Gallery",
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.bold),
//             ),
//             actions: [
//               InkWell(
//                 onTap: () {
//                   _settingModalBottomSheet(context);
//                 },
//                 child: Image.asset(
//                   "assets/images/Plus.png",
//                   scale: 3,
//                 ),
//               )
//             ],
//           ),
//           body: Column(
//             children: [
//               TabBar(
//                   onTap: (val) {
//                     value = val;
//                   },
//                   tabs: selectTabs,
//                   labelColor: Colors.red,
//                   // isScrollable: true,

//                   indicatorWeight: 2,
//                   indicatorSize: TabBarIndicatorSize.label,
//                   indicatorColor: Colors.orange.shade900,
//                   unselectedLabelColor: Colors.grey),
//               Expanded(
//                 // height: MediaQuery.of(context).size.height,
//                 child: Stack(children: [
//                   TabBarView(
//                     children: [
//                       isListloading
//                           ? Center(
//                               child: CircularProgressIndicator(),
//                             )
//                           : StaggerWidget(
//                               data: imagesData,
//                             ),
//                       isListloading
//                           ? Center(
//                               child: CircularProgressIndicator(),
//                             )
//                           : VideoWidget(
//                               data: videosData,
//                             ),
//                       // StaggerWidget(),
//                     ],
//                   ),
//                 ]),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _settingModalBottomSheet(context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext context) {
//           return Container(
//             height: value != 1 ? 200.h : 100.h,
//             child: new Wrap(
//               children: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.all(10),
//                   child: Text("Upload Media",
//                       //'Upload Profile Picture',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       )),
//                 ),
//                 Divider(),
//                 if (value == 1)
//                   new ListTile(
//                     leading: Container(
//                       height: 38.h,
//                       width: 35.h,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(0),
//                           border: Border.all(color: Colors.black12, width: 0.1),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Theme.of(context)
//                                   .indicatorColor
//                                   .withOpacity(0.2),
//                               spreadRadius: 3,
//                               blurRadius: 10,
//                               offset:
//                                   Offset(0, 3), // changes position of shadow
//                             ),
//                           ],
//                           image: DecorationImage(
//                               image:
//                                   AssetImage("assets/images/app gallery.png"),
//                               fit: BoxFit.fill)),
//                     ),
//                     trailing: Icon(Icons.keyboard_arrow_right),
//                     title: new Text("Video Library",
//                         style: Theme.of(context).textTheme.subtitle2),
//                     onTap: () async {
//                       String imageName = getRandomString(15);
//                       var url = [];
//                       var thumbnail;
//                       // var videoUrl;
//                       showLoadingAnimation(context);
//                       // setState(() {
//                       //   contentType = "video";
//                       //   isLoadingProgress = true;
//                       // });

//                       await utilService!
//                           .postPickVideos(
//                               folder: "mediaGallery", context: context)
//                           .then((value) async {
//                         if (value == "") Navigator.pop(context);
//                         // videoUrl = value;
//                         await utilService!
//                             .videoThumbnail(folder: "mediaGallery", url: value)
//                             .then((val) async {
//                           thumbnail = val;
//                           url.add({
//                             "url": value,
//                             "thumbnail": thumbnail,
//                             "fileName": imageName,
//                             "contentType": "video",
//                             "entityType": "user"
//                           });
//                           videosData.insert(0, {
//                             "url": value,
//                             "thumbnail": thumbnail,
//                             "fileName": imageName,
//                             "contentType": "video",
//                             "entityType": "user"
//                           });
//                           setState(() {});
//                           await Provider.of<MediaGalleryProvider>(context,
//                                   listen: false)
//                               .uploadMedia(media: url, context: context);
//                           Navigator.pop(context);
//                         });
//                       });

//                       Navigator.pop(context);
//                     },
//                   ),
//                 if (value != 1)
//                   Container(
//                     child: new ListTile(
//                       leading: Container(
//                         height: 38.h,
//                         width: 35.h,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(0),
//                             border:
//                                 Border.all(color: Colors.black12, width: 0.1),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Theme.of(context)
//                                     .indicatorColor
//                                     .withOpacity(0.2),
//                                 spreadRadius: 3,
//                                 blurRadius: 10,
//                                 offset:
//                                     Offset(0, 3), // changes position of shadow
//                               ),
//                             ],
//                             image: DecorationImage(
//                                 image: AssetImage("assets/images/gallery.png"),
//                                 fit: BoxFit.fill)),
//                       ),
//                       trailing: Icon(Icons.keyboard_arrow_right),
//                       title: new Text("Photo Library",
//                           // 'Browse',
//                           style: Theme.of(context).textTheme.subtitle2),
//                       onTap: () async {
//                         String imageName = getRandomString(15);
//                         var url = [];
//                         var tempList = [];

//                         await utilService!
//                             .browseMediaImages(selectedFiles)
//                             .then((value) {
//                           showLoadingAnimation(context);
//                           utilService!
//                               .uploadFunction(selectedFiles)
//                               .then((value) {
//                             tempList = value;
//                             for (int i = 0; i < tempList.length; i++) {
//                               url.add({
//                                 "url": tempList[i],
//                                 "thumbnail": tempList[i],
//                                 "fileName": imageName,
//                                 "contentType": "image",
//                                 "entityType": "user"
//                               });
//                               /////for show uploaded firebase images at the run time////
//                               imagesData.insert(0, {
//                                 "url": tempList[i],
//                                 "thumbnail": tempList[i],
//                                 "fileName": imageName,
//                                 "contentType": "image",
//                                 "entityType": "user"
//                               });
//                             }
//                             setState(() {});
//                           }).then((value) async {
//                             await Provider.of<MediaGalleryProvider>(context,
//                                     listen: false)
//                                 .uploadMedia(media: url, context: context);
//                             Navigator.of(context).pop();
//                             Navigator.of(context).pop();
//                           });
//                         });
//                       },
//                     ),
//                   ),
//                 if (value != 1)
//                   Container(
//                     margin: EdgeInsets.only(top: 10),
//                     child: new ListTile(
//                       leading: Container(
//                         height: 38.h,
//                         width: 35.h,
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(0),
//                             border:
//                                 Border.all(color: Colors.black12, width: 0.1),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Theme.of(context)
//                                     .indicatorColor
//                                     .withOpacity(0.2),
//                                 spreadRadius: 3,
//                                 blurRadius: 10,
//                                 offset:
//                                     Offset(0, 3), // changes position of shadow
//                               ),
//                             ],
//                             image: DecorationImage(
//                                 image: AssetImage("assets/images/camera.png"),
//                                 scale: 3
//                                 // fit: BoxFit.fill
//                                 )),
//                       ),
//                       trailing: Icon(Icons.keyboard_arrow_right),
//                       title: new Text("Camera",
//                           // 'Browse',
//                           style: Theme.of(context).textTheme.subtitle2),
//                       onTap: () async {
//                         // var date = DateTime.now().microsecondsSinceEpoch;
//                         // var url;
//                         List data = [];
//                         showLoadingAnimation(context);

//                         await utilService!
//                             .postCaptureImage(
//                                 folder: "mediaGallery", context: context)
//                             .then((String value) async {
//                           Navigator.of(context).pop();
//                           data.add({
//                             "url": value,
//                             "thumbnail": value,
//                             "fileName": utilService!.fileName,
//                             "contentType": "image",
//                             "entityType": "user"
//                           });

//                           if (value != "") {
//                             imagesData.insert(0, {
//                               "url": value,
//                               "thumbnail": value,
//                               "fileName": utilService!.fileName,
//                               "contentType": "image",
//                               "entityType": "user"
//                             });
//                             await Provider.of<MediaGalleryProvider>(context,
//                                     listen: false)
//                                 .uploadMedia(media: data, context: context);
//                             // Navigator.of(context).pop();
//                           }
//                         });
//                         // });
//                         Navigator.of(context).pop();

//                         // isLoadingProgress = false;
//                       },
//                     ),
//                   ),
//               ],
//             ),
//           );
//         });
//   }
// }