import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mystory_flutter/models/relation.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/cache_image.dart';
import 'package:mystory_flutter/widgets/csc_picker_widget.dart';
import 'package:provider/provider.dart';

class AddFamilyMemberManuallyScreen extends StatefulWidget {
  Map<String, dynamic> userData;

  AddFamilyMemberManuallyScreen({this.userData = const {}});

  @override
  _AddFamilyMemberManuallyScreenState createState() =>
      _AddFamilyMemberManuallyScreenState();
}

class _AddFamilyMemberManuallyScreenState
    extends State<AddFamilyMemberManuallyScreen> {
  var navigationService = locator<NavigationService>();
  var utilService = locator<UtilService>();
  bool isLoadingProgress = false;
  String? selectedRelation;
  String? selectedRelationId;
  String? countryValue;
  String? stateValue;
  String? cityValue;
  var locationData;
  var imageUrl = '';
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  // TextEditingController emailController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController homeTownController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController dateFromController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  DateTime selectedFromDate = DateTime.now();

  String getInitials(String name) => name.isNotEmpty
      ? name.trim().split(' ').map((l) => l[0]).take(1).join()
      : '';

  Future<Null> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).primaryColor,
                onSurface: Colors.black,
              ),
              buttonTheme: ButtonThemeData(
                colorScheme: ColorScheme.light(
                  primary: Theme.of(context).primaryColor,
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

  var user;

  @override
  void initState() {
    user = Provider.of<AuthProviderr>(context, listen: false).user;
    if (widget.userData.isNotEmpty) {
      firstNameController.text = widget.userData["firstName"] ?? "";
      lastNameController.text = widget.userData["lastName"] ?? "";
      middleNameController.text = widget.userData["middleName"] ?? "";
      dateOfBirthController.text = widget.userData["dob"] ?? "";
      descriptionController.text = widget.userData["description"] ?? "";
      countryValue = widget.userData["address"]["countryValue"] ?? "";
      stateValue = widget.userData["address"]["stateValue"] ?? "";
      cityController.text = widget.userData["address"]["cityValue"] ?? "";
      // homeTownController.text = widget.userData["address"]["homeTown"] ?? "";
      homeTownController.text = widget.userData["homeTown"] ?? "";
      RelationModel rm = RelationModel.fromJson(widget.userData["relation"]);
      selectedRelation = rm.relationName;
      selectedRelationId = rm.id;
      imageUrl = widget.userData["profilePicture"];
    }
    // emailController.text = user.email ?? "";
    // firstNameController.text = user.firstName;
    // lastNameController.text = user.lastName;
    // dateOfBirthController.text = user.dob;

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
            navigationService.navigateTo(MyProfileScreenRoute);
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: widget.userData.isNotEmpty
                ? AppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // navigationService.navigateTo(MyProfileScreenRoute);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.grey.shade600,
                        size: 25.h,
                      ),
                    ),
                    centerTitle: true,
                    title: Text(widget.userData.isNotEmpty?
                      "Edit Family Member":"Add Family Member",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  )
                : null, // commented by chetu.
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
                                color: Theme.of(context).primaryColor,
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
                                color: Theme.of(context).primaryColor,
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
                                color: Theme.of(context).primaryColor,
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
                            "Short Description",
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
                          keyboardType: TextInputType.multiline,
                          controller: descriptionController,
                          autocorrect: true,
                          textInputAction: TextInputAction.next,
                          maxLines: 5,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 15,
                            ),
                            hintText: 'Write short description',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.sp,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).indicatorColor,
                                  width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Consumer<InviteProvider>(
                          builder: (context, relation, child) => Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Given Relation",
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
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.grey.shade400,
                                        ),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: DropdownButton(
                                      dropdownColor: Colors.white,
                                      menuMaxHeight: 200,
                                      hint: Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          selectedRelation == "" ||
                                                  selectedRelation == null
                                              ? "Select Relation"
                                              : selectedRelation.toString(),
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                      ),
                                      isExpanded: true,
                                      style: TextStyle(
                                          fontSize: 14.sp, color: Colors.black),
                                      // value: getRelation,
                                      underline: SizedBox(),
                                      onChanged: (newValue) {
                                        RelationModel rm =
                                            newValue as RelationModel;

                                        setState(() {
                                          selectedRelation = rm.relationName;
                                          selectedRelationId = rm.id;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                      ),
                                      items: relation.relationData
                                          .map((valueItem) {
                                        return DropdownMenuItem(
                                          value: valueItem,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.35,
                                            child: Text(
                                              "   ${valueItem.relationName}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14.sp),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              )),
                      SizedBox(
                        height: 15.h,
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
                                color: Theme.of(context).primaryColor,
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
                                color: Theme.of(context).primaryColor,
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
                        "Howetown",
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
                            "Hometown",
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
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 500,
                        child: TextFormField(
                          controller: homeTownController,
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
                            hintText: 'Enter Hometown',
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
                                color: Theme.of(context).primaryColor,
                                width: 1.w,
                              ),
                            ),
                          ),
                        ),
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
                            height: MediaQuery.of(context).size.height * 0.053,
                            width: MediaQuery.of(context).size.width * 0.43,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.resolveWith(
                                      (states) => 0),
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.transparent)),
                              onPressed: () async {
                                var location = {
                                  // "cityValue": cityValue,
                                  "countryValue": countryValue,
                                  "cityValue": cityController.text,
                                  "stateValue": stateValue
                                };
                                if (
                                    // imageUrl.isEmpty ||
                                    firstNameController.text == "" ||
                                        // middleNameController.text == "" ||
                                        // givenNameController.text == "" ||
                                        lastNameController.text == "" ||
                                        descriptionController.text == "" ||
                                        // shortDescriptionController.text == "" ||
                                        // homeTownController.text == "" ||
                                        dateOfBirthController.text == "" ||
                                        countryValue == "" ||
                                        stateValue == "" ||
                                        // cityValue
                                        // cityController.text == "" ||
                                        location.length == 0 ||
                                        selectedRelation == "" ||
                                        selectedRelationId == "" ||
                                        homeTownController.text == ""
                                    // cityValue
                                    // cityController.text == "" ||
                                    ) {
                                  utilService.showToast(
                                      "Please fill all fields", context);
                                } else {
                                  setState(() {
                                    isLoadingProgress = true;
                                  });

                                  await Provider.of<AuthProviderr>(context,
                                          listen: false)
                                      .addFamilyMemberManually(
                                          context: context,
                                          profilePic: imageUrl == ""
                                           //   ? 'https://firebasestorage.googleapis.com/v0/b/mystory-app-9a032.appspot.com/o/images%2Fplace_holder.png?alt=media&token=6d2ba124-8b92-47fb-b3bd-e2842410285b'
                                              ? 'https://firebasestorage.googleapis.com/v0/b/mystory-app-9a032.appspot.com/o/images%2Fplace_holder.png?alt=media&token=119053cd-3bbe-4a57-b0ec-abd05ef9cdb9&_gl=1*lqwmyu*_ga*Mzk4MTUyMjgyLjE2OTI4OTI5NzQ.*_ga_CW55HF8NVT*MTY5ODc1NzUwMC4xNTAuMS4xNjk4NzU5NzMzLjQwLjAuMA..'
                                              : imageUrl,
                                          firstName: firstNameController.text,
                                          middleName: middleNameController.text,
                                          lastName: lastNameController.text,
                                          description:
                                              descriptionController.text,
                                          dateOfBirth:
                                              dateOfBirthController.text,
                                          relation: {
                                            "id": selectedRelationId!,
                                            "relationName": selectedRelation!
                                          },
                                          location: location,
                                          homeTown: homeTownController.text,
                                          data: widget.userData);
                                }
                                setState(() {
                                  isLoadingProgress = false;
                                });
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
                                MediaQuery.of(context).size.width / 2.5,
                                MediaQuery.of(context).size.height * 0.055,
                              ),
                              backgroundColor: Colors.white,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50),
                                side: BorderSide(
                                    color: Theme.of(context).indicatorColor),
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
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                onTap: () {
                  setState(() {
                    isLoadingProgress = true;
                    utilService
                        .captureImageManuallyAddedUser(user.id, context)
                        .then((String value) => setState(() {
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
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  onTap: () {
                    setState(() {
                      isLoadingProgress = true;
                      utilService
                          .browseImageManuallyAddedUser(user.id, context)
                          .then((String value) => setState(() {
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
