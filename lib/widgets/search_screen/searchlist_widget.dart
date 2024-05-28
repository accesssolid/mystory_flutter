import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchListWidget extends StatefulWidget {
  final data;
  Function(dynamic,String)? action;
  String? tag;
  var active;
  SearchListWidget({
    this.action,
    this.active,
    this.data,
    this.tag,
  });

  @override
  _SearchListWidgetState createState() => _SearchListWidgetState();
}

class _SearchListWidgetState extends State<SearchListWidget> {
  void handletap() {
    widget.action!(widget.tag,widget.data['title']);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.active=true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handletap,
      child: Column(
        children: [
          Container(
            width: widget.tag == '1' ? 45.w : null,
            margin: EdgeInsets.only(left: 10.w, top: 15.h),
            decoration: BoxDecoration(
              gradient: widget.active
                  ? LinearGradient(
                      colors: [
                        Color.fromRGBO(91, 121, 229, 1),
                        Color.fromRGBO(129, 109, 224, 1)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.99],
                    )
                  : LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.white,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.99],
                    ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                widget.active
                    ? BoxShadow(
                        color: Color.fromRGBO(221, 214, 249, 1),
                        spreadRadius: -4,
                        blurRadius: 5,
                        offset: Offset(5, 8))
                    : BoxShadow(color: Colors.transparent)
              ],
            ),
            child: Center(
                child: Padding(
              padding: EdgeInsets.only(
                  left: 9.0.w, right: 9.0.w, top: 6.0.h, bottom: 6.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.data['title'],
                    style: TextStyle(
                      color: widget.active ? Colors.white : Colors.black,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            )),
          ),
          SizedBox(
            height: 2.h,
          )
        ],
      ),
    );
  }
}
