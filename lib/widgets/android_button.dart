// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:mystory_flutter/providers/auth_provider.dart';
// import 'package:provider/provider.dart';
//
// class AndroidButton extends StatefulWidget {
//   final Function(bool)? callback;
//   AndroidButton({this.callback});
//
//   @override
//   _AndroidButtonState createState() => _AndroidButtonState();
// }
//
// class _AndroidButtonState extends State<AndroidButton> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           width: 65.w,
//           height: 60.h,
//           decoration: BoxDecoration(
//             color: Colors.grey.shade200,
//             borderRadius: BorderRadius.all(
//               Radius.circular(10.0),
//             ),
//           ),
//           // ignore: deprecated_member_use
//           // code change by chetu
//           // change flatbutton to textbutton
//           child: TextButton(
//             onPressed: () async {
//               // uncomment code for the facebook button by chetu
//               setState(() {
//                 widget.callback!(true);
//               });
//
//               await Provider.of<AuthProvider>(context, listen: false)
//                   .signinWithfacebook(context);
//               setState(() {
//                 widget.callback!(false);
//               });
//             },
//             child: Image.asset(
//               "assets/images/Login-Facebook.png",
//               width: 35.w,
//               height: 35.h,
//               fit: BoxFit.contain,
//             ),
//           ),
//         ),
//         SizedBox(
//           width: 20.w,
//         ),
//         Container(
//           width: 65.w,
//           height: 60.h,
//           decoration: BoxDecoration(
//             color: Colors.grey.shade200,
//             borderRadius: BorderRadius.all(
//               Radius.circular(10.0),
//             ),
//           ),
//           // ignore: deprecated_member_use
//           // code change by chetu
//           // update flatbutton from textbutton
//           child: TextButton(
//             onPressed: () async {
//               // uncomment the code for google signin by chetu
//               setState(() {
//                 widget.callback!(true);
//               });
//               // await Provider.of<AuthProvider>(context, listen: false)
//               //     .setRememberMe(true);
//               await Provider.of<AuthProvider>(
//                       context, // isko un commint ker na hai
//                       listen: false)
//                   .googleAuthProvider(context);
//               setState(() {
//                 widget.callback!(false);
//               });
//             },
//             child: Image.asset(
//               "assets/images/Login-Google.png",
//               width: 35.w,
//               height: 35.h,
//               fit: BoxFit.contain,
//             ),
//           ),
//         ),
//         SizedBox(
//           width: 20.w,
//         ),
//       ],
//     );
//   }
// }
