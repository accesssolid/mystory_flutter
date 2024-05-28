import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostCommentsWidget extends StatefulWidget {
  final data;
  PostCommentsWidget({this.data});
  @override
  _PostCommentsWidgetState createState() => _PostCommentsWidgetState();
}

class _PostCommentsWidgetState extends State<PostCommentsWidget> {
  @override
  Widget build(BuildContext context) {
    String str = widget.data["addedByName"];

    //get string length
    int len = str.length;

    print(len);
    ScreenUtil.init(
      context,
       // BoxConstraints(
       //     maxWidth: MediaQuery.of(context).size.width,
       //     maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        //orientation: Orientation.portrait
    );
    return RichText(
      text: TextSpan(
        text: widget.data["addedByName"],
        style: TextStyle(
          color: Colors.black,
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
          fontFamily: "Rubik",
        ),
        children: <TextSpan>[
          TextSpan(
              text: "    ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600)),
          TextSpan(
              text: widget.data["description"],
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Rubik-Regular",
                height: 1.5,
                fontSize: 13.sp,
              )),
        ],
      ),
    );

    // Row(children: [
    //   Text(
    //     "${widget.data["addedByName"]}",
    //     textAlign: TextAlign.left,
    //     style: TextStyle(
    //         color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.bold),
    //   ),
    //   Flexible(
    //     child: HashTagText(
    //       text: "   ${widget.data["description"]}",
    //       decoratedStyle: TextStyle(
    //           fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.red),
    //       basicStyle: TextStyle(
    //           color: Colors.black,
    //           fontSize: 13.sp,
    //           fontWeight: FontWeight.w600),
    //       onTap: (text) {
    //         print(text);
    //       },
    //     ),
    //   ),
    // ]);
  }
}
