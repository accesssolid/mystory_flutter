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
import 'package:mystory_flutter/widgets/storybook_widget.dart';
import 'package:provider/provider.dart';

class StoryBookscreen extends StatefulWidget {
  const StoryBookscreen({Key? key}) : super(key: key);

  @override
  _StoryBookscreenState createState() => _StoryBookscreenState();
}

class _StoryBookscreenState extends State<StoryBookscreen> {
  var navigationService = locator<NavigationService>();
  var utilService = locator<UtilService>();

  List categorySubData = [];

  bool isLoading = false;
  bool isPaginaionLoading = false;
  int? _expandedIndex = 0;
  var user;
  List<CategoryModel> categoryData = [];

  int page = 2;
  int count = 10;
  var _scroll = ScrollController();

  List<PopupMenuEntry<String>> list = [];

  @override
  void initState() {
    user = Provider.of<AuthProviderr>(context, listen: false).user;

    categorySubData =
        Provider.of<CategoryProvider>(context, listen: false).getSubCategory;
    categoryData =
        Provider.of<CategoryProvider>(context, listen: false).getAllCategories;

    post();
    _scroll.addListener(() {
      if (_scroll.position.pixels == _scroll.position.maxScrollExtent) {
        context
            .read<PostProvider>()
            .storyDataGetMoreData(count: count, page: page, context: context);
        setState(() {
          page = page + 1;
        });
      }
    });

    super.initState();
  }

  post() async {
    //  if (categorySubData.isEmpty) {
    setState(() {
      isLoading = true;
    });

    await Provider.of<CategoryProvider>(context, listen: false)
        .fetchSubCategoriesStoryBook(
      id: categoryData[0].id,
    );

    categorySubData =
        Provider.of<CategoryProvider>(context, listen: false).getSubCategory;
    //  context.read<PostProvider>().storyCatId = categorySubData[0]["id"];
    context.read<PostProvider>().clearStoeyPostData();
    await Provider.of<PostProvider>(context, listen: false)
        .fetchAllCategoryPost(
      count: 10,
      page: 1,
      childId: "all",
      userId: user.id,
    );
    await Provider.of<PostProvider>(context, listen: false)
        .fetchAllMyStoryPost(page: 1, count: 10, id: "all");

    setState(() {
      isLoading = false;
    });
    // }
    // else {
    setState(() {
      isLoading = false;
    });
    // }
  }

  callback(bool data) {
    setState(() {
      isLoading = data;
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // var storageService = locator<StorageService>();
              // var data = await storageService.getData("route");
              // navigationService.navigateTo(data);
              // navigationService.navigateTo(MaindeshboardRoute);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.fullName.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                      Colors.black
                  ),
                ),
                Text(
                  " (Storybook)", // changed by chetu
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                      Colors.black
                  ),
                )
              ],
            ),
            // Consumer<CategoryProvider>(builder: (context, category, child) {
            //   return Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(
            //         category.selectStoryText == "" ||
            //                 category.selectStoryText == null
            //             ? category.categoryData[0].categoryName
            //             : utilService
            //                 .nameToFirstLetterCapital(category.selectStoryText),
            //         style: TextStyle(
            //             color: Color.fromRGBO(141, 141, 141, 1), fontSize: 12),
            //       ),
            //       SizedBox(
            //         width: 5,
            //       ),
            //       GestureDetector(
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => CategoriesListScreen(
            //                       routeLink: StoryBookscreenRoute,
            //                       routeName: "StoryBookScreen",
            //                     )),
            //           );
            //         },
            //         child: Icon(
            //           Icons.keyboard_arrow_down,
            //           color: Colors.black,
            //           size: 22,
            //         ),
            //       )
            //     ],
            //   );
            // })
          ],
        ),
        actions: <Widget>[
          // IconButton(onPressed: (){}, icon: Icon(Icons.search)),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                context.read<AuthProviderr>().tempRoute = "/storybook-screen";
                var storageService = locator<StorageService>();
                await storageService.setData("route", "/storybook-screen");
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
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          categoryData.isEmpty
              ? Container()
              : Consumer<CategoryProvider>(builder: (context, cat, child) {
                  return Container(
                    // color: Colors.red,
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.065,
                    child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryData.length,
                        itemBuilder: (ctx, i) {
                          return GestureDetector(
                            onTap: () async {
                              context.read<PostProvider>().clearStoeyPostData();
                              setState(() {
                                _expandedIndex = i;
                                isLoading = true;
                              });
                              await Provider.of<CategoryProvider>(context,
                                      listen: false)
                                  .fetchSubCategoriesStoryBook(
                                id: i == 0
                                    ? categoryData[0].id
                                    : categoryData[i].id,
                              );
                              await Provider.of<PostProvider>(context,
                                      listen: false)
                                  .fetchAllCategoryPostByCategoryIdForParticularUser(
                                count: 10,
                                page: 1,
                                childId:  categoryData[i].id,
                                userId: user.id,
                              );
                              await Provider.of<PostProvider>(context,
                                      listen: false)
                                  .fetchAllMyStoryPost(
                                      count: 10,
                                      page: 1,
                                      id: i == 0 ? "all" : "");
                              // context.read<PostProvider>().storyCatId =
                              //     cat.categorySubDataStoryBook[i]["id"];
                              context.read<PostProvider>().storyCatId = i == 0
                                  ? "all"
                                  : cat.categorySubDataStoryBook[1]["id"];

                              list.clear();
                              for (var data in cat.categorySubDataStoryBook) {
                                //    print(data['categoryName']);
                                if (data["categoryName"] != "All")
                                  list.add(PopupMenuItem(
                                      value: data['id'],
                                      child: Text(data[
                                          'categoryName']))); // implemented by chetu
                              }
                              setState(() {
                                isLoading = false;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  top: 8.w,
                                  left: 12.w,
                                  //  right: 12.w,
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
                                    20), // Createsssss border
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 15.w,
                                    // right: 15.w,
                                    top: 5.w,
                                    bottom: 5.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      utilService.nameToFirstLetterCapital(cat
                                          .categoryData[i].categoryName
                                          .toString()),
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
                                          print(item);
                                          context
                                              .read<PostProvider>()
                                              .clearStoeyPostData();
                                          await Provider.of<PostProvider>(
                                                  context,
                                                  listen: false)
                                              .fetchAllCategoryPost(
                                            count: 10,
                                            page: 1,
                                            childId: item,
                                            userId: user.id,
                                          );
                                          await Provider.of<PostProvider>(
                                                  context,
                                                  listen: false)
                                              .fetchAllMyStoryPost(
                                                  count: 10, page: 1, id: item);
                                          // context.read<PostProvider>().storyCatId =
                                          //     cat.categorySubDataStoryBook[i]["id"];
                                          context
                                              .read<PostProvider>()
                                              .storyCatId = i ==
                                                  0
                                              ? "all"
                                              : cat.categorySubDataStoryBook[1]
                                                  ["id"];
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            list)
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                }),
          Expanded(
            child: Container(
              child: Consumer<PostProvider>(builder: (context, post, child) {
                return Stack(children: [
                  Container(
                      padding: EdgeInsets.all(20),
                      child: post.categoryAllPost.length == 0 && !isLoading
                          ? NoDataYet(
                              title: "No storybook yet", image: "Primary.png")
                          : ListView.builder(
                              controller: _scroll,
                              itemCount: post.categoryAllPost.length + 1,
                              itemBuilder: (BuildContext context, int i) {
                                if (i == post.categoryAllPost.length) {
                                  return post.isStoryBookLoading == true
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        )
                                      : Container();
                                } else {
                                  return NewsFeedWidget(
                                    route: "Storybook",
                                    index: i,
                                    data: post.categoryAllPost[i],
                                    subCatID:
                                        context.read<PostProvider>().storyCatId,
                                    callback: callback,
                                  );
                                }
                              },
                            )),
                  if (isLoading)
                    Positioned.fill(
                        child: Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ))
                ]);
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isPaginaionLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
