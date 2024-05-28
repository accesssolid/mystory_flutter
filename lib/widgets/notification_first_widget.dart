import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/linkStories_familytree&storybook_provider.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/screens/post_comments_screen.dart';
import 'package:mystory_flutter/screens/family_member_profile_screen.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../global.dart';

class NotificationFirstWidget extends StatefulWidget {
  final data;
  int? count;

  NotificationFirstWidget({
    this.data,
    this.count
  });

  @override
  _NotificationFirstWidgetState createState() =>
      _NotificationFirstWidgetState();
}

class _NotificationFirstWidgetState extends State<NotificationFirstWidget> {
  UtilService? utilService = locator<UtilService>();

  NavigationService? navigationService = locator<NavigationService>();
  var formatted;
  var user;

  @override
  void initState() {
    user = Provider.of<AuthProviderr>(context, listen: false).user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
    return GestureDetector(
      onTap: widget.data["type"] == "invite-approved"
          ? () async {
              showLoadingAnimation(context);
              await Provider.of<InviteProvider>(context, listen: false)
                  .fetchSearchUserDetail(
                      myId: user.id, viewuserId: widget.data["recieverId"])
                  .then((value) async {
                Provider.of<InviteProvider>(context, listen: false)
                    .setFamilyData(
                        context.read<InviteProvider>().searchUserData);
                await Provider.of<InviteProvider>(context, listen: false)
                    .fetchFamiltTreeMember(
                        id: widget.data["recieverId"], count: 10, page: 1);
                await context
                    .read<LinkFamilyStoryProvider>()
                    .familyMemberStories(
                        count: 10, page: 1, id: widget.data["recieverId"]);
                await context
                    .read<LinkFamilyStoryProvider>()
                    .familyMemberLinkedStories(
                        count: 10, page: 1, id: widget.data["recieverId"]);
                Navigator.pop(context);

                var storageService = locator<StorageService>();
                await storageService.setData("route", "/notification-screen");
                navigationService!.navigateTo(FamilyMemberProfileScreenRoute);
              });
            }
          : () async {
              showLoadingAnimation(context);
              await Provider.of<PostProvider>(context, listen: false)
                  .getPostById(id: widget.data["postId"], context: context)
                  .then((_) async {
                Navigator.pop(context);
                if (context.read<PostProvider>().postById.length != 0) {
                  var storageService = locator<StorageService>();
                  await storageService.setData("route", "/notification-screen");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostCommentsScreen(
                              data: context.read<PostProvider>().postById,
                              date: formatted,
                            )),
                  );
                } else {
                  Navigator.pop(context);
                  utilService!.showToast("This post has been deleted", context);

                  navigationService!.navigateTo(NotificationScreenRoute);
                  return;
                }
              });
            },
      child: Container(
        color: Colors.grey.shade100,
        padding: EdgeInsets.only(
          top: 10.h,
          left: 15.w,
          // right: 15.w,
          bottom: 5.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    // Provider.of<InviteProvider>(context, listen: false)
                    //     .setFamilyData(
                    //         context.read<InviteProvider>().searchUserData);
                    // // showLoadingAnimation(context);
                    // await Provider.of<InviteProvider>(context, listen: false)
                    //     .fetchSearchUserDetail(
                    //         myId: user.id, viewuserId: widget.data["addedById"])
                    //     .then((value) {
                    //   // Navigator.pop(context);
                    //   // context
                    //   //             .read<InviteProvider>()
                    //   //             .searchUserData['inviteStatus'] ==
                    //   //         "approved"
                    //   // ?

                    //   Navigator.of(context).push(
                    //     MaterialPageRoute(
                    //       builder: (ctx) => SisterScreen(
                    //         route: "Notification Screen",
                    //         // familyMember: context
                    //         //     .read<InviteProvider>()
                    //         //     .searchUserData
                    //       ),
                    //     ),
                    //   );

                    //   // : navigationService
                    //   //     .navigateTo(SearchStoryBookScreenRoute);
                    // });
                  },
                  child: Container(
                    width: 45.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        scale: 3,
                        image: NetworkImage(
                          widget.data["profilePicture"],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(
                        widget.data["firstName"].toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.height * 0.021,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (widget.data["type"] == "invite-approved") Text(" "),
                      if (widget.data["type"] == "invite-approved")
                        Text(
                          widget.data["lastName"].toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.021,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ]),
                    Row(
                      children: [
                        Text(
                          "@${widget.data["firstName"]}"
                              .replaceAll(" ", "")
                              .toLowerCase(),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.015,
                          ),
                        ),
                        if (widget.data["type"] == "invite-approved")
                          Text(
                            widget.data["lastName"].toString().toLowerCase(),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                          ),
                      ],
                    ),

                    SizedBox(
                      height: 5.h,
                    ),
                    // notificationlist[index]["pool"].length == 0
                    //     ? Container()
                    //     : Text(
                    //         "Like 4 Your Storybook",
                    //         style: TextStyle(
                    //           color: Colors.black,
                    //           fontSize: 14.sp,
                    //         ),
                    //       ),
                    // notificationlist[index]["pool"].length == 0
                    //     ? Container(
                    //         child: Column(
                    //           crossAxisAlignment:
                    //               CrossAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               "Commented on",
                    //               style: TextStyle(
                    //                 color: Colors.black,
                    //                 fontSize: 14.sp,
                    //               ),
                    //             ),
                    //             SizedBox(
                    //               height: 3.h,
                    //             ),
                    //             Container(
                    //               width: 175.w,
                    //               child: RichText(
                    //                 text: TextSpan(
                    //                   text:
                    //                       'Haha..Nice one. Good Luck This Stratin Weekend ',
                    //                   style: TextStyle(
                    //                     height: 1.3,
                    //                     fontSize: 12.sp,
                    //                     color: Colors.black,
                    //                   ),
                    //                   children: <TextSpan>[
                    //                     TextSpan(
                    //                       text: 'Reply',
                    //                       style: TextStyle(
                    //                         fontSize: 12.sp,
                    //                         color: Colors.grey,
                    //                         fontWeight:
                    //                             FontWeight.w700,
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //             SizedBox(
                    //               height: 15.h,
                    //             )
                    //           ],
                    //         ),
                    //       )
                    //     : Container(
                    //         height: 55.h,
                    //         child: ListView.separated(
                    //           shrinkWrap: true,
                    //           scrollDirection: Axis.horizontal,
                    //           itemCount: notificationlist[index]
                    //                   ["pool"]
                    //               .length,
                    //           itemBuilder:
                    //               (BuildContext context, int i) {
                    //             return Padding(
                    //               padding: EdgeInsets.only(
                    //                   top: 10.h, bottom: 10.h),
                    //               child: Container(
                    //                 width: 40.w,
                    //                 decoration: BoxDecoration(
                    //                   borderRadius:
                    //                       BorderRadius.circular(8),
                    //                   image: DecorationImage(
                    //                     fit: BoxFit.cover,
                    //                     image: AssetImage(
                    //                       notificationlist[index]
                    //                           ["pool"][i]["image"],
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             );
                    //           },
                    //           separatorBuilder:
                    //               (BuildContext context, int i) {
                    //             return SizedBox(
                    //               width: 5.w,
                    //             );
                    //           },
                    //         ),
                    //       ),

                    Container(
                      width: MediaQuery.of(context).size.height * 0.28,
                      // color: Colors.red,
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        text: TextSpan(
                          text: widget.data["message"],

                          // 'wants to add you in his ',
                          style: TextStyle(
                            height: 1.3,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.015,
                            color: Colors.black87,
                          ),

                          // children: <TextSpan>[
                          //   TextSpan(
                          //     text: widget.data["tree"],
                          //     style: TextStyle(
                          //       fontSize: 12.sp,
                          //       color: Colors.black,
                          //       fontWeight: FontWeight.w700,
                          //     ),
                          //   ),
                          //   TextSpan(
                          //     text: 'as his ',
                          //     style: TextStyle(
                          //       fontSize: 12.sp,
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          //   TextSpan(
                          //     text: widget.data["relation"],
                          //     style: TextStyle(
                          //       fontSize: 12.sp,
                          //       color: Colors.black,
                          //       fontWeight: FontWeight.w700,
                          //     ),
                          //   ),
                          //   TextSpan(
                          //     text: 'See More...',
                          //     style: TextStyle(
                          //       fontSize: 12.sp,
                          //       color: Colors.red,
                          //     ),
                          //   ),
                          // ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              // color: Colors.red,
              width: MediaQuery.of(context).size.width * 0.17,
              padding: EdgeInsets.only(right: 5.w),
              child: Text(
                formatted,
                maxLines: 2,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.014,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
