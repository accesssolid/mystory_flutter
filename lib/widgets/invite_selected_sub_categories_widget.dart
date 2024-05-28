import 'package:flutter/material.dart';
import 'package:mystory_flutter/providers/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class SelectedInviteSubCategoriesWidget extends StatefulWidget {
  final data;
  final route;
  SelectedInviteSubCategoriesWidget({this.data, this.route});

  @override
  _SelectedInviteSubCategoriesWidgetState createState() =>
      _SelectedInviteSubCategoriesWidgetState();
}

class _SelectedInviteSubCategoriesWidgetState
    extends State<SelectedInviteSubCategoriesWidget> {
  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return InkWell(
        onTap: widget.route == "Create Story"
            ? () {
                Provider.of<CategoryProvider>(context, listen: false)
                    .insertInCategorySubDataCreateStory(widget.data);
                Provider.of<CategoryProvider>(context, listen: false)
                    .removeCreateStorySubCatSelectData(widget.data);
              }
            : () {
                Provider.of<CategoryProvider>(context, listen: false)
                    .insertInCategorySubDataInviteMember(widget.data);
                Provider.of<CategoryProvider>(context, listen: false)
                    .removeInviteSubCatSelectData(widget.data);
              },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.remove_circle_outlined,
             // color: Theme.of(context).primaryColor,  //commented by chetu
              size: 15.0,
            ),
            SizedBox(
              width: 10.w,
            ),
            Container(
              width: 100.w,
              child: Text(
                widget.data["categoryName"],
                style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
               //     color: Theme.of(context).primaryColor
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
