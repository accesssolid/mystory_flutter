import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/global.dart';
import 'package:mystory_flutter/models/relation.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/linkStories_familytree&storybook_provider.dart';
import 'package:mystory_flutter/screens/family_member_manual_profile_screen.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/my_family_widget.dart';
import 'package:mystory_flutter/widgets/no_data_yet.dart';
import 'package:provider/provider.dart';

class MyFamilyScreen extends StatefulWidget {
  const MyFamilyScreen({Key? key}) : super(key: key);

  @override
  _MyFamilyScreenState createState() => _MyFamilyScreenState();
}

class _MyFamilyScreenState extends State<MyFamilyScreen> {
  var navigationService = locator<NavigationService>();
  var utilService = locator<UtilService>();
  TextEditingController searchController = TextEditingController();
  var user;
  int page = 2;
  int count = 10;
  String? tempId = "all";
  List<RelationModel> getRelation = [];
  bool isloading = false;
  int? _expandedIndex = 0;
  var _scroll = ScrollController();
  Map<String, dynamic> seacrhData = {};

  // String? id;
// List familyData = [];
  // List newFamilyData = [];
  // List<String> newDataList = [];
  // List<String> dataSearch = [];

  // bool isPaginaionLoading = false;
  // bool isRefreshLoading = false;

  void fetchRelationsFamly() async {
    getRelation = Provider.of<InviteProvider>(context, listen: false)
        .getRelationFamilyTree;

    if (getRelation.length == 0) {
      setState(() {
        isloading = true;
      });

      await Provider.of<InviteProvider>(context, listen: false)
          .fetchAllRelationFamilyTree();
      getRelation = Provider.of<InviteProvider>(context, listen: false)
          .getRelationFamilyTree;

      setState(() {
        isloading = false;
      });
    } else
      setState(() {
        isloading = false;
      });
  }

  @override
  void didChangeDependencies() {
    _expandedIndex = 0;
    fetchRelationsFamly();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    user = Provider.of<AuthProviderr>(context, listen: false).user;
    seacrhData =
        Provider.of<InviteProvider>(context, listen: false).getSearchUserData;

    fetchRelationsFamly();

    // familyData =
    //     Provider.of<InviteProvider>(context, listen: false).getFamilyTreeData;

    //////////search ////
    // for (int i = 0;
    //     i < context.read<InviteProvider>().fetcFamilyTree.length;
    //     i++) {
    //   dataSearch
    //       .add(context.read<InviteProvider>().fetcFamilyTree[i]["firstName"]);
    // }
    // newDataList = List.from(dataSearch);
    //////////////

    // familyTree();
    _scroll.addListener(() {
      if (_scroll.position.pixels == _scroll.position.maxScrollExtent) {
        // setState(() {
        //   print('Page reached end of page');
        //   getMoreData(
        //     count: count,
        //     page: page,
        //   );
        // });
        context.read<InviteProvider>().getMoreDatafamilyTreeTab(
            count: count, page: page, id: user.id, context: context);
        setState(() {
          page = page + 1;
        });
      }
    });
    super.initState();
  }

  Future _pullToRefresh() async {
    context.read<InviteProvider>().getMoreDatafamilyTreeTab(
        count: count, page: page, id: user.id, context: context);
    setState(() {
      page = page + 1;
    });
  }

  onItemChanged(String value) {
    setState(() {
      if (searchController.text.length != 0) {
        context.read<InviteProvider>().clearnewDataList();
        context.read<InviteProvider>().fetcFamilyTree.forEach((element) {
          if (element["firstName"]
              .toLowerCase()
              .contains(value.toLowerCase())) {
            context.read<InviteProvider>().newDataList.add(element);
          }
          // print(element["name"]);
        });
      } else {
        context.read<InviteProvider>().clearnewDataList();
      }
      // context.read<InviteProvider>().newDataList = context
      //     .read<InviteProvider>()
      //     .dataSearch
      //     .where((string) => string.toLowerCase().contains(value.toLowerCase()))
      //     .toList();
    });
  }

  // void getMoreData({
  //   int? count,
  //   int? page,
  // }) async {
  //   try {
  //     if (!isPaginaionLoading) {
  //       setState(() {
  //         isPaginaionLoading = true;
  //       });

  //       await Provider.of<InviteProvider>(context, listen: false)
  //           .fetchAllFamilyTree(id: user.id, count: count, page: page);
  //       newFamilyData = Provider.of<InviteProvider>(context, listen: false)
  //           .getFamilyTreeData;
  //       setState(() {
  //         isPaginaionLoading = false;
  //         if (newFamilyData.length == 0) {
  //           utilService.showToast("No more Newsfeeds", context);
  //         } else {
  //           familyData.addAll(newFamilyData);
  //         }
  //         // page += 1;
  //         // print(page);
  //       });
  //     }
  //   } catch (err) {
  //     setState(() {
  //       isPaginaionLoading = false;
  //     });
  //     utilService.showToast(err.toString(), context);
  //   }
  // }

  // Future<void> _pullRefreshAll() async {
  //   // setState(() {
  //   //   isRefreshLoading = true;
  //   // });

  //   await Provider.of<InviteProvider>(context, listen: false)
  //       .fetchAllFamilyTree(id: user.id, count: 10, page: 1);
  //   familyData =
  //       Provider.of<InviteProvider>(context, listen: false).getFamilyTreeData;

  //   // setState(() {
  //   //   isRefreshLoading = false;
  //   // });
  // }

  // Future<void> _pullRefreshById() async {
  //   // setState(() {
  //   //   isRefreshLoading = true;
  //   // });

  //   await Provider.of<InviteProvider>(context, listen: false)
  //       .fetchFilterFamilyTree(
  //     count: "200",
  //     page: "1",
  //     reltationId: tempId,
  //     id: user.id,
  //   );

  //   // setState(() {
  //   //   isRefreshLoading = false;
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        bottom: PreferredSize(
            child: Column(
              children: [
                getRelation.isEmpty
                    ? Container()
                    : Container(
                        // padding: EdgeInsets.all(0),
                        // margin: EdgeInsets.only(top: 0.h),
                        margin:
                            EdgeInsets.only(top: 0.h, left: 10.w, right: 10.w),
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: ListView.builder(
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: getRelation.length,
                            itemBuilder: (ctx, i) {
                              return GestureDetector(
                                onTap: () async {
                                  // context.read<InviteProvider>().clearFamilyTreeData();
                                  setState(() {
                                    _expandedIndex = i;
                                    isloading = true;
                                  });
                                  await Provider.of<InviteProvider>(context,
                                          listen: false)
                                      .fetchFilterFamilyTree(
                                    count: "10",
                                    page: "1",
                                    reltationId: getRelation[i].id,
                                    id: user.id,
                                  );

                                  tempId = getRelation[i].id;
                                  // familyData = Provider.of<InviteProvider>(
                                  //         context,
                                  //         listen: false)
                                  //     .getFamilyTreeData;
                                  // if (tempId == "all")
                                  //   for (int i = 0;
                                  //       i < familyData.length;
                                  //       i++) {
                                  //     dataSearch
                                  //         .add(familyData[i]["firstName"]);
                                  //   }
                                  // if (tempId == "all")
                                  //   newDataList = List.from(dataSearch);
                                  setState(() {
                                    isloading = false;
                                  });
                                },
                                child: Container(
                                  // height: MediaQuery.of(context).size.height * 0.03,
                                  alignment: Alignment.center,
                                  // padding: EdgeInsets.only(left: 15.w, right: 15.w,top: 5.w,bottom: 5.w),
                                  margin: EdgeInsets.only(
                                      top: 8.w,
                                      left: 5.w,
                                      right: 5.w,
                                      bottom: 8.w),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: _expandedIndex == i
                                            ? Color.fromRGBO(91, 121, 229, 1)
                                            : Colors.transparent,
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 2.0,
                                        spreadRadius: 0.0,
                                      ),
                                    ],
                                    gradient: LinearGradient(
                                      colors: [
                                        _expandedIndex == i
                                            ? Color.fromRGBO(91, 121, 229, 1)
                                            : Colors.transparent,
                                        _expandedIndex == i
                                            ? Color.fromRGBO(129, 109, 224, 1)
                                            : Colors.transparent
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [0.0, 0.99],
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        30), // Createsssss border
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 15.w,
                                        right: 15.w,
                                        top: 5.w,
                                        bottom: 5.w),
                                    child: Text(
                                      getRelation[i].relationName.toString(),
                                      // utilService.nameToFirstLetterCapital(
                                      //   getRelation[i].relationName
                                      //         .toString()),
                                      style: TextStyle(
                                          color: _expandedIndex == i
                                              ? Colors.white
                                              : Colors.grey,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                          fontWeight: _expandedIndex == i
                                              ? FontWeight.w600
                                              : FontWeight.w300),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),

                SizedBox(
                  height: 20.h,
                ),
                // context.read<InviteProvider>().tempId == getRelation[0].id
                tempId == "all"
                    ? Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        height: 40.h,
                        child: TextField(
                          controller: searchController,
                          onChanged: onItemChanged,
                          decoration: InputDecoration(
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
                                    size: 20.h,
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
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                            hintText: "Search",
                            fillColor: Color.fromRGBO(245, 246, 248, 0.6),
                          ),
                        ),
                      )
                    : Container(),
                if (tempId == "all")
                  SizedBox(
                    height: 20.h,
                  ),
              ],
            ),
            preferredSize: tempId == "all"
                ? Size.fromHeight(
                    MediaQuery.of(context).size.height * 0.14,
                  )
                : Size.fromHeight(
                    MediaQuery.of(context).size.height * 0.06,
                  )),
      ),
      body:
          //  RefreshIndicator(
          //   onRefresh: tempId == "all" ? _pullRefreshAll : _pullRefreshById,
          //   triggerMode: RefreshIndicatorTriggerMode.onEdge,
          //   child:
          Container(
        padding: EdgeInsets.all(5),
        child: tempId == "all"
            ? Container(
                // height: MediaQuery.of(context).size.height / 1 / 1.5,
                child:
                    Consumer<InviteProvider>(builder: (context, family, child) {
                  return family.fetcFamilyTree.length != 0
                      ? Stack(
                          children: [
                            // Consumer<InviteProvider>(
                            //     builder: (context, _, child) {
                            //   return
                            family.newDataList.length == 0 &&
                                    searchController.text.length != 0
                                ? NoDataYet(
                                    title: "No Search Found",
                                    image: "Group 947.png")
                                : RefreshIndicator(
                                    onRefresh: _pullToRefresh,
                                    child: ListView.builder(
                                        // physics:
                                        //     NeverScrollableScrollPhysics(),
                                        controller: _scroll,
                                        shrinkWrap: true,
                                        itemCount:
                                            searchController.text.length != 0
                                                ? family.newDataList.length
                                                : family.fetcFamilyTree.length +
                                                    1,
                                        itemBuilder: (ctx, i) {
                                          // if (i == newDataList.length) {
                                          //   return _buildProgressIndicator();
                                          // }
                                          if (i ==
                                              family.fetcFamilyTree.length) {
                                            return family.isPaginaionLoading ==
                                                    true
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                  )
                                                : Container();
                                          } else {
                                            bool widgetVisibility = true;
                                            if (family.fetcFamilyTree[i]
                                                    ["id"] ==
                                                user.id) {
                                              widgetVisibility = false;
                                            }
                                            if (family.fetcFamilyTree[i]
                                                ["isRemove"]) {
                                              widgetVisibility = false;
                                            }
                                            if (searchController.text.length !=
                                                0) {
                                              if (family.newDataList[i]["id"] ==
                                                  user.id) {
                                                widgetVisibility = false;
                                              }
                                              if (family.newDataList[i]
                                                  ["isRemove"]) {
                                                widgetVisibility = false;
                                              }
                                            }

                                            return Visibility(
                                              visible: widgetVisibility,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  showLoadingAnimation(context);
                                                  await Provider.of<
                                                              InviteProvider>(
                                                          context,
                                                          listen: false)
                                                      .fetchSearchUserDetail(
                                                          myId: user.id,
                                                          viewuserId: family
                                                                  .fetcFamilyTree[
                                                              i]['id'])
                                                      .then((value) async {
                                                    if (value == null) {
                                                      //* navigated on manually user screen by chetu

                                                      Map<String, dynamic>
                                                          data =
                                                          searchController.text
                                                                      .length !=
                                                                  0
                                                              ? family.newDataList[
                                                                  i]
                                                              : family
                                                                  .fetcFamilyTree[i];

                                                      Provider.of<InviteProvider>(
                                                              context,
                                                              listen: false)
                                                          .setFamilyData(data);

                                                      Navigator.pop(context);
                                                      var storageService =
                                                          locator<
                                                              StorageService>();
                                                      await storageService.setData(
                                                          "route",
                                                          "/familytree-screen");
                                                      print(data);
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (builder) =>
                                                                  FamilyMemberManualProfileScreen(
                                                                    userData:
                                                                        data,
                                                                    showRelationButton:
                                                                        true,
                                                                  )));

                                                      // utilService.showToast("User is not exists", context);
                                                      // Navigator.pop(context);
                                                    } else {
                                                      Provider.of<InviteProvider>(
                                                              context,
                                                              listen: false)
                                                          .setFamilyData(family
                                                              .searchUserData);
                                                      await Provider.of<
                                                                  InviteProvider>(
                                                              context,
                                                              listen: false)
                                                          .fetchFamiltTreeMember(
                                                              id: family
                                                                      .fetcFamilyTree[
                                                                  i]['id'],
                                                              count: 10,
                                                              page: 1);
                                                      await context
                                                          .read<
                                                              LinkFamilyStoryProvider>()
                                                          .familyMemberStories(
                                                              count: 10,
                                                              page: 1,
                                                              id: family
                                                                      .fetcFamilyTree[
                                                                  i]['id']);
                                                      await context
                                                          .read<
                                                              LinkFamilyStoryProvider>()
                                                          .familyMemberLinkedStories(
                                                              count: 10,
                                                              page: 1,
                                                              id: family
                                                                      .fetcFamilyTree[
                                                                  i]['id']);
                                                      Navigator.pop(context);

                                                      var storageService =
                                                          locator<
                                                              StorageService>();
                                                      await storageService.setData(
                                                          "route",
                                                          "/familytree-screen");
                                                      navigationService.navigateTo(
                                                          FamilyMemberProfileScreenRoute);
                                                    }
                                                  });
                                                  Provider.of<InviteProvider>(
                                                          context,
                                                          listen: false)
                                                      .setUserData(family
                                                          .fetcFamilyTree[i]);
                                                  // .setUserData(family.FilterFamilyTreeData[i]);
                                                },
                                                child: MyFamilyWidget(
                                                    data: searchController
                                                                .text.length !=
                                                            0
                                                        ? family.newDataList[i]
                                                        : family
                                                            .fetcFamilyTree[i]),
                                              ),
                                            );
                                          }
                                        }),
                                  ),
                            // }),
                            if (isloading)
                              Positioned.fill(
                                  child: Align(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(),
                              ))
                          ],
                        )
                      : Center(
                          child: Container(
                              margin: EdgeInsets.only(bottom: 80),
                              alignment: Alignment.center,
                              child: NoDataYet(
                                  title: "No family tree yet",
                                  image: "3 User1.png")),
                        );
                }),
              )
            : Consumer<InviteProvider>(builder: (context, familyFiter, child) {
                return familyFiter.FilterFamilyTreeData.length != 0
                    ? Stack(
                        children: [
                          // Consumer<InviteProvider>(
                          //     builder: (context, _, child) {
                          //   return
                          //  familyFiter
                          //             .FilterFamilyTreeData.length ==
                          //         0
                          //     ? NoDataYet(
                          //         title: "No Search Found",
                          //         image: "Group 947.png")
                          //     :
                          RefreshIndicator(
                            onRefresh: _pullToRefresh,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    familyFiter.FilterFamilyTreeData.length,
                                itemBuilder: (ctx, i) {
                                  bool widgetVisibility = true;
                                  if (familyFiter.FilterFamilyTreeData[i]
                                          ["id"] ==
                                      user.id) {
                                    widgetVisibility = false;
                                  }
                                  if (familyFiter.FilterFamilyTreeData[i]
                                      ["isRemove"]) {
                                    widgetVisibility = false;
                                  }
                                  return Visibility(
                                    visible: widgetVisibility,
                                    child: GestureDetector(
                                      onTap: () async {
                                        showLoadingAnimation(context);
                                        await Provider.of<InviteProvider>(
                                                context,
                                                listen: false)
                                            .fetchSearchUserDetail(
                                                myId: user.id,
                                                viewuserId: familyFiter
                                                        .FilterFamilyTreeData[i]
                                                    ['id'])
                                            .then((value) async {
                                          if (value == null) {
                                            //* navigated on manually user screen by chetu

                                            Map<String, dynamic> data =
                                                familyFiter
                                                    .FilterFamilyTreeData[i];

                                            Provider.of<InviteProvider>(context,
                                                    listen: false)
                                                .setFamilyData(data);

                                            Navigator.pop(context);
                                            var storageService =
                                                locator<StorageService>();
                                            await storageService.setData(
                                                "route", "/familytree-screen");

                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (builder) =>
                                                        FamilyMemberManualProfileScreen(
                                                          userData: data,
                                                          showRelationButton:
                                                              true,
                                                        ))); // implemented by chetu.

                                            // utilService.showToast(
                                            //     "User is not exists", context);
                                            // Navigator.pop(context);    // commented by chetu
                                          } else {
                                            Provider.of<InviteProvider>(context,
                                                    listen: false)
                                                .setFamilyData(
                                                    familyFiter.searchUserData);
                                            await Provider.of<InviteProvider>(
                                                    context,
                                                    listen: false)
                                                .fetchFamiltTreeMember(
                                                    id: familyFiter
                                                            .FilterFamilyTreeData[
                                                        i]['id'],
                                                    count: 10,
                                                    page: 1);
                                            await context
                                                .read<LinkFamilyStoryProvider>()
                                                .familyMemberStories(
                                                    count: 10,
                                                    page: 1,
                                                    id: familyFiter
                                                            .FilterFamilyTreeData[
                                                        i]['id']);
                                            await context
                                                .read<LinkFamilyStoryProvider>()
                                                .familyMemberLinkedStories(
                                                    count: 10,
                                                    page: 1,
                                                    id: familyFiter
                                                            .FilterFamilyTreeData[
                                                        i]['id']);
                                            Navigator.pop(context);
                                            var storageService =
                                                locator<StorageService>();
                                            await storageService.setData(
                                                "route", "/familytree-screen");
                                            // context
                                            //     .read<
                                            //         LinkFamilyStoryProvider>()
                                            //     .linkRoute = "FamilyTab";
                                            navigationService.navigateTo(
                                                FamilyMemberProfileScreenRoute);
                                          }
                                        });
                                      },
                                      child: MyFamilyWidget(
                                        data: familyFiter.FilterFamilyTreeData[
                                            i], /////////hi
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          // }),
                          if (isloading)
                            Positioned.fill(
                                child: Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(),
                            ))
                        ],
                      )
                    : Center(
                        child: Container(
                            // margin: EdgeInsets.only(bottom: 80),
                            alignment: Alignment.center,
                            child: NoDataYet(
                                title: "No family tree yet",
                                image: "3 User1.png")),
                      );
              }),
      ),
      // ),
      floatingActionButton: InkWell(
        onTap: () {
          // navigationService.navigateTo(MaindashboardSearchRoute);
          //  navigationService.navigateTo(AddFamilyMemberScreenRoute);
          navigationService.navigateTo(AddFamilyMemberScreenRoute);
        },
        child: Container(
          height: 50.h,
          width: 55.w,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                "assets/images/Group 933.png",
              ),
            ),
          ),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 33,
          ),
        ),
      ),
    );
    // );
  }

// Widget _buildProgressIndicator() {
//   return new Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: new Center(
//       child: new Opacity(
//         opacity: isPaginaionLoading ? 1.0 : 00,
//         child: new CircularProgressIndicator(),
//       ),
//     ),
//   );
// }
}
