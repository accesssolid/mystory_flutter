
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/column_scroll_view.dart';
import 'package:mystory_flutter/widgets/search_screen/search_item.dart';

class ProfileListScreen extends StatefulWidget {
  ProfileListScreen({Key? key}) : super(key: key);

  @override
  _ProfileListScreenState createState() => _ProfileListScreenState();
}

class _ProfileListScreenState extends State<ProfileListScreen> {
  var navigationService = locator<NavigationService>();
   List<Map<String, dynamic>> searchitems = [
    {
      "id": "1",
      "title": "Manede Portman",
      "subtitle": "@mandeportman",
      "img": "assets/images/dummy.jpg"
    },
    {
      "id": "2",
      "title": "Manede Portman",
      "subtitle": "@mandeportman",
      "img": "assets/images/dummy01.jpg"
    },
    {
      "id": "3",
      "title": "Manede Portman",
      "subtitle": "@mandeportman",
      "img": "assets/images/dummy03.jpg"
    },
     {
      "id": "4",
      "title": "Manede Portman",
      "subtitle": "@mandeportman",
      "img": "assets/images/dummy03.jpg"
    },
     {
      "id": "5",
      "title": "Manede Portman",
      "subtitle": "@mandeportman",
      "img": "assets/images/dummy03.jpg"
    },
     {
      "id": "6",
      "title": "Manede Portman",
      "subtitle": "@mandeportman",
      "img": "assets/images/dummy03.jpg"
    },
     {
      "id": "7",
      "title": "Manede Portman",
      "subtitle": "@mandeportman",
      "img": "assets/images/dummy03.jpg"
    },
     {
      "id": "8",
      "title": "Manede Portman",
      "subtitle": "@mandeportman",
      "img": "assets/images/dummy.jpg"
    },
    {
      "id": "9",
      "title": "Manede Portman",
      "subtitle": "@mandeportman",
      "img": "assets/images/dummy01.jpg"
    },
     {
      "id": "10",
      "title": "Manede Portman",
      "subtitle": "@mandeportman",
      "img": "assets/images/dummy.jpg"
    },
    {
      "id": "11",
      "title": "Manede Portman",
      "subtitle": "@mandeportman",
      "img": "assets/images/dummy01.jpg"
    },
  ];
   String tagId = ' ';
  void active(val) {
    setState(() {
      tagId = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              navigationService.navigateTo(MyProfileScreenRoute);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 24.h,
            ),
          ),
          centerTitle: true,
          title: Text(
            "Storybook",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
         
        ),
        body: Padding(
          padding: const EdgeInsets.only(left:18.0,right: 18.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  
                      // physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                              padding: EdgeInsets.zero,
                    
                    itemCount: searchitems.length,
                    itemBuilder: (ctx, i) {
                              return SearchItemWidget(
                    data: searchitems[i],
                    action: active,
                    tag: searchitems[i]['id'],
                    active: tagId == searchitems[i]['id'] ? true : false,
                              );
                    }),
              ),
            ],
          ),
        ),
    );
  }
}