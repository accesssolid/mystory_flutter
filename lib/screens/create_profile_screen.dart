import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/cache_image.dart';
import 'package:mystory_flutter/widgets/csc_picker_widget.dart';
import 'package:mystory_flutter/widgets/exit_alert_dialog.dart';
import 'package:provider/provider.dart';

class CreateProfile extends StatefulWidget {
  final title;
  final editData;

  CreateProfile({this.title, this.editData});

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  var navigationService = locator<NavigationService>();
  var utilService = locator<UtilService>();
  bool isLoadingProgress = false;
  String? countryValue;
  String? stateValue;
  String? cityValue;

  var locationData;
  var imageUrl = '';
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController givenNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController shortDescriptionController = TextEditingController();
  TextEditingController homeTownController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController dateFromController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  DateTime selectedFromDate = DateTime.now();

  String getInitials(String name) =>
      name.isNotEmpty
          ? name.trim().split(' ').map((l) => l[0]).take(1).join()
          : '';

  Future<Null> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme
                    .of(context)
                    .primaryColor,
                onSurface: Colors.black,
              ),
              buttonTheme: ButtonThemeData(
                colorScheme: ColorScheme.light(
                  primary: Theme
                      .of(context)
                      .primaryColor,
                ),
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: selectedFromDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1920),
        lastDate: DateTime.now());
    if (picked != null)
      setState(() {
        selectedFromDate = picked;
        dateOfBirthController.text =
            DateFormat.yMMMMd().format(selectedFromDate);
      });
  }

  void SaveProfile()async{
    {
      String searchKey =
      getInitials(firstNameController.text);
      var location = {
        // "cityValue": cityValue,
        "countryValue": countryValue,
        "cityValue": cityController.text,
        "stateValue": stateValue
      };
        setState(() {
          isLoadingProgress = true;
        });
        if (widget.editData != null) {
          await Provider.of<AuthProviderr>(context,
              listen: false)
              .updateProfile(
            context: context,
            profilePic: imageUrl,
            firstName: firstNameController.text,
            middleName: middleNameController.text,
            givenName: givenNameController.text,
            lastName: lastNameController.text,
            emailAddress: emailController.text,
            shortDescription:
            shortDescriptionController.text,
            homeTown: homeTownController.text,
            dateOfBirth: dateOfBirthController.text,
            location: location,
            searchKey: searchKey,
          );
        } else {
          setState(() {
            isLoadingProgress = true;
          });
          await Provider.of<AuthProviderr>(context,
              listen: false)
              .createProfileInformation(
            context: context,
            profilePic: imageUrl == ""
                ? 'https://firebasestorage.googleapis.com/v0/b/mystory-app-9a032.appspot.com/o/images%2Fplace_holder.png?alt=media&token=6d2ba124-8b92-47fb-b3bd-e2842410285b'
                : imageUrl,
            firstName: firstNameController.text,
            middleName: middleNameController.text,
            givenName: givenNameController.text,
            lastName: lastNameController.text,
            emailAddress: emailController.text,
            shortDescription:
            shortDescriptionController.text,
            homeTown: homeTownController.text,
            dateOfBirth: dateOfBirthController.text,
            location: location,
            searchKey: searchKey,
          );
        }
        setState(() {
          isLoadingProgress = false;
        });
      }
  }

  ValidateAll(){
    if(firstNameController.text.isEmpty){
      utilService.showToast(
          "First name cannot be empty", context);
      return;
    }else if(lastNameController.text.isEmpty){
      utilService.showToast(
          "Last name cannot be empty", context);
      return;
    }else if(emailController.text.isEmpty){
      utilService.showToast(
          "email cannot be empty", context);
      return;
    }else if(dateOfBirthController.text.isEmpty){
      utilService.showToast(
          "Date of birth need to be selected", context);
      return;
    }else if(countryValue == null || countryValue == ''){
      utilService.showToast(
          "Country need to be select", context);
      return;
    }else if(stateValue == null || stateValue == ''){
      utilService.showToast(
          "State need to be select", context);
      return;
    }else{
      SaveProfile();
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => ExitAlertDialog(),
    ).then((value) => value as bool);
  }

  var user;

  @override
  void initState() {
    user = Provider
        .of<AuthProviderr>(context, listen: false)
        .user;

    emailController.text = user.email ?? "";
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
    dateOfBirthController.text = user.dob;

    if (widget.editData != null) {
      imageUrl = user.profilePicture;
      firstNameController.text = user.firstName;
      middleNameController.text = user.middleName;
      givenNameController.text = user.givenName;
      lastNameController.text = user.lastName;
      emailController.text = user.email;
      homeTownController.text = user.homeTown;
      shortDescriptionController.text = user.shortDescription;
      dateOfBirthController.text = user.dob;

      countryValue = user.address["countryValue"] ?? "";
      stateValue = user.address["stateValue"] ?? "";
      cityController.text = user.address["cityValue"] ?? "";
      // setState(() {
      //   countryValue = locationData["countryValue"].toString();
      // });
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      //BoxConstraints(
      //    maxWidth: MediaQuery.of(context).size.width,
      //    maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(360, 690),
      //orientation: Orientation.portrait
    );
    return Stack(
      children: [
        WillPopScope(
          onWillPop: () async {
            // FocusScope.of(context).unfocus();
            // navigationService.navigateTo(MyProfileScreenRoute);
            _onBackPressed();
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: widget.editData != null
                  ? IconButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                  navigationService.navigateTo(MyProfileScreenRoute);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.grey.shade600,
                  size: 25.h,
                ),
              )
                  : Text(""),
              centerTitle: true,
              title: Text(
                widget.title == null || widget.title == ""
                    ? "Create Profile "
                    : widget.title.toString(),
                // "Edit Profile",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // actions: [
              //   widget.title == null || widget.title == ""
              //       ? IconButton(
              //           icon: const Icon(Icons.logout),
              //           color: Colors.grey.shade600,
              //           onPressed: () async {
              //             setState(() {
              //               isLoadingProgress = true;
              //             });
              //             await Provider.of<AuthProviderr>(context,
              //                     listen: false)
              //                 .logoutFirebaseUser(context);
              //             setState(() {
              //               isLoadingProgress = false;
              //             });
              //           },
              //         )
              //       : Text("")
              // ]
            ),
            body: Container(
              padding: EdgeInsets.only(
                bottom: 10.h,
                left: 15.w,
                right: 15.w,
                top: 15.h,
              ),
              child: Form(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      imageUrl != ""
                          ? Stack(children: [
                        CacheImage(
                          placeHolder: "place_holder.png",
                          imageUrl: imageUrl,
                          width: 500.w,
                          height: 160.h,
                          radius: 6.0,
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: TextButton(
                                  onPressed: () {
                                    _uploadModalBottomSheet(context);
                                  },
                                  child: Container(
                                    height: 30.h,
                                    width: 120.w,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromRGBO(
                                                234, 189, 195, 1),
                                            spreadRadius: -3,
                                            blurRadius: 5,
                                            offset: Offset(1, 5))
                                      ],
                                      gradient: LinearGradient(
                                          colors: [
                                            Color.fromRGBO(
                                                255, 128, 75, 1),
                                            Color.fromRGBO(255, 90, 82, 1)
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.0, 0.99]),
                                      borderRadius:
                                      BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: (Text(
                                        "Add Picture   +",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                        ),
                                      )),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ])
                          : Container(
                        width: 500.w,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(5),
                          padding: EdgeInsets.all(30),
                          color: Colors.grey.shade500,
                          strokeWidth: 2,
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/Upload.png",
                                scale: 3,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Center(
                                child: Text(
                                  "Change Upload",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              TextButton(
                                  onPressed: () {
                                    _uploadModalBottomSheet(context);
                                  },
                                  child: Container(
                                    height: 30.h,
                                    width: 120.w,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromRGBO(
                                                234, 189, 195, 1),
                                            spreadRadius: -3,
                                            blurRadius: 5,
                                            offset: Offset(1, 5))
                                      ],
                                      gradient: LinearGradient(
                                          colors: [
                                            Color.fromRGBO(
                                                255, 128, 75, 1),
                                            Color.fromRGBO(255, 90, 82, 1)
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.0, 0.99]),
                                      borderRadius:
                                      BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: (Text(
                                        "Add Picture   +",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                        ),
                                      )),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "First Name",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        width: 500,
                        child: TextFormField(
                          controller: firstNameController,
                          autocorrect: true,
                          maxLength: 15,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 15,
                            ),
                            hintText: 'First Name',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.w,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                width: 1.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        "Middle Name",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        width: 500,
                        child: TextFormField(
                          controller: middleNameController,
                          autocorrect: true,
                          maxLength: 15,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 15,
                            ),
                            hintText: 'Middle Name',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.w,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                width: 1.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "Given Name",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          // Text(
                          //   "*",
                          //   style: TextStyle(
                          //     fontSize: 15.sp,
                          //     color: Colors.red,
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        width: 500,
                        child: TextFormField(
                          controller: givenNameController,
                          maxLength: 15,
                          autocorrect: true,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 15,
                            ),
                            hintText: 'Given Name',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.w,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                width: 1.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "Last Name",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        width: 500,
                        child: TextFormField(
                          controller: lastNameController,
                          autocorrect: true,
                          maxLength: 15,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 15,
                            ),
                            hintText: 'Last Name',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.w,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                width: 1.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "Email Address",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        width: 500,
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          readOnly: user.email == null || user.email == ""
                              ? false
                              : true,
                          autocorrect: true,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 15,
                            ),
                            hintText: 'Email Address',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.w,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                width: 1.w,
                              ),
                            ),
                            suffixIcon: Icon(
                              Icons.email_outlined,
                              size: 20.h,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        "Short Description",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "Write a short description about your relation",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        width: 500,
                        child: TextFormField(
                          controller: shortDescriptionController,
                          maxLines: 6,
                          maxLength: 1000,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          autocorrect: true,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 15,
                            ),
                            hintText: 'Write Story',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.w,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                width: 1.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "Hometown",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          // Text(
                          //   "*",
                          //   style: TextStyle(
                          //     fontSize: 15.sp,
                          //     color: Colors.red,
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        width: 500,
                        child: TextFormField(
                          controller: homeTownController,
                          autocorrect: true,
                          maxLength: 15,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                          // readOnly: user.homeTown == null || user.homeTown == ""
                          //     ? false
                          //     : true,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 15,
                            ),
                            hintText: 'Select Hometown',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.w,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                width: 1.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        "Date of Birth",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "Date",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        child: TextFormField(
                          readOnly: true,
                          onTap: () {
                            _selectFromDate(context);
                          },
                          style: TextStyle(
                              fontSize: (11),
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                          controller: dateOfBirthController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 20,
                            ),
                            hintText: 'Date of Birth',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.w,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                width: 1.w,
                              ),
                            ),
                            suffixIcon: Image.asset(
                              "assets/images/Calendar.png",
                              scale: 3,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        "Place Of Birth",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CSPickerWidget(
                        city: cityValue,
                        country: countryValue,
                        state: stateValue,
                        showStates: true,
                        showCities: false,
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        disabledDropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        selectedItemStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                        dropdownHeadingStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        dropdownItemStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                        dropdownDialogRadius: 10.0,
                        searchBarRadius: 10.0,
                        onCountryChanged: (value) {
                          setState(() {
                            var a = value;
                            countryValue = a.substring(a.indexOf(' ') + 1);
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            stateValue = value;
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            cityValue = value;
                          });
                        },
                      ),
                      Row(
                        children: [
                          Text(
                            "City",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        width: 500,
                        child: TextFormField(
                          controller: cityController,
                          autocorrect: true,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                          // maxLength: 40,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 15,
                            ),
                            hintText: 'Enter City',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.w,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                width: 1.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(91, 121, 229, 1),
                                    Color.fromRGBO(129, 109, 224, 1)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.0, 0.99]),
                            ),
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.053,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.43,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.resolveWith(
                                          (states) => 0),
                                  backgroundColor:
                                  MaterialStateColor.resolveWith(
                                          (states) => Colors.transparent)),
                              onPressed: (){
                                  ValidateAll();
                            },
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              textStyle: TextStyle(fontWeight: FontWeight.w600),
                              fixedSize: Size(
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width / 2.5,
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.055,
                              ),
                              backgroundColor: Colors.white,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50),
                                side: BorderSide(
                                    color: Theme
                                        .of(context)
                                        .indicatorColor),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              // firstNameController.text = "";
                              // middleNameController.text = "";
                              // givenNameController.text = "";
                              // lastNameController.text = "";
                              // emailController.text = "";
                              // shortDescriptionController.text = "";
                              // homeTownController.text = "";
                              // dateOfBirthController.text = "";
                              // countryValue = "";
                              // stateValue = "";
                              // cityValue = "";
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Platform.isIOS ? 15.h : 0,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isLoadingProgress)
          Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )),
      ],
    );
  }

  void _uploadModalBottomSheet(context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15.0),
          topLeft: Radius.circular(15.0),
        ),
      ),
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: 200.h,
          child: new Wrap(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Upload File",
                  //'Upload Profile Picture',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(),
              new ListTile(
                leading: Container(
                  height: 45.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                      begin: (Alignment.bottomCenter),
                      end: (Alignment.bottomLeft),
                      colors: [
                        Colors.purple,
                        Colors.purpleAccent,
                      ],
                    ),
                  ),
                  child: new Icon(
                    Icons.camera,
                    color: Colors.white,
                  ),
                ),
                title: new Text(
                  "Take Photo",
                  // 'Take Photo',
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle2,
                ),
                onTap: () {
                  setState(() {
                    isLoadingProgress = true;
                    utilService
                        .captureImage(user.id, context)
                        .then((String value) =>
                        setState(() {
                          isLoadingProgress = false;
                          imageUrl = value;
                        }));
                  });
                  isLoadingProgress = false;
                  Navigator.of(context).pop();
                },
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: new ListTile(
                  leading: Container(
                    margin: EdgeInsets.only(top: 3.h),
                    height: 45.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                            begin: (Alignment.bottomCenter),
                            end: (Alignment.bottomLeft),
                            colors: [
                              Colors.pink,
                              Colors.pinkAccent,
                            ])),
                    child: new Icon(
                      Icons.image,
                      color: Colors.white,
                    ),
                  ),
                  title: new Text(
                    "Browse",
                    // 'Browse',
                    style: Theme
                        .of(context)
                        .textTheme
                        .subtitle2,
                  ),
                  onTap: () {
                    setState(() {
                      isLoadingProgress = true;
                      utilService
                          .browseImage(user.id, context)
                          .then((String value) =>
                          setState(() {
                            isLoadingProgress = false;
                            imageUrl = value;
                          }));
                    });
                    isLoadingProgress = false;
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}