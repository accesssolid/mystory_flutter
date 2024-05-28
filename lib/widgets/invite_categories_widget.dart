import 'package:flutter/material.dart';
import 'package:mystory_flutter/providers/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../global.dart';

// ignore: must_be_immutable
class InviteCategoriesWidget extends StatefulWidget {
  final data;
  ValueChanged<dynamic>? action;
  String? tag;
  final active;
  final active1;
  InviteCategoriesWidget(
      {this.action, this.data, this.tag, this.active, this.active1});

  @override
  _InviteCategoriesWidgetState createState() => _InviteCategoriesWidgetState();
}

class _InviteCategoriesWidgetState extends State<InviteCategoriesWidget> {
  void handletap() {
    widget.action!(widget.tag!);
  }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return Container(
        child: InkWell(
          onTap: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
            handletap();
            showLoadingAnimation(context);

            await Provider.of<CategoryProvider>(context, listen: false)
                .fetchSubCategoriesCreateStory(
              id: widget.data.id,
            )
                .then((value) {
              Navigator.pop(context);
              Provider.of<CategoryProvider>(context, listen: false)
                  .setCreateStoryParentCategoriesId(widget.data);
              // Provider.of<CategoryProvider>(context, listen: false)
              //     .emptyInviteSubCategories();
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.active
                  ? new Icon(
                      Icons.check,
                      color: Theme.of(context).primaryColor,
                      size: 15.0,
                    )
                  : new Icon(
                      Icons.check,
                      color: Colors.grey,
                      size: 15.0,
                    ),
              SizedBox(
                width: 10.w,
              ),
              Container(
                width: 100.w,
                child: Text(
                  widget.data.categoryName,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: widget.active
                        ? Theme.of(context).primaryColor
                        : Color.fromRGBO(88, 102, 115, 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
