import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/category_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:provider/provider.dart';

class SearchStoryBookScreen extends StatefulWidget {
  SearchStoryBookScreen({route});

  String? route;
  @override
  _SearchStoryBookScreenState createState() => _SearchStoryBookScreenState();
}

class _SearchStoryBookScreenState extends State<SearchStoryBookScreen> {
  // var getUserDetail;
  // List<SearchModel> search = [];
  @override
  void initState() {
    // search =
    // Provider.of<InviteProvider>(context, listen: false).getSearchUserData;
    // getUserDetail =
    //     Provider.of<AuthProviderr>(context, listen: false).getUserDetailData;
    super.initState();
  }

  var navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return Consumer<InviteProvider>(builder: (context, search, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              navigationService.closeScreen();
              // navigationService.navigateTo(MaindashboardSearchRoute);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          title: Text(
            search.searchUserData["fullName"],
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: Container(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.red.shade100,
                                blurRadius: 5,
                                spreadRadius: 0,
                                offset: Offset(0, 6))
                          ]),
                      child: search.searchUserData["profilePicture"] != ""
                          ? CircleAvatar(
                              backgroundColor: Colors.orange.shade900,
                              radius: 28,
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(search
                                    .searchUserData["profilePicture"]
                                    .toString()),
                              ))
                          : CircleAvatar(
                              backgroundColor: Colors.orange.shade900,
                              radius: 28,
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage(
                                    "assets/images/place_holder.png"),
                              ),
                            ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          search.searchUserData['storyBookCount'].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.sp),
                        ),
                        Text(
                          "Storybook",
                          style: TextStyle(
                              fontSize: 10.sp,
                              color: Color.fromRGBO(141, 141, 141, 1),
                              height: 1.7),
                        ),
                      ],
                    ),
                    Container(
                        height: 40,
                        child: VerticalDivider(
                          color: Colors.grey.shade200,
                          width: 2,
                          thickness: 2,
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          search.searchUserData['treeBookCount'].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.sp),
                        ),
                        Text(
                          "Family Tree",
                          style: TextStyle(
                              fontSize: 10.sp,
                              color: Color.fromRGBO(141, 141, 141, 1),
                              height: 1.7),
                        ),
                      ],
                    ),
                    // Container(
                    //     height: 40,
                    //     child: VerticalDivider(
                    //       color: Colors.grey.shade200,
                    //       width: 2,
                    //       thickness: 2,
                    //     )),
                    // Container(
                    //   height: 70,
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       SizedBox(
                    //         height: 18,
                    //       ),
                    //       Text(
                    //         search.searchUserData['linkStoryCount'].toString(),
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold, fontSize: 14.sp),
                    //       ),
                    //       Container(
                    //         padding: EdgeInsets.only(top: 2.h),
                    //         // width: 70,
                    //         child: Text(
                    //           "Linked Storybook",
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //               fontSize: 10.sp,
                    //               color: Color.fromRGBO(141, 141, 141, 1),
                    //               height: 1.3),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox()
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Text(
                search.searchUserData['fullName'].toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "@${search.searchUserData['firstName']}${search.searchUserData['lastName']}"
                    .toLowerCase(),
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12.sp),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(91, 121, 229, 1),
                          Color.fromRGBO(129, 109, 224, 1)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 0.99])),
                child: ElevatedButton(
                    style: ButtonStyle(
                      elevation:
                          MaterialStateProperty.resolveWith((states) => 0),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.transparent),
                    ),
                    onPressed: search.searchUserData['inviteStatus'] ==
                                "pending" ||
                            search.searchUserData['inviteStatus'] == "approved"
                        ? () {}
                        : () {
                            Provider.of<AuthProviderr>(context, listen: false)
                                .setDataForUserDetail(search.searchUserData);
                            navigationService
                                .navigateTo(InviteMemberScreenRoute);
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          search.searchUserData['inviteStatus'] == "pending"
                              ? Text("Pending")
                              : search.searchUserData['inviteStatus'] == "reject"
                                  ? Text("Rejected")
                                  : Text("Invite To Your Tree"),
                        ],
                      ),
                    )
                    ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                width: 400,
                color: Colors.grey.shade100,
                height: 6,
              ),
              // SizedBox(
              //   height: 25,
              // ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade50,
                        radius: 60,
                        backgroundImage:
                            AssetImage("assets/images/Group 33607.png"),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                        "This account is private",
                        // search.searchUserData['fullName'].toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        child: Text(
                          "Invite this account to see their photos and videos.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              height: 1.5),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )),
      );
    });
  }
}
