import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/models/category.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/category_provider.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:provider/provider.dart';

class CategoriesListScreen extends StatefulWidget {
  final routeName;
  final routeLink;
  CategoriesListScreen({this.routeName, this.routeLink});

  @override
  _CategoriesListScreenState createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen> {
  TextEditingController controller1 = TextEditingController();
  var navigationService = locator<NavigationService>();
  // var data;
  var item;
  int index = 0;
  bool isLoading = false;
  List<CategoryModel> categoryData = [];
  var catObjId;
  FixedExtentScrollController? controller;
  // final List<dynamic> _list = [
  //   'My Story',
  //   'Education',
  //   'Career',
  //   'Dream',
  //   'Travel',
  //   'Family',
  //   'Friends',
  //   'Faith',
  //   'Favorites',
  // ];
  @override
  void initState() {
    categoryData =
        Provider.of<CategoryProvider>(context, listen: false).getAllCategories;
    CategoryModel mystory = categoryData.firstWhere((element) => element.id=="mystory");
    categoryData.removeWhere((element) => element.id=="mystory");
    categoryData.removeWhere((element) => element.id == "all");  // implemented by chetu
    categoryData.insert(
        0,
        CategoryModel.fromJson({
          "parentId": "all",
          "id": "all",
          "categoryName": "All",
        }));  // implemented by chetu
    categoryData.insert(1, mystory);   //changed by chetu on 6 nov 2023

    super.initState();
    // var index = _list.indexWhere((element) => element == data);
    // if (index != -1) {
    //   selected = index;
    //   controller = FixedExtentScrollController(initialItem: selected);
    // }
  }

  // List _items;

  // void active(String val) {
  //   setState(() {
  //     data = val;
  //   });
  // }

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
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                color: Colors.grey,
                size: ScreenUtil().setWidth(30),
              ),
            ),
            SizedBox(
              width: 15,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            // // height: double.infinity,
            // // width: double.infinity,
            // decoration: BoxDecoration(
            //   color: Colors.red,
            //   image: DecorationImage(
            //     fit: BoxFit.cover,
            //     image: AssetImage("assets/images/splash.png"),
            //   ),
            // ),
            child: Container(
              padding: EdgeInsets.only(right: 15.w, left: 15.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Container(
                  //   width: 400.h,
                  //   child: TextFormField(
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => CategoriesListScreen(
                  //               // heightController: controller1,
                  //               ),
                  //         ),
                  //       );
                  //     },
                  //     controller: controller1,
                  //     // autofocus: true,
                  //     decoration: InputDecoration(
                  //         focusedBorder: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(10.0),
                  //           borderSide: BorderSide(
                  //             width: 1,
                  //             color: Color.fromRGBO(
                  //               238,
                  //               238,
                  //               238,
                  //               1,
                  //             ),
                  //           ),
                  //         ),
                  //         enabledBorder: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(10.0),
                  //           borderSide: BorderSide(
                  //             color: Colors.grey,
                  //             width: 2.0,
                  //           ),
                  //         ),
                  //         contentPadding: EdgeInsets.symmetric(
                  //           vertical: 5.0.h,
                  //           horizontal: 20.w,
                  //         ),
                  //         suffixIcon: Icon(
                  //           Icons.search,
                  //           color: Color.fromRGBO(
                  //             179,
                  //             179,
                  //             181,
                  //             1,
                  //           ),
                  //         ),
                  //         hintText: 'Search',
                  //         hintStyle: TextStyle(
                  //           color: Colors.grey,
                  //           fontSize: 15.sp,
                  //         ),
                  //         filled: true,
                  //         fillColor: Color.fromRGBO(
                  //           251,
                  //           251,
                  //           251,
                  //           1,
                  //         )),
                  //   ),
                  // ),

                  // SizedBox(
                  //   height: ScreenUtil().setHeight(35),
                  // ),
                  Container(
                    height: ScreenUtil().setHeight(400),
                    alignment: Alignment.center,
                    width: ScreenUtil().setWidth(270),
                    child: CupertinoPicker(
                        itemExtent: 45,
                        squeeze: 1,
                        scrollController: controller,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            this.index = index;
                          });
                          item = categoryData[index].categoryName;
                          catObjId = categoryData[index].id;
                        },
                        looping: false,
                        children: List.generate(categoryData.length, (index) {
                          final isSelected = this.index == index;
                          final item = categoryData[index].categoryName;
                          return Center(
                            child: isSelected
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 8.w,
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromRGBO(84, 122, 227, 1),
                                              Color.fromRGBO(130, 108, 234, 1),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: [0.0, 1.0],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Text(
                                        item.toString(),
                                        style: TextStyle(
                                          fontSize: isSelected ? 30.sp : 20.sp,
                                          fontWeight: isSelected
                                              ? FontWeight.w800
                                              : FontWeight.w400,
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    item.toString(),
                                    style: TextStyle(
                                      fontSize: isSelected ? 30.sp : 20.sp,
                                      fontWeight: isSelected
                                          ? FontWeight.w800
                                          : FontWeight.w400,
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                          );
                        })),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(80),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () async {
                        var user =
                            Provider.of<AuthProviderr>(context, listen: false)
                                .user;
                        setState(() {
                          isLoading = true;
                        });
                        widget.routeName == "HomeScreen"
                            ? Provider.of<CategoryProvider>(context,
                                    listen: false)
                                .selectHome(this.index == 0
                                    ? categoryData[0].categoryName
                                    : item)
                            : Provider.of<CategoryProvider>(context,
                                    listen: false)
                                .selectStoryBook(this.index == 0
                                    ? categoryData[0].categoryName
                                    : item);

                        widget.routeName == "HomeScreen"
                            ? await Provider.of<CategoryProvider>(context,
                                    listen: false)
                                .fetchSubCategoriesHomeScreen(
                                id: this.index == 0
                                    ? categoryData[0].id
                                    : catObjId,
                              )
                                .then((value) async {
                                context.read<PostProvider>().clearPostData();
                                await Provider.of<PostProvider>(context,
                                        listen: false)
                                    .fetchAllNewsFeedByCategoryId(
                                  count: 20,
                                  page: 1,
                                  subCategoryId: context
                                      .read<CategoryProvider>()
                                      .subCategoryDataHomeScreen[0]["id"],
                                  userId: user.id,
                                );
                              })
                            : await Provider.of<CategoryProvider>(context,
                                    listen: false)
                                .fetchSubCategoriesStoryBook(
                                id: this.index == 0
                                    ? categoryData[0].id
                                    : catObjId,
                              )
                                .then((value) async {
                                context
                                    .read<PostProvider>()
                                    .clearStoeyPostData();
                                await Provider.of<PostProvider>(context,
                                        listen: false)
                                    .fetchAllCategoryPost(
                                  count: 10,
                                  page: 1,
                                  childId: context
                                      .read<CategoryProvider>()
                                      .categorySubDataStoryBook[0]["id"],
                                  userId: user.id,
                                );
                              });

                        setState(() {
                          isLoading = false;
                        });

                        navigationService.closeScreen();
                        FocusManager.instance.primaryFocus?.unfocus();
                        // navigationService.navigateTo(widget.routeLink);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        elevation: 0,
                        textStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                          fontWeight: FontWeight.w600,
                        ),
                        fixedSize: Size(
                          MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height * 0.060,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      child: Container(
                        child: Text(
                          "Done",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      if (isLoading)
        Positioned.fill(
            child: Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ))
    ]);
  }
}
