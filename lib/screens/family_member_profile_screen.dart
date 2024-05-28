import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/chatProvider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/linkStories_familytree&storybook_provider.dart';
import 'package:mystory_flutter/screens/chat_message_screen.dart';
import 'package:mystory_flutter/screens/edit_permission_screen.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/gallery_widget.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mystory_flutter/widgets/video_gallery_widget.dart';
import 'package:provider/provider.dart';

class FamilyMemberProfileScreen extends StatefulWidget {
  @override
  _FamilyMemberProfileScreenState createState() =>
      _FamilyMemberProfileScreenState();
}

class _FamilyMemberProfileScreenState extends State<FamilyMemberProfileScreen> {
  var navigationService = locator<NavigationService>();

  var memberData;
  bool isLoading = false;
  bool isLoadingProgress = false;
  var userData;
  UtilService? utilService = locator<UtilService>();

  var user;
  Map<String, dynamic> seacrhData = {};
  Map<String, dynamic>? mediaData;
  Map<String, dynamic>? mediaDataVideos;
  var familyData;
  bool familyTreePermission = false;

  abc() async {
    print('arso ya yaha hai');

    String chatRoomId = await context.read<ChatProvider>().chatRoomId;
    print('chat room id $chatRoomId');
    if (chatRoomId.isEmpty || chatRoomId == null) {
      print('condition if');
      context.read<ChatProvider>().createChatRoom2(
          senderUser: context.read<AuthProviderr>().user,
          receiverUser: familyData);
      print('condition if 2');
    } else {
      memberData = await context.read<ChatProvider>().getChatPersonProfile();
      print(memberData);
    }
  }

  @override
  void initState() {
    familyData =
        Provider.of<InviteProvider>(context, listen: false).getFAmilyData;
    seacrhData = userData =
        Provider.of<InviteProvider>(context, listen: false).getSearchUserData;
    print("familyData");
    print(familyData.toString());
    seacrhData =
        Provider.of<InviteProvider>(context, listen: false).getSearchUserData;
    mediaData = Provider.of<InviteProvider>(context, listen: false)
        .getMemberMediaImageListData;
    mediaDataVideos = Provider.of<InviteProvider>(context, listen: false)
        .getMemberMediaVideotData;
    user = Provider.of<AuthProviderr>(context, listen: false).user;
    print(user);
    print(user.id);
    context.read<ChatProvider>().senderId =
        context.read<AuthProviderr>().user.id;
    context.read<ChatProvider>().receverId = familyData['id'];
    context.read<ChatProvider>().getChatRoomId().then((_) async {
      await abc();
    });
    familyMediaImages();
    familyMediaVideos();
    getPermissions();
    super.initState();
  }

  familyMediaImages() async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<InviteProvider>(context, listen: false)
        .fetchFamilyMediaGalleryImg(id: familyData['id'], page: 1, count: 10);
    print('Family Data: ${familyData['id']}');
    mediaData = Provider.of<InviteProvider>(context, listen: false)
        .getMemberMediaImageListData;
    setState(() {
      isLoading = false;
    });
    // } else {
    setState(() {
      isLoading = false;
    });
    // }
  }

  familyMediaVideos() async {
    setState(() {
      isLoading = true;
    });

    await Provider.of<InviteProvider>(context, listen: false)
        .fetchFamilyMediaGalleryVideos(
            context: context, id: familyData['id'], page: 1, count: 10);
    mediaDataVideos = Provider.of<InviteProvider>(context, listen: false)
        .getMemberMediaVideotData;
    setState(() {
      isLoading = false;
    });
  }

  storyAndLinkStory() async {
    setState(() {
      isLoadingProgress = true;
    });
    await context
        .read<LinkFamilyStoryProvider>()
        .familyMemberStories(count: 10, page: 1, id: familyData['id']);
    await context
        .read<LinkFamilyStoryProvider>()
        .familyMemberLinkedStories(count: 10, page: 1, id: familyData['id']);
    setState(() {
      isLoadingProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Tab> selectTabs = <Tab>[
      Tab(
        icon: Icon(
          Icons.image,
        ),
      ),
      Tab(
          icon: Icon(
        Icons.video_call,
      )),
    ];
    return DefaultTabController(
      length: selectTabs.length,
      child: Consumer<InviteProvider>(builder: (context, memberDetail, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () async {
                print("searchUserData");
                var storageService, data;
                storageService = locator<StorageService>();
                data = await storageService.getData("route");
                print(data);
                navigationService.navigateTo(data);
                navigationService.navigateTo(FamilyTreeListRoute);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  "My Family",
                  style:
                      TextStyle(color: Colors.grey.shade500, fontSize: 10.sp),
                ),
                Text(
                  memberDetail.searchUserData['firstName'] +
                      ' ' +
                      memberDetail.searchUserData['lastName'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    navigationService.navigateTo(EditPermissionScreenRoute);
                  },
                  icon: Icon(
                    Icons.settings,
                    color: Colors.black,
                  ))
            ],
          ),
          body: Container(
            child: Padding(
              padding: EdgeInsets.only(left: 12.0.w, right: 12.w),
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
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(memberDetail
                                  .searchUserData['profilePicture']),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            print("mediaData");
                            print(mediaData!.isEmpty);
                            print(mediaDataVideos!.isEmpty);
                            if (memberDetail.message == "no link" ||
                                mediaData!.isEmpty &&
                                    mediaDataVideos!.isEmpty) {
                              print("Aaya1");
                              return;
                            } else {
                              // if (context
                              //     .read<LinkFamilyStoryProvider>()
                              //     .familyMemberStoriesData
                              //     .isEmpty) {
                              //   print("Aaya2");
                              //   return;
                              // } else {
                              //
                                print("Aaya3");
                                context
                                    .read<LinkFamilyStoryProvider>()
                                    .linkRoute = "FamilyMemberScreen";
                                context
                                    .read<LinkFamilyStoryProvider>()
                                    .familyMemberId = familyData['id'];

                                navigationService.navigateTo(
                                    FamilyMemberStoryBookScreenRoute);
                           //   }
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                intl.NumberFormat.compact().format(memberDetail
                                    .searchUserData['storyBookCount']),
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
                        GestureDetector(
                          onTap: () async {
                            print("searchUserData");
                            print(memberDetail.searchUserData);
                            print(memberDetail.message);
                            final familyTree =
                                context.read<InviteProvider>().familyTree;
                            print("A");
                            print(familyTree);
                            if (memberDetail.message == "no link"
                            )
                            {
                              return;
                            } else {
                              if(familyTreePermission ||
                                  familyTree.isNotEmpty){
                              navigationService
                                  .navigateTo(FamilyTreeMemberRoute);
                              }else{
                                utilService!.showToast("You don't have permission.", context!);

                              }
                            } 
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Text(
                                      intl.NumberFormat.compact().format(
                                          memberDetail
                                              .searchUserData['treeBookCount']),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp),
                                    ),
                                    Positioned(
                                        top: -14.0.h,
                                        right: -15.0.w,
                                        child: Icon(
                                          memberDetail.message == "noo link"
                                              ? Icons.lock
                                              : null,
                                          color: Colors.black,
                                          size: 16.w,
                                        )),
                                  ],
                                ),
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
                        SizedBox()
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red.shade100),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 6.0, right: 6, top: 4, bottom: 4),
                      child: Text(
                        memberDetail.searchUserData['relation'],
                        style: TextStyle(
                            color: Color.fromRGBO(239, 111, 110, 1),
                            fontSize: 12.sp),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    memberDetail.searchUserData['firstName'] +
                        ' ' +
                        memberDetail.searchUserData['lastName'],
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "DOB:",
                        style: TextStyle(
                            fontSize: 12.sp, color: Colors.grey.shade500),
                      ),
                      Text(
                        memberDetail.searchUserData['dob'],
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Wrap(
                    children: [
                      Text(
                        "BIRTH PLACE: ",
                        style: TextStyle(
                            fontSize: 12.sp, color: Colors.grey.shade500),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          memberDetail.searchUserData['address']['cityValue'] +
                              ',' +
                              memberDetail.searchUserData['address']
                                  ['stateValue'] +
                              ',' +
                              memberDetail.searchUserData['address']
                                      ['countryValue']
                                  .toString()
                                  .trim(),
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
                        "HOMETOWN: ",
                        style: TextStyle(
                            fontSize: 12.sp, color: Colors.grey.shade500),
                      ),
                      Text(
                        memberDetail.searchUserData['homeTown'],
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 33.h,
                        width: 160.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(255, 209, 200, 1),
                                spreadRadius: -4,
                                blurRadius: 6,
                                offset: Offset(6, 13))
                          ],
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(255, 145, 73, 1),
                              Color.fromRGBO(254, 65, 85, 1),
                            ],
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter,
                          ),
                        ),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.resolveWith(
                                    (states) => 0),
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.transparent),
                                shape: MaterialStateProperty.resolveWith(
                                    (states) => RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)))),
                            onPressed: () async {
                              await context
                                  .read<ChatProvider>()
                                  .getChatRoomId();
                              print('condition if 3');
                              memberData = await context
                                  .read<ChatProvider>()
                                  .getChatPersonProfile();
                              print('memberdata $memberData');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChatMessageScreen(memberData),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                    image:
                                        AssetImage("assets/images/Chat.png")),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Message",
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              ],
                            )),
                      ),
                      Container(
                        height: 33.h,
                        width: 160.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(218, 221, 250, 1),
                                spreadRadius: -4,
                                blurRadius: 6,
                                offset: Offset(6, 13))
                          ],
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(90, 120, 226, 1),
                              Color.fromRGBO(134, 107, 235, 1),
                            ],
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter,
                          ),
                        ),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.resolveWith(
                                    (states) => 0),
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.transparent),
                                shape: MaterialStateProperty.resolveWith(
                                    (states) => RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)))),
                            onPressed: () {
                              navigationService.navigateTo(
                                  ChanngeRelationScreenRoute,
                                  args:
                                      "user"); //* added arguments by chetu on 30 aug //
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image:
                                      AssetImage("assets/images/Profile.png"),
                                  height: 16,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Change Relation",
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TabBar(
                      tabs: selectTabs,
                      labelColor: Colors.orange,
                      indicatorWeight: 2,
                      indicatorPadding: EdgeInsets.zero,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: Colors.orange.shade900,
                      unselectedLabelColor: Colors.grey.shade500),
                  Expanded(
                    child: TabBarView(
                      children: [
                        isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).backgroundColor,
                                ),
                              )
                            : GalleryWidget(
                                imageData: mediaData,
                              ),
                        isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                    color: Theme.of(context).backgroundColor),
                              )
                            : VideoGalleryWidget(videoData: mediaDataVideos)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<void> getPermissions() async {
    var data = await Provider.of<InviteProvider>(context, listen: false)
        .fetchUserPermissions(familyData['id']);
    if (data[0]["receiverId"]==user.id) {
      print("aaya 1");
      print(data[0]["permission"]["familyTree"]);
      familyTreePermission = data[0]["permission"]["familyTree"];
    }
    else{
      print("aaya 2");
      print(data[0]["sender"]["permission"]["familyTree"]);
      familyTreePermission = data[0]["sender"]["permission"]["familyTree"];

    }
  }  // create by chetu on 21 nov 2023
}
