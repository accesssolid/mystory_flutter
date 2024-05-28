// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class SharningPermissionWidget extends StatefulWidget {
  final data;
  int? index;
  ValueChanged<dynamic>? action;
  String? tag;

  final active;

  SharningPermissionWidget(
      {this.action, this.data, this.tag, this.active, this.index});

  @override
  _SharningPermissionWidgetState createState() =>
      _SharningPermissionWidgetState();
}

class _SharningPermissionWidgetState extends State<SharningPermissionWidget> {
  // bool yes = true;
  // bool no = false;
  late bool isButtonDisabled;
  var val;

  // void handletap() {
  //   widget.action!(widget.tag!);
  // }

  @override
  void initState() {
    // val = 0;
    // if (widget.data["id"] == "1") {
    //   // Provider.of<InviteProvider>(context, listen: false).show();
    //   // val = 1;
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text(
                widget.data['title'],
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.014,
                  fontWeight: FontWeight.w800,
                  color: Color.fromRGBO(168, 168, 168, 1),
                ),
              ),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.data['mtitle'],
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.014,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(168, 168, 168, 1),
                  ),
                ),
                Radio(
                  value: 0,
                  groupValue:
                      context.watch<InviteProvider>().defaultSharingSelection ==
                              0
                          ? 0
                          : val,
                  onChanged: (value) {
                    setState(() {
                      val = value;
                      // _value = false;
                      if (widget.data['id'] == "4") {
                        Provider.of<InviteProvider>(context, listen: false)
                            .setDefaultCategoriesSubCategoriesValue(value);
                      }

                      if (widget.data['id'] == "2") {
                        Provider.of<InviteProvider>(context, listen: false)
                            .setDefaultStoryBookPermissionsValue(value);
                      }
                      if (widget.data['id'] == "3") {
                        Provider.of<InviteProvider>(context, listen: false)
                            .setDefaultFamilyTreePermissionsValue(value);
                      }
                    });
                  },
                  activeColor:
                      context.watch<InviteProvider>().defaultSharingSelection ==
                              0
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                ),
                if (widget.index == 0 || widget.index == 1)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.063,
                  ),
                Text(
                  widget.data['subtitle'],
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.014,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(168, 168, 168, 1),
                  ),
                ),
                Radio(
                  value: 1,
                  groupValue:
                      context.watch<InviteProvider>().defaultSharingSelection ==
                              0
                          ? 0
                          : val,
                  onChanged: (value) {
                    setState(() {
                      val = value;
                      // _value = false;
                      if (widget.data['id'] == "4") {
                        Provider.of<InviteProvider>(context, listen: false)
                            .setDefaultCategoriesSubCategoriesValue(value);
                      }

                      if (widget.data['id'] == "2") {
                        Provider.of<InviteProvider>(context, listen: false)
                            .setDefaultStoryBookPermissionsValue(value);
                      }
                      if (widget.data['id'] == "3") {
                        Provider.of<InviteProvider>(context, listen: false)
                            .setDefaultFamilyTreePermissionsValue(value);
                      }
                    });
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
