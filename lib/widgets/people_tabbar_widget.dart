import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/linkStories_familytree&storybook_provider.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:provider/provider.dart';

import '../global.dart';

class PeopleTabbarWidget extends StatefulWidget {
  final TextEditingController? searchController;
  String? name;
  PeopleTabbarWidget({this.name, this.searchController, Key? key})
      : super(key: key);

  @override
  _PeopleTabbarWidgetState createState() => _PeopleTabbarWidgetState();
}

class _PeopleTabbarWidgetState extends State<PeopleTabbarWidget> {
  var navigationService = locator<NavigationService>();
  // String name = "";
  var user;
  @override
  void initState() {
    user = Provider.of<AuthProviderr>(context, listen: false).user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: (widget.name != "")
                ? FirebaseFirestore.instance
                    .collection('users')
                    .where("searchKey",
                        isEqualTo: widget.name!.substring(0, 1).toUpperCase())
                    .snapshots()
                : FirebaseFirestore.instance.collection("users").snapshots(),
            builder: (context, snapshot) {
              return (snapshot.connectionState == ConnectionState.waiting)
                  ? Center(child: CircularProgressIndicator())
                  : snapshot.data!.docs.length == 0 &&
                          widget.searchController!.text != ""
                      ? Center(child: Text("No Data"))
                      : Expanded(
                          // height: 150,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext ctx, index) {
                                var searchData = snapshot.data!.docs[index];

                                return InkWell(
                                  onTap: () async {
                                    showLoadingAnimation(context);
                                    await Provider.of<InviteProvider>(context,
                                            listen: false)
                                        .fetchSearchUserDetail(
                                            myId: user.id,
                                            viewuserId: searchData['id'])
                                        .then((value) async {
                                      Provider.of<InviteProvider>(context,
                                              listen: false)
                                          .setFamilyData(context
                                              .read<InviteProvider>()
                                              .searchUserData);
                                      if (context
                                              .read<InviteProvider>()
                                              .searchUserData['inviteStatus'] ==
                                          "approved") {
                                        await Provider.of<InviteProvider>(
                                                context,
                                                listen: false)
                                            .fetchFamiltTreeMember(
                                                id: searchData['id'],
                                                count: 10,
                                                page: 1);
                                        await context
                                            .read<LinkFamilyStoryProvider>()
                                            .familyMemberStories(
                                                count: 10,
                                                page: 1,
                                                id: searchData['id']);
                                        await context
                                            .read<LinkFamilyStoryProvider>()
                                            .familyMemberLinkedStories(
                                                count: 10,
                                                page: 1,
                                                id: searchData['id']);
                                        Navigator.pop(context);
                                        var storageService =
                                            locator<StorageService>();
                                        await storageService.setData("route",
                                            "/maindeshboard-search-screen");
                                        navigationService.navigateTo(
                                            FamilyMemberProfileScreenRoute);
                                      } else {
                                        // Navigator.pop(context);
                                        navigationService.navigateTo(
                                            SearchStoryBookScreenRoute);
                                      }
                                      // context
                                      //                 .read<InviteProvider>()
                                      //                 .searchUserData[
                                      //             'inviteStatus'] ==
                                      //         "approved"
                                      //     ? navigationService.navigateTo(
                                      //         FamilyMemberProfileScreenRoute)
                                      //     //  Navigator.of(context).push(
                                      //     //     MaterialPageRoute(
                                      //     //       builder: (ctx) =>
                                      //     //           SisterScreen(
                                      //     //         route: "Search Screen",
                                      //     //         // familyMember: context
                                      //     //         //     .read<
                                      //     //         //         InviteProvider>()
                                      //     //         //     .searchUserData
                                      //     //       ),
                                      //     //     ),
                                      //     //   )
                                      //     : navigationService.navigateTo(
                                      //         SearchStoryBookScreenRoute);
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
                                  child: searchData['id'] != user.id &&
                                          searchData['address']
                                                  ['countryValue'] !=
                                              ""
                                      ? Container(
                                          margin: EdgeInsets.only(top: 12),
                                          child: Row(
                                            children: [
                                              Container(
                                                  decoration:
                                                      BoxDecoration(boxShadow: [
                                                    BoxShadow(
                                                        color: Color.fromRGBO(
                                                            221, 214, 249, 1),
                                                        spreadRadius: -8,
                                                        blurRadius: 5,
                                                        offset: Offset(0, 12)),
                                                  ]),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: searchData[
                                                                'profilePicture'] !=
                                                            ""
                                                        ? Image(
                                                            image: NetworkImage(
                                                                searchData[
                                                                        'profilePicture']
                                                                    .toString()),
                                                            fit: BoxFit.cover,
                                                            height: 45,
                                                            width: 45,
                                                          )
                                                        : Image(
                                                            image: AssetImage(
                                                                "assets/images/place_holder.png"),
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    searchData['fullName'] != ""
                                                        ? searchData['fullName']
                                                            .toString()
                                                        : "",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  // Text(
                                                  //   widget.data['subtitle'],
                                                  //   style: TextStyle(color: Colors.grey.shade700, fontSize: 10),
                                                  // )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(),
                                );
                              }),
                        );
            },
          ),
        ],
      ),
    );
  }
}
