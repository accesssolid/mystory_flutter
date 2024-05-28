import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class MyFamilyWidget extends StatefulWidget {
  final data;

  // final searchTitle;
  MyFamilyWidget({
    this.data,
    // this.searchTitle
  });

  @override
  _MyFamilyWidgetState createState() => _MyFamilyWidgetState();
}

class _MyFamilyWidgetState extends State<MyFamilyWidget> {
  var navigationService = locator<NavigationService>();

  // void handletap() {
  //   widget.action!(widget.tag!);
  //   navigationService.navigateTo(SisterScreenRoute);

  // }

  fetchDataFromPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // String apiDataString = pref.getString('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(241, 241, 241, 1),
              spreadRadius: 6,
              blurRadius: 9,
              offset: Offset(0, 7),
            ),
          ],
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(width: 1, color: Colors.transparent),
        ),
        margin: EdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 75.h,
                    width: 75.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(225, 227, 251, 1),
                            spreadRadius: -6,
                            blurRadius: 5,
                            offset: Offset(0, 13))
                      ],
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.data['profilePicture'].toString(),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.r),
                          color: Colors.red.shade50,
                        ),
                        padding: EdgeInsets.only(
                            left: 5, right: 5.0, bottom: 2.0, top: 2.0),
                        child: Text(
                          widget.data['relation']['relationName'].toString(),
                          style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.red,
                              height: 1.5),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.data['firstName'],
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(47, 45, 101, 1),
                                height: 1.5),
                          ),
                          Text(" "),
                          Text(
                            widget.data['lastName'],
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(47, 45, 101, 1),
                                height: 1.5),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "DOB:",
                            style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(88, 102, 115, 1),
                                height: 1.5),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            widget.data['dob'].toString(),
                            style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                height: 1.3),
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: RichText(
                          text: TextSpan(
                            text: 'BIRTH PLACE: ',
                            style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(88, 102, 115, 1),
                                height: 1.5),
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.data['address']['cityValue'] +
                                    ',' +
                                    widget.data['address']['stateValue'] +
                                    ',' +widget.data['address']['countryValue'].toString().trim(),
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    height: 1.3),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     Icon(
              //       Icons.more_vert,
              //       color: Colors.grey,
              //       size: 20.h,
              //     )
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
