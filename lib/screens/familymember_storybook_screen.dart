import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/models/category.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/category_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/linkStories_familytree&storybook_provider.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/screens/categories_list_screen.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/linked_story_book_widget.dart';
import 'package:mystory_flutter/widgets/no_data_yet.dart';
import 'package:provider/provider.dart';

class FamilyMemberStoryBookScreen extends StatefulWidget {
  const FamilyMemberStoryBookScreen({Key? key}) : super(key: key);

  @override
  _FamilyMemberStoryBookScreenState createState() =>
      _FamilyMemberStoryBookScreenState();
}

class _FamilyMemberStoryBookScreenState
    extends State<FamilyMemberStoryBookScreen> {
  var navigationService = locator<NavigationService>();
  var utilService = locator<UtilService>();
  var _scroll = ScrollController();
  bool isLoading = false;
  List categorySubData = [];
  List<CategoryModel> categoryData = [];
  int? _expandedIndex = 0;

  int page = 2;
  int count = 10;
  var userId;

  List<PopupMenuEntry<String>> list = [];

  @override
  void initState() {
    userId = context.read<LinkFamilyStoryProvider>().familyMemberId;
    categorySubData =
        Provider.of<CategoryProvider>(context, listen: false).getSubCategory;
    categoryData =
        Provider.of<CategoryProvider>(context, listen: false).getAllCategories;
    post();
    setState(() {
      isLoading = false;
    });
    // _scroll.addListener(() {
    //   if (_scroll.position.pixels == _scroll.position.maxScrollExtent) {
    //     context.read<LinkFamilyStoryProvider>().getMoreDatafamilyMemberStories(
    //         context: context,
    //         count: count,
    //         page: page,
    //         id: context.read<LinkFamilyStoryProvider>().familyMemberId);
    //
    //     setState(() {
    //       page++;
    //     });
    //   }
    // });
    super.initState();
  }

  post() async {
    if (categorySubData.isEmpty) {
      setState(() {
        isLoading = true;
      });

      await Provider.of<CategoryProvider>(context, listen: false)
          .fetchSubCategoriesStoryBook(
        id: categoryData[0].id,
      );

      categorySubData =
          Provider.of<CategoryProvider>(context, listen: false).getSubCategory;
      context.read<PostProvider>().storyCatId = categorySubData[0]["id"];
      await Provider.of<PostProvider>(context, listen: false)
          .fetchAllCategoryPost(
        count: 10,
        page: 1,
        childId: categorySubData[0]["id"],
        userId: userId,
      );
      await Provider.of<PostProvider>(context, listen: false)
          .fetchAllMyStoryPost(
              page: 1, count: 10, id: categorySubData[0]["id"]);

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }

    await context
        .read<LinkFamilyStoryProvider>()
        .familyMemberStories(count: 10, page: 1, id: userId);
  }

  @override
  void dispose() {
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
    return Stack(children: [
      Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  navigationService.navigateTo(FamilyMemberProfileScreenRoute);
                }),
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  "Storybook",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                // Consumer<CategoryProvider>(builder: (context, category, child) {
                //   return Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text(
                //         category.selectStoryText == "" ||
                //                 category.selectStoryText == null
                //             ? category.categoryData[0].categoryName
                //             : utilService.nameToFirstLetterCapital(
                //                 category.selectStoryText),
                //         style: TextStyle(
                //             color: Color.fromRGBO(141, 141, 141, 1),
                //             fontSize: 12),
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
                // })       // commented by chetu..
              ],
            ),
            actions: <Widget>[
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.engineering,
                    color: Colors.transparent,
                  )),
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 8,
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
                            itemCount: cat.categoryData.length,
                            itemBuilder: (ctx, i) {
                              return GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _expandedIndex = i;
                                    isLoading = true;
                                  });
                                  print("Results");
                                  print(userId);
                                  print(cat.categoryData[i].id);
                                  print(categoryData[i].id);
                                  // var user = Provider.of<AuthProvider>(context,
                                  //     listen: false)
                                  //     .user;

                                  // Provider.of<CategoryProvider>(context,
                                  //     listen: false)
                                  //     .selectStoryBook(i == 0
                                  //     ? categoryData[0].categoryName
                                  //     : item);

                                  await Provider.of<CategoryProvider>(context,
                                          listen: false)
                                      .fetchSubCategoriesStoryBook(
                                    id: categoryData[i].id,
                                  )
                                      .then((value) async {
                                    context
                                        .read<PostProvider>()
                                        .clearStoeyPostData();
                                    await Provider.of<LinkFamilyStoryProvider>(
                                            context,
                                            listen: false)
                                        .filterFamilyMemberStories(
                                            count: 10,
                                            page: 1,
                                            id: userId,
                                            categories: cat.categoryData[i].id);
                                    //     .fetchAllCategoryPost(
                                    //   count: 10,
                                    //   page: 1,
                                    //   childId: context
                                    //       .read<CategoryProvider>()
                                    //       .categorySubDataStoryBook[0]["id"],
                                    //   userId: user.id,
                                    // );
                                  });

                                  // await Provider.of<LinkFamilyStoryProvider>(
                                  //         context,
                                  //         listen: false)
                                  //     .filterFamilyMemberStories(
                                  //         count: 10,
                                  //         page: 1,
                                  //         id: userId,
                                  //         categories: cat.categoryData[i].id);

                                  setState(() {
                                    isLoading = false;
                                  });
                                  list.clear();
                                  for (var data
                                      in cat.categorySubDataStoryBook) {
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
                                      top: 8.w,
                                      left: 12.w,
                                      // right: 12.w,
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
                                        //    right: 15.w,
                                        top: 5.w,
                                        bottom: 5.w),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            utilService
                                                .nameToFirstLetterCapital(cat
                                                    .categoryData[i]
                                                    .categoryName
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
                                                await Provider.of<
                                                            LinkFamilyStoryProvider>(
                                                        context,
                                                        listen: false)
                                                    // .fetchAllCategoryPost(
                                                    //     count: 10,
                                                    //     page: 1,
                                                    //     userId: userId,
                                                    //     childId: item);
                                                .fetchAllCategoryPost(
                                                        count: 10,
                                                        page: 1,
                                                        userId: userId,
                                                        childId: item);
                                                //     .fetchAllCategoryPost(
                                                //   count: 10,
                                                //   page: 1,
                                                //   childId: context
                                                //       .read<CategoryProvider>()
                                                //       .categorySubDataStoryBook[0]["id"],
                                                //   userId: user.id,
                                                // );

                                                setState(() {
                                                  isLoading = false;
                                                });
                                              },
                                              itemBuilder:
                                                  (BuildContext context) =>
                                                      list)
                                        ]),
                                  ),
                                ),
                              );
                            }),
                      );
                    }),
              Expanded(
                child: Consumer<LinkFamilyStoryProvider>(
                    builder: (context, invite, child) {
                  return invite.familyMemberStoriesData.length == 0 &&
                          !isLoading
                      ? NoDataYet(title: "No stories yet", image: "add.png")
                      : Container(
                          padding: EdgeInsets.all(20),
                          child: ListView.builder(
                            controller: _scroll,
                            itemCount:
                                invite.familyMemberStoriesData.length + 1,
                            itemBuilder: (BuildContext context, int i) {
                              if (i == invite.familyMemberStoriesData.length) {
                                return invite.isPaginaionLoading == true
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      )
                                    : Container();
                              } else {
                                return LinkedStoryBookWidget(
                                  data: invite.familyMemberStoriesData[i],
                                );
                              }
                            },
                          ));
                }),
              ),
            ],
          )),
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
