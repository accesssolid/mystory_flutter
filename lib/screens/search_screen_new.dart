import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/global.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/newsFeed_tabbar_widget.dart';
import 'package:mystory_flutter/widgets/people_tabbar_widget.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  var navigationService = locator<NavigationService>();
  String name = "";
  var user;
  int? value = 0;
  @override
  void initState() {
    user = Provider.of<AuthProviderr>(context, listen: false).user;
 
    super.initState();
  }

  // onItemChanged(String value) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   await Provider.of<PostProvider>(context)
  //       .searchNewsFeed(userId: user.id, keyWord: value, page: 1, count: 10);
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  final List<Tab> selectTabs = <Tab>[
    Tab(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_alt_sharp,
            // [0] == [0] ?
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Users',
            style: TextStyle(fontSize: 18),
          )
        ],
      ),

      //  : Colors.grey.shade900,
    ),
    Tab(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.feed,
            // [0] == [0] ?
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Newsfeeds',
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: selectTabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            child: AppBar(
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
                            onChanged: value == 0
                                ? (val) {
                                    setState(() {
                                      name = val;
                                    });
                                  }
                                : (val) async {
                                    if (searchController.text.length != 0) {
                                      await Provider.of<PostProvider>(context,
                                              listen: false)
                                          .searchNewsFeed(
                                            context: context,
                                              userId: user.id,
                                              keyWord: val,
                                              page: 1,
                                              count: 10);
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
                      ],
                    ),
                  ),
                  preferredSize: Size.fromHeight(0)),
            ),
            preferredSize: Size.fromHeight(70)),
        body: Column(children: [
          TabBar(
              onTap: (val) {
                setState(() {
                  value = val;
                });
              },
              tabs: selectTabs,
              labelColor: Colors.orange,
              // isScrollable: true,

              indicatorWeight: 2,
              indicatorPadding: EdgeInsets.zero,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.orange.shade900,
              unselectedLabelColor: Colors.grey.shade500),
          Expanded(
            child: TabBarView(children: [
              PeopleTabbarWidget(
                name: name,
                key: UniqueKey(),
                searchController: searchController,
              ),
              NewsFeedTabbarWidget(
                key: UniqueKey(),
                searchController: searchController,
              )
            ]),
          ),
        ]),
      ),
    );
  }
}
