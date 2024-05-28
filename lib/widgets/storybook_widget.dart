import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:hashtagable_v3/widgets/hashtag_text.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:share_plus/share_plus.dart';

class StoryBookWidget extends StatefulWidget {
  const StoryBookWidget({Key? key}) : super(key: key);

  @override
  _StoryBookWidgetState createState() => _StoryBookWidgetState();
}

class _StoryBookWidgetState extends State<StoryBookWidget> {
  bool like = false;
  List<Map<String, dynamic>> groupList = [
    {
      "id": "1",
      "name": "Mande Portman",
      "group": "Friends",
      "relation": "Bro",
      "video": "assets/images/play.png",
      "time": "25 Mins ago",
      "title": "it's been a very wonderful",
      "subtitle": "",
      "description":
          "Its been a wonderful on the west beach today.Best Day ever #maryane #summertime #beachlife",
      "image": "assets/images/dummy01.jpg",
      "post":
          "https://cdn.pixabay.com/photo/2016/02/19/11/20/jump-1209647_960_720.jpg",
    },
    {
      "id": "2",
      "name": "Mande Portman",
      "group": "Friends",
      "relation": "Bro",
      "video": "",
      "time": "1 Hours ago",
      "title": "Mandypo it's been a very wonderful",
      "subtitle": "@maryjane",
      "description":
          "#caption #love #quotes #books #photography #likeBooks #bookLover #follow #captions #instagood ",
      "image": "assets/images/dummy01.jpg",
      "post":
          "https://cdn.pixabay.com/photo/2021/09/08/09/03/book-6606414_960_720.jpg",
    },
    {
      "id": "3",
      "name": "Mande Portman",
      "group": "Friends",
      "relation": "Bro",
      "video": "assets/images/play.png",
      "time": "25 Mins ago",
      "title": "it's been a very wonderful",
      "subtitle": "",
      "description":
          "Its been a wonderful on the west beach today.Best Day ever #maryane #summertime #beachlife",
      "image": "assets/images/dummy01.jpg",
      "post":
          "https://cdn.pixabay.com/photo/2016/02/19/11/20/jump-1209647_960_720.jpg",
    },
  ];
  String text = '';
  String subject = '';
  List<String> imagePaths = [];
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var navigationService = locator<NavigationService>();
    ScreenUtil.init(

        context,
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
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // navigationService.navigateTo(SearchStoryBookWidgetRoute);
                          },
                          child: Row(
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
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2.r),
                                      color: Colors.red.shade50,
                                    ),
                                    padding: EdgeInsets.all(2),
                                    child: Text(
                                      groupList[index]['group'],
                                      style: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.red,
                                          height: 1.5),
                                    ),
                                  ),
                                  Text(
                                    groupList[index]['name'],
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    width: 150.w,
                                    child: Row(
                                      children: [
                                        Text(
                                          groupList[index]['relation']
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              height: 1.5),
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Container(
                                          color: Colors.grey,
                                          height: 10.h,
                                          width: 1.w,
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Text(
                                          groupList[index]['time'],
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey,
                                              height: 1.5),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        FocusedMenuHolder(
                          menuWidth: MediaQuery.of(context).size.width * 0.50,
                          blurSize: 0,
                          menuItemExtent: 45,
                          menuBoxDecoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          duration: Duration(milliseconds: 100),
                          animateMenuItems: true,
                          blurBackgroundColor: Colors.black54,
                          bottomOffsetHeight: 100,
                          openWithTap: true,
                          menuItems: <FocusedMenuItem>[
                            FocusedMenuItem(
                                title: Text("Edit"),
                                trailingIcon: Icon(Icons.edit),
                                onPressed: () {}),
                            FocusedMenuItem(
                                title: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                                trailingIcon: Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () {}),
                          ],
                          onPressed: () {},
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.grey,
                            size: 25.h,
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        groupList[index]['title'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13.sp),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(groupList[index]['subtitle'],
                          style: TextStyle(fontSize: 13.sp, color: Colors.red))
                    ],
                  ),
                  SizedBox(
                    height: 3,
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
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade300,
                                    spreadRadius: -13,
                                    blurRadius: 5,
                                    offset: Offset(0, 20))
                              ],
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
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade300,
                                        spreadRadius: -13,
                                        blurRadius: 5,
                                        offset: Offset(0, 20))
                                  ],
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
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    like = !like;
                                  });
                                },
                                child: Image.asset(
                                  "assets/images/Like.png",
                                  scale: 3,
                                  color: like ? Colors.red : Colors.grey,
                                )),
                            Text(
                              "  1.5k",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            InkWell(
                              onTap: () {
                                navigationService
                                    .navigateTo(CommentsScreenRoute);
                              },
                              child: Image.asset(
                                "assets/images/Comment.png",
                                scale: 3,
                              ),
                            ),
                            Text("  256",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            SizedBox(
                              width: 15.w,
                            ),
                            GestureDetector(
                              onTap: () => _onShareWithEmptyOrigin(context),
                              child: Image.asset(
                                "assets/images/Share.png",
                                scale: 3,
                              ),
                            ),
                            Text(" 256",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  )
                ],
              ),
            );
          },
        ),
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
  _onDeleteImage(int position) {
    setState(() {
      imagePaths.removeAt(position);
    });
  }

  _onShare(BuildContext context) async {
    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
    //
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The ElevatedButton's RenderObject
    // has its position and size after it's built.
    final RenderBox box = context.findRenderObject() as RenderBox;

    if (imagePaths.isNotEmpty) {
      await Share.shareFiles(imagePaths,
          text: text,
          subject: subject,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share(text,
          subject: subject,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  _onShareWithEmptyOrigin(BuildContext context) async {
    await Share.share("text");
  }
}
