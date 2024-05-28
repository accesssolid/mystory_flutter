import 'package:flutter/material.dart';
import 'package:mystory_flutter/providers/category_provider.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../global.dart';

// ignore: must_be_immutable
class InviteSubCategoriesWidget extends StatefulWidget {
  final data;
  final route;
  // ValueChanged<dynamic>? action;
  // String? tag;
  // final active;
  // final active1;
  InviteSubCategoriesWidget(
      {
      // this.action,
      this.data,
      this.route
      //  this.tag, this.active, this.active1
      });

  @override
  _InviteSubCategoriesWidgetState createState() =>
      _InviteSubCategoriesWidgetState();
}

class _InviteSubCategoriesWidgetState extends State<InviteSubCategoriesWidget> {
  UtilService? utilService = locator<UtilService>();
  // bool isActive = false;
  // void handletap(var data) {
  //   setState(() {
  //     isActive = !isActive;
  //   });
  //   if (isActive) {
  //     Provider.of<CategoryProvider>(context, listen: false)
  //         .setInviteSubCategories(data);

  //     // Provider.of<CategoryProvider>(context, listen: false)
  //     //     .removreCategorySubDataInviteMember(data);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return InkWell(
        onTap: widget.route == "Create Story"
            ? () {
                FocusScope.of(context).requestFocus(new FocusNode());
                if (Provider.of<CategoryProvider>(context, listen: false)
                        .createStorySubCatSelectData
                        .length >
                    9) {
                  utilService!
                      .showToast("You should select only 10 sub categories",context);
                } else {
                  Provider.of<CategoryProvider>(context, listen: false)
                      .setCreateStorySubCatSelectData(widget.data);
                  Provider.of<CategoryProvider>(context, listen: false)
                      .removeCategorySubDataCreateStory(widget.data);
                }
              }
            : () {
                Provider.of<CategoryProvider>(context, listen: false)
                    .setInviteSubCategories(widget.data);
                Provider.of<CategoryProvider>(context, listen: false)
                    .removreCategorySubDataInviteMember(widget.data);
              },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check,
             // color: Colors.grey,
              color: Theme.of(context).primaryColor,  //changed by chetu
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
                  color:Theme.of(context).primaryColor, // done by chetu
                 // color: Color.fromRGBO(88, 102, 115, 1),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
