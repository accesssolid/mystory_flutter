import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/global.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/chatProvider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/screens/chat_message_screen.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/no_data_yet.dart';
import 'package:provider/provider.dart';

class AddNewChatScreen extends StatefulWidget {
  final String userId;

  const AddNewChatScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<AddNewChatScreen> createState() => _AddNewChatScreenState();
}

class _AddNewChatScreenState extends State<AddNewChatScreen> {
  TextEditingController searchEditingController = TextEditingController();
  var _scroll = ScrollController();
  int page = 2;
  int count = 10;
  var user;
  List<QueryDocumentSnapshot<Object?>> userDataList = [];
  List<QueryDocumentSnapshot<Object?>> userDataListFiltered = [];
  String message = "Type any name or email to search.";
  var navigationService = locator<NavigationService>();
  List<Map<String, dynamic>> familyList = [];

  @override
  void initState() {
    user = Provider.of<AuthProviderr>(context, listen: false).user;

    // familyList.addAll(context
    //     .read<InviteProvider>()
    //     .fetcFamilyTree
    //     .where((element) => element["email"] != ""));

    _scroll.addListener(() {
      if (_scroll.position.pixels == _scroll.position.maxScrollExtent) {
        context.read<InviteProvider>().getMoreDatafamilyTreeTab(
            count: count, page: page, id: user.id, context: context);
        setState(() {
          page = page + 1;
        });
      }
    });
    getFamilyData();
    super.initState();
  }

  getFamilyData() async {
    //* method created by chetu

    await Provider.of<InviteProvider>(context, listen: false)
        .fetchAllFamilyTree(id: user.id, count: 10, page: 1);
    await Provider.of<InviteProvider>(context, listen: false)
        .fetchFilterFamilyTree(
      count: "10",
      page: "1",
      reltationId: "brother",
      id: user.id,
    );
    // QuerySnapshot querySnapshot =
    //     await FirebaseFirestore.instance.collection("users").get();
    // userDataList = querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.15,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Text(
            "Select member to chat",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          )),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 40.h,
            child: TextField(
              controller: searchEditingController,
              onChanged: onItemChanged,
              decoration: InputDecoration(
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
                        size: 20.h,
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
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                ),
                hintText: "Search",
                fillColor: Color.fromRGBO(245, 246, 248, 0.6),
              ),
            ),
          ),
          SizedBox(height: 20),
          // userDataListFiltered.isEmpty
          //     ? Center(child: Text(message))
          Expanded(
            child: Container(
              // height: MediaQuery.of(context).size.height / 1 / 1.5,
              child:
                  Consumer<InviteProvider>(builder: (context, family, child) {
                return family.fetcFamilyTree.length != 0
                    ? Stack(
                        children: [
                          family.newDataList.length == 0 &&
                                  searchEditingController.text.length != 0
                              ? NoDataYet(
                                  title: "No Search Found",
                                  image: "Group 947.png")
                              : ListView.builder(
                                  // physics:
                                  //     NeverScrollableScrollPhysics(),
                                  controller: _scroll,
                                  shrinkWrap: true,
                                  itemCount:
                                      searchEditingController.text.length != 0
                                          ? family.newDataList.length
                                          : family.fetcFamilyTree.length + 1,
                                  itemBuilder: (ctx, i) {
                                    if (i == family.fetcFamilyTree.length) {
                                      return family.isPaginaionLoading == true
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            )
                                          : Container();
                                    } else {
                                      return searchEditingController.text.length !=
                                              0
                                          ? Visibility(
                                              visible: !family.newDataList[i]
                                                  ["isRemove"],
                                              child:
                                                  (family.newDataList[i]
                                                                  ['email'] ==
                                                              "" ||
                                                          family.newDataList[i]
                                                                  ['id'] ==
                                                              widget.userId)
                                                      ? Container()
                                                      : GestureDetector(
                                                          onTap: () async {
                                                            //  showLoadingAnimation(context);

                                                            context
                                                                    .read<
                                                                        ChatProvider>()
                                                                    .senderId =
                                                                context
                                                                    .read<
                                                                        AuthProviderr>()
                                                                    .user
                                                                    .id;
                                                            context
                                                                .read<
                                                                    ChatProvider>()
                                                                .receverId = context
                                                                    .read<
                                                                        ChatProvider>()
                                                                    .receverId =
                                                                family.newDataList[
                                                                    i]['id'];

                                                            await context
                                                                .read<
                                                                    ChatProvider>()
                                                                .getChatRoomId();
                                                            print(
                                                                'condition if 3');
                                                            var memberData =
                                                                await context
                                                                    .read<
                                                                        ChatProvider>()
                                                                    .getChatPersonProfile();
                                                            print(
                                                                'memberdata $memberData');
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ChatMessageScreen(
                                                                        memberData),
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 12),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            boxShadow: [
                                                                          BoxShadow(
                                                                              color: Color.fromRGBO(221, 214, 249, 1),
                                                                              spreadRadius: -8,
                                                                              blurRadius: 5,
                                                                              offset: Offset(0, 12)),
                                                                        ]),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      child: family.newDataList[i]['profilePicture'] !=
                                                                              ""
                                                                          ? Image(
                                                                              image: NetworkImage(family.newDataList[i]['profilePicture'].toString()),
                                                                              //  image: AssetImage("assets/images/place_holder.png"),
                                                                              fit: BoxFit.cover,
                                                                              height: 45,
                                                                              width: 45,
                                                                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                                return Image(
                                                                                  image: AssetImage("assets/images/place_holder.png"),
                                                                                  fit: BoxFit.cover,
                                                                                  height: 45,
                                                                                  width: 45,
                                                                                );
                                                                              },
                                                                            )
                                                                          : Image(
                                                                              image: AssetImage("assets/images/place_holder.png"),
                                                                              fit: BoxFit.cover,
                                                                              height: 45,
                                                                              width: 45,
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
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          family.newDataList[i]
                                                                              [
                                                                              'firstName'],
                                                                          style: TextStyle(
                                                                              fontSize: 13.sp,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Color.fromRGBO(47, 45, 101, 1),
                                                                              height: 1.5),
                                                                        ),
                                                                        Text(
                                                                            " "),
                                                                        Text(
                                                                          family.newDataList[i]
                                                                              [
                                                                              'lastName'],
                                                                          style: TextStyle(
                                                                              fontSize: 13.sp,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Color.fromRGBO(47, 45, 101, 1),
                                                                              height: 1.5),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    // Text(
                                                                    //   family.fetcFamilyTree[
                                                                    //           i][
                                                                    //       'givenName'],
                                                                    //   style: TextStyle(
                                                                    //       color: Colors
                                                                    //           .grey
                                                                    //           .shade700,
                                                                    //       fontSize:
                                                                    //           10),
                                                                    // )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )))
                                          : Visibility(
                                              visible: !family.fetcFamilyTree[i]
                                                  ["isRemove"],
                                              child:
                                                  (family.fetcFamilyTree[i]
                                                                  ['email'] ==
                                                              "" ||
                                                          family.fetcFamilyTree[
                                                                  i]['id'] ==
                                                              widget.userId)
                                                      ? Container()
                                                      : GestureDetector(
                                                          onTap: () async {
                                                            //  showLoadingAnimation(context);

                                                            context
                                                                    .read<
                                                                        ChatProvider>()
                                                                    .senderId =
                                                                context
                                                                    .read<
                                                                        AuthProviderr>()
                                                                    .user
                                                                    .id;
                                                            context
                                                                .read<
                                                                    ChatProvider>()
                                                                .receverId = context
                                                                    .read<
                                                                        ChatProvider>()
                                                                    .receverId =
                                                                family.fetcFamilyTree[
                                                                    i]['id'];

                                                            await context
                                                                .read<
                                                                    ChatProvider>()
                                                                .getChatRoomId();
                                                            print(
                                                                'condition if 3');
                                                            var memberData =
                                                                await context
                                                                    .read<
                                                                        ChatProvider>()
                                                                    .getChatPersonProfile();
                                                            print(
                                                                'memberdata $memberData');
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ChatMessageScreen(
                                                                        memberData),
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 12),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            boxShadow: [
                                                                          BoxShadow(
                                                                              color: Color.fromRGBO(221, 214, 249, 1),
                                                                              spreadRadius: -8,
                                                                              blurRadius: 5,
                                                                              offset: Offset(0, 12)),
                                                                        ]),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      child: family.fetcFamilyTree[i]['profilePicture'] !=
                                                                              ""
                                                                          ? Image(
                                                                              image: NetworkImage(family.fetcFamilyTree[i]['profilePicture'].toString()),
                                                                              //  image: AssetImage("assets/images/place_holder.png"),
                                                                              fit: BoxFit.cover,
                                                                              height: 45,
                                                                              width: 45,
                                                                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                                return Image(
                                                                                  image: AssetImage("assets/images/place_holder.png"),
                                                                                  fit: BoxFit.cover,
                                                                                  height: 45,
                                                                                  width: 45,
                                                                                );
                                                                              },
                                                                            )
                                                                          : Image(
                                                                              image: AssetImage("assets/images/place_holder.png"),
                                                                              fit: BoxFit.cover,
                                                                              height: 45,
                                                                              width: 45,
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
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          family.fetcFamilyTree[i]
                                                                              [
                                                                              'firstName'],
                                                                          style: TextStyle(
                                                                              fontSize: 13.sp,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Color.fromRGBO(47, 45, 101, 1),
                                                                              height: 1.5),
                                                                        ),
                                                                        Text(
                                                                            " "),
                                                                        Text(
                                                                          family.fetcFamilyTree[i]
                                                                              [
                                                                              'lastName'],
                                                                          style: TextStyle(
                                                                              fontSize: 13.sp,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Color.fromRGBO(47, 45, 101, 1),
                                                                              height: 1.5),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    // Text(
                                                                    //   family.fetcFamilyTree[
                                                                    //           i][
                                                                    //       'givenName'],
                                                                    //   style: TextStyle(
                                                                    //       color: Colors
                                                                    //           .grey
                                                                    //           .shade700,
                                                                    //       fontSize:
                                                                    //           10),
                                                                    // )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )));
                                    }
                                  }),
                          // }),
                          // if (isloading)
                          //   Positioned.fill(
                          //       child: Align(
                          //         alignment: Alignment.center,
                          //         child: CircularProgressIndicator(),
                          //       ))
                        ],
                      )
                    : Center(
                        child: Container(
                            margin: EdgeInsets.only(bottom: 80),
                            alignment: Alignment.center,
                            child: NoDataYet(
                                title: "No family tree yet",
                                image: "3 User1.png")),
                      );
              }),
            ),
          )
          // : Expanded(
          //     child: ListView.builder(
          //         // physics: NeverScrollableScrollPhysics(),
          //         shrinkWrap: true,
          //         // primary: true,
          //         // snapshot.data!.docs.length
          //         itemCount: userDataListFiltered.length,
          //         itemBuilder: (BuildContext ctx, index) {
          //           var searchData = userDataListFiltered[index];
          //           return InkWell(
          //             onTap: () async {
          //               showLoadingAnimation(context);
          //               await Provider.of<InviteProvider>(context,
          //                       listen: false)
          //                   .fetchSearchUserDetail(
          //                       myId: widget.userId,
          //                       viewuserId: searchData['id'])
          //                   .then((value) {
          //                 Navigator.pop(context);
          //                 Provider.of<InviteProvider>(context,
          //                         listen: false)
          //                     .setFamilyData(context
          //                         .read<InviteProvider>()
          //                         .searchUserData);
          //                 context
          //                             .read<InviteProvider>()
          //                             .searchUserData['inviteStatus'] ==
          //                         "approved"
          //                     ? navigationService.navigateTo(
          //                         FamilyMemberProfileScreenRoute)
          //                     : navigationService
          //                         .navigateTo(SearchStoryBookScreenRoute);
          //                 searchEditingController.clear();
          //                 userDataListFiltered.clear();
          //                 message = "Type any name or email to search.";
          //               });
          //             },
          //             child: searchData['id'] != widget.userId
          //                 ? Container(
          //                     margin: EdgeInsets.only(top: 12),
          //                     child: Row(
          //                       children: [
          //                         Container(
          //                             decoration: BoxDecoration(boxShadow: [
          //                               BoxShadow(
          //                                   color: Color.fromRGBO(
          //                                       221, 214, 249, 1),
          //                                   spreadRadius: -8,
          //                                   blurRadius: 5,
          //                                   offset: Offset(0, 12)),
          //                             ]),
          //                             child: ClipRRect(
          //                               borderRadius:
          //                                   BorderRadius.circular(10),
          //                               child: searchData[
          //                                           'profilePicture'] !=
          //                                       ""
          //                                   ? Image(
          //                                       image: NetworkImage(
          //                                           searchData[
          //                                                   'profilePicture']
          //                                               .toString()),
          //                                       //  image: AssetImage("assets/images/place_holder.png"),
          //                                       fit: BoxFit.cover,
          //                                       height: 45,
          //                                       width: 45,
          //                                       errorBuilder:
          //                                           (BuildContext context,
          //                                               Object exception,
          //                                               StackTrace?
          //                                                   stackTrace) {
          //                                         print(
          //                                             "Exception >> ${exception.toString()}");
          //                                         return Image(
          //                                           image: AssetImage(
          //                                               "assets/images/place_holder.png"),
          //                                           fit: BoxFit.cover,
          //                                           height: 45,
          //                                           width: 45,
          //                                         );
          //                                       },
          //                                     )
          //                                   : Image(
          //                                       image: AssetImage(
          //                                           "assets/images/place_holder.png"),
          //                                       fit: BoxFit.cover,
          //                                       height: 45,
          //                                       width: 45,
          //                                     ),
          //                             )),
          //                         SizedBox(
          //                           width: 15,
          //                         ),
          //                         Column(
          //                           crossAxisAlignment:
          //                               CrossAxisAlignment.start,
          //                           children: [
          //                             Text(
          //                               searchData['fullName'] != ""
          //                                   ? searchData['fullName']
          //                                       .toString()
          //                                   : "",
          //                               style: TextStyle(
          //                                   fontSize: 12,
          //                                   fontWeight: FontWeight.w700),
          //                             ),
          //                             SizedBox(
          //                               height: 4,
          //                             ),
          //                             Text(
          //                               searchData['givenName'],
          //                               style: TextStyle(
          //                                   color: Colors.grey.shade700,
          //                                   fontSize: 10),
          //                             )
          //                           ],
          //                         )
          //                       ],
          //                     ),
          //                   )
          //                 : Container(),
          //           );
          //         }),
          //   )
        ],
      ),
    );
  }

  onItemChanged(String value) {
    setState(() {
      if (searchEditingController.text.length != 0) {
        context.read<InviteProvider>().clearnewDataList();
        context.read<InviteProvider>().fetcFamilyTree.forEach((element) {
          if (element["firstName"]
                  .toString()
                  .toLowerCase()
                  .contains(value.toString().toLowerCase()) ||
              element["fullName"]
                  .toString()
                  .toLowerCase()
                  .contains(value.toString().toLowerCase()) ||
              element["email"]
                  .toString()
                  .toLowerCase()
                  .contains(value.toString().toLowerCase())) {
            context.read<InviteProvider>().newDataList.add(element);
          }
        });
      } else {
        context.read<InviteProvider>().clearnewDataList();
      }
    });
  }
}
