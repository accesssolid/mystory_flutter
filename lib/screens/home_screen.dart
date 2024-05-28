import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/models/category.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/category_provider.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/screens/categories_list_screen.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/news_feed_widget.dart';
import 'package:mystory_flutter/widgets/no_data_yet.dart';
import 'package:provider/provider.dart';

import '../providers/invite_member.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var navigationService = locator<NavigationService>();
  var utilService = locator<UtilService>();
  var user;
  var _scroll = ScrollController();

  var selectedData;
  bool isLoading = false;
  int? _expandedIndex = 0;
  int? selectedIndex = 0;
  List newsFeedSubCategoryData = [];
  List<CategoryModel> categoryData = [];

  int page = 2;
  int count = 20;
  var pagecount=1;

  List<PopupMenuEntry<String>> list = [];

  @override
  void initState() {
    user = Provider.of<AuthProviderr>(context, listen: false).user;
    categoryData =
        Provider.of<CategoryProvider>(context, listen: false).getAllCategories;
    CategoryModel mystory =
        categoryData.firstWhere((element) => element.id == "mystory");
    categoryData.removeWhere((element) => element.id == "mystory");
    categoryData.removeWhere((element) => element.id == "all");
    categoryData.insert(
        0,
        CategoryModel.fromJson({
          "parentId": "all",
          "id": "all",
          "categoryName": "All",
        })); // implemented by chetu
    categoryData.insert(1, mystory); // changed by chetu.
    // categoryData.insert(0, CategoryModel.fromJson({
    //   "parentId": "all",
    //   "id": "all",
    //   "categoryName": "All",
    // }));// implemented by chetu for category add all
    newsFeedSubCategoryData =
        Provider.of<CategoryProvider>(context, listen: false)
            .subCategoryDataHomeScreen;

    dummy();

    _scroll.addListener(() {

      var listLength = context.read<PostProvider>().newsFeedPost.length;
      print("pagination calling");
      print("=============listLength listLength =========listLength====listLength\n\n");
      print("============$listLength============");
      print("=============listLength listLength =========listLength====listLength\n\n");
      if (_scroll.position.pixels == _scroll.position.maxScrollExtent) {
        context
            .read<PostProvider>()
            .getMoreData(count: count, page: context.read<PostProvider>().pageCount, context: context);

        if (listLength > context.read<PostProvider>().newsFeedPost.length) {
          setState(() {
            page++;

          });
        }
      }
    });

    super.initState();
  }

  Future<void> _pullRefresh(dynamic sub) async {
    context.read<PostProvider>().clearPostData();

    setState(() {
      isLoading = true;
    });

    await Provider.of<PostProvider>(context, listen: false)
        .fetchAllNewsFeedByCategoryId(
      count: 10,
      page: pagecount,
      subCategoryId: sub.subCategoryDataHomeScreen[selectedIndex]["id"],
      userId: user.id,
    );

    await Provider.of<PostProvider>(context, listen: false)
        .fetchAllNewsFeedPost(
      count: 10,
      page: pagecount,
      id: sub.subCategoryDataHomeScreen[selectedIndex]["id"],
    );

    context.read<PostProvider>().catId =
    sub.subCategoryDataHomeScreen[selectedIndex]["id"];

    setState(() {
      isLoading = false;
      pagecount++; // Increment the page number
    });
  }

  dummy() async {
    if (newsFeedSubCategoryData.isEmpty) {
      setState(() {
        isLoading = true;
      });
      context.read<PostProvider>().clearNewsFeedPost();
      await Provider.of<CategoryProvider>(context, listen: false)
          .fetchSubCategoriesHomeScreen(
        id: categoryData[0].id,
      );

      newsFeedSubCategoryData =
          Provider.of<CategoryProvider>(context, listen: false)
              .subCategoryDataHomeScreen;
      context.read<PostProvider>().catId = newsFeedSubCategoryData[0]["id"];
      await Provider.of<PostProvider>(context, listen: false)
          .fetchAllNewsFeedByCategoryId(
        count: 10,
        page: 1,
        subCategoryId: newsFeedSubCategoryData[0]["id"],
        userId: user.id,
      );
      await Provider.of<PostProvider>(context, listen: false)
          .fetchAllNewsFeedPost(
              count: 10, page: 1, id: newsFeedSubCategoryData[0]["id"]);
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // _scroll.dispose();
    super.dispose();
  }

  callback(bool data) {
    setState(() {
      isLoading = data;
    });
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
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              icon: Image.asset(
                'assets/images/Left.png',
                scale: 1.0,
                color: Colors.black,
              ),
              onPressed: () => Scaffold.of(context).openDrawer()),
          centerTitle: true,
          title: Column(
            children: [
              Text(
                "Newsfeed", // changed by chetu
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                         Colors.black
                  )
              ),

            ],
          ),
          actions: <Widget>[
            // IconButton(onPressed: (){}, icon: Icon(Icons.search)),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  context.read<AuthProviderr>().tempRoute =
                      "/maindeshboard-screen";
                  var storageService = locator<StorageService>();
                  await storageService.setData(
                      "route", "/maindeshboard-screen");
                  navigationService.navigateTo(MyProfileScreenRoute);
                },
                child: user.profilePicture == "" || user.profilePicture == null
                    ? CircleAvatar(
                        backgroundImage:
                            AssetImage("assets/images/place_holder.png"),
                      )
                    : CircleAvatar(
                        backgroundColor: Theme.of(context).backgroundColor,
                        backgroundImage:
                            NetworkImage(user.profilePicture.toString())),
              ),
            ),
          ],
        ),
        body: Consumer<CategoryProvider>(builder: (context, sub, child) {
          return Column(
            children: [
              sub.categoryData.isEmpty
                  ? Container()
                  : Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.065,
                      child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: sub.categoryData.length,
                          itemBuilder: (ctx, i) {
                            return GestureDetector(
                              onTap: () async {
                                context.read<PostProvider>().clearPostData();
                                setState(() {
                                  print("CATEGORY CLICK IS HEREE ${categoryData[i].id}");
                                  context.read<PostProvider>().pageCount=1;
                                  _expandedIndex = i;
                                  selectedIndex = i;
                                  isLoading = true;
                                });

                                var user = Provider.of<AuthProviderr>(context,
                                        listen: false)
                                    .user;

                                await Provider.of<CategoryProvider>(context,
                                        listen: false)
                                    .fetchSubCategoriesHomeScreen(
                                  id: i == 0
                                      ? categoryData[0].id
                                      : categoryData[i].id,
                                )
                                    .then((value) async {
                                  context.read<PostProvider>().clearPostData();

                                  await Provider.of<PostProvider>(context,
                                          listen: false)
                                      .fetchNewsFeedOnlyByCategoryId(
                                    count: 20,
                                    page: 1,
                                    categoryId: categoryData[i].id,
                                    userId: user.id,
                                  );
                                });

                                await Provider.of<PostProvider>(context,
                                        listen: false)
                                    .fetchAllNewsFeedPost(
                                  count: 10,
                                  page: 1,
                                  //  id: sub.subCategoryDataHomeScreen[selectedIndex]["id"],  // commented by chetu
                                  id: i == 0
                                      ? "all"
                                      : "${sub.subCategoryDataHomeScreen[1]["id"]}", // implemented by chetu
                                );
                                //   print("sub");
                                //  print(sub.subCategoryDataHomeScreen);
                                context.read<PostProvider>().catId = i == 0
                                    ? "all"
                                    : sub.subCategoryDataHomeScreen[1]["id"];

                                setState(() {
                                  isLoading = false;
                                });

                                list.clear();
                                for (var data
                                    in sub.subCategoryDataHomeScreen) {
                                  //    print(data['categoryName']);
                                  if (data["categoryName"] != "All")
                                    list.add(PopupMenuItem(
                                        value: data['id'],
                                        child: Text(data[
                                            'categoryName']))); // implemented by chetu
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    top: 8.w, left: 12.w, bottom: 8.w),
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
                                      20), // Createsssss border
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 15.w,
                                      //  right: 15.w,
                                      top: 5.w,
                                      bottom: 5.w),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        utilService.nameToFirstLetterCapital(sub
                                            .categoryData[i].categoryName
                                            .toString()),
                                        style: TextStyle(
                                            color: _expandedIndex == i
                                                ? Colors.white
                                                : Colors.grey.shade400,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      PopupMenuButton<String>(
                                          //    initialValue: "Allo ",
                                          padding: EdgeInsets.zero,
                                          enabled: _expandedIndex == i &&
                                              _expandedIndex != 0,
                                          icon: const Icon(
                                            Icons.expand_circle_down,
                                          ),
                                          onSelected: (String item) async {
                                            print("Tapped");
                                          //  print(item);
                                            context
                                                .read<PostProvider>()
                                                .clearPostData();

                                            await Provider.of<PostProvider>(
                                                    context,
                                                    listen: false)
                                                .fetchAllNewsFeedByCategoryId(
                                              count: 10,
                                              page: 1,
                                              subCategoryId: item,
                                              userId: user.id,
                                            );
                                            await Provider.of<PostProvider>(
                                                    context,
                                                    listen: false)
                                                .fetchAllNewsFeedPost(
                                              count: 10,
                                              page: 1,
                                              id: item,
                                            );
                                            context.read<PostProvider>().catId =
                                                item;
                                            setState(() {
                                              isLoading = false;
                                            });
                                          },
                                          itemBuilder: (BuildContext context) =>
                                              list)
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
              Consumer<PostProvider>(builder: (context, post, child) {
                Provider.of<InviteProvider>(context, listen: false)
                    .fetchAllFamilyTree(id: user.id, count: 25, page: 1);
                List<Map<String, dynamic>> familyMembersList =
                    Provider.of<InviteProvider>(context, listen: false)
                        .getFamilyTreeData;
                return Expanded(
                  child: post.newsFeedPost.length == 0 && !isLoading
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            NoDataYet(
                                title: "No newsfeed yet", image: "add.png"),
                            GestureDetector(
                                onTap: () async {
                                  print("CLICK ON REFRESH");
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await Provider.of<PostProvider>(context,
                                          listen: false)
                                      .fetchAllNewsFeedByCategoryId(
                                    count: 10,
                                    page: 1,
                                    subCategoryId:
                                        sub.subCategoryDataHomeScreen[
                                            selectedIndex]["id"],
                                    userId: user.id,
                                  );
                                  await Provider.of<PostProvider>(context,
                                          listen: false)
                                      .fetchAllNewsFeedPost(
                                    count: 10,
                                    page: 1,
                                    id: sub.subCategoryDataHomeScreen[
                                        selectedIndex]["id"],
                                  );
                                  context.read<PostProvider>().catId =
                                      sub.subCategoryDataHomeScreen[
                                          selectedIndex]["id"];

                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    'Refresh',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ],
                        )
                      : Container(
                          padding: EdgeInsets.all(10),
                          child: RefreshIndicator(
                            onRefresh: () => _pullRefresh(sub),
                            displacement:
                                MediaQuery.of(context).size.height * 0.8,
                            child: ListView.builder(
                              controller: _scroll,
                              itemCount: post.newsFeedPost.length + 1,
                              itemBuilder: (BuildContext context, int i) {
                                if (i == post.newsFeedPost.length) {
                                  return post.isPaginaionLoading == true
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        )
                                      : Container();
                                } else {
                                  // print(
                                  //     "Hello = ${post.newsFeedPost.length.toString()}");
                                  //    print(post.newsFeedPost[i]["addedById"]);
                                  //   print(familyMembersList);
                                  if (familyMembersList.any((element) =>
                                      element["id"] ==
                                          post.newsFeedPost[i]["addedById"] &&
                                      !element["isRemove"])) {
                                    return NewsFeedWidget(
                                      route: "Home",
                                      index: i,
                                      subCatID:
                                          context.read<PostProvider>().catId,
                                      data: post.newsFeedPost[i],
                                      callback: callback,
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                  // Text(post.newsFeedPost[i].toString());
                                }
                              },
                            ),
                          )),
                );
              })
            ],
          );
        }),
      ),
      if (isLoading)
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        )
    ]);
  }
}
