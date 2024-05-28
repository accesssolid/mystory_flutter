import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddFamilyMemeberWidget extends StatefulWidget {
  final data;
  ValueChanged<dynamic>? action;
  String? tag;
  final active;
  AddFamilyMemeberWidget({
    this.action,
    this.active,
    this.data,
    this.tag,
  });

  @override
  _AddFamilyMemeberWidgetState createState() => _AddFamilyMemeberWidgetState();
}

class _AddFamilyMemeberWidgetState extends State<AddFamilyMemeberWidget> {
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
          children: [
            Container(
              decoration: BoxDecoration(boxShadow: [BoxShadow(color: Color.fromRGBO(221, 214, 249, 1),spreadRadius: -8,blurRadius: 5,offset: Offset(0, 12)),]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                              image: AssetImage(widget.data['img']),
                              fit: BoxFit.cover,
                              height: 50,
                              width: 50,
                            ),
                )),
            SizedBox(width: 15,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.data['title'],style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                SizedBox(height: 5,),
                Text(widget.data['subtitle'],style: TextStyle(color: Colors.grey.shade400,fontSize: 12),)
              ],
            )
          ],
        ),
      ),
    );
  }
}
