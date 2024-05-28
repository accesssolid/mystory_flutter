import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../global.dart';

class IosButton extends StatefulWidget {
  const IosButton({Key? key}) : super(key: key);

  @override
  _IosButtonState createState() => _IosButtonState();
}

class _IosButtonState extends State<IosButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 65.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          // ignore: deprecated_member_use
          //  code change by chetu
          // change flatbutton to textbutton
          child: TextButton(
            onPressed: () {},
            child: Image.asset(
              "assets/images/Login-Facebook.png",
              width: 35.w,
              height: 35.h,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(
          width: 20.w,
        ),
        Container(
          width: 65.w,
          height: 65.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          // ignore: deprecated_member_use
          // code change by chetu
          // change flatbutton to textbutton
          child: TextButton(
            onPressed: () {},
            child: Image.asset(
              "assets/images/Login-Google.png",
              width: 35.w,
              height: 35.h,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(
          width: 20.w,
        ),
        Container(
          width: 65.w,
          height: 65.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          // ignore: deprecated_member_use
          // code change by chetu
          // change flatbutton to textbutton
          child: TextButton(
            onPressed: () async {
              // await context.read<AuthProvider>().signInWithApple(context);
            },
            child: Image.asset(
              "assets/images/apple-icon.png",
              width: 35.w,
              height: 35.h,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
