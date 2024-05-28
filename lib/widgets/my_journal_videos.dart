import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hashtagable_v3/widgets/hashtag_text.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';

class MyJournalVideos extends StatefulWidget {
  const MyJournalVideos({Key? key}) : super(key: key);

  @override
  _MyJournalVideosState createState() => _MyJournalVideosState();
}

class _MyJournalVideosState extends State<MyJournalVideos> {
  bool like = false;
  List<Map<String, dynamic>> groupList = [
    {
      "id": "1",
      "name": "Mande Portman",
      "username": "@mandeportman",
      "video": "assets/images/play.png",
      "time": "25 Mins ago",
      "description":
          "Its been a wonderful on the west beach today.Best Day ever #maryane #summertime #beachlife",
      "image": "assets/images/1.jpg",
      "post":
          "https://cdn.pixabay.com/photo/2016/02/19/11/20/jump-1209647_960_720.jpg",
    },
    {
      "id": "2",
      "name": "Mande Portman",
      "username": "@mandeportman",
      "relation": "Brother",
      "video": "assets/images/play.png",
      "time": "1 Hours ago",
      "description":
          "#caption #love #quotes #Moutains #photography #likeMoutains #MoutainsLover #follow #captions #instagood ",
      "image": "assets/images/1.jpg",
      "post":
          "https://cdn.pixabay.com/photo/2020/12/02/00/57/mountain-5795883_960_720.jpg",
    },
    {
      "id": "3",
      "name": "Mande Portman",
      "username": "@mandeportman",
      "video": "assets/images/play.png",
      "time": "10 Hours ago",
      "description":
          "#caption #love #quotes #MakeUpLife #photography #tutorials #MakeupLover #lipstick #work #beauty ",
      "image": "assets/images/1.jpg",
      "post":
          "https://cdn.pixabay.com/photo/2021/10/10/21/52/makeup-6698881_960_720.jpg",
    },
  ];
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var navigationService = locator<NavigationService>();
    ScreenUtil.init(
      context,
        //BoxConstraints(
        //    maxWidth: MediaQuery.of(context).size.width,
        //    maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        //orientation: Orientation.portrait
    );
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: groupList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              child: CircleAvatar(
                                radius: height * 0.035,
                                backgroundColor: Colors.transparent,
                                backgroundImage:
                                    AssetImage(groupList[index]['image']),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  groupList[index]['time'],
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
                                      height: 1.5),
                                ),
                                Text(
                                  groupList[index]['name'],
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  groupList[index]['username'],
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
                                      height: 1.5),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Icon(
                          Icons.more_vert,
                          color: Colors.grey,
                          size: 25.h,
                        ),
                      ],
                    ),
                  ),
                  HashTagText(
                    text: groupList[index]["description"],
                    decoratedStyle: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    basicStyle: TextStyle(fontSize: 14.sp, color: Colors.black),
                    onTap: (text) {
                      print(text);
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  groupList[index]["video"] == ""
                      ? Container(
                          height: 180.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(groupList[index]["post"]),
                                  fit: BoxFit.fill)),
                        )
                      : Stack(
                          children: [
                            Container(
                              height: 180.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    colorFilter: new ColorFilter.mode(
                                        Colors.black.withOpacity(0.8),
                                        BlendMode.dstATop),
                                    image:
                                        NetworkImage(groupList[index]["post"]),
                                    fit: BoxFit.cover,
                                  )),

                              // child: Image.network(source, fit: BoxFit.cover),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                      child: InkWell(
                                          onTap: () {
                                            navigationService
                                                .navigateTo(VideoplayerRoute);
                                          },
                                          child: Image.asset(
                                              "assets/images/play.png"))),
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Container(
          height: 60.h,
          width: 60.h,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: new LinearGradient(
                colors: [
                  Colors.orange,
                  Colors.red,
                ],
              )),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 2,
      ),
    );
  }
  // void _settingModalBottomSheet(context) {
  //   showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: context,
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //         topRight: Radius.circular(15.0),
  //         topLeft: Radius.circular(15.0),
  //       )),
  //       builder: (BuildContext bc) {
  //         return Container(
  //             height: MediaQuery.of(context).size.height / 1.19,
  //             child: CommentWidget()
  //             );
  //       });
  // }

}
