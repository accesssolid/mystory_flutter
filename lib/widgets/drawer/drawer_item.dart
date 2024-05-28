import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/notification_provider.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/web_view_screen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DrawerItem extends StatefulWidget {
  final data;
  final active;
  final Function(bool)? callback;
  ValueChanged<dynamic>? action;
  final String? tag;

  DrawerItem({this.action, this.active, this.data, this.tag, this.callback});

  @override
  _DrawerItemState createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  bool? isactive = false;
  var navigationService = locator<NavigationService>();

  void handletap() async {
    widget.action!(widget.tag!);
    if (widget.tag == '2') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => WebViewScreen(
                  url:
                      "https://www.termsfeed.com/live/96c8c3dc-4565-4d9a-a1ad-9299eb9e72b0"))); // implemented by chetu
    } else if (widget.tag == '3') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => WebViewScreen(
                  url:
                      "https://www.mystoryforlife.com/faq"))); // implemented by chetu
    } else if (widget.tag == '4') {
      setState(() {
        widget.callback!(true);
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "status": "Offline",
      });

      context.read<NotificationProvider>().notificationSub!.cancel();
      await Provider.of<NotificationProvider>(context, listen: false)
          .setToNull();
      await Provider.of<NotificationProvider>(context, listen: false)
          .removeAllNotifications();
      await Provider.of<AuthProviderr>(context, listen: false)
          .logoutFirebaseUser(context);
      setState(() {
        widget.callback!(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 48),
          child: GestureDetector(
            onTap: handletap,
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
                padding: EdgeInsets.only(
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
