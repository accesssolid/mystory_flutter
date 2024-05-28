import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mystory_flutter/global.dart';
import 'package:mystory_flutter/mention_pack/flutter_mentions.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
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
import 'package:mystory_flutter/widgets/gallery_options_alert.dart';
import 'package:mystory_flutter/widgets/invite_categories_widget.dart';
import 'package:mystory_flutter/widgets/invite_selected_sub_categories_widget.dart';
import 'package:mystory_flutter/widgets/invite_sub_categories_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import '../models/category.dart';
import '../providers/category_provider.dart';
import '../widgets/column_scroll_view.dart';
import 'ai_assistant_screen.dart';

class CreateStoryScreen extends StatefulWidget {
  // final postTitle;
  final postEdit;
  String? subId;
  String? route;

  CreateStoryScreen(
      {
      // this.postTitle,
      this.postEdit,
      this.subId,
      this.route});

  @override
  _CreateStoryScreenState createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();
  String message = '';
  bool isCurrentUserTyping = false;
  FocusNode? _focusNode;

  void onTextFieldTapped() {}

  // bool isCurrentUserTyping = false;

  Uint8List? imageBytes;
  UtilService? utilService = locator<UtilService>();
  NavigationService? navigationService = locator<NavigationService>();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  String? captureDetail;
  List<CategoryModel> categoryData = [];
  bool isLoading = false;
  var pId;
  var sId;
  var subCategories = [];
  var getUserData;
  var selectedCategory;
  String? selectsubcategory;
  List? memberItems = ["Friend", "Family"];
  var relation;
  bool isLoadingProgress = false;
  bool isMediaLoading = false;
  var user;

  // var media;
  var url;
  String contentType = "";
  String tagId = ' ';

  void active(val) {
    setState(() {
      tagId = val;
    });
  }

  int? deleteIndex;

  // void locationOfPainCallback(String lop) {
  //   setState(() => relation = lop);
  // }

  bool _sel = false;

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
  //   context.read<MediaGalleryProvider>().mediaImages.length =
  //       context.read<MediaGalleryProvider>().mediaImages.length -
  //           context.read<MediaGalleryProvider>().newMediaImages.length;
  // }

  @override
  void initState() {
    getUserData = Provider.of<AuthProviderr>(context, listen: false).user;
    categoryData =
        Provider.of<CategoryProvider>(context, listen: false).getAllCategories;
    // media = Provider.of<CategoryProvider>(context, listen: false).getMedia;
    user = Provider.of<AuthProviderr>(context, listen: false).user;
    if (widget.postEdit != null) {
      // editLength = widget.postEdit['media'].length;
      titleController.text = widget.postEdit['storyTitle'];
      descriptionController.text = widget.postEdit['description'];
      yearController.text = widget.postEdit['year'] ?? "";
      monthController.text = widget.postEdit['month'] ?? "";
      dayController.text = widget.postEdit['day'] ?? "";

      // for(var i = 0; widget.postEdit['catagory'].length > i ; i++){

      //   widget.postEdit['catagory'][i]['parentId'] == null ?
      context.read<MediaGalleryProvider>().mediaImages =
          widget.postEdit['media'];
      // selectedCategory = widget.postEdit['catagory'][0]['categoryName'];
      // selectsubcategory = widget.postEdit['catagory'][1]['categoryName'];

      // }
    }

    super.initState();
  }

  void _onMessageChanged(String value) {
    setState(() {
      message = value;

      if (value.trim().isEmpty) {
        isCurrentUserTyping = false;
        return;
      } else {
        isCurrentUserTyping = true;
        // print(value);
      }
    });
    descriptionController.text = message;
  }

  var image;

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
      return AbsorbPointer(
        absorbing: isLoadingProgress,
        child: Stack(children: [
          WillPopScope(
            onWillPop: () async {
              await Provider.of<PostProvider>(context, listen: false)
                  .cleargetTagUsersObj();
              Provider.of<CategoryProvider>(context, listen: false)
                  .nullCreateStorySubCatSelectList();
              Provider.of<CategoryProvider>(context, listen: false)
                  .nullCategorySubDataCreateStory();
              context.read<MediaGalleryProvider>().clearMediaImages();
              navigationService!.navigateTo(MaindeshboardRoute);
              // navigationService!.closeScreen();
              return true;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                  child: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    bottom: AppBar(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      centerTitle: true,
                      title: Padding(
                        padding: EdgeInsets.only(
                            top: widget.postEdit != null ? 0 : 15),
                        child: Text(
                          widget.postEdit != null
                              ? context
                                  .read<MediaGalleryProvider>()
                                  .postTitle
                                  .toString()
                              : "Create Story",
                          // "Create Story",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      actions: [
                        widget.postEdit == null
                            ? Padding(
                                padding: EdgeInsets.only(
                                    top: widget.postEdit != null ? 0 : 17),
                                child: IconButton(
                                    onPressed: () async {
                                      await Provider.of<PostProvider>(context,
                                              listen: false)
                                          .cleargetTagUsersObj();
                                      Provider.of<CategoryProvider>(context,
                                              listen: false)
                                          .nullCreateStorySubCatSelectList();
                                      Provider.of<CategoryProvider>(context,
                                              listen: false)
                                          .nullCategorySubDataCreateStory();
                                      context
                                          .read<MediaGalleryProvider>()
                                          .clearMediaImages();
                                      navigationService!
                                          .navigateTo(MaindeshboardRoute);
                                      // navigationService!.closeScreen();
                                    },
                                    icon:
                                        Icon(Icons.close, color: Colors.black)),
                              )
                            : Container()
                      ],
                      leading: widget.postEdit != null
                          ? Padding(
                              padding: EdgeInsets.only(
                                  top: widget.postEdit != null ? 0 : 17),
                              child: IconButton(
                                  onPressed: () async {
                                    await Provider.of<PostProvider>(context,
                                            listen: false)
                                        .cleargetTagUsersObj();
                                    Provider.of<CategoryProvider>(context,
                                            listen: false)
                                        .nullCreateStorySubCatSelectList();
                                    Provider.of<CategoryProvider>(context,
                                            listen: false)
                                        .nullCategorySubDataCreateStory();
                                    context
                                        .read<MediaGalleryProvider>()
                                        .clearMediaImages();
                                    navigationService!
                                        .navigateTo(MaindeshboardRoute);
                                    // navigationService!.closeScreen();
                                  },
                                  icon: Icon(Icons.arrow_back,
                                      color: Colors.black)),
                            )
                          : Container(),
                    ),
                  ),
                  preferredSize:
                      Size.fromHeight(widget.postEdit != null ? 60 : 80)),
              body: Consumer<CategoryProvider>(builder: (context, cp, child) {
                return ColumnScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding:
                            EdgeInsets.only(left: 13.h, right: 13.h, top: 5),
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
                                            backgroundColor: Theme.of(context)
                                                .backgroundColor,
                                            backgroundImage: NetworkImage(
                                              getUserData.profilePicture,
                                            )),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "@${getUserData.firstName}${getUserData.lastName}"
                                            .toLowerCase(),
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Color.fromRGBO(
                                                161, 161, 161, 1)),
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Text(
                                        "${getUserData.firstName} ${getUserData.lastName}",
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 4.h,
                                      ),
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
                                    " Story Title",
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
                                // height: 45.h,
                                child: TextField(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.sp,
                                  ),
                                  controller: titleController,
                                  maxLength: 100,
                                  maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced,
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
                                            color: Theme.of(context)
                                                .primaryColor)),
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
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Text(
                                " Story Date",
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.black87),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      // height: 45.h,
                                      child: TextField(
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.sp,
                                        ),
                                        controller: yearController,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        maxLength: 4,
                                        onChanged: (val) {},
                                        decoration: InputDecoration(
                                          isDense: true,
                                          counter: Offstage(),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .indicatorColor)),
                                          disabledBorder: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .primaryColor)),
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
                                          hintText: "Year*",
                                          fillColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Container(
                                      // height: 45.h,
                                      child: TextField(
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.sp,
                                        ),
                                        controller: monthController,
                                        keyboardType: TextInputType.number,
                                        maxLength: 2,
                                        textInputAction: TextInputAction.next,
                                        onChanged: (val) {
                                          if (int.parse(monthController.text
                                                  .toString()) >
                                              12) {
                                            monthController.text = '';
                                            utilService!.showToast(
                                                "Month cannot be greater then 12",
                                                context);
                                          }
                                        },
                                        decoration: InputDecoration(
                                          isDense: true,
                                          counter: Offstage(),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .indicatorColor)),
                                          disabledBorder: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .primaryColor)),
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
                                          hintText: "Month",
                                          fillColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Container(
                                      // height: 45.h,
                                      child: TextField(
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.sp,
                                        ),
                                        keyboardType: TextInputType.number,
                                        controller: dayController,
                                        onChanged: (val) {
                                          if (int.parse(dayController.text
                                                  .toString()) >
                                              31) {
                                            dayController.text = '';
                                            utilService!.showToast(
                                                "Day cannot be greater then 31",
                                                context);
                                          }
                                        },
                                        maxLength: 2,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          counter: Offstage(),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .indicatorColor)),
                                          disabledBorder: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .primaryColor)),
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
                                          hintText: "Day",
                                          fillColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Stack(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
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
                                          Text(
                                            " Capture Details of story here",
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.grey.shade600),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Stack(
                                        // clipBehavior: Clip.none,
                                        //   fit: StackFit.loose,
                                        // overflow: Overflow.visible,
                                        children: <Widget>[
                                          if(captureDetail!=null&&captureDetail!="")
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width,
                                              child: TextField(controller:  descriptionController,
                                                maxLines: null,
                                                maxLength: 10000,
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
                                                            color: Theme.of(context)
                                                                .primaryColor)),
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
                                                autofocus: false,),
                                            ),
                                          if(captureDetail==null || captureDetail=="")
                                            FlutterMentions(
                                              key: key,

                                              suggestionPosition: SuggestionPosition.Top,
                                              maxLines: 5,
                                              maxLength: 10000,
                                              maxLengthEnforcement:
                                              MaxLengthEnforcement.enforced,
                                              // minLines: 1,
                                              defaultText: widget.postEdit != null
                                                  ? widget.postEdit['description']
                                                  : "",

                                              focusNode: _focusNode,
                                              keyboardType: TextInputType.multiline,   // changed by chetu on 6 nov 2023.
                                              onChanged: _onMessageChanged,
                                              //   textInputAction: TextInputAction.newline,   // commented by chetu
                                              style:
                                              TextStyle(color: Colors.black, height: 1),
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
                                                          color: Theme.of(context)
                                                              .primaryColor)),
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
                                              autofocus: false,

                                              suggestionListDecoration: BoxDecoration(
                                                color: Theme.of(context).backgroundColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              onTap: () => onTextFieldTapped(),
                                              mentions: [
                                                Mention(
                                                    trigger: '@',
                                                    style: const TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                    data: context
                                                        .read<InviteProvider>()
                                                        .tagFamilyTree,
                                                    matchAll: false,
                                                    suggestionBuilder: (data) {
                                                      return Container(
                                                        // decoration: BoxDecoration(
                                                        //   // borderRadius: BorderRadius.circular(10),
                                                        //   color:
                                                        //       Theme.of(context).backgroundColor,
                                                        // ),
                                                        padding: const EdgeInsets.all(10.0),
                                                        // margin: const EdgeInsets.all(10.0),
                                                        child: Column(children: [
                                                          Row(
                                                            children: <Widget>[
                                                              ClipRRect(
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    360),
                                                                child: CircleAvatar(
                                                                  backgroundColor: Colors.red,
                                                                  backgroundImage:
                                                                  NetworkImage(
                                                                    data['image'],
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 20.0,
                                                              ),
                                                              Column(
                                                                children: <Widget>[
                                                                  Text(
                                                                    data['full_name'],
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 13.sp,
                                                                        fontWeight:
                                                                        FontWeight.w400),
                                                                  ),
                                                                  // Text(
                                                                  //   '@${data['full_name']}',
                                                                  //   style: TextStyle(
                                                                  //     color: Colors.white,
                                                                  //   ),
                                                                  // ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          Divider(
                                                            color: Colors.white,
                                                          )
                                                        ]),
                                                      );
                                                    }),
                                              ],
                                            ),




                                        ],
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    right: 1,

                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () async {
                                        print("ONTAP ONTAP ONTAP ONTAP ONTAP ONTAP=====");
                                        var data = await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => AiAssistantPage()),
                                        );
                                        if (data != null) {
                                          setState(() {
                                            captureDetail = data;
                                            descriptionController.text = data;
                                          });
                                        }
                                        print("IN CREATE STROY PAGE===\n\n");
                                        print(data);
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: Text("Tap for AI Assistant",style: TextStyle(fontSize: 12),),
                                          ),
                                          IgnorePointer(
                                            child: Container(
                                            //  color: Colors.amber,
                                              width: 81,
                                              child: Row(
                                                crossAxisAlignment:CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(""),
                                                  Center(
                                                    child: Image(
                                                      width: 64,
                                                      height: 74,
                                                      image: AssetImage('assets/images/editimage.png'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              // TextField(
                              //   style: TextStyle(
                              //     color: Colors.black,
                              //     fontSize: 13.sp,
                              //   ),
                              //   maxLines: 5,
                              //   controller: descriptionController,
                              //   textInputAction: TextInputAction.next,
                              //   decoration: InputDecoration(
                              //       enabledBorder: OutlineInputBorder(
                              //           borderSide: BorderSide(
                              //               width: 1,
                              //               color:
                              //                   Theme.of(context).indicatorColor)),
                              //       disabledBorder: InputBorder.none,
                              //       focusedBorder: OutlineInputBorder(
                              //           borderSide: BorderSide(
                              //               width: 1,
                              //               color: Theme.of(context).primaryColor)),
                              //       errorBorder: InputBorder.none,
                              //       filled: true,
                              //       hintStyle: TextStyle(
                              //         color: Color.fromRGBO(
                              //           218,
                              //           219,
                              //           221,
                              //           1,
                              //         ),
                              //       ),
                              //       hintText: "Write Comments..",
                              //       fillColor: Colors.white,
                              //       contentPadding: EdgeInsets.symmetric(
                              //           horizontal: 14.h, vertical: 12.h)),
                              // ),
                              SizedBox(
                                height: 15.h,
                              ),
                              if (widget.postEdit == null)
                                Row(
                                  children: [
                                    Text(
                                      " Select Storybook Category",
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
                              if (widget.postEdit == null)
                                SizedBox(
                                  height: 8.h,
                                ),
                              if (widget.postEdit == null)
                                GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 4 / 0.6,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 1.0,
                                      mainAxisSpacing: 1.0,
                                    ),
                                    itemCount: cp.categoryData.length-1,
                                    itemBuilder: (context, index) {
                                      index = index+1;
                                      return InviteCategoriesWidget(
                                        data: cp.categoryData[index],
                                        tag: cp.categoryData[index].id,
                                        action: active,
                                        active:
                                            tagId == cp.categoryData[index].id
                                                ? true
                                                : false,
                                      );
                                    }),
                              // Container(
                              //   padding: EdgeInsets.only(left: sx(4)),
                              //   decoration: BoxDecoration(
                              //     border: Border.all(
                              //       width: 1,
                              //       color: Colors.grey.shade400,
                              //     ),
                              //   ),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     children: [
                              //       DropdownButton(
                              //         dropdownColor: Colors.white,
                              //         menuMaxHeight: 200,

                              //         hint: Padding(
                              //           padding: EdgeInsets.only(left: sx(10)),
                              //           child: Text(
                              //             selectedCategory == "" ||
                              //                     selectedCategory == null
                              //                 ? "Select Category"
                              //                 : selectedCategory.toString(),
                              //             style: TextStyle(
                              //                 fontSize: sy(9),
                              //                 fontWeight: FontWeight.w600,
                              //                 color: Colors.grey.shade400),
                              //           ),
                              //         ),

                              //         // isExpanded: true,
                              //         style: TextStyle(
                              //             fontSize: sy(12),
                              //             color: Colors.white),
                              //         // value: selectCategory,
                              //         underline: SizedBox(),
                              //         onChanged: (newValue) {
                              //           setState(() {
                              //             selectedCategory = newValue;
                              //             // categoryData.where((element) => element.parentId);
                              //             // for (var i = 0;
                              //             //     i < categoryData.length;
                              //             //     i++) {
                              //             //   print(categoryData.[i]);
                              //             // }

                              //             // var test;

                              //             // List amount = categoryData
                              //             //     .map((value) => value.parentId)
                              //             //     .toList();
                              //             // for (var i = 0; i < amount.length; i++) {
                              //             //   test = amount[i];
                              //             // }
                              //             // print(amount);
                              //             // print(test);
                              //           });
                              //         },
                              //         icon: Icon(
                              //           Icons.keyboard_arrow_down,
                              //           color: Colors.blue,
                              //         ),
                              //         items: categoryData.map((valueItem) {
                              //           return DropdownMenuItem(
                              //             onTap: () async {
                              //               setState(() {
                              //                 isLoadingProgress = true;
                              //               });
                              //               await Provider.of<CategoryProvider>(
                              //                       context,
                              //                       listen: false)
                              //                   .fetchSubCategoriesCreateStory(
                              //                 id: valueItem.id ?? "",
                              //               );
                              //               pId = valueItem.id;
                              //               setState(() {
                              //                 isLoadingProgress = false;
                              //               });

                              //               await Provider.of<CategoryProvider>(
                              //                       context,
                              //                       listen: false)
                              //                   .setCategory(valueItem);

                              //               // print(valueItem.parentId);
                              //             },
                              //             value: valueItem.categoryName ?? "",
                              //             child: SizedBox(
                              //               width: MediaQuery.of(context)
                              //                       .size
                              //                       .width /
                              //                   1.22,
                              //               child: Text(
                              //                 "   ${valueItem.categoryName}",
                              //                 style: TextStyle(
                              //                     color: Colors.black,
                              //                     fontSize: sy(11)),
                              //               ),
                              //             ),
                              //           );
                              //         }).toList(),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              if (widget.postEdit == null)
                                SizedBox(
                                  height: 15.h,
                                ),
                              cp.categorySubDataCreateStory.isNotEmpty
                                  ? Column(
                                      children: [
                                        if (widget.postEdit == null)
                                          Row(
                                            children: [
                                              Text(
                                                " Select Subcategories",
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.black87),
                                              ),
                                              Text(
                                                "*",
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.red),
                                              ),
                                            ],
                                          ),
                                        if (widget.postEdit == null)
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                        if (widget.postEdit == null)
                                          GridView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                childAspectRatio: 4 / 0.6,
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 1.0,
                                                mainAxisSpacing: 1.0,
                                              ),
                                              itemCount: cp
                                                  .categorySubDataCreateStory
                                                  .length,
                                              itemBuilder: (context, index) {
                                                return InviteSubCategoriesWidget(
                                                  route: "Create Story",
                                                  data:
                                                      cp.categorySubDataCreateStory[
                                                          index],
                                                );
                                              }),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                      ],
                                    )
                                  : Container(),
                              cp.createStorySubCatSelectData.isNotEmpty
                                  ? Column(
                                      children: [
                                        if (widget.postEdit == null)
                                          Row(
                                            children: [
                                              Text(
                                                " Selected Subcategories",
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.black87),
                                              ),
                                              Text(
                                                "*",
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.red),
                                              ),
                                              Text(
                                                "(${cp.createStorySubCatSelectData.length})"
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.black87),
                                              ),
                                            ],
                                          ),
                                        if (widget.postEdit == null)
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                        if (widget.postEdit == null)
                                          GridView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                childAspectRatio: 4 / 0.6,
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 1.0,
                                                mainAxisSpacing: 1.0,
                                              ),
                                              itemCount: cp
                                                  .createStorySubCatSelectData
                                                  .length,
                                              itemBuilder: (context, index) {
                                                return SelectedInviteSubCategoriesWidget(
                                                  route: "Create Story",
                                                  data:
                                                      cp.createStorySubCatSelectData[
                                                          index],
                                                );
                                              }),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                      ],
                                    )
                                  : Container(),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 20.w,
                                        height: 18.h,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .indicatorColor,
                                                width: 1)),
                                        child: Theme(
                                          data: ThemeData(
                                            unselectedWidgetColor: Colors.white,
                                          ),
                                          child: Checkbox(
                                            value: _sel,
                                            activeColor:
                                                Theme.of(context).primaryColor,
                                            onChanged: (bool? resp) async {
                                              setState(() {
                                                _sel = resp!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.black87,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                text:
                                                    'Set story as confidential'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ])),
                    Consumer<MediaGalleryProvider>(
                        builder: (context, media, child) {
                      return Padding(
                        padding: EdgeInsets.all(12.h),
                        child: media.mediaImages.length != 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                      "Media:",
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.black87),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    GridView.builder(
                                        clipBehavior: Clip.none,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: media.mediaImages.length,
                                        shrinkWrap: true,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisSpacing: sy(5.0),
                                          crossAxisSpacing: sy(5.0),
                                          // childAspectRatio: 5 / 5,

                                          crossAxisCount: 2,
                                        ),
                                        itemBuilder: (context, i) {
                                          if (media.mediaImages[i]
                                                  ["contentType"] ==
                                              "image") {
                                            return Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  CacheImage(
                                                    placeHolder: "fdsf (2).png",
                                                    imageUrl: media
                                                        .mediaImages[i]["url"],
                                                    width: 500.w,
                                                    height: 140.h,
                                                    radius: 6.0,
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
                                          if (media.mediaImages[i]
                                                  ["contentType"] ==
                                              "audio") {
                                            return Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.r),
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
                                          } else {
                                            return Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                    child: CreatedStoryVideo(
                                                      img: media.mediaImages[i]
                                                          ["url"],
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
                                                              setState(() {
                                                                isMediaLoading =
                                                                    false;
                                                              });
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
                                List combineList = [];
                                List parentList = [];
                                List subCatList = [];
                                for (var j = 0;
                                    j < cp.createStoryParentCategoriesId.length;
                                    j++) {
                                  parentList.add(
                                      cp.createStoryParentCategoriesId[j].id);
                                }

                                for (var i = 0;
                                    i < cp.createStorySubCatSelectData.length;
                                    i++) {
                                  subCatList.add(
                                      cp.createStorySubCatSelectData[i]["id"]);
                                }
                                combineList = [
                                  ...cp.createStoryParentCategoriesId,
                                  ...cp.createStorySubCatSelectData,
                                ];
                                List<Map<String, dynamic>> tagList = [];
                                tagList = Provider.of<PostProvider>(context,
                                        listen: false)
                                    .getTagUsersObj;

                                if (titleController.text == ""

                                    //location.length == 0
                                    ) {
                                  utilService!.showToast(
                                      "Please fill all fields", context);
                                } else if (yearController.text == "") {
                                  utilService!
                                      .showToast("Please enter year", context);
                                } else if (int.parse(
                                        yearController.text.toString()) >
                                    DateTime.now().year) {
                                  utilService!.showToast(
                                      "year cannot be greater than current year",
                                      context);
                                } else if (parentList.isEmpty &&
                                    widget.postEdit == null) {
                                  utilService!.showToast(
                                      "Please select  category", context);
                                } else if (parentList.isNotEmpty &&
                                    subCatList.isEmpty &&
                                    widget.postEdit == null) {
                                  utilService!.showToast(
                                      "Please select sub category", context);
                                } else {
                                  setState(() {
                                    isLoadingProgress = true;
                                  });
                                  if (widget.postEdit != null) {
                                    button.createStorynewListDataAndOldList();
                                    await Provider.of<PostProvider>(context,
                                            listen: false)
                                        .updateStoryPost(
                                            catagory:
                                                widget.postEdit['catagory'],
                                            route: widget.route,
                                            subCatID: widget.subId,
                                            context: context,
                                            id: widget.postEdit["id"],
                                            storyTitle: titleController.text,
                                            description:
                                                descriptionController.text,
                                            addedByName:
                                                widget.postEdit["addedByName"],
                                            addedById:
                                                widget.postEdit["addedById"],
                                            addedByProfilePic: widget
                                                .postEdit["addedByProfilePic"],
                                            media: button.mediaImages,
                                            year: yearController.text,
                                            month: monthController.text,
                                            day: dayController.text,
                                            newMedia: button.newMediaImages,
                                            deletedMedia: deleteMedia,
                                            taggedUser: tagList,
                                            subCatagories: widget
                                                .postEdit['subCatagories'],
                                            isConfidential: _sel);
                                    button.clearMewMediaImages();
                                    // context
                                    //     .read<MediaGalleryProvider>()
                                    //     .clearMediaImages();
                                    // context
                                    //     .read<MediaGalleryProvider>()
                                    //     .clearMewMediaImages();
                                  } else {
                                    setState(() {
                                      isLoadingProgress = true;
                                    });
                                    await Provider.of<PostProvider>(context,
                                            listen: false)
                                        .createStoryPost(
                                            subCatID: widget.subId,
                                            context: context,
                                            catagory: combineList,
                                            parentsId: parentList,
                                            subCatagoriesId: subCatList,
                                            storyTitle: titleController.text,
                                            description:
                                                descriptionController.text,
                                            year: yearController.text,
                                            month: monthController.text,
                                            day: dayController.text,
                                            addedByName: getUserData.fullName,
                                            addedById: getUserData.id,
                                            addedByProfilePic:
                                                getUserData.profilePicture,
                                            media: button.mediaImages,
                                            //  context
                                            //     .read<MediaGalleryProvider>()
                                            //     .mediaImages,
                                            taggedUser: tagList,
                                            isConfidential: _sel);
                                    combineList = [];
                                    parentList = [];

                                    subCatList = [];
                                    Provider.of<CategoryProvider>(context,
                                            listen: false)
                                        .nullCreateStoryParentCategoriesId();

                                    Provider.of<CategoryProvider>(context,
                                            listen: false)
                                        .nullCreateStorySubCatSelectData();
                                    Provider.of<CategoryProvider>(context,
                                            listen: false)
                                        .nullCategorySubDataCreateStory();
                                    // context
                                    // .read<MediaGalleryProvider>()
                                    // .clearMediaImages();
                                    await Provider.of<PostProvider>(context,
                                            listen: false)
                                        .cleargetTagUsersObj();
                                    Provider.of<CategoryProvider>(context,
                                            listen: false)
                                        .nullCreateStorySubCatSelectList();
                                    Provider.of<CategoryProvider>(context,
                                            listen: false)
                                        .nullCategorySubDataCreateStory();

                                    context
                                        .read<MediaGalleryProvider>()
                                        .clearMediaImages();
                                  }
                                  setState(() {
                                    isLoadingProgress = false;
                                  });

                                  // await Provider.of<PostProvider>(context,
                                  //         listen: false)
                                  //     .fetchAllUserPost(getUserData.id);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                textStyle: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.03,
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
                                widget.postEdit != null
                                    ? "Update Story"
                                    : "Create Story",
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
                ));
              }),
            ),
          ),
          if (isLoadingProgress)
            Positioned.fill(
                child: Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ))
        ]),
      );
    });
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Consumer<MediaGalleryProvider>(
              builder: (context, media, child) {
            return Container(
              height: 290.h,
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
                            fit: BoxFit.fill,
                          )),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    title: new Text("Video Library",
                        style: Theme.of(context).textTheme.subtitle2),
                      onTap: () async {



                        showLoadingAnimation(context,showPercentage: true);

                           // //Listen to the uploadTask's snapshot stream to get the upload progress
                           // uploadTask.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
                           //   double percentage = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
                           //   // Update UI with the percentage value
                           //   print('Upload SDF SDF SDF  is ${percentage.toStringAsFixed(2)}% done');
                           //   Provider.of<AuthProviderr>(context, listen: false).setLoadingProgresss(percentage.toInt());
                           // });

                        contentType = "video";

                        final String? videoUrl = await utilService!.postPickVideos(folder: "post", context: context);

                        if (videoUrl != null && videoUrl.isNotEmpty) {
                          final String? fileName = await VideoThumbnail.thumbnailFile(
                            video: videoUrl,
                            thumbnailPath: (await getTemporaryDirectory()).path,
                            imageFormat: ImageFormat.PNG,
                            maxHeight: 0,
                            quality: 0,
                          );

                          if (fileName != null) {
                            final date = DateTime.now().microsecondsSinceEpoch;
                            final firebase_storage.Reference storageReference = FirebaseStorage.instance.ref().child("post/$date");
                            final File file = File(fileName);

                            final firebase_storage.UploadTask uploadTask = storageReference.putFile(file);
                            final firebase_storage.TaskSnapshot downloadUrl = await uploadTask.whenComplete(() => null);
                            final String urlasset = await downloadUrl.ref.getDownloadURL();

                            if (widget.postEdit != null) {
                              media.addNewMediaImage({
                                "url": videoUrl,
                                "thumbnail": urlasset,
                                "fileName": utilService!.fileName,
                                "contentType": contentType,
                                "entityType": "story"
                              });
                            }

                            media.addMediaImage({
                              "url": videoUrl,
                              "thumbnail": urlasset,
                              "fileName": utilService!.fileName,
                              "contentType": contentType,
                              "entityType": "story"
                            });
                          }
                        }
                        Provider.of<AuthProviderr>(context, listen: false).setLoadingProgresss(0);
                        Navigator.of(context).pop(); // Dismiss loading indicator
                        setState(() {}); // Update UI if needed
                        Navigator.of(context).pop(); // Close current screen
                      }
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
                            .postBrowseImage(folder: "post", context: context)
                            .then((String value) => setState(() {
                                  // isLoadingProgress = false;
                                  Navigator.of(context).pop();
                                  url = value;
                                  if (url != "") {
                                    if (widget.postEdit != null)
                                      media.addNewMediaImage(
                                        {
                                          "url": url,
                                          "thumbnail": url,
                                          "fileName": utilService!.fileName,
                                          "contentType": contentType,
                                          "entityType": "story"
                                        },
                                      );
                                    // context
                                    //     .read<MediaGalleryProvider>()
                                    //     .newMediaImages
                                    //     .add(
                                    //   {
                                    //     "url": url,
                                    //     "thumbnail": url,
                                    //     "fileName": utilService!.fileName,
                                    //     "contentType": contentType,
                                    //     "entityType": "story"
                                    //   },
                                    // );
                                    media.addMediaImage(
                                      {
                                        "url": url,
                                        "thumbnail": url,
                                        "fileName": utilService!.fileName,
                                        "contentType": contentType,
                                        "entityType": "story"
                                      },
                                    );
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
                                scale: 3
                                // fit: BoxFit.fill
                                )),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      title: new Text("Camera",
                          // 'Browse',
                          style: Theme.of(context).textTheme.subtitle2),
                      onTap: () async {
                        showLoadingAnimation(context);
                        contentType = "image";

                        await utilService!
                            .postCaptureImage(folder: "post", context: context)
                            .then((String value) => setState(() {
                                  Navigator.of(context).pop();

                                  url = value;
                                  if (url != "") {
                                    if (widget.postEdit != null)
                                      media.addNewMediaImage(
                                        {
                                          "url": url,
                                          "thumbnail": url,
                                          "fileName": utilService!.fileName,
                                          "contentType": contentType,
                                          "entityType": "story"
                                        },
                                      );
                                    media.addMediaImage(
                                      {
                                        "url": url,
                                        "thumbnail": url,
                                        "fileName": utilService!.fileName,
                                        "contentType": contentType,
                                        "entityType": "story"
                                      },
                                    );
                                  }
                                }));
                        // });
                        Navigator.of(context).pop();
                        // isLoadingProgress = false;
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
                            .mediaGalleryRoute = "Create Story";
                        var storageService = locator<StorageService>();
                        await storageService.setData(
                            "route", "/create-story-screen");
                        navigationService!.navigateTo(MediaGalleryScreenRoute);
                      },
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }
}
