import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/models/email_invite.dart';
import 'package:mystory_flutter/models/relation.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/screens/add_family_member_manually_screen.dart';
import 'package:mystory_flutter/services/dynamic_link_service.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';

import '../global.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  AddFamilyMemberScreen({Key? key}) : super(key: key);

  @override
  _AddFamilyMemberScreenState createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
  var navigationService = locator<NavigationService>();
  var utilService = locator<UtilService>();
  var dynamicLink = locator<DynamicLinksService>();

  var user;
  bool isloading = false;
  String name = "";
  EmailInvite? emailInvite;
  TextEditingController searchController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController relationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<RelationModel> getRelation = [];
  bool showRelation = false;
  var selectedRelationId;
  // List<String> tabList = ["Search User", "Add Manually", "Invite Member"];  // commented for hide invite user, by chetu on 6 nov 2023
  List<String> tabList = ["Search User", "Add Manually"];
  List<QueryDocumentSnapshot<Object?>> userDataList = [];
  List<QueryDocumentSnapshot<Object?>> userDataListFiltered = [];
  String message = "Type any name or email to search.";

  // List<Map<String, dynamic>> addfamilylist = [
  //     "id": "3",
  //     "title": "Manede Portman",
  //     "subtitle": "@mandeportman",
  //     "img": "assets/images/dummy03.jpg"
  //   },
  // ];

  String tagId = ' ';

  int? _expandedIndex = 0;

  void active(val) {
    setState(() {
      tagId = val;
    });
  }

  var selectedRelation;

  fetchRelations() async {
    getRelation =
        Provider.of<InviteProvider>(context, listen: false).getRelation;

    if (getRelation.length == 0) {
      setState(() {
        isloading = true;
      });

      await Provider.of<InviteProvider>(context, listen: false)
          .fetchAllRelation();
      getRelation =
          Provider.of<InviteProvider>(context, listen: false).getRelation;

      setState(() {
        isloading = false;
      });
    } else
      setState(() {
        isloading = false;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRelations();
    user = Provider.of<AuthProviderr>(context, listen: false).user;
    getUserData();
  }

  getUserData() async {
    //* method created by chetu

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("users").get();
    userDataList = querySnapshot.docs;
  }

  void sendInvite() async {
    print(
        'relation Controller: ${relationController.text} User Name: ${user.fullName}}');
    if (emailController.text.isEmpty || relationController.text.isEmpty) {
      utilService.showToast("Please fill all * fields", context);
    } else {
      setState(() {
        isloading = true;
      });
      final createdLink = await dynamicLink.createDynamicLink();
      print('Hi there Created Link: $createdLink');
      emailInvite = EmailInvite(
          to: emailController.text,
          message: Message(
              subject: "MyStory Invitation",
              text:
                  "${user.fullName} has invited you to join MyStory. \n$createdLink")); // removed name by chetu.
      Provider.of<InviteProvider>(context, listen: false)
          .emailInviteMember(context: context, emailInvite: emailInvite);
      setState(() {
        isloading = false;
      });
      navigationService.closeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return AbsorbPointer(
        absorbing: isloading,
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                child: AppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.black,
                    onPressed: () {
                      navigationService
                          .navigateTo(MaindashboardFamilyTreehRoute);
                    },
                  ),
                  centerTitle: true,
                  title: Text(
                    "Add Family Member",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  bottom: PreferredSize(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 7, right: 7),
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height * 0.065,
                            child: ListView.builder(
                                padding: EdgeInsets.all(0),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                              //  itemCount: 3,   commented for hide invite user by chetu
                                itemCount: 2,
                                itemBuilder: (ctx, i) {
                                  return GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        _expandedIndex = i;
                                        // selectedIndex = i;
                                        // isLoading = true;
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                          top: 6.w, bottom: 6.w),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: _expandedIndex == i
                                                ? Color.fromRGBO(
                                                    91, 121, 229, 1)
                                                : Colors.transparent,
                                            offset: Offset(0.0, 1.0), //(x,y)
                                            blurRadius: 2.0,
                                            spreadRadius: 0.0,
                                          ),
                                        ],
                                        gradient: LinearGradient(
                                          colors: [
                                            _expandedIndex == i
                                                ? Color.fromRGBO(
                                                    91, 121, 229, 1)
                                                : Colors.transparent,
                                            _expandedIndex == i
                                                ? Color.fromRGBO(
                                                    129, 109, 224, 1)
                                                : Colors.transparent
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.0, 0.99],
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            20), // Createsssss border
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 15.w,
                                            right: 15.w,
                                            top: 5.w,
                                            bottom: 5.w),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              tabList[i],
                                              style: TextStyle(
                                                  color: _expandedIndex == i
                                                      ? Colors.white
                                                      : Colors.grey.shade400,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.02,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),

                          // Container(
                          //   padding: EdgeInsets.only(left: 20, right: 20),
                          //   height: 45.h,
                          //   child: TextFormField(
                          //     controller: searchController,
                          //     onChanged: (val) {
                          //       setState(() {
                          //         name = val;
                          //       });
                          //     },
                          //     decoration: InputDecoration(
                          //       contentPadding:
                          //           EdgeInsets.symmetric(horizontal: 20),
                          //       isDense: true,
                          //       suffixIcon: Container(
                          //         width: 60.w,
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.start,
                          //           children: [
                          //             Container(
                          //               width: 1.w,
                          //               height: 30.h,
                          //               color: Colors.grey.shade300,
                          //             ),
                          //             SizedBox(
                          //               width: 20.w,
                          //             ),
                          //             Icon(
                          //               Icons.search,
                          //               size: 24.h,
                          //               color: Colors.grey.shade700,
                          //             ),
                          //             SizedBox(
                          //               width: 10.w,
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //       border: OutlineInputBorder(
                          //         borderRadius: BorderRadius.all(
                          //           Radius.circular(05.0),
                          //         ),
                          //         borderSide: BorderSide(
                          //           width: 0.w,
                          //           style: BorderStyle.none,
                          //         ),
                          //       ),
                          //       filled: true,
                          //       hintStyle: TextStyle(
                          //         color: Color.fromRGBO(171, 170, 169, 1),
                          //         fontWeight: FontWeight.w400,
                          //         fontSize: 12.sp,
                          //       ),
                          //       hintText: "Search here..",
                          //       fillColor: Color.fromRGBO(245, 246, 248, 0.6),
                          //     ),
                          //   ),
                          // ),   // comented by chetu
                        ],
                      ),
                      preferredSize: Size.fromHeight(0)),
                ),
                preferredSize: Size.fromHeight(130),
              ),
              body: _expandedIndex == 0
                  ? Container(
                      child: Padding(
                      padding: EdgeInsets.only(left: 18.0, right: 18.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 45.h,
                                  child: TextFormField(
                                    controller: searchController,
                                    onChanged: (val) {
                                      setState(() {
                                        name = val;
                                        if (val.isNotEmpty) {
                                          userDataListFiltered.clear();
                                          userDataListFiltered.addAll(
                                              userDataList
                                                  .where((data) =>
                                                      (data['fullName']
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains(val
                                                              .toLowerCase())) ||
                                                      data['email']
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains(val
                                                              .toLowerCase()))
                                                  .toList());
                                          message = "No user Found.";
                                        } else {
                                          message =
                                              "Type any name or email to search.";
                                          userDataListFiltered.clear();
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      isDense: true,
                                      suffixIcon: Container(
                                        width: 60.w,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                      fillColor:
                                          Color.fromRGBO(245, 246, 248, 0.6),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Suggestion",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "View All",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade400),
                                    )
                                  ],
                                ),
                                // ListView.builder(
                                //     shrinkWrap: true,
                                //     physics: NeverScrollableScrollPhysics(),
                                //     padding: EdgeInsets.zero,
                                //     itemCount: addfamilylist.length,
                                //     itemBuilder: (ctx, i) {
                                //       return AddFamilyMemeberWidget(
                                //         data: addfamilylist[i],
                                //         action: active,
                                //         tag: addfamilylist[i]['id'],
                                //         active:
                                //             tagId == addfamilylist[i]['id'] ? true : false,
                                //       );
                                //     }),
                                SizedBox(
                                  height: 10.h,
                                ),

                                Container(
                                  child: userDataListFiltered.isEmpty
                                      ? Center(child: Text(message))
                                      : ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          primary: true,
                                          // snapshot.data!.docs.length
                                          itemCount:
                                              userDataListFiltered.length,
                                          itemBuilder:
                                              (BuildContext ctx, index) {
                                            var searchData =
                                                userDataListFiltered[index];
                                            return InkWell(
                                              onTap: () async {
                                                showLoadingAnimation(context);
                                                await Provider.of<
                                                            InviteProvider>(
                                                        context,
                                                        listen: false)
                                                    .fetchSearchUserDetail(
                                                        myId: user.id,
                                                        viewuserId:
                                                            searchData['id'])
                                                    .then((value) async {
                                                  Navigator.pop(context);
                                                  var storageService =
                                                  locator<StorageService>();
                                                  await storageService.setData(
                                                      "route", "/ add-familymember-screen");
                                                  Provider.of<InviteProvider>(
                                                          context,
                                                          listen: false)
                                                      .setFamilyData(context
                                                          .read<
                                                              InviteProvider>()
                                                          .searchUserData);
                                                  context
                                                                  .read<
                                                                      InviteProvider>()
                                                                  .searchUserData[
                                                              'inviteStatus'] ==
                                                          "approved"
                                                      ? navigationService
                                                          .navigateTo(
                                                              FamilyMemberProfileScreenRoute)
                                                      //  Navigator.of(context).push(
                                                      //     MaterialPageRoute(
                                                      //       builder: (ctx) =>
                                                      //           SisterScreen(
                                                      //         route: "Search Screen",
                                                      //         // familyMember: context
                                                      //         //     .read<
                                                      //         //         InviteProvider>()
                                                      //         //     .searchUserData
                                                      //       ),
                                                      //     ),
                                                      //   )
                                                      : navigationService
                                                          .navigateTo(
                                                              SearchStoryBookScreenRoute);
                                                  searchController.clear();
                                                  userDataListFiltered.clear();
                                                  message = "Type any name or email to search.";
                                                  setState(() {
                                                    name = "";

                                                  });
                                                });
                                                // var sendData = {
                                                //   'profilePicture':
                                                //       searchData["profilePicture"]
                                                //           .toString(),
                                                //   'fullName':
                                                //       searchData['fullName'].toString(),
                                                //   'id': searchData['id'].toString(),
                                                //   'firstName':
                                                //       searchData['firstName'].toString(),
                                                //   'lastName':
                                                //       searchData['lastName'].toString(),
                                                //   'middleName':
                                                //       searchData['middleName'].toString(),
                                                //   'email': searchData['email'].toString(),
                                                //   'dob': searchData['dob'].toString(),
                                                //   'address': searchData['address'],
                                                // };
                                                // Provider.of<AuthProvider>(context,
                                                //         listen: false)
                                                //     .setDataForUserDetail(sendData);
                                              },
                                              child: searchData['id'] != user.id
                                                  ? Container(
                                                      margin: EdgeInsets.only(
                                                          top: 12),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      boxShadow: [
                                                                    BoxShadow(
                                                                        color: Color.fromRGBO(
                                                                            221,
                                                                            214,
                                                                            249,
                                                                            1),
                                                                        spreadRadius:
                                                                            -8,
                                                                        blurRadius:
                                                                            5,
                                                                        offset: Offset(
                                                                            0,
                                                                            12)),
                                                                  ]),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                child: searchData[
                                                                            'profilePicture'] !=
                                                                        ""
                                                                    ? Image(
                                                                        image: NetworkImage(
                                                                            searchData['profilePicture'].toString()),
                                                                        //  image: AssetImage("assets/images/place_holder.png"),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        height:
                                                                            45,
                                                                        width:
                                                                            45,
                                                                        errorBuilder: (BuildContext context,
                                                                            Object
                                                                                exception,
                                                                            StackTrace?
                                                                                stackTrace) {
                                                                          print(
                                                                              "Exception >> ${exception.toString()}");
                                                                          return Image(
                                                                            image:
                                                                                AssetImage("assets/images/place_holder.png"),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            height:
                                                                                45,
                                                                            width:
                                                                                45,
                                                                          );
                                                                        },
                                                                      )
                                                                    : Image(
                                                                        image: AssetImage(
                                                                            "assets/images/place_holder.png"),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        height:
                                                                            45,
                                                                        width:
                                                                            45,
                                                                      ),
                                                              )),
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                searchData['fullName'] !=
                                                                        ""
                                                                    ? searchData[
                                                                            'fullName']
                                                                        .toString()
                                                                    : "",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                              SizedBox(
                                                                height: 4,
                                                              ),
                                                              Text(
                                                                searchData[
                                                                    'givenName'],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade700,
                                                                    fontSize:
                                                                        10),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                            );
                                          }),
                                )

                                // SingleChildScrollView(
                                //   // height:
                                //   //     MediaQuery.of(context).size.height * 0.3,
                                //   child: StreamBuilder<QuerySnapshot>(
                                //     stream: (name != "")
                                //         ? FirebaseFirestore.instance
                                //             .collection('users')
                                //             .where("searchKey",
                                //                 isEqualTo: name
                                //                     .substring(0, 1)
                                //                     .toUpperCase())
                                //             .snapshots()
                                //         : FirebaseFirestore.instance
                                //             .collection("users")
                                //             .snapshots(),
                                //     builder: (context, snapshot) {
                                //       return (snapshot.connectionState ==
                                //               ConnectionState.waiting)
                                //           ? Center(
                                //               child:
                                //                   CircularProgressIndicator())
                                //           : snapshot.data == null &&
                                //                   searchController.text != ""
                                //               ? Center(child: Text("No Data"))
                                //               : ListView.builder(
                                //                   physics:
                                //                       NeverScrollableScrollPhysics(),
                                //                   shrinkWrap: true,
                                //                   // snapshot.data!.docs.length
                                //                   itemCount: snapshot
                                //                       .data!.docs.length,
                                //                   itemBuilder:
                                //                       (BuildContext ctx,
                                //                           index) {
                                //                     var searchData = snapshot
                                //                         .data!.docs[index];
                                //                     return InkWell(
                                //                       onTap: () async {
                                //                         showLoadingAnimation(
                                //                             context);
                                //                         await Provider.of<
                                //                                     InviteProvider>(
                                //                                 context,
                                //                                 listen: false)
                                //                             .fetchSearchUserDetail(
                                //                                 myId: user.id,
                                //                                 viewuserId:
                                //                                     searchData[
                                //                                         'id'])
                                //                             .then((value) {
                                //                           Navigator.pop(
                                //                               context);
                                //                           Provider.of<InviteProvider>(
                                //                                   context,
                                //                                   listen: false)
                                //                               .setFamilyData(context
                                //                                   .read<
                                //                                       InviteProvider>()
                                //                                   .searchUserData);
                                //                           context.read<InviteProvider>().searchUserData[
                                //                                       'inviteStatus'] ==
                                //                                   "approved"
                                //                               ? navigationService
                                //                                   .navigateTo(
                                //                                       FamilyMemberProfileScreenRoute)
                                //                               //  Navigator.of(context).push(
                                //                               //     MaterialPageRoute(
                                //                               //       builder: (ctx) =>
                                //                               //           SisterScreen(
                                //                               //         route: "Search Screen",
                                //                               //         // familyMember: context
                                //                               //         //     .read<
                                //                               //         //         InviteProvider>()
                                //                               //         //     .searchUserData
                                //                               //       ),
                                //                               //     ),
                                //                               //   )
                                //                               : navigationService
                                //                                   .navigateTo(
                                //                                       SearchStoryBookScreenRoute);
                                //                           searchController
                                //                               .clear();
                                //                           setState(() {
                                //                             name = "";
                                //                           });
                                //                         });
                                //                         // var sendData = {
                                //                         //   'profilePicture':
                                //                         //       searchData["profilePicture"]
                                //                         //           .toString(),
                                //                         //   'fullName':
                                //                         //       searchData['fullName'].toString(),
                                //                         //   'id': searchData['id'].toString(),
                                //                         //   'firstName':
                                //                         //       searchData['firstName'].toString(),
                                //                         //   'lastName':
                                //                         //       searchData['lastName'].toString(),
                                //                         //   'middleName':
                                //                         //       searchData['middleName'].toString(),
                                //                         //   'email': searchData['email'].toString(),
                                //                         //   'dob': searchData['dob'].toString(),
                                //                         //   'address': searchData['address'],
                                //                         // };
                                //                         // Provider.of<AuthProvider>(context,
                                //                         //         listen: false)
                                //                         //     .setDataForUserDetail(sendData);
                                //                       },
                                //                       child:
                                //                           searchData['id'] !=
                                //                                   user.id
                                //                               ? Container(
                                //                                   margin: EdgeInsets
                                //                                       .only(
                                //                                           top:
                                //                                               12),
                                //                                   child: Row(
                                //                                     children: [
                                //                                       Container(
                                //                                           decoration: BoxDecoration(
                                //                                               boxShadow: [
                                //                                                 BoxShadow(color: Color.fromRGBO(221, 214, 249, 1), spreadRadius: -8, blurRadius: 5, offset: Offset(0, 12)),
                                //                                               ]),
                                //                                           child:
                                //                                               ClipRRect(
                                //                                             borderRadius:
                                //                                                 BorderRadius.circular(10),
                                //                                             child: searchData['profilePicture'] != ""
                                //                                                 ? Image(
                                //                                                     image: NetworkImage(searchData['profilePicture'].toString()),
                                //                                                     //  image: AssetImage("assets/images/place_holder.png"),
                                //                                                     fit: BoxFit.cover,
                                //                                                     height: 45,
                                //                                                     width: 45,
                                //                                                     errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                //                                                       print("Exception >> ${exception.toString()}");
                                //                                                       return Image(
                                //                                                         image: AssetImage("assets/images/place_holder.png"),
                                //                                                         fit: BoxFit.cover,
                                //                                                         height: 45,
                                //                                                         width: 45,
                                //                                                       );
                                //                                                     },
                                //                                                   )
                                //                                                 : Image(
                                //                                                     image: AssetImage("assets/images/place_holder.png"),
                                //                                                     fit: BoxFit.cover,
                                //                                                     height: 45,
                                //                                                     width: 45,
                                //                                                   ),
                                //                                           )),
                                //                                       SizedBox(
                                //                                         width:
                                //                                             15,
                                //                                       ),
                                //                                       Column(
                                //                                         crossAxisAlignment:
                                //                                             CrossAxisAlignment.start,
                                //                                         children: [
                                //                                           Text(
                                //                                             searchData['fullName'] != ""
                                //                                                 ? searchData['fullName'].toString()
                                //                                                 : "",
                                //                                             style:
                                //                                                 TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                                //                                           ),
                                //                                           SizedBox(
                                //                                             height:
                                //                                                 4,
                                //                                           ),
                                //                                           Text(
                                //                                             searchData['givenName'],
                                //                                             style:
                                //                                                 TextStyle(color: Colors.grey.shade700, fontSize: 10),
                                //                                           )
                                //                                         ],
                                //                                       )
                                //                                     ],
                                //                                   ),
                                //                                 )
                                //                               : Container(),
                                //                     );
                                //                   });
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ))
                  : _expandedIndex == 1
                      ? Container(child: AddFamilyMemberManuallyScreen())
                      : Container(
                          child: Padding(
                          padding: EdgeInsets.only(left: 18.0, right: 18.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          " Given Relation",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          "*",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          width: 500.w,
                                          // height: 60.h,
                                          // color: Colors.red,
                                          child: TextFormField(
                                            // keyboardType: TextInputType.emailAddress,
                                            controller: relationController,
                                            autocorrect: true,
                                            readOnly: true,
                                            textInputAction:
                                                TextInputAction.next,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.sp,
                                            ),
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    showRelation =
                                                        !showRelation;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  size: 20.h,
                                                  color: Theme.of(context)
                                                      .backgroundColor,
                                                ),
                                              ),
                                              isDense: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 15.0,
                                                horizontal: 12,
                                              ),
                                              hintText: 'Select Relation',
                                              hintStyle: TextStyle(
                                                  fontSize: sy(9),
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey.shade400),
                                              filled: true,
                                              fillColor: Colors.white,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .indicatorColor,
                                                    width: 1),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    width: 1),
                                              ),
                                            ),
                                          ),
                                        ),
                                        showRelation
                                            ? Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    15.w, 0, 0, 10),
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 5,
                                                      blurRadius: 7,
                                                      offset: Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: ListView.builder(
                                                  itemCount: getRelation.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          relationController
                                                                  .text =
                                                              "${getRelation[index].relationName}";
                                                          selectedRelation =
                                                              getRelation[index]
                                                                  .relationName;
                                                          selectedRelationId =
                                                              getRelation[index]
                                                                  .id;
                                                        });
                                                        showRelation = false;
                                                      },
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 25.h,
                                                          ),
                                                          Text(
                                                            "   ${getRelation[index].relationName}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    sy(11)),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Short Description",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      "Write a short descriptive about your relation",
                                      style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Container(
                                      child: TextFormField(
                                        keyboardType: TextInputType.multiline,
                                        controller: descriptionController,
                                        autocorrect: true,
                                        textInputAction: TextInputAction.next,
                                        maxLines: 5,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 15.0,
                                            horizontal: 15,
                                          ),
                                          hintText: 'Write Story',
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.sp,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .indicatorColor,
                                                width: 1),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          " Email",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        Text(
                                          "*",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                      "Email Address",
                                      style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Container(
                                      height: 45.h,
                                      child: TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: emailController,
                                        autocorrect: true,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          suffixIcon: Icon(
                                            Icons.mail_outline_rounded,
                                            size: 20.h,
                                            color: Colors.grey,
                                          ),
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 15.0,
                                            horizontal: 15,
                                          ),
                                          hintText: 'Enter email here...',
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.sp,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .indicatorColor,
                                                width: 1),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey.shade400,
                                                  spreadRadius: -3,
                                                  blurRadius: 5,
                                                  offset: Offset(1, 5))
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Color.fromRGBO(
                                                      91, 121, 229, 1),
                                                  Color.fromRGBO(
                                                      129, 109, 224, 1)
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                stops: [0.0, 0.99]),
                                          ),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.053,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.43,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              sendInvite();
                                            },
                                            style: ButtonStyle(
                                                elevation: MaterialStateProperty
                                                    .resolveWith((states) => 0),
                                                backgroundColor:
                                                    MaterialStateColor
                                                        .resolveWith((states) =>
                                                            Colors
                                                                .transparent)),
                                            child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 10),
                                                child: new Text(
                                                  "Invite",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )),
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              navigationService.closeScreen();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              textStyle: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.03,
                                                  fontWeight: FontWeight.w600),
                                              fixedSize: Size(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.43,
                                                  MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.070),
                                              backgroundColor: Colors.transparent,
                                              side: BorderSide(
                                                color: Theme.of(context)
                                                    .indicatorColor,
                                              ),
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        30.0),
                                              ),
                                            ),
                                            child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 10),
                                                child: new Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .indicatorColor,
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )),
            ),
            isloading
                ? Center(
                    child: SizedBox(),
                  )
                : SizedBox()
          ],
        ),
      );
    });
  }
}
