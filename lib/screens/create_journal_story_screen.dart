import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/global.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/media_gallery_provider.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/cache_image.dart';
import 'package:mystory_flutter/widgets/column_scroll_view.dart';
import 'package:mystory_flutter/widgets/create_story_video_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../models/category.dart';
import '../providers/category_provider.dart';
import '../widgets/column_scroll_view.dart';

class CreateJournalStoryScreen extends StatefulWidget {
  final journalTitle;
  final journalEdit;
  CreateJournalStoryScreen({this.journalTitle, this.journalEdit});

  @override
  _CreateJournalStoryScreenState createState() =>
      _CreateJournalStoryScreenState();
}

class _CreateJournalStoryScreenState extends State<CreateJournalStoryScreen> {
  UtilService? utilService = locator<UtilService>();
  NavigationService? navigationService = locator<NavigationService>();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  int? deleteIndex;
  bool isLoading = false;
  bool isMediaLoading = false;
  var getUserData;

  bool isLoadingProgress = false;
  var user;
  // var media;
  var url;

  String contentType = "";

  // List mediaImages = [];
  // List newMediaImages = [];
  List deleteMedia = [];

  late int editLength;
  // void newListDataAndOldList() {
  //   // if (editLength != mediaImages.length) {
  //   //   for (int i = editLength - 1; i < mediaImages.length; i++) {
  //   //     mediaImages.removeAt(i);
  //   //   }
  //   // }
  //   context.read<MediaGalleryProvider>().journalMediaImages.length =
  //       context.read<MediaGalleryProvider>().journalMediaImages.length -
  //           context.read<MediaGalleryProvider>().journalNewMediaImages.length;
  // }

  @override
  void initState() {
    getUserData = Provider.of<AuthProviderr>(context, listen: false).user;

    // media = Provider.of<CategoryProvider>(context, listen: false).getMedia;
    user = Provider.of<AuthProviderr>(context, listen: false).user;
    if (widget.journalEdit != null) {
      titleController.text = widget.journalEdit['journalTitle'];
      descriptionController.text = widget.journalEdit['description'];

      // for(var i = 0; widget.journalEdit['catagory'].length > i ; i++){

      //   widget.journalEdit['catagory'][i]['parentId'] == null ?
      context.read<MediaGalleryProvider>().journalMediaImages =
          widget.journalEdit['media'];

      // }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      //BoxConstraints(
      //    maxWidth: MediaQuery.of(context).size.width,
      //    maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(360, 690),
      //orientation: Orientation.portrait
    );
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return WillPopScope(
        onWillPop: () async {
          // FocusScope.of(context).unfocus();
          navigationService!.closeScreen();
          //navigationService!.navigateTo(MyJournalScreenRoute);
          return true;
        },
        child: AbsorbPointer(
          absorbing: isLoadingProgress,
          child: Stack(children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar:
                  //  PreferredSize(
                  //     child:
                  AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                    onPressed: () {
                      navigationService!.closeScreen();
                     // navigationService!.navigateTo(MyJournalScreenRoute);
                      // context
                      //     .read<MediaGalleryProvider>()
                      //     .clearjournalMediaImages();
                      // navigationService!.navigateTo(MyJournalScreenRoute);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black)),
                title: Text(
                  widget.journalTitle == null || widget.journalTitle == ""
                      ? "Create Journal"
                      : widget.journalTitle.toString(),
                  // "Create Story",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),

              // preferredSize: Size.fromHeight(90)),
              body: ColumnScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: EdgeInsets.all(12.h),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(3),
                                  height: 55.h,
                                  width: 55.h,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.red.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      shape: BoxShape.circle,
                                      gradient: new LinearGradient(
                                        colors: [
                                          Colors.orange,
                                          Colors.red,
                                        ],
                                      )),
                                  child: getUserData.profilePicture == ""
                                      ? CircleAvatar(
                                          backgroundImage: AssetImage(
                                              "assets/images/place_holder.png"),
                                        )
                                      : CircleAvatar(
                                          backgroundColor:
                                              Theme.of(context).backgroundColor,
                                          backgroundImage: NetworkImage(
                                              getUserData.profilePicture)),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "@${getUserData.firstName}${getUserData.lastName}"
                                          .toLowerCase(),
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          color:
                                              Color.fromRGBO(161, 161, 161, 1)),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Text(
                                      "${getUserData.firstName} ${getUserData.lastName}",
                                      // getUserData.fullName,
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    // InkWell(
                                    //   onTap: () {},
                                    //   child: Container(
                                    //     padding:
                                    //         EdgeInsets.fromLTRB(9.w, 3.h, 9.w, 3.h),
                                    //     color: Color.fromRGBO(243, 243, 243, 1),
                                    //     child: Row(
                                    //       children: [
                                    //         Text(
                                    //           "Tag Family Members",
                                    //           style: TextStyle(
                                    //               fontSize: 10.sp,
                                    //               color: Colors.black),
                                    //         ),
                                    //         Icon(
                                    //           Icons.keyboard_arrow_right,
                                    //           color: Theme.of(context).primaryColor,
                                    //           size: 15.h,
                                    //         )
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  " Journal Title",
                                  style: TextStyle(
                                      fontSize: 12.sp, color: Colors.black87),
                                ),
                                Text(
                                  "*",
                                  style: TextStyle(
                                      fontSize: 16.sp, color: Colors.red),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Container(
                              child: TextField(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.sp,
                                ),
                                maxLength: 100,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                controller: titleController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  isDense: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: Theme.of(context)
                                              .indicatorColor)),
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color:
                                              Theme.of(context).primaryColor)),
                                  errorBorder: InputBorder.none,
                                  filled: true,
                                  hintStyle: TextStyle(
                                    letterSpacing: 1,
                                    color: Color.fromRGBO(
                                      218,
                                      219,
                                      221,
                                      1,
                                    ),
                                  ),
                                  hintText: "Text..",
                                  fillColor: Colors.white,
                                  // contentPadding: EdgeInsets.only(
                                  //   left: 15.w,
                                  //   top: 18.h,
                                  //   bottom: 18.h,
                                  // ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  " Write Something..",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      " Capture details of journal here",
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.black87),
                                    ),
                                    Text(
                                      "*",
                                      style: TextStyle(
                                          fontSize: 16.sp, color: Colors.red),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            TextField(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.sp,
                              ),
                              maxLines: 5,
                              maxLength: 10000,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              controller: descriptionController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: Theme.of(context)
                                              .indicatorColor)),
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color:
                                              Theme.of(context).primaryColor)),
                                  errorBorder: InputBorder.none,
                                  filled: true,
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(
                                      218,
                                      219,
                                      221,
                                      1,
                                    ),
                                  ),
                                  hintText: "Write Comments..",
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 14.h, vertical: 12.h)),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                          ])),
                  Consumer<MediaGalleryProvider>(
                      builder: (context, media, child) {
                    return Padding(
                      padding: EdgeInsets.all(12.h),
                      child: media.journalMediaImages.length != 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Text(
                                    "Media:",
                                    style: TextStyle(
                                        fontSize: 12.sp, color: Colors.black87),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  GridView.builder(
                                      padding: EdgeInsets.all(0),
                                      clipBehavior: Clip.none,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          media.journalMediaImages.length,
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: sy(5.0),
                                        crossAxisSpacing: sy(5.0),
                                        // childAspectRatio: 5 / 5,

                                        crossAxisCount: 2,
                                      ),
                                      itemBuilder: (context, i) {
                                        if(media.journalMediaImages[i]
                                                    ["contentType"] ==
                                                "image") {
                                          return Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                CacheImage(
                                                  placeHolder:
                                                  "fdsf (2).png",
                                                  imageUrl: media
                                                      .journalMediaImages[
                                                  i]["url"],
                                                  width: 500.w,
                                                  height: 165.h,
                                                  radius: 6.0,
                                                ),
                                                Positioned.fill(
                                                    right: -35.w,
                                                    top: -20.h,
                                                    child: Align(
                                                      alignment: Alignment
                                                          .topRight,
                                                      child: MaterialButton(
                                                        onPressed:
                                                            () async {
                                                          setState(() {
                                                            deleteIndex = i;
                                                          });
                                                          deleteMedia.add(
                                                              media
                                                                  .journalMediaImages[
                                                              i]);
                                                          setState(() {
                                                            isMediaLoading =
                                                            true;
                                                          });
                                                          await firebase_storage
                                                              .FirebaseStorage
                                                              .instance
                                                              .refFromURL(
                                                              media
                                                                  .journalMediaImages[
                                                              i]
                                                              [
                                                              "url"])
                                                              .delete()
                                                              .catchError(
                                                                  (onError) {
                                                                print(onError);
                                                              });
                                                          setState(() {
                                                            media
                                                                .journalMediaImages
                                                                .removeAt(
                                                                i);
                                                            isMediaLoading =
                                                            false;
                                                          });
                                                        },
                                                        color:
                                                        Colors.black54,
                                                        textColor:
                                                        Colors.white,
                                                        child: Icon(
                                                          Icons.cancel,
                                                          size: 18,
                                                        ),
                                                        // padding: EdgeInsets.all(13),
                                                        shape:
                                                        CircleBorder(),
                                                        height: 24,
                                                      ),
                                                    )),
                                                if (isMediaLoading &&
                                                    deleteIndex == i)
                                                  Positioned.fill(
                                                      child: Align(
                                                        alignment:
                                                        Alignment.center,
                                                        child:
                                                        CircularProgressIndicator(
                                                          color: Theme
                                                              .of(
                                                              context)
                                                              .backgroundColor,
                                                        ),
                                                      ))
                                              ]);
                                        }
                                        if (media.journalMediaImages[i]
                                        ["contentType"] ==
                                            "audio") {
                                          return Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(6.r),
                                                  child: Image(
                                                    image: AssetImage(
                                                      "assets/images/audio_placeholder.png",
                                                    ),
                                                    width: 500.w,
                                                    height: 140.h,
                                                    fit: BoxFit.fill,
                                                    // height: MediaQuery.of(context).size.height * 0.5,
                                                  ),
                                                ),
                                                Positioned.fill(
                                                    right: -35.w,
                                                    top: -20.h,
                                                    child: Align(
                                                      alignment:
                                                      Alignment.topRight,
                                                      child: MaterialButton(
                                                        onPressed: () async {
                                                          setState(() {
                                                            deleteIndex = i;
                                                          });

                                                          deleteMedia.add(media
                                                              .mediaImages[i]);
                                                          setState(() {
                                                            isMediaLoading =
                                                            true;
                                                          });
                                                          await firebase_storage
                                                              .FirebaseStorage
                                                              .instance
                                                              .refFromURL(media
                                                              .mediaImages[
                                                          i]["url"])
                                                              .delete()
                                                              .catchError(
                                                                  (onError) {
                                                                print(onError);
                                                              });
                                                          setState(() {
                                                            media.mediaImages
                                                                .removeAt(i);
                                                            isMediaLoading =
                                                            false;
                                                          });
                                                        },
                                                        color: Colors.black54,
                                                        textColor:
                                                        Colors.white,
                                                        child: Icon(
                                                          Icons.cancel,
                                                          size: 18,
                                                        ),
                                                        // padding: EdgeInsets.all(13),
                                                        shape: CircleBorder(),
                                                        height: 24,
                                                      ),
                                                    )),
                                                if (isMediaLoading &&
                                                    deleteIndex == i)
                                                  Positioned.fill(
                                                      child: Align(
                                                        alignment:
                                                        Alignment.center,
                                                        child:
                                                        CircularProgressIndicator(
                                                          color: Theme.of(context)
                                                              .backgroundColor,
                                                        ),
                                                      ))
                                              ]);
                                        }
                                        else{
                                          return Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      6.0),
                                                  child: CreatedStoryVideo(
                                                    img: media
                                                        .journalMediaImages[
                                                    i]["url"],
                                                  ),
                                                ),
                                                Positioned.fill(
                                                    right: -35.w,
                                                    top: -20.h,
                                                    child: Align(
                                                      alignment: Alignment
                                                          .topRight,
                                                      child: MaterialButton(
                                                        onPressed:
                                                            () async {
                                                          setState(() {
                                                            deleteIndex = i;
                                                          });
                                                          deleteMedia.add(
                                                              media.journalMediaImages[
                                                              i]);
                                                          setState(() {
                                                            isMediaLoading =
                                                            true;
                                                          });
                                                          await firebase_storage
                                                              .FirebaseStorage
                                                              .instance
                                                              .refFromURL(
                                                              media.journalMediaImages[
                                                              i]
                                                              [
                                                              "url"])
                                                              .delete()
                                                              .catchError(
                                                                  (onError) {
                                                                print(onError);
                                                              });
                                                          setState(() {
                                                            media
                                                                .journalMediaImages
                                                                .removeAt(
                                                                i);
                                                            isMediaLoading =
                                                            false;
                                                          });
                                                        },
                                                        color:
                                                        Colors.black54,
                                                        textColor:
                                                        Colors.white,
                                                        child: Icon(
                                                          Icons.cancel,
                                                          size: 18,
                                                        ),
                                                        // padding: EdgeInsets.all(13),
                                                        shape:
                                                        CircleBorder(),
                                                        height: 24,
                                                      ),
                                                    )),
                                                if (isMediaLoading &&
                                                    deleteIndex == i)
                                                  Positioned.fill(
                                                      child: Align(
                                                        alignment:
                                                        Alignment.center,
                                                        child:
                                                        CircularProgressIndicator(
                                                          color: Theme.of(
                                                              context)
                                                              .backgroundColor,
                                                        ),
                                                      ))
                                              ]);
                                        }


                                      }),
                                ])
                          : Container(),
                    );
                  }),
                  Container(
                    padding: EdgeInsets.all(12.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _settingModalBottomSheet(context);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            textStyle: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.03,
                                fontWeight: FontWeight.w600),
                            fixedSize: Size(
                              MediaQuery.of(context).size.width * 1,
                              MediaQuery.of(context).size.height * 0.060,
                            ),
                            backgroundColor: Colors.white,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0),
                              side: BorderSide(
                                width: 1.w,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          child: Text(
                            "Upload Media",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Consumer<MediaGalleryProvider>(
                            builder: (context, button, child) {
                          return ElevatedButton(
                            onPressed: () async {
                              if (titleController.text == "" ||
                                      descriptionController.text == ""

                                  //location.length == 0
                                  ) {
                                utilService!.showToast(
                                    "Please fill all fields", context);
                              } else {
                                setState(() {
                                  isLoadingProgress = true;
                                });
                                if (widget.journalEdit != null) {
                                  button.journalNewListDataAndOldList();
                                  await Provider.of<PostProvider>(context,
                                          listen: false)
                                      .updateJournalPost(
                                    context: context,
                                    id: widget.journalEdit["id"],
                                    journalTitle: titleController.text,
                                    description: descriptionController.text,
                                    addedByName:
                                        widget.journalEdit["addedByName"],
                                    addedById: widget.journalEdit["addedById"],
                                    addedByProfilePic:
                                        widget.journalEdit["addedByProfilePic"],
                                    media: button.journalMediaImages,
                                    //  context
                                    //     .read<MediaGalleryProvider>()
                                    //     .journalMediaImages,
                                    newMedia: button.journalNewMediaImages,
                                    // context
                                    //     .read<MediaGalleryProvider>()
                                    //     .journalNewMediaImages,
                                    deletedMedia: deleteMedia,
                                  );
                                  button.clearjournalNewMediaImages();
                                } else {
                                  setState(() {
                                    isLoadingProgress = true;
                                  });
                                  await Provider.of<PostProvider>(context,
                                          listen: false)
                                      .createJournalPost(
                                    context: context,
                                    journalTitle: titleController.text,
                                    description: descriptionController.text,
                                    addedByName: getUserData.fullName,
                                    addedById: getUserData.id,
                                    addedByProfilePic:
                                        getUserData.profilePicture,
                                    media: button.journalMediaImages,
                                    //  context
                                    //     .read<MediaGalleryProvider>()
                                    //     .journalMediaImages,
                                  );
                                  button.clearjournalMediaImages();
                                }
                                setState(() {
                                  isLoadingProgress = false;
                                });
                                navigationService!.closeScreen();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              textStyle: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.03,
                                  fontWeight: FontWeight.w600),
                              backgroundColor: Theme.of(context).primaryColor,
                              fixedSize: Size(
                                MediaQuery.of(context).size.width * 1,
                                MediaQuery.of(context).size.height * 0.060,
                              ),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                side: BorderSide(
                                  width: 1.w,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            child: Text(
                              widget.journalEdit != null
                                  ? "Update Journal"
                                  : "Create Journal",
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              )),
            ),
            if (isLoadingProgress)
              Positioned.fill(
                  child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ))
          ]),
        ),
      );
    });
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Consumer<MediaGalleryProvider>(
              builder: (context, media, child) {
            return Container(
              height: 300.h,
              child: new Wrap(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Upload Media",
                        //'Upload Profile Picture',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Divider(),
                  new ListTile(
                    leading: Container(
                      height: 38.h,
                      width: 35.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(color: Colors.black12, width: 0.1),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .indicatorColor
                                  .withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          image: DecorationImage(
                              image: AssetImage("assets/images/gallery.png"),
                              fit: BoxFit.fill)),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    title: new Text("Video Library",
                        style: Theme.of(context).textTheme.subtitle2),
                    onTap: () async {
                      showLoadingAnimation(context);
                      setState(() {
                        contentType = "video";
                      });

                      final String? videoUrl = await utilService!.postPickVideos(folder: "journal post", context: context);

                      if (videoUrl != null && videoUrl.isNotEmpty) {
                        final String thumbnailUrl = await utilService!.videoThumbnail(folder: "journal post", url: videoUrl);
                        if (widget.journalEdit != null) {
                          media.addJournalNewMediaImage({
                            "url": videoUrl,
                            "thumbnail": thumbnailUrl,
                            "fileName": utilService!.fileName,
                            "contentType": contentType,
                            "entityType": "story"
                          });
                          media.addJournalMediaImage({
                            "url": videoUrl,
                            "thumbnail": thumbnailUrl,
                            "fileName": utilService!.fileName,
                            "contentType": contentType,
                            "entityType": "story"
                          });
                        } else {
                          media.addJournalMediaImage({
                            "url": videoUrl,
                            "thumbnail": thumbnailUrl,
                            "fileName": utilService!.fileName,
                            "contentType": contentType,
                            "entityType": "story"
                          });
                        }
                      }

                      Navigator.pop(context); // Dismiss loading indicator
                      Navigator.pop(context); // Close current screen

                      setState(() {
                        // Reset state if needed
                      });
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: new ListTile(
                      leading: Container(
                        height: 38.h,
                        width: 35.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            border:
                                Border.all(color: Colors.black12, width: 0.1),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .indicatorColor
                                    .withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/app gallery.png"),
                                fit: BoxFit.fill)),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      title: new Text("Photo Library",
                          // 'Browse',
                          style: Theme.of(context).textTheme.subtitle2),
                      onTap: () async {
                        // setState(() {
                        showLoadingAnimation(context);
                        contentType = "image";
                        // isLoadingProgress = true;
                        await utilService!
                            .postBrowseImage(folder: "journal post",context: context)
                            .then((String value) => setState(() {
                                  Navigator.of(context).pop();
                                  // isLoadingProgress = false;
                                  url = value;
                                  if (url != "") {
                                    if (widget.journalEdit != null) {
                                      media.addJournalNewMediaImage(
                                        {
                                          "url": url,
                                          "thumbnail": url,
                                          "fileName": utilService!.fileName,
                                          "contentType": contentType,
                                          "entityType": "story"
                                        },
                                      );
                                      media.addJournalMediaImage(
                                        {
                                          "url": url,
                                          "thumbnail": url,
                                          "fileName": utilService!.fileName,
                                          "contentType": contentType,
                                          "entityType": "story"
                                        },
                                      );
                                    } else {
                                      media.addJournalMediaImage(
                                        {
                                          "url": url,
                                          "thumbnail": url,
                                          "fileName": utilService!.fileName,
                                          "contentType": contentType,
                                          "entityType": "story"
                                        },
                                      );
                                    }
                                    // Provider.of<CategoryProvider>(context,
                                    //         listen: false)
                                    //     .setImages(
                                    //   {
                                    //     "url": url,
                                    //     "fileName": utilService!.fileName,
                                    //     "contentType": contentType,
                                    //     "entityType": "story"
                                    //   },
                                    // );
                                  }
                                }));
                        // });
                        // isLoadingProgress = false;

                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: new ListTile(
                      leading: Container(
                        height: 38.h,
                        width: 35.h,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(0),
                            border:
                                Border.all(color: Colors.black12, width: 0.1),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .indicatorColor
                                    .withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            image: DecorationImage(
                              image: AssetImage("assets/images/camera.png"),
                              scale: 3,
                              // fit: BoxFit.fill
                            )),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      title: new Text("Camera",
                          // 'Browse',
                          style: Theme.of(context).textTheme.subtitle2),
                      onTap: () async {
                        // setState(() {
                        contentType = "image";
                        showLoadingAnimation(context);
                        // isLoadingProgress = true;
                        await utilService!
                            .postCaptureImage(
                                folder: "journal post", context: context)
                            .then((String value) => setState(() {
                                  Navigator.of(context).pop();
                                  // isLoadingProgress = false;
                                  url = value;
                                  if (url != "") {
                                    if (widget.journalEdit != null) {
                                      media.addJournalNewMediaImage(
                                        {
                                          "url": url,
                                          "thumbnail": url,
                                          "fileName": utilService!.fileName,
                                          "contentType": contentType,
                                          "entityType": "story"
                                        },
                                      );
                                      media.addJournalMediaImage(
                                        {
                                          "url": url,
                                          "thumbnail": url,
                                          "fileName": utilService!.fileName,
                                          "contentType": contentType,
                                          "entityType": "story"
                                        },
                                      );
                                    } else {
                                      media.addJournalMediaImage(
                                        {
                                          "url": url,
                                          "thumbnail": url,
                                          "fileName": utilService!.fileName,
                                          "contentType": contentType,
                                          "entityType": "story"
                                        },
                                      );
                                    }
                                    // Provider.of<CategoryProvider>(context,
                                    //         listen: false)
                                    //     .setImages(
                                    //   {
                                    //     "url": url,
                                    //     "fileName": utilService!.fileName,
                                    //     "contentType": contentType,
                                    //     "entityType": "story"
                                    //   },
                                    // );
                                  }
                                }));
                        // });
                        // isLoadingProgress = false;

                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: new ListTile(
                      leading: Container(
                        height: 38.h,
                        width: 35.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            border:
                                Border.all(color: Colors.black12, width: 0.1),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .indicatorColor
                                    .withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/app gallery.png"),
                                fit: BoxFit.fill)),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      title: new Text("App Gallery",
                          // 'Browse',
                          style: Theme.of(context).textTheme.subtitle2),
                      onTap: () async {
                        Provider.of<MediaGalleryProvider>(context,
                                listen: false)
                            .mediaGalleryRoute = "Journal";
                        var storageService = locator<StorageService>();
                        await storageService.setData(
                            "route", "/create-journal-story-screen");
                        navigationService!.navigateTo(MediaGalleryScreenRoute);
                      },
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(top: 10),
                  //   child: new ListTile(
                  //     leading: Container(
                  //       height: 38.h,
                  //       width: 35.h,
                  //       decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(0),
                  //           border:
                  //           Border.all(color: Colors.black12, width: 0.1),
                  //           boxShadow: [
                  //             BoxShadow(
                  //               color: Theme.of(context)
                  //                   .indicatorColor
                  //                   .withOpacity(0.2),
                  //               spreadRadius: 3,
                  //               blurRadius: 10,
                  //               offset:
                  //               Offset(0, 3), // changes position of shadow
                  //             ),
                  //           ],
                  //          ),
                  //       child: Icon(Icons.mic),
                  //     ),
                  //     trailing: Icon(Icons.keyboard_arrow_right),
                  //     title: new Text("Audio Library",
                  //         // 'Browse',
                  //         style: Theme.of(context).textTheme.subtitle2),
                  //     onTap: () async {
                  //       // setState(() {
                  //       showLoadingAnimation(context);
                  //       contentType = "audio";
                  //       // isLoadingProgress = true;
                  //       await utilService!
                  //           .postBrowseAudio(folder: "journal post", context: context)
                  //           .then((String value) => setState(() {
                  //         // isLoadingProgress = false;
                  //         Navigator.of(context).pop();
                  //         url = value;
                  //         if (url != "") {
                  //           if (widget.journalEdit != null) {
                  //             media.addJournalNewMediaImage(
                  //               {
                  //                 "url": url,
                  //                 "thumbnail": url,
                  //                 "fileName": utilService!.fileName,
                  //                 "contentType": contentType,
                  //                 "entityType": "story"
                  //               },
                  //             );
                  //             media.addJournalMediaImage(
                  //               {
                  //                 "url": url,
                  //                 "thumbnail": url,
                  //                 "fileName": utilService!.fileName,
                  //                 "contentType": contentType,
                  //                 "entityType": "story"
                  //               },
                  //             );
                  //           } else {
                  //             media.addJournalMediaImage(
                  //               {
                  //                 "url": url,
                  //                 "thumbnail": url,
                  //                 "fileName": utilService!.fileName,
                  //                 "contentType": contentType,
                  //                 "entityType": "story"
                  //               },
                  //             );
                  //           }
                  //           // Provider.of<CategoryProvider>(context,
                  //           //         listen: false)
                  //           //     .setImages(
                  //           //   {
                  //           //     "url": url,
                  //           //     "fileName": utilService!.fileName,
                  //           //     "contentType": contentType,
                  //           //     "entityType": "story"
                  //           //   },
                  //           // );
                  //         }
                  //       }));
                  //       // });
                  //       // isLoadingProgress = false;
                  //
                  //       Navigator.of(context).pop();
                  //     },
                  //   ),
                  // ),
                ],
              ),
            );
          });
        });
  }
}
