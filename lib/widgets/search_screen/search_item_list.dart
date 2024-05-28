import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchItemListWidget extends StatefulWidget {
  final data;
  ValueChanged<dynamic>? action;
  String? tag;
  final active;
  SearchItemListWidget({
    this.action,
    this.active,
    this.data,
    this.tag,
  });

  @override
  _SearchItemListWidgetState createState() => _SearchItemListWidgetState();
}

class _SearchItemListWidgetState extends State<SearchItemListWidget> {
  void handletap() {
    widget.action!(widget.tag);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handletap,
      child: Container(
        margin: EdgeInsets.only(top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Row(children: [
              Container(
              decoration: BoxDecoration(boxShadow: [BoxShadow(color: Color.fromRGBO(221, 214, 249, 1),spreadRadius: -8,blurRadius: 5,offset: Offset(0, 12)),]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                              image: AssetImage(widget.data['img']),
                              fit: BoxFit.cover,
                              height: 45,
                              width: 45,
                            ),
                )),
            SizedBox(width: 15,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.data['title'],style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w700),),
                SizedBox(height: 4,),
                Text(widget.data['subtitle'],style: TextStyle(color: Colors.grey.shade800,fontSize: 10.sp),)
              ],
            ),
           ],),
           Icon(Icons.close,size: 18,)

          ],
        ),
      ),
    );
  }
}
