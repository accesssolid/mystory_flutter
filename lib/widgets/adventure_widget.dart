import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class AdventureWidget extends StatefulWidget {
  final data;
  ValueChanged<dynamic>? action;
  String? tag;
  final active;
  AdventureWidget({this.action, this.data, this.tag, this.active});

  @override
  _AdventureWidgetState createState() => _AdventureWidgetState();
}

class _AdventureWidgetState extends State<AdventureWidget> {
  void handletap() {
    widget.action!(widget.tag!);
  }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return Container(
        child: GestureDetector(
          onTap: handletap,
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            widget.active
                                ? new Icon(
                                    Icons.check,
                                    color: Theme.of(context).primaryColor,
                                    size: 20.0,
                                  )
                                : new Icon(
                                    Icons.check,
                                    color: Colors.grey,
                                    size: 20.0,
                                  ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Container(
                              width: 100.w,
                              child: Text(
                                widget.data['title'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: widget.active
                                      ? Theme.of(context).primaryColor
                                      : Color.fromRGBO(88, 102, 115, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            widget.active
                                ? new Icon(
                                    Icons.check,
                                    color: Theme.of(context).primaryColor,
                                    size: 20.0,
                                  )
                                : new Icon(
                                    Icons.check,
                                    color: Colors.grey,
                                    size: 20.0,
                                  ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Container(
                              width: 100.w,
                              child: Text(
                                widget.data['title'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: widget.active
                                      ? Theme.of(context).primaryColor
                                      : Color.fromRGBO(88, 102, 115, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
