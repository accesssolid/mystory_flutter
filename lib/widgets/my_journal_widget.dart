import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/screens/create_journal_story_screen.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/cache_image.dart';
import 'package:mystory_flutter/widgets/gallery-pkg/galleryimage.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../global.dart';
import 'delete_popup_widget.dart';

class JournalWidget extends StatefulWidget {
  final data;
  // final Function(bool)? callback;
  JournalWidget({
    this.data,
    //  this.callback
  });
  @override
  _JournalWidgetState createState() => _JournalWidgetState();
}

class _JournalWidgetState extends State<JournalWidget> {
  var formatted;
  var user;
  List images = [];
  bool isLoading = false;
  NavigationService? navigationService = locator<NavigationService>();
  @override
  void initState() {
    user = Provider.of<AuthProviderr>(context, listen: false).user;
    for (var i = 0; i < widget.data["media"].length; i++) {
      images.add(widget.data["media"][i]["url"]);
    }
    super.initState();
  }

  deleteJournal() async {
    showLoadingAnimation(context);
    await Provider.of<PostProvider>(context, listen: false)
        .deleteJournalPost(
      context: context,
      data: widget.data,
    )
        .then((_) {
      Navigator.pop(context);
      navigationService!.navigateTo(MyJournalScreenRoute);
    });
  }

  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    Provider.of<PostProvider>(context, listen: false)
        .setTempData(widget.data["media"]);
    formatted = timeago.format(
        DateTime.fromMillisecondsSinceEpoch(widget.data["createdOnDate"]));
    ScreenUtil.init(
      context,
        //BoxConstraints(
        //    maxWidth: MediaQuery.of(context).size.width,
        //    maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
       // orientation: Orientation.portrait
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: user.profilePicture == "" ||
                              user.profilePicture == null
                          ? CircleAvatar(
                              radius: height * 0.034,
                              backgroundImage:
                                  AssetImage("assets/images/place_holder.png"),
                            )
                          : CircleAvatar(
                              radius: height * 0.034,
                              backgroundColor: Colors.transparent,
                              child: CacheImage(
                                placeHolder: "place_holder.png",
                                imageUrl: user.profilePicture,
                                height: 100,
                                width: 100,
                                radius: 100,
                              ),
                            ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatted,
                          style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                              height: 1.5),
                        ),
                        //   SizedBox(
                        //   height: 4.w,
                        // ),
                        Text(
                          "${user.firstName}" + " " + "${user.lastName}",
                          // widget.data['addedByName'],
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "@${user.firstName}${user.lastName}".toLowerCase(),
                          // "@${widget.data['addedByName']}".toLowerCase(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey,
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
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                duration: Duration(milliseconds: 100),
                animateMenuItems: true,
                blurBackgroundColor: Colors.black54,
                bottomOffsetHeight: 100,
                openWithTap: true,
                menuItems: <FocusedMenuItem>[
                  FocusedMenuItem(
                      title: Text("Edit"),
                      trailingIcon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return CreateJournalStoryScreen(
                              journalTitle: "Edit Journal",
                              journalEdit: widget.data);
                        }));
                      }),
                  FocusedMenuItem(
                      title: Text(
                        "Delete",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      trailingIcon: Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return DeletePopupWidget(deleteJournal);
                            });
                      }),
                ],
                onPressed: () {},
                child: Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                  size: 23.h,
                ),
              )
            ],
          ),
        ),
        Row(
          children: [
            Text(
              widget.data['journalTitle'] ?? "",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
            ),
          ],
        ),
        SizedBox(
          height: 3,
        ),

        ReadMoreText(
          widget.data["description"],
          trimLines: 2,
          style: TextStyle(fontSize: 14.sp, color: Colors.black),
          trimCollapsedText: 'Show more',
          trimExpandedText: 'Show less',
          // moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        // HashTagText(
        //   text: widget.data["description"],
        //   decoratedStyle: TextStyle(
        //       fontSize: 14.sp,
        //       color: Colors.black,
        //       fontWeight: FontWeight.bold),
        //   basicStyle: TextStyle(fontSize: 14.sp, color: Colors.black),
        //   onTap: (text) {
        //     print(text);
        //   },
        // ),
        SizedBox(
          height: 10.h,
        ),
        widget.data["media"].isEmpty
            ? Container()
            : GalleryImage(key: UniqueKey(), imageUrls: widget.data["media"]),
        SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }
}
