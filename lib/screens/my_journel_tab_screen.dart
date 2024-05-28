import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/my_journal_images.dart';
import 'package:mystory_flutter/widgets/my_journal_videos.dart';

class MyJournalTabScreen extends StatefulWidget {
  const MyJournalTabScreen({Key? key}) : super(key: key);

  @override
  MyJournalTabScreenState createState() => MyJournalTabScreenState();
}

class MyJournalTabScreenState extends State<MyJournalTabScreen> {
  var navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    final List<Tab> selectTabs = <Tab>[
      Tab(icon: Icon(Icons.photo_sharp)
          //      Image.asset(
          //   "assets/images/Image.png",
          // )
          ),
      Tab(
          icon: Image.asset(
        "assets/images/Video.png",fit: BoxFit.fill,height: 20,
      ),),
    ];
    ScreenUtil.init(
      context,
      //BoxConstraints(
      //    maxWidth: MediaQuery.of(context).size.width,
      //    maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(360, 690),
      //orientation: Orientation.portrait
    );
    return DefaultTabController(
      length: selectTabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              navigationService.navigateTo(MaindeshboardRoute);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black38,
              size: 25.h,
            ),
          ),
          centerTitle: true,
          title: Text(
            "My Journal",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                Colors.black
            )
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_horiz,
                  color: Colors.grey,
                ))
          ],
        ),
        body: Column(
          children: [
            Container(
              width: 280,
             
              child: TabBar(
                  tabs: selectTabs,
                  labelColor: Colors.red,
                  // isScrollable: true,

                  indicatorWeight: 2,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.orange.shade900,
                  unselectedLabelColor: Colors.grey),
            ),
            Expanded(
              // height: MediaQuery.of(context).size.height,
              child: TabBarView(
                children: [
                  MyJournalImages(),
                  MyJournalVideos(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
