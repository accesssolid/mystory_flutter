//* Create by chetu on 29 aug //

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/global.dart';
import 'package:mystory_flutter/providers/chatProvider.dart';
import 'package:mystory_flutter/screens/add_family_member_manually_screen.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/cache_image.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:screenshot/screenshot.dart';

import '../providers/invite_member.dart';
import '../widgets/read_more_widget.dart';

class FamilyMemberManualProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final bool showRelationButton;

  FamilyMemberManualProfileScreen(
      {Key? key, required this.userData, required this.showRelationButton})
      : super(key: key);

  @override
  State<FamilyMemberManualProfileScreen> createState() =>
      _FamilyMemberManualProfileScreenState(userData);
}

class _FamilyMemberManualProfileScreenState
    extends State<FamilyMemberManualProfileScreen> {
  Map<String, dynamic> userData;

  _FamilyMemberManualProfileScreenState(this.userData);

  var navigationService = locator<NavigationService>();

  String relationName = "";
  String name = "";
  String dob = "";
  String birthPlace = "";
  String hometown = "";
  String shortDescription = "";
  bool isExpanded = false;

  @override
  void initState() {
    relationName = userData['relation']["relationName"];
    print(userData['id']);
    print("userData");
    name = userData['firstName'] + ' ' + userData['lastName'] ?? "";
    dob = userData['dob'] ?? "";
    birthPlace = userData['address']['cityValue'] +
            ',' +userData['address']['stateValue'] +
            ',' +userData['address']['countryValue'].toString().trim() ??
        "";
    hometown = userData['homeTown'] ?? "";
    shortDescription = userData['description'] ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InviteProvider>(builder: (context, memberDetail, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () async {
              if (widget.showRelationButton) {
                var storageService, data;
                storageService = locator<StorageService>();
                data = await storageService.getData("route");
                navigationService.navigateTo(data);
                navigationService.navigateTo(FamilyTreeListRoute);
              } else {
                Navigator.pop(context);
              }
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          title: Column(
            children: [
              Text(
                "My Family",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ),
        bottomNavigationBar:  Visibility(
          visible: widget.showRelationButton,
          child: Padding(
            padding: const EdgeInsets.only(left:8.0,right:8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 7, bottom: 15),
                    height: 33.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(255, 209, 200, 1),
                            spreadRadius: -4,
                            blurRadius: 6,
                            offset: Offset(6, 13))
                      ],
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(255, 145, 73, 1),
                          Color.fromRGBO(254, 65, 85, 1),
                        ],
                        end: Alignment.bottomCenter,
                        begin: Alignment.topCenter,
                      ),
                    ),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.resolveWith(
                                    (states) => 0),
                            backgroundColor:
                            MaterialStateColor.resolveWith(
                                    (states) => Colors.transparent),
                            shape: MaterialStateProperty.resolveWith(
                                    (states) => RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(50)))),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  content: Text(
                                      'Do you want to delete this member permanently?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          Navigator.pop(context);

                                          var data = {
                                            "treeAdminId":
                                            userData["treeAdminId"],
                                            "manualUserId": userData["id"]
                                          };
                                          showLoadingAnimation(context);
                                          await Provider.of<
                                              InviteProvider>(
                                              context,
                                              listen: false)
                                              .deleteFamilyMember(
                                              data: data,
                                              context: context)
                                              .then((value) async {
                                            if (value) {
                                              var storageService, data;
                                              storageService = locator<
                                                  StorageService>();
                                              data = await storageService
                                                  .getData("route");
                                              navigationService
                                                  .navigateTo(data);
                                              navigationService.navigateTo(
                                                  FamilyTreeListRoute);
                                            } else {
                                              Navigator.pop(context);
                                            }
                                          });
                                        },
                                        child: Text('Yes!')),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No'))
                                  ],
                                );
                              });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Delete",
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ],
                        )),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 7, bottom: 15),
                    height: 33.h,
                    //  width: 120.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(218, 221, 250, 1),
                            spreadRadius: -4,
                            blurRadius: 6,
                            offset: Offset(6, 13))
                      ],
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(90, 120, 226, 1),
                          Color.fromRGBO(134, 107, 235, 1),
                        ],
                        end: Alignment.bottomCenter,
                        begin: Alignment.topCenter,
                      ),
                    ),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.resolveWith(
                                    (states) => 0),
                            backgroundColor:
                            MaterialStateColor.resolveWith(
                                    (states) => Colors.transparent),
                            shape: MaterialStateProperty.resolveWith(
                                    (states) => RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(50)))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) =>
                                      AddFamilyMemberManuallyScreen(
                                          userData: userData)));
                          //     .then((value) {
                          //   if (value != null) {
                          //     name =
                          //         value["firstName"] + value["lastName"];
                          //     dob = value["dob"];
                          //     birthPlace = value['address']
                          //                 ['countryValue'] +
                          //             ',' +
                          //             value['address']['stateValue'] +
                          //             ',' +
                          //             value['address']['cityValue'] ??
                          //         "";
                          //     hometown = value['homeTown'] ?? "";
                          //     shortDescription =
                          //         value['description'] ?? "";
                          //   }
                          // });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Edit",
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                //height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: EdgeInsets.only(left: 12.0.w, right: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.white,
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                    offset: Offset(0, 6))
                              ]),
                          child: CacheImage(
                            placeHolder: "place_holder.png",
                            imageUrl: userData['profilePicture'],
                            width: 400.w,
                            height: 120.h,
                            radius: 6.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.red.shade100),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 6.0, right: 6, top: 4, bottom: 4),
                            child: Text(
                              relationName,
                              style: TextStyle(
                                  color: Color.fromRGBO(239, 111, 110, 1),
                                  fontSize: 12.sp),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Name : ",
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.grey.shade500),
                          ),
                          Text(
                            name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12.sp),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "DOB : ",
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.grey.shade500),
                          ),
                          Text(
                            dob,
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "BIRTH PLACE : ",
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.grey.shade500),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,

                              child: Text(
                                overflow: TextOverflow.fade,
                                birthPlace.trim(),
                                style: TextStyle(
                                    fontSize: 12.sp, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "HOMETOWN : ",
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.grey.shade500),
                          ),
                          Text(
                            hometown,
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Short Description - ",
                        style:
                            TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                        //Text(
                        //  shortDescription,
                        //  style: TextStyle(
                        //      fontSize: 12.sp),
                        //),
                      // if (shortDescription.length > 55)
                      //   TextButton(
                      //     onPressed: () {
                      //       setState(() {
                      //         isExpanded = !isExpanded;
                      //       });
                      //     },
                      //     child: Text(
                      //       isExpanded ? 'Read Less' : 'Read More',
                      //       style: TextStyle(color: Colors.blue),
                      //     ),
                      //   ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: [
                      //     Expanded(
                      //       child: Text(
                      //         shortDescription,
                      //         maxLines: isExpanded ? 500 : 3,
                      //         overflow: TextOverflow.ellipsis,
                      //         style: TextStyle(fontSize: 12.0),
                      //       ),
                      //     ),
                      //     if (shortDescription.length >55)
                      //       TextButton(
                      //         onPressed: () {
                      //           setState(() {
                      //             isExpanded = !isExpanded;
                      //           });
                      //         },
                      //         child: Text(
                      //           isExpanded ? 'Read Less' : 'Read More',
                      //           style:  TextStyle(fontSize: 12.0),
                      //         ),
                      //       ),
                      //   ],
                      // ),
                      ReadMoreTextWidget(
                        "$shortDescription",
                        textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 12.0),
                        trimLines: 4,
                        trimLength: 200,

                        moreStyle:  TextStyle(
                            color: Color(0xff2069d3),
                            fontWeight: FontWeight.w500),
                        lessStyle:   TextStyle(
                            color: Color(0xff2069d3),
                            fontWeight: FontWeight.w500),

                      ),

                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
