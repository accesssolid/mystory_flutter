import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CategoriesWidget extends StatefulWidget {
  final data;
  ValueChanged<dynamic>? action;
  final active;
  String? tag;
  CategoriesWidget({Key? key, this.data, this.tag, this.action, this.active})
      : super(key: key);

  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  void handletap() {
    widget.action!(widget.tag!);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      //BoxConstraints(
      //    maxWidth: MediaQuery.of(context).size.width,
      //    maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(360, 690),
      //orientation: Orientation.portrait
    );
    return GestureDetector(
      onTap: handletap,
      child: widget.active!
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8.w,
                  height: 30.h,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Center(
                  child: Text(
                    widget.data["title"],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: Text(
                widget.data["title"],
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.sp,
                ),
              ),
            ),
    );
  }
}
