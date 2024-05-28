import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mystory_flutter/models/category.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/category_provider.dart';
import 'package:mystory_flutter/providers/media_gallery_provider.dart';
import 'package:mystory_flutter/providers/post_provider.dart';

import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DrawerList extends StatefulWidget {
  final data;
  final active;
  final Function(bool)? callback;
  ValueChanged<dynamic>? action;
  final String? tag;

  DrawerList({this.action, this.active, this.data, this.tag, this.callback});

  @override
  _DrawerListState createState() => _DrawerListState();
}

class _DrawerListState extends State<DrawerList> {
  var navigationService = locator<NavigationService>();

  @override
  void initState() {
    super.initState();
  }

  void handletap() async {
    widget.action!(widget.tag!);
    if (widget.tag == '1') {
      // var storageService = locator<StorageService>();
      // await storageService.setData("route", "/maindeshboard-screen");

      navigationService.navigateTo(StoryBookscreenRoute);
    }
    if (widget.tag == '2') {
      navigationService.navigateTo(MyJournalScreenRoute);
    }
    if (widget.tag == '3') {
      // Provider.of<MediaGalleryProvider>(context, listen: false)
      //     .mediaGalleryRoute = "/maindeshboard-screen";
      //
      // var storageService = locator<StorageService>();
      // await storageService.setData("route", "/maindeshboard-screen");
      navigationService.navigateTo(MediaGalleryScreenRoute);
    }
    if (widget.tag == "4") {
      navigationService.navigateTo(MessagesScreenRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: handletap,
          child: Padding(
            padding: EdgeInsets.only(right: 48),
            child: Container(
              decoration: BoxDecoration(
                  gradient: widget.active
                      ? LinearGradient(
                          colors: [
                            Color.fromRGBO(91, 121, 229, 1),
                            Color.fromRGBO(129, 109, 224, 1)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.99])
                      : LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white,
                          ],
                        ),
                  borderRadius: BorderRadius.circular(50)),
              margin: EdgeInsets.only(left: 13, right: 0),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 14.0, right: 8.0, top: 11.0, bottom: 11.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image(
                          image: AssetImage(widget.data['img']),
                          height: 17,
                          color: widget.active ? Colors.white : Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.data['title'],
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: widget.active
                                  ? Colors.white
                                  : Colors.grey.shade600),
                        ),
                      ],
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chats')
                          //.orderBy('time', descending: true)
                          .where(
                              'members.${context.read<AuthProviderr>().user.id}.id',
                              isEqualTo: context.read<AuthProviderr>().user.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = [];
                          final chatMap = snapshot.data!.docs;
                          chatMap.forEach((element) {
                            data.add(element.data());
                          });
                          // print('ChatData: ${data.length}');
                          final count = [];
                          data.forEach((element) {
                            count.add(element['members']
                                    [context.read<AuthProviderr>().user.id]
                                ['unreadCount']);
                          });
                          int c=0;
                          for(int i=0;i<count.length;i++){
                            c=count[i]+c;
                          }
                          return c!=0?
                            widget.tag == '4'
                              ? Row(
                                  children: [
                                    Container(
                                      height: 18,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.blue,
                                      ),
                                      child: Center(
                                          child: Text(
                                        "New",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      )),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 18,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.red,
                                      ),
                                      child: Center(
                                          child: Text(
                                            c>9?'+9':c.toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      )),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    )
                                  ],
                                )
                              : Container():SizedBox();
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget _buildDrwerItem(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 48),
          child: GestureDetector(
            onTap: handletap,
            child: Container(
              decoration: BoxDecoration(
                  color: widget.active ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.circular(50)),
              margin: EdgeInsets.only(left: 13, right: 0),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 14.0, right: 8.0, top: 11.0, bottom: 11.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image(
                          image: AssetImage(widget.data['img']),
                          height: 17,
                          color: widget.active! ? Colors.white : Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.data['title'],
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: widget.active!
                                  ? Colors.white
                                  : Colors.grey.shade600),
                        ),
                      ],
                    ),
                    widget.tag == '1'
                        ? Row(
                            children: [
                              Container(
                                height: 18,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.blue,
                                ),
                                child: Center(
                                    child: Text(
                                  "New",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                )),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 18,
                                width: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.red,
                                ),
                                child: Center(
                                    child: Text(
                                  "6",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                )),
                              ),
                              SizedBox(
                                width: 15,
                              )
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
