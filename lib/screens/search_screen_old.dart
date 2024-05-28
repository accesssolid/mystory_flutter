import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/global.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/category_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/news_feed_widget.dart';
import 'package:mystory_flutter/widgets/no_data_yet.dart';
import 'package:mystory_flutter/widgets/search_screen/searchlist_widget.dart';
import 'package:mystory_flutter/widgets/stagger_widget.dart';
import 'package:mystory_flutter/widgets/video_widget.dart';
import 'package:mystory_flutter/widgets/video_widget_search_screen.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';

class SearchScreenOld extends StatefulWidget {
  SearchScreenOld({Key? key}) : super(key: key);

  @override
  _SearchScreenOldState createState() => _SearchScreenOldState();
}

class _SearchScreenOldState extends State<SearchScreenOld> {
  TextEditingController searchController = TextEditingController();
  var navigationService = locator<NavigationService>();
  String name = "";
  bool isLoading = false;
  int? selectedIndex = 0;
  var _scroll = ScrollController();
  List<Map<String, dynamic>> searchlist = [
    {"id": "1", "title": "All"},
    {"id": "2", "title": "newsfeed"},
    {"id": "3", "title": "people"},
    // {"id": "4", "title": "tag"},
    {"id": "5", "title": "photos"},
    {"id": "6", "title": "videos"},
  ];

  // List<Map<String, dynamic>> searchitemlist = [
  //   {
  //     "id": "1",
  //     "title": "Manede Portman",
  //     "subtitle": "@mandeportman",
  //     "img": "assets/images/dummy.jpg"
  //   },
  //   {
  //     "id": "2",
  //     "title": "Manede Portman",
  //     "subtitle": "@mandeportman",
  //     "img": "assets/images/dummy01.jpg"
  //   },
  //   {
  //     "id": "3",
  //     "title": "Manede Portman",
  //     "subtitle": "@mandeportman",
  //     "img": "assets/images/dummy03.jpg"
  //   },
  //   {
  //     "id": "4",
  //     "title": "Manede Portman",
  //     "subtitle": "@mandeportman",
  //     "img": "assets/images/dummy03.jpg"
  //   },
  //   {
  //     "id": "5",
  //     "title": "Manede Portman",
  //     "subtitle": "@mandeportman",
  //     "img": "assets/images/dummy03.jpg"
  //   },
  // ];
  String tagId = '1';
  String title = 'All';
  List<QueryDocumentSnapshot<Object?>> userDataList = [];
  List<QueryDocumentSnapshot<Object?>> userDataListFiltered = [];

  void active(val, title) {
    print("val");
    print(val);
    Provider.of<PostProvider>(context, listen: false)
        .searchNewsFeedPost
        .clear();
    setState(() {
      tagId = val;
      this.title = title;
      name = "";
      searchController.text = "";
      context.read<PostProvider>().clearSearchPhotos();
      context.read<PostProvider>().clearSearchVideos();
      isLoading = false;
      userDataListFiltered.clear();
      imagesData.clear();
      videosData.clear();
    });
  }

  int page = 2;
  int count = 10;
  var user;
  List newsFeedSubCategoryData = [];
  List imagesData = [];
  List videosData = [];
  List allData = [];

  @override
  void initState() {
    user = Provider.of<AuthProviderr>(context, listen: false).user;
    newsFeedSubCategoryData =
        Provider.of<CategoryProvider>(context, listen: false)
            .subCategoryDataHomeScreen;
    dummy();
    _scroll.addListener(() {
      if (_scroll.position.pixels == _scroll.position.maxScrollExtent) {
        context
            .read<PostProvider>()
            .getMoreData(count: count, page: page, context: context);

        setState(() {
          page++;
        });
      }
    });
    getUserData();
    super.initState();
  }

  getUserData() async {
    //* method created by chetu

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("users").get();
    userDataList = querySnapshot.docs;
    // userDataListFiltered = querySnapshot.docs;
  }

  dummy() async {
    // setState(() {
    //   isLoading = true;
    // }); // commented by chetu
    await Provider.of<PostProvider>(context, listen: false)
        .fetchAllNewsFeedPost(
            count: 10, page: 1, id: newsFeedSubCategoryData[0]["id"]);
    // setState(() {
    //   isLoading = false;
    // });  // commented by chetu
    //  List<QueryDocumentSnapshot<Map,String>> a=
  }

  CategoryProvider? sub;

  refreshData() async {
    setState(() {
      name = "";
      isLoading = true;
    });
    await Provider.of<PostProvider>(context, listen: false)
        .fetchAllNewsFeedByCategoryId(
      count: 10,
      page: 1,
      subCategoryId: sub!.subCategoryDataHomeScreen[selectedIndex]["id"],
      userId: user.id,
    );
    await Provider.of<PostProvider>(context, listen: false)
        .fetchAllNewsFeedPost(
      count: 10,
      page: 1,
      id: sub!.subCategoryDataHomeScreen[selectedIndex]["id"],
    );
    context.read<PostProvider>().catId =
        sub!.subCategoryDataHomeScreen[selectedIndex]["id"];

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          child: AppBar(
            leading: SizedBox(),
            elevation: 0,
            backgroundColor: Colors.white,
            bottom: PreferredSize(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 0, right: 0),
                        height: 50.h,
                        child: TextFormField(
                          controller: searchController,
                          onChanged: (title == "All")
                              ? (val) async {
                                  if (val.length > 0) {
                                    setState(() {
                                      name = val;
                                      isLoading = true;
                                    });
                                    userDataListFiltered.clear();

                                    userDataListFiltered.addAll(userDataList
                                        .where((data) =>
                                            (data['fullName']
                                                .toString()
                                                .toLowerCase()
                                                .contains(val.toLowerCase())) ||
                                            data['email']
                                                .toString()
                                                .toLowerCase()
                                                .contains(val.toLowerCase()))
                                        .toList());
                                    imagesData.clear();
                                    await Provider.of<PostProvider>(context,
                                            listen: false)
                                        .searchPhotos(
                                            context: context,
                                            userId: user.id,
                                            keyWord: val,
                                            page: 1,
                                            count: 10);
                                    imagesData = Provider.of<PostProvider>(
                                            context,
                                            listen: false)
                                        .getSearchPhotos;
                                    imagesData.sort((a, b) => b["createdOnDate"]
                                        .compareTo(a["createdOnDate"]));
                                    videosData.clear();
                                    await Provider.of<PostProvider>(context,
                                            listen: false)
                                        .searchVideos(
                                            context: context,
                                            userId: user.id,
                                            keyWord: val,
                                            page: 1,
                                            count: 10);

                                    videosData = Provider.of<PostProvider>(
                                            context,
                                            listen: false)
                                        .getSearchVideos;

                                    videosData.sort((a, b) => b["createdOnDate"]
                                        .compareTo(a["createdOnDate"]));

                                    await Provider.of<PostProvider>(context,
                                            listen: false)
                                        .searchNewsFeed(
                                            context: context,
                                            userId: user.id,
                                            keyWord: val,
                                            page: 1,
                                            count: 10);

                                    setState(() {
                                      isLoading = false;
                                    });
                                  } else {
                                    setState(() {});

                                    userDataListFiltered.clear();

                                    await Future.delayed(Duration(seconds: 4));
                                    Provider.of<PostProvider>(context,
                                            listen: false)
                                        .searchNewsFeedPost
                                        .clear();
                                    imagesData.clear();
                                    videosData.clear();
                                    setState(() {});
                                  }
                                }
                              : (title == "people")
                                  ? (val) {
                                      if (val.length != 0) {
                                        setState(() {
                                          name = val;
                                          userDataListFiltered.clear();
                                          userDataListFiltered.addAll(
                                              userDataList
                                                  .where((data) =>
                                                      (data['fullName']
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains(val
                                                              .toLowerCase())) ||
                                                      data['email']
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains(val
                                                              .toLowerCase()))
                                                  .toList());
                                        });
                                      } else {
                                        userDataListFiltered.clear();
                                        setState(() {});
                                      }
                                    }
                                  : title == "newsfeed"
                                      ? (val) async {
                                          if (searchController
                                              .text.isNotEmpty) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            name = val;
                                            await Provider.of<PostProvider>(
                                                    context,
                                                    listen: false)
                                                .searchNewsFeed(
                                                    context: context,
                                                    userId: user.id,
                                                    keyWord: val,
                                                    page: 1,
                                                    count: 10);
                                            setState(() {
                                              isLoading = false;
                                            });
                                          } else {
                                            refreshData();
                                          }
                                        }
                                      : title == "photos"
                                          ? (val) async {
                                              name = val;
                                              if (name.isNotEmpty) {
                                                print('Search Photos');
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                await Provider.of<PostProvider>(
                                                        context,
                                                        listen: false)
                                                    .searchPhotos(
                                                        context: context,
                                                        userId: user.id,
                                                        keyWord: val,
                                                        page: 1,
                                                        count: 10);
                                                setState(() {
                                                  isLoading = false;
                                                });
                                                imagesData =
                                                    Provider.of<PostProvider>(
                                                            context,
                                                            listen: false)
                                                        .getSearchPhotos;
                                              }
                                            }
                                          : (val) async {
                                              name = val;
                                              if (name.isNotEmpty) {
                                                print('Search Videos');
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                name = val;
                                                await Provider.of<PostProvider>(
                                                        context,
                                                        listen: false)
                                                    .searchVideos(
                                                        context: context,
                                                        userId: user.id,
                                                        keyWord: val,
                                                        page: 1,
                                                        count: 10);
                                                videosData =
                                                    Provider.of<PostProvider>(
                                                            context,
                                                            listen: false)
                                                        .getSearchVideos;
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              }
                                            },
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            isDense: true,
                            suffixIcon: Container(
                              width: 60.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 1.w,
                                    height: 30.h,
                                    color: Colors.grey.shade300,
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  Icon(
                                    Icons.search,
                                    size: 24.h,
                                    color: Colors.grey.shade700,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                ],
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(05.0),
                              ),
                              borderSide: BorderSide(
                                width: 0.w,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(171, 170, 169, 1),
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                            ),
                            hintText: "Search here..",
                            fillColor: Color.fromRGBO(245, 246, 248, 0.6),
                          ),
                        ),
                      ),
                      Container(
                        height: 47.h,
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            itemCount: searchlist.length,
                            itemBuilder: (ctx, i) {
                              return SearchListWidget(
                                data: searchlist[i],
                                action: active,
                                tag: searchlist[i]['id'],
                                active:
                                    tagId == searchlist[i]['id'] ? true : false,
                              );
                            }),
                      ),
                    ],
                  ),
                ),
                preferredSize: Size.fromHeight(0)),
          ),
          preferredSize: Size.fromHeight(135)),
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Suggestion",
            //       style: TextStyle(fontWeight: FontWeight.bold),
            //     ),
            //     Text(
            //       "View All",
            //       style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            //     )
            //   ],
            // ),
            if ((title == 'All') && userDataList != null)

              //* implemented list view for search - by chetu
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 10),
                    Text("Users",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Stack(
                      children: [
                        userDataListFiltered.isEmpty
                            ? NoDataYet(title: "No Users", image: "3 User.png")
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: userDataListFiltered.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  var searchData = userDataListFiltered![index];
                                  return InkWell(
                                    onTap: () async {
                                      showLoadingAnimation(context);
                                      await Provider.of<InviteProvider>(context,
                                              listen: false)
                                          .fetchSearchUserDetail(
                                              myId: user.id,
                                              viewuserId: searchData['id'])
                                          .then((value) {
                                        Navigator.pop(context);

                                        Provider.of<InviteProvider>(context,
                                                listen: false)
                                            .setFamilyData(context
                                                .read<InviteProvider>()
                                                .searchUserData);
                                        context
                                                        .read<InviteProvider>()
                                                        .searchUserData[
                                                    'inviteStatus'] ==
                                                "approved"
                                            ? navigationService.navigateTo(
                                                FamilyMemberProfileScreenRoute)
                                            //  Navigator.of(context).push(
                                            //     MaterialPageRoute(
                                            //       builder: (ctx) =>
                                            //           SisterScreen(
                                            //         route: "Search Screen",
                                            //         // familyMember: context
                                            //         //     .read<
                                            //         //         InviteProvider>()
                                            //         //     .searchUserData
                                            //       ),
                                            //     ),
                                            //   )
                                            : navigationService.navigateTo(
                                                SearchStoryBookScreenRoute);
                                      });
                                    },
                                    child: searchData['id'] != user.id
                                        ? Container(
                                            margin: EdgeInsets.only(top: 12),
                                            child: Row(
                                              children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      221,
                                                                      214,
                                                                      249,
                                                                      1),
                                                              spreadRadius: -8,
                                                              blurRadius: 5,
                                                              offset: Offset(
                                                                  0, 12)),
                                                        ]),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: searchData[
                                                                  'profilePicture'] !=
                                                              ""
                                                          ? Image(
                                                              image: NetworkImage(
                                                                  searchData[
                                                                          'profilePicture']
                                                                      .toString()),
                                                              fit: BoxFit.cover,
                                                              height: 45,
                                                              width: 45,
                                                              errorBuilder: (BuildContext
                                                                      context,
                                                                  Object
                                                                      exception,
                                                                  StackTrace?
                                                                      stackTrace) {
                                                                print(
                                                                    "Exception >> ${exception.toString()}");
                                                                return Image(
                                                                  image: AssetImage(
                                                                      "assets/images/place_holder.png"),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 45,
                                                                  width: 45,
                                                                );
                                                              },
                                                            )
                                                          : Image(
                                                              image: AssetImage(
                                                                  "assets/images/place_holder.png"),
                                                              fit: BoxFit.cover,
                                                              height: 45,
                                                              width: 45,
                                                            ),
                                                    )),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      searchData['fullName'] !=
                                                              ""
                                                          ? searchData[
                                                                  'fullName']
                                                              .toString()
                                                          : "",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      searchData['givenName'],
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade700,
                                                          fontSize: 10),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        : Container(),
                                  );
                                }),
                      ],
                    ),
                    SizedBox(height: 25),
                    Text("NewsFeed",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Consumer2<PostProvider, CategoryProvider>(
                        builder: (context, post, sub, child) {
                      this.sub = sub;
                      if (post.searchNewsFeedPost.length != 0) {
                        print("date aayi");
                        print(post.searchNewsFeedPost[0]);
                        print(post.searchNewsFeedPost[0]["createdOnDate"]);
                        post.searchNewsFeedPost.sort((a, b) =>
                            b["createdOnDate"].compareTo(a["createdOnDate"]));
                      }
                      return post.searchNewsFeedPost.length == 0 && !isLoading
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                NoDataYet(
                                    title: "No stories yet",
                                    image: "Group 947.png"),
                              ],
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: ListView.builder(
                                shrinkWrap: true,
                                controller: _scroll,
                                itemCount: post.searchNewsFeedPost.length + 1,
                                itemBuilder: (BuildContext context, int i) {
                                  if (i == post.searchNewsFeedPost.length) {
                                    return post.isPaginaionLoading == true
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()
                                            ),
                                          )
                                        : Container();
                                  } else {
                                    return NewsFeedWidget(
                                      route: "Search",
                                      data: post.searchNewsFeedPost[i],
                                      // callback: callback,
                                    );
                                  }
                                },
                              ));
                    }),
                    SizedBox(height: 25),
                    Text("Photos",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Stack(children: [
                      StaggerWidget(
                        data: imagesData,
                        title: 'search',
                      ),
                      // isLoading
                      //     ? Center(
                      //         child: CircularProgressIndicator(),
                      //       )
                      //     :
                      SizedBox(),
                    ]),
                    SizedBox(height: 25),
                    Text("Videos",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    VideoWidgetSearchScreen(
                      data: videosData,
                      title: 'search',
                    ),
                  ],
                ),
              ),

            // StreamBuilder<QuerySnapshot>(
            //   stream: (name != "")
            //       ? FirebaseFirestore.instance
            //           .collection('users')
            //           .where('fullName',
            //               isGreaterThanOrEqualTo:
            //                   name[0].toUpperCase() + name.substring(1))
            //           .where('fullName',
            //               isLessThan:
            //                   name[0].toUpperCase() + name.substring(1) + 'z')
            //           .snapshots()
            //       : FirebaseFirestore.instance
            //           .collection("users")
            //           .snapshots(),
            //   //*
            //
            //   //*
            //   builder: (context, snapshot) {
            //     return (snapshot.connectionState == ConnectionState.waiting)
            //         ? Center(child: CircularProgressIndicator())
            //         : snapshot.data!.docs.length == 0 &&
            //                 searchController.text != ""
            //             ? Center(child: Text("No Data"))
            //             : Expanded(
            //                 // height: 150,
            //                 child:
            //                 ListView.builder(
            //                     shrinkWrap: true,
            //                     itemCount: snapshot.data!.docs.length,
            //                     itemBuilder: (BuildContext ctx, index) {
            //                       var searchData = snapshot.data!.docs[index];
            //                       return InkWell(
            //                         onTap: () async {
            //                           showLoadingAnimation(context);
            //                           await Provider.of<InviteProvider>(
            //                                   context,
            //                                   listen: false)
            //                               .fetchSearchUserDetail(
            //                                   myId: user.id,
            //                                   viewuserId: searchData['id'])
            //                               .then((value) {
            //                             Navigator.pop(context);
            //                             Provider.of<InviteProvider>(context,
            //                                     listen: false)
            //                                 .setFamilyData(context
            //                                     .read<InviteProvider>()
            //                                     .searchUserData);
            //                             context
            //                                             .read<InviteProvider>()
            //                                             .searchUserData[
            //                                         'inviteStatus'] ==
            //                                     "approved"
            //                                 ? navigationService.navigateTo(
            //                                     FamilyMemberProfileScreenRoute)
            //                                 //  Navigator.of(context).push(
            //                                 //     MaterialPageRoute(
            //                                 //       builder: (ctx) =>
            //                                 //           SisterScreen(
            //                                 //         route: "Search Screen",
            //                                 //         // familyMember: context
            //                                 //         //     .read<
            //                                 //         //         InviteProvider>()
            //                                 //         //     .searchUserData
            //                                 //       ),
            //                                 //     ),
            //                                 //   )
            //                                 : navigationService.navigateTo(
            //                                     SearchStoryBookScreenRoute);
            //                           });
            //                           // var sendData = {
            //                           //   'profilePicture':
            //                           //       searchData["profilePicture"]
            //                           //           .toString(),
            //                           //   'fullName':
            //                           //       searchData['fullName'].toString(),
            //                           //   'id': searchData['id'].toString(),
            //                           //   'firstName':
            //                           //       searchData['firstName'].toString(),
            //                           //   'lastName':
            //                           //       searchData['lastName'].toString(),
            //                           //   'middleName':
            //                           //       searchData['middleName'].toString(),
            //                           //   'email': searchData['email'].toString(),
            //                           //   'dob': searchData['dob'].toString(),
            //                           //   'address': searchData['address'],
            //                           // };
            //                           // Provider.of<AuthProviderr>(context,
            //                           //         listen: false)
            //                           //     .setDataForUserDetail(sendData);
            //                         },
            //                         child: searchData['id'] != user.id
            //                             ? Container(
            //                                 margin: EdgeInsets.only(top: 12),
            //                                 child: Row(
            //                                   children: [
            //                                     Container(
            //                                         decoration: BoxDecoration(
            //                                             boxShadow: [
            //                                               BoxShadow(
            //                                                   color: Color
            //                                                       .fromRGBO(
            //                                                           221,
            //                                                           214,
            //                                                           249,
            //                                                           1),
            //                                                   spreadRadius:
            //                                                       -8,
            //                                                   blurRadius: 5,
            //                                                   offset: Offset(
            //                                                       0, 12)),
            //                                             ]),
            //                                         child: ClipRRect(
            //                                           borderRadius:
            //                                               BorderRadius
            //                                                   .circular(10),
            //                                           child: searchData[
            //                                                       'profilePicture'] !=
            //                                                   ""
            //                                               ? Image(
            //                                                   image: NetworkImage(
            //                                                       searchData[
            //                                                               'profilePicture']
            //                                                           .toString()),
            //                                                   fit: BoxFit
            //                                                       .cover,
            //                                                   height: 45,
            //                                                   width: 45,
            //                                                 )
            //                                               : Image(
            //                                                   image: AssetImage(
            //                                                       "assets/images/place_holder.png"),
            //                                                   fit: BoxFit
            //                                                       .cover,
            //                                                   height: 45,
            //                                                   width: 45,
            //                                                 ),
            //                                         )),
            //                                     SizedBox(
            //                                       width: 15,
            //                                     ),
            //                                     Column(
            //                                       crossAxisAlignment:
            //                                           CrossAxisAlignment
            //                                               .start,
            //                                       children: [
            //                                         Text(
            //                                           searchData['fullName'] !=
            //                                                   ""
            //                                               ? searchData[
            //                                                       'fullName']
            //                                                   .toString()
            //                                               : "",
            //                                           style: TextStyle(
            //                                               fontSize: 12,
            //                                               fontWeight:
            //                                                   FontWeight
            //                                                       .w700),
            //                                         ),
            //                                         SizedBox(
            //                                           height: 4,
            //                                         ),
            //                                         Text(
            //                                           searchData['givenName'],
            //                                           style: TextStyle(
            //                                               color: Colors
            //                                                   .grey.shade700,
            //                                               fontSize: 10),
            //                                         )
            //                                       ],
            //                                     )
            //                                   ],
            //                                 ),
            //                               )
            //                             : Container(),
            //                       );
            //                     }),
            //               );
            //   },
            // ),

            // if (title == "newsfeed")
            //   StreamBuilder<QuerySnapshot>(
            //       stream: FirebaseFirestore.instance
            //           .collection("users")
            //           .doc(user.id)
            //           .collection("tree")
            //           .snapshots(),
            //       builder: (context, outSnapshot) {
            //         final userData = outSnapshot.data!.docs;
            //         return StreamBuilder<QuerySnapshot>(
            //           stream: (name != "")
            //               ? FirebaseFirestore.instance
            //                   .collection('post')
            //                   .where('storyTitle',
            //                       isGreaterThanOrEqualTo:
            //                           name[0].toUpperCase() + name.substring(1))
            //                   .where('storyTitle',
            //                       isLessThan: name[0].toUpperCase() +
            //                           name.substring(1) +
            //                           'z')
            //                   .snapshots()
            //               : FirebaseFirestore.instance
            //                   .collection("post")
            //                   .where('addedById', isEqualTo: user.id)
            //                   // .where('addedById',
            //                   //     whereIn: userData)
            //                   .snapshots(),
            //           builder: (context, snapshot) {
            //             return (snapshot.connectionState ==
            //                     ConnectionState.waiting)
            //                 ? Center(child: CircularProgressIndicator())
            //                 : snapshot.data!.docs.length == 0 &&
            //                         searchController.text != ""
            //                     ? Center(child: Text("No Data"))
            //                     : Expanded(
            //                         child: ListView.builder(
            //                             shrinkWrap: true,
            //                             itemCount: snapshot.data!.docs.length,
            //                             itemBuilder: (BuildContext ctx, index) {
            //                               var searchData =
            //                                   snapshot.data!.docs[index];
            //                               return NewsFeedWidget(
            //                                 route: "Home",
            //                                 index: index,
            //                                 subCatID: context
            //                                     .read<PostProvider>()
            //                                     .catId,
            //                                 data: searchData,
            //                               );
            //                             }),
            //                       );
            //           },
            //         );
            //       }),
            //By Default The newssfedd is not empty below is comment
            // if (title == "newsfeed" && name.isEmpty)
            //   Consumer2<PostProvider, CategoryProvider>(
            //       builder: (context, post, sub, child) {
            //     this.sub = sub;
            //     return Expanded(
            //       child: post.newsFeedPost.length == 0 && !isLoading
            //           ? Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: [
            //                 NoDataYet(
            //                     title: "No newsfeed yet", image: "add.png"),
            //                 GestureDetector(
            //                     onTap: () async {
            //                       setState(() {
            //                         isLoading = true;
            //                       });
            //                       await Provider.of<PostProvider>(context,
            //                               listen: false)
            //                           .fetchAllNewsFeedByCategoryId(
            //                         count: 10,
            //                         page: 1,
            //                         subCategoryId:
            //                             sub.subCategoryDataHomeScreen[
            //                                 selectedIndex]["id"],
            //                         userId: user.id,
            //                       );
            //                       await Provider.of<PostProvider>(context,
            //                               listen: false)
            //                           .fetchAllNewsFeedPost(
            //                         count: 10,
            //                         page: 1,
            //                         id: sub.subCategoryDataHomeScreen[
            //                             selectedIndex]["id"],
            //                       );
            //                       context.read<PostProvider>().catId =
            //                           sub.subCategoryDataHomeScreen[
            //                               selectedIndex]["id"];
            //
            //                       setState(() {
            //                         isLoading = false;
            //                       });
            //                     },
            //                     child: Padding(
            //                       padding: const EdgeInsets.all(16.0),
            //                       child: Text(
            //                         'Refresh',
            //                         style: TextStyle(
            //                             fontSize: 20,
            //                             color: Theme.of(context)
            //                                 .colorScheme
            //                                 .primary,
            //                             fontWeight: FontWeight.bold),
            //                       ),
            //                     )),
            //               ],
            //             )
            //           : Container(
            //               padding: EdgeInsets.all(20),
            //               child: ListView.builder(
            //                 controller: _scroll,
            //                 itemCount: post.newsFeedPost.length + 1,
            //                 itemBuilder: (BuildContext context, int i) {
            //                   if (i == post.newsFeedPost.length) {
            //                     return post.isPaginaionLoading == true
            //                         ? Padding(
            //                             padding: const EdgeInsets.all(8.0),
            //                             child: Center(
            //                                 child: CircularProgressIndicator()),
            //                           )
            //                         : Container();
            //                   } else {
            //                     return NewsFeedWidget(
            //                       route: "Home",
            //                       index: i,
            //                       subCatID: context.read<PostProvider>().catId,
            //                       data: post.newsFeedPost[i],
            //                     );
            //                   }
            //                 },
            //               )),
            //     );
            //   }),
            if (title == 'people')
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: userDataListFiltered.length,
                    itemBuilder: (BuildContext ctx, index) {
                      var searchData = userDataListFiltered![index];
                      return InkWell(
                        onTap: () async {
                          showLoadingAnimation(context);
                          await Provider.of<InviteProvider>(context,
                                  listen: false)
                              .fetchSearchUserDetail(
                                  myId: user.id, viewuserId: searchData['id'])
                              .then((value) {
                            Navigator.pop(context);
                            Provider.of<InviteProvider>(context, listen: false)
                                .setFamilyData(context
                                    .read<InviteProvider>()
                                    .searchUserData);
                            context
                                        .read<InviteProvider>()
                                        .searchUserData['inviteStatus'] ==
                                    "approved"
                                ? navigationService
                                    .navigateTo(FamilyMemberProfileScreenRoute)
                                //  Navigator.of(context).push(
                                //     MaterialPageRoute(
                                //       builder: (ctx) =>
                                //           SisterScreen(
                                //         route: "Search Screen",
                                //         // familyMember: context
                                //         //     .read<
                                //         //         InviteProvider>()
                                //         //     .searchUserData
                                //       ),
                                //     ),
                                //   )
                                : navigationService
                                    .navigateTo(SearchStoryBookScreenRoute);
                          });
                          // var sendData = {
                          //   'profilePicture':
                          //       searchData["profilePicture"]
                          //           .toString(),
                          //   'fullName':
                          //       searchData['fullName'].toString(),
                          //   'id': searchData['id'].toString(),
                          //   'firstName':
                          //       searchData['firstName'].toString(),
                          //   'lastName':
                          //       searchData['lastName'].toString(),
                          //   'middleName':
                          //       searchData['middleName'].toString(),
                          //   'email': searchData['email'].toString(),
                          //   'dob': searchData['dob'].toString(),
                          //   'address': searchData['address'],
                          // };
                          // Provider.of<AuthProviderr>(context,
                          //         listen: false)
                          //     .setDataForUserDetail(sendData);
                        },
                        child: searchData['id'] != user.id
                            ? Container(
                                margin: EdgeInsets.only(top: 12),
                                child: Row(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(boxShadow: [
                                          BoxShadow(
                                              color: Color.fromRGBO(
                                                  221, 214, 249, 1),
                                              spreadRadius: -8,
                                              blurRadius: 5,
                                              offset: Offset(0, 12)),
                                        ]),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: searchData['profilePicture'] !=
                                                  ""
                                              ? Image(
                                                  image: NetworkImage(
                                                      searchData[
                                                              'profilePicture']
                                                          .toString()),
                                                  fit: BoxFit.cover,
                                                  height: 45,
                                                  width: 45,
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                    print(
                                                        "Exception >> ${exception.toString()}");
                                                    return Image(
                                                      image: AssetImage(
                                                          "assets/images/place_holder.png"),
                                                      fit: BoxFit.cover,
                                                      height: 45,
                                                      width: 45,
                                                    );
                                                  },
                                                )
                                              : Image(
                                                  image: AssetImage(
                                                      "assets/images/place_holder.png"),
                                                  fit: BoxFit.cover,
                                                  height: 45,
                                                  width: 45,
                                                ),
                                        )),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          searchData['fullName'] != ""
                                              ? searchData['fullName']
                                                  .toString()
                                              : "",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          searchData['givenName'],
                                          style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 10),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                      );
                    }),
              ),
            if (title == "newsfeed" && name.isNotEmpty)
              Consumer2<PostProvider, CategoryProvider>(
                  builder: (context, post, sub, child) {
                this.sub = sub;
                return Expanded(
                  child: post.searchNewsFeedPost.length == 0 && !isLoading
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            NoDataYet(
                                title: post.searchMessage,
                                image: "Group 947.png"),
                          ],
                        )
                      : Container(
                          padding: EdgeInsets.all(20),
                          child: ListView.builder(
                            controller: _scroll,
                            itemCount: post.searchNewsFeedPost.length + 1,
                            itemBuilder: (BuildContext context, int i) {
                              if (i == post.searchNewsFeedPost.length) {
                                return post.isPaginaionLoading == true
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      )
                                    : Container();
                              } else {
                                return NewsFeedWidget(
                                  route: "Search",
                                  data: post.searchNewsFeedPost[i],
                                  // callback: callback,
                                );
                              }
                            },
                          )),
                );
              }),

            if (title == 'photos')
              Expanded(
                child: Stack(
                  children: [
                    StaggerWidget(
                      data: imagesData,
                      title: 'search',
                    ),
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox(),
                  ],
                ),
              ),

            if (title == "videos")
              Expanded(
                child: Stack(
                  children: [
                    VideoWidget(
                      data: videosData,
                      title: 'search',
                    ),
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
