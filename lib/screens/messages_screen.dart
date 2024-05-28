import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/chatProvider.dart';
import 'package:mystory_flutter/providers/message_provider.dart';
import 'package:mystory_flutter/screens/add_new_chat_screen.dart';
import 'package:mystory_flutter/screens/search_screen_old.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/chat_widget.dart';
import 'package:mystory_flutter/widgets/no_data_yet.dart';
import 'package:provider/provider.dart';

import 'search_storybook_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  TextEditingController? searchController = TextEditingController();
  var navigationService = locator<NavigationService>();
  List<Map<String, dynamic>> temp = [];
  List newDataList = [];
  List dataSearch = [];
  bool snap = false;
  String tagId = ' ';
  int textCount = 0;
  bool tapped = false;

  void active(val) {
    setState(() {
      tagId = val;
    });
  }

  var user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<AuthProviderr>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigationService.navigateTo(MaindeshboardRoute);
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 60.h,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.grey,
                size: 30,
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
            title: Text(
              "Chat",
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            actions: <Widget>[
              // IconButton(onPressed: (){}, icon: Icon(Icons.search)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    context.read<AuthProviderr>().tempRoute = "/chat-screen";
                    var storageService = locator<StorageService>();
                    await storageService.setData("route", "/chat-screen");
                    navigationService.navigateTo(MyProfileScreenRoute);
                  },
                  child: user.profilePicture == "" ||
                      user.profilePicture == null
                      ? CircleAvatar(
                    backgroundImage:
                    AssetImage("assets/images/place_holder.png"),
                  )
                      : CircleAvatar(
                      backgroundColor: Theme.of(context).backgroundColor,
                      backgroundImage:
                      NetworkImage(user.profilePicture.toString())),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Container(

              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    height: 50.h,
                    child: TextField(
                      controller: searchController,
                      onTap: () {
                        List<Map<String, dynamic>> members = [];
                        // Map<String, dynamic> members = {};
                        print(textCount);
                        //    if (textCount == 0) {
                        print("inside");
                        temp.clear();
                        temp = context.read<MessageProvider>().chatData;

                        for (int i = 0; i < temp.length; i++) {
                          // members.add(temp[i]['members'])  ;
                          //  members[i].forEach((key, value) { })
                          temp[i]['members'].forEach((key, value) {
                            if (key != context.read<AuthProviderr>().user.id) {
                              // dataSearch = value['name'];
                              dataSearch.add(value);
                            } else {
                              var abc = value;
                            }
                          });
                        }

                        // newDataList = dataSearch;
                        // print(newDataList);
                        //     }
                      },
                      onChanged: (val) {
                        textCount = val.length;
                        if (val.length > 0) {
                          tapped = true;
                        } else {
                          tapped = false;
                        }
                        setState(() {
                          if (searchController!.text.length > 0) {
                            newDataList.clear();

                            dataSearch.forEach((element) {
                              if (element['name']
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                                newDataList.add(element);
                              }
                              // print(element["name"]);
                            });
                            snap = true;
                          } else {
                            snap = false;
                            newDataList.clear();
                          }
                        });

                      },
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
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                        ),
                        hintText: "Search here..",
                        fillColor: Color.fromRGBO(245, 246, 248, 0.6),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Expanded(
                    child: snap == true
                        ? newDataList.length == 0
                        ? NoDataYet(
                        title: "No Search Found",
                        image: "Group 947.png")
                        : Container(
                      // height: 100,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: newDataList.length,
                        // snapshot.data!.docs.length,
                        itemBuilder: (ctx, i) {
                          GlobalKey key1 = GlobalKey();
                          // Map<String, dynamic> chatMap =
                          //     snapshot.data!.docs[i].data()
                          //         as Map<String, dynamic>;

                          // context
                          //     .read<MessageProvider>()
                          //     .chatData
                          //     .add(chatMap);
                          print(newDataList.length);
                          return ChatWidget(
                            key: key1,
                            chatMessage: {},
                            searchTitle: newDataList[i],
                            ref: "Active",
                          );
                        },
                        separatorBuilder:
                            (BuildContext context, int index) {
                          return SizedBox(
                            height: 10.h,
                          );
                        },
                      ),
                    )
                        : StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chats')
                            .where(
                            'members.${context.read<AuthProviderr>().user.id}.id',
                            isEqualTo:
                            context.read<AuthProviderr>().user.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.separated(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length??0,
                              // snapshot.data!.docs.length,
                              itemBuilder: (ctx, i) {
                                GlobalKey key2 = GlobalKey();
                                Map<String, dynamic> chatMap =
                                snapshot.data!.docs[i].data()
                                as Map<String, dynamic>;
                                context
                                    .read<MessageProvider>()
                                    .chatData
                                    .clear();
                                context
                                    .read<MessageProvider>()
                                    .chatData
                                    .add(chatMap);

                                return chatMap['lastMessage'] == ''
                                    ? Container()
                                    : chatMap.isEmpty
                                    ? Container(
                                  height: MediaQuery.of(context)
                                      .size
                                      .height *
                                      0.5,
                                  // color: Colors.green,
                                  child: Center(
                                    child: NoDataYet(
                                      title: "No messages yet",
                                      image: "Group 1035.png",
                                    ),
                                  ),
                                )
                                    : ChatWidget(
                                  key: key2,
                                  chatMessage: chatMap,
                                  ref: "Not Active",
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 5.h,
                                );
                              },
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.6),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: FloatingActionButton(
              elevation: 4,
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) =>
                        AddNewChatScreen(userId: user.id));
              },
              isExtended: true,
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 32,
              ),
            ),
          )),
    );
  }

}
