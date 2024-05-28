import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/linkStories_familytree&storybook_provider.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/user_media_images_widget.dart';
import 'package:mystory_flutter/widgets/user_media_videos_widget.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../widgets/read_more_widget.dart';
import 'create_profile_screen.dart';
import 'package:readmore/readmore.dart';

class MyProfileScreen extends StatefulWidget {
  MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  var navigationService = locator<NavigationService>();
  var getUserData;

  // bool isLinkedLoading = false;
  bool isListloading = false;
  List imagesData = [];
  List videosData = [];

  @override
  void initState() {
    getUserData = Provider.of<AuthProviderr>(context, listen: false).user;
    print("getUserData");
    print(getUserData);
    super.initState();
    getMedia();
  }

  getMedia() async {
    setState(() {
      isListloading = true;
    });
    await Provider.of<AuthProviderr>(context, listen: false)
        .fetchUserMediaGalleryImages(
            id: getUserData.id, count: 10, page: 1, context: context);
    await Provider.of<AuthProviderr>(context, listen: false)
        .fetchUserMediaGalleryVideos(
            id: getUserData.id, count: 10, page: 1, context: context);

    imagesData =
        Provider.of<AuthProviderr>(context, listen: false).getUserImages;
    videosData =
        Provider.of<AuthProviderr>(context, listen: false).getUserVideos;

    setState(() {
      isListloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Tab> selectTabs = <Tab>[
      Tab(
        icon: Icon(
          Icons.image,
          // [0] == [0] ?
        ),

        //  : Colors.grey.shade900,
      ),
      Tab(
          icon: Icon(
        Icons.video_call,
        // [0] == [0] ?
      )

          //  : Colors.grey.shade900,
          ),
    ];
    return DefaultTabController(
      length: selectTabs.length,
      child: WillPopScope(
        onWillPop: () async {
          var storageService;
          storageService = locator<StorageService>();
          var data = await storageService.getData("route");
          if (data == "" || data == null) {
            navigationService.navigateTo(MaindeshboardRoute);
          } else if (data == "/storybook-screen") {
            navigationService.navigateTo(MaindeshboardRoute);
          } else if (data == "/chat-screen") {
            navigationService.navigateTo(MaindeshboardRoute);
          } else if (data == "/myjournal-screen") {
            navigationService.navigateTo(MaindeshboardRoute);
          } else {
            navigationService.navigateTo(data);
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: InkWell(
              onTap: () async {
                // Navigator.of(context).pop();
                var storageService;
                storageService = locator<StorageService>();
                var data = await storageService.getData("route");
                if (data == "" || data == null) {
                  // print('arso data from if $data');
                  navigationService.navigateTo(MaindeshboardRoute);
                } else if (data == "/storybook-screen") {
                  //print('arso data from else if $data');
                  navigationService.navigateTo(MaindeshboardRoute);
                } else if (data == "/myprofile-screen") {
                  //print('arso data from else if $data');
                  // navigationService.navigateTo(MaindeshboardRoute);
                  Navigator.pop(context);
                } else if (data == "/chat-screen") {
                  navigationService.navigateTo(MaindeshboardRoute);
                } else if (data == "/myjournal-screen") {
                  navigationService.navigateTo(MaindeshboardRoute);
                } else {
                  //  print('arso data from else$data');
                  navigationService.navigateTo(data);
                }

                // navigationService.navigateTo(MaindeshboardRoute);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 24.h,
              ),
            ),
            centerTitle: true,
            title: Text(
              "My Profile",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return CreateProfile(
                        title: "Edit Profile", editData: getUserData);
                  }));
                  // navigationService.navigateTo(EditProfileScreenRoute);
                },
                child: Image(
                  image: AssetImage(
                    "assets/images/Edit Square.png",
                  ),
                ),
              ),
            ],
          ),
          body: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.red.shade100,
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                    offset: Offset(0, 6))
                              ]),
                          child: CircleAvatar(
                            backgroundColor: Colors.orange.shade900,
                            radius: 28,
                            child: getUserData.profilePicture == ""
                                ? CircleAvatar(
                                    radius: 25,
                                    backgroundImage: AssetImage(
                                        "assets/images/place_holder.png"))
                                : CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).backgroundColor,
                                    radius: 25,
                                    backgroundImage: NetworkImage(
                                        getUserData.profilePicture.toString())),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            // var storageService = locator<StorageService>();
                            // await storageService.setData(
                            //     "route", "/myprofile-screen");
                            navigationService.navigateTo(StoryBookscreenRoute);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                intl.NumberFormat.compact()
                                    .format(getUserData.storyBookCount),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp),
                              ),
                              Text(
                                "Storybook",
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Color.fromRGBO(141, 141, 141, 1),
                                    height: 1.7),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            height: 40,
                            child: VerticalDivider(
                              color: Colors.grey.shade200,
                              width: 2,
                              thickness: 2,
                            )),
                        InkWell(
                          onTap: () async {
                            var storageService = locator<StorageService>();
                            await storageService.setData(
                                "route", "/myprofile-screen");
                            navigationService.navigateTo(FamilyTreeListRoute);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                getUserData.treeBookCount.toString(),
                                // intl.NumberFormat.compact()
                                //     .format(getUserData.treeBookCount),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp),
                              ),
                              Text(
                                "Family Tree",
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Color.fromRGBO(141, 141, 141, 1),
                                    height: 1.7),
                              ),
                            ],
                          ),
                        ),
                        //LinkStory Book Comment
                        // Container(
                        //     height: 40,
                        //     child: VerticalDivider(
                        //       color: Colors.grey.shade200,
                        //       width: 2,
                        //       thickness: 2,
                        //     )),
                        // InkWell(
                        //   onTap: () async {
                        //     context.read<LinkFamilyStoryProvider>().linkRoute =
                        //         "ProfileScreen";
                        //     // setState(() {
                        //     //   isLinkedLoading = true;
                        //     // });
                        //
                        //     // await context
                        //     //     .read<LinkFamilyStoryProvider>()
                        //     //     .userLinkedStories(count: 10, page: 1);
                        //     // setState(() {
                        //     //   isLinkedLoading = false;
                        //     // });
                        //     navigationService.navigateTo(
                        //         MyProfileLinkedStoryBookScreenRoute);
                        //   },
                        //   child:
                        //       // isLinkedLoading
                        //       //     ? CircularProgressIndicator()
                        //       //     :
                        //       Container(
                        //     height: 70,
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       children: [
                        //         SizedBox(
                        //           height: 18,
                        //         ),
                        //         Text(
                        //           intl.NumberFormat.compact()
                        //               .format(getUserData.linkStoryCount),
                        //           style: TextStyle(
                        //               fontWeight: FontWeight.bold,
                        //               fontSize: 14.sp),
                        //         ),
                        //         Container(
                        //           padding: EdgeInsets.only(top: 2.h),
                        //           // width: 70,
                        //           child: Text(
                        //             "Linked Storybook",
                        //             textAlign: TextAlign.center,
                        //             style: TextStyle(
                        //                 fontSize: 10.sp,
                        //                 color: Color.fromRGBO(141, 141, 141, 1),
                        //                 height: 1.3),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        SizedBox()
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${getUserData.firstName} ${getUserData.middleName} ${getUserData.lastName}",
                    // getUserData.fullName,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "DOB:  ",
                        style: TextStyle(
                            fontSize: 12.sp, color: Colors.grey.shade500),
                      ),
                      Text(
                        getUserData.dob,
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Wrap(
                    children: [
                      Text(
                        "BIRTH PLACE:  ",
                        style: TextStyle(
                            fontSize: 12.sp, color: Colors.grey.shade500),
                      ),
                      Container(
                        // margin: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          getUserData.address["countryValue"] == "" ||
                                  getUserData.address == null
                              ? ""
                              : getUserData.address["cityValue"] +
                                  ", " +
                                  getUserData.address["stateValue"] +
                                  ", " +
                                  getUserData.address["countryValue"].trim(),
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "HOME TOWN:  ",
                        style: TextStyle(
                            fontSize: 12.sp, color: Colors.grey.shade500),
                      ),
                      Text(
                        getUserData.homeTown == null
                            ? ""
                            : getUserData.homeTown,
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Consumer<AuthProviderr>(
                      builder: (context, relationship, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Text(
                              "${relationship.getRelationShip[index].relation!.relationName} : ",
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.grey.shade500),
                            ),
                            Text(
                              "${relationship.getRelationShip[index].firstName} ${relationship.getRelationShip[index].lastName}",
                              style: TextStyle(
                                  fontSize: 12.sp, fontWeight: FontWeight.w600),
                            )
                          ],
                        );
                      },
                      itemCount: relationship.getRelationShip.length,
                    );
                  }),
                  SizedBox(
                    height: 10.h,
                  ),
                  ReadMoreTextWidget(
                    getUserData.shortDescription,
                    textAlign: TextAlign.start,

                    style:  TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
                    trimLines: 4,
                    trimLength: 200,
                    moreStyle:  TextStyle(
                        color: Color(0xff2069d3),
                        fontWeight: FontWeight.w600),
                    lessStyle:   TextStyle(
                        color: Color(0xff2069d3),
                        fontWeight: FontWeight.w600),

                  ),
                  // ReadMoreText(
                  //   getUserData.shortDescription,
                  //   trimLines: 2,
                  //   style:
                  //       TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                  //   colorClickableText:  Color(0xff2069d3),
                  //   trimMode: TrimMode.Line,
                  //   trimCollapsedText: 'See more',
                  //   trimExpandedText: 'See less',
                  //   moreStyle: TextStyle(
                  //       fontSize: 12.sp,
                  //       fontWeight: FontWeight.w600,
                  //       color:  Color(0xff2069d3)),
                  //   textAlign: TextAlign.left,
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                  TabBar(
                      tabs: selectTabs,
                      labelColor: Color.fromRGBO(229, 130, 108, 1),
                      // isScrollable: true,

                      indicatorWeight: 2,
                      indicatorPadding: EdgeInsets.zero,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: Color.fromRGBO(229, 130, 108, 1),
                      unselectedLabelColor: Colors.grey.shade500),
                  Expanded(
                    // height: MediaQuery.of(context).size.height,
                    child: TabBarView(
                      children: [
                        isListloading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : UserMediaImagesWidget(data: imagesData),
                        isListloading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : UserMediaVideosWidget(data: videosData)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
