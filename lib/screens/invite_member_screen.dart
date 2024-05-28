import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mystory_flutter/models/category.dart';
import 'package:mystory_flutter/models/relation.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/category_provider.dart';
import 'package:mystory_flutter/providers/chatProvider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/notification_provider.dart';
import 'package:mystory_flutter/screens/maindeshboard_screen.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/widgets/column_scroll_view.dart';
import 'package:mystory_flutter/widgets/invite_categories_widget.dart';
import 'package:mystory_flutter/widgets/invite_selected_sub_categories_widget.dart';
import 'package:mystory_flutter/widgets/invite_sub_categories_widget.dart';
import 'package:mystory_flutter/widgets/sharing_permission_widget.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';
import '../global.dart';
import '../services/navigation_service.dart';
import '../utils/service_locator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';

class InviteMemberScreen extends StatefulWidget {
  bool fromAcceptInvitation;
  dynamic data;
  dynamic receiverEmail;

  InviteMemberScreen(
      {Key? key,
      this.fromAcceptInvitation = false,
      this.data,
      this.receiverEmail})
      : super(key: key);

  @override
  _InviteMemberScreenState createState() => _InviteMemberScreenState();
}

enum PermissionValue { yes, no }

class _InviteMemberScreenState extends State<InviteMemberScreen> {
  var navigationService = locator<NavigationService>();
  var utilService = locator<UtilService>();
  var selectedCategory;
  bool showRelation = false;
  TextEditingController commentController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  var val;
  var getUserDetail;

  // List<CategoryModel> categoryData = [];
  List<RelationModel> getRelation = [];
  List categoriesList = [];
  List tempcategoriesList = [];
  var selectedRelation;
  var selectedRelationId;
  bool isloading = false;

  PermissionValue defaultPermission = PermissionValue.yes;
  PermissionValue storyBookPermission = PermissionValue.yes;
  PermissionValue familyTreePermission = PermissionValue.yes;

  List subCategoryIds = [];

  fetchRelations() async {
    getRelation =
        Provider.of<InviteProvider>(context, listen: false).getRelation;

    if (getRelation.length == 0) {
      setState(() {
        isloading = true;
      });

      await Provider.of<InviteProvider>(context, listen: false)
          .fetchAllRelation();
      getRelation =
          Provider.of<InviteProvider>(context, listen: false).getRelation;

      setState(() {
        isloading = false;
      });
    } else
      setState(() {
        isloading = false;
      });
  }

  var tempList = [];
  var user;

  // bool byDefault = false;
  @override
  void initState() {
    categoriesList = Provider.of<CategoryProvider>(context, listen: false)
        .inviteSubCatSelectData;
    // categoryData =
    //     Provider.of<CategoryProvider>(context, listen: false).categoryData;
    // for (int i = 0; i < categoryData.length; i++) {
    //   tempList.add(categoryData[i].id);
    // }
    //   Provider.of<CategoryProvider>(context, listen: false).populateInitially(tempList);
    fetchRelations();

    getUserDetail =
        Provider.of<AuthProviderr>(context, listen: false).getUserDetailData;
    emailController.text = getUserDetail == null ? '' : getUserDetail['email'];
    user = Provider.of<AuthProviderr>(context, listen: false).user;

    if (widget.fromAcceptInvitation) {
      print("widget.data");
      emailController.text = widget.receiverEmail;
    }
    getAllSubCategories();
    super.initState();
  }

  TextEditingController relationController = TextEditingController();

  // bool defaultSharingSelection = false;
  // bool storyBookPermissions = false;
  // bool familyTreePermissions = false;
  // bool categoriesSubCategories = true;

  List<Map<String, dynamic>> permision = [
    // {
    //   "id": "1",
    //   "title": "Default Sharing Selection",
    //   "mtitle": "Yes",
    //   "subtitle": "No",
    // },
    {
      "id": "2",
      "title": "StoryBook Permissions",
      "mtitle": "Yes",
      "subtitle": "No"
    },
    {
      "id": "3",
      "title": "Family Tree Permissions",
      "mtitle": "Yes",
      "subtitle": "No"
    },
    {
      "id": "4",
      "title": "Categories & SubCategories",
      "mtitle": "All",
      "subtitle": "Custom"
    },
  ];

  String tagId2 = ' ';

  void active2(val) {
    setState(() {
      tagId2 = val;
    });
  }

  String tagId1 = ' ';

  void active1(val) {
    setState(() {
      tagId1 = val;
    });
  }

  String tagId = ' ';

  void active(val) {
    setState(() {
      tagId = val;
    });
  }

  // ignore: unused_field

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return AbsorbPointer(
        absorbing: isloading,
        child: Stack(children: [
          Consumer<InviteProvider>(builder: (context, invite, child) {
            return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  centerTitle: true,
                  toolbarHeight: 60.h,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      relationController.text = '';
                      // invite.defaultSharingSelection = 0;
                      //
                      // invite.storyBookPermissions = 0;
                      //
                      // invite.storyBookPermissions = 0;
                      //
                      // invite.categoriesSubCategories = 0;
                      Provider.of<CategoryProvider>(context, listen: false)
                          .nullInviteSubCatSelectList();

                      tempcategoriesList = [];
                      // navigationService.navigateTo(SearchStoryBookScreenRoute);
                      navigationService.closeScreen();
                    },
                  ),
                  title: Text(
                    widget.fromAcceptInvitation
                        ? "Accept Family Member"
                        : "Invite Member",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                body:
                    Consumer<CategoryProvider>(builder: (context, cat, child) {
                  List<CategoryModel> catListData = cat.categoryData
                      .skipWhile((value) => value.categoryName == "All")
                      .toList(); //implemented by chetu for remove all from drop down button
                  return SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(left: 14, right: 14),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: !widget.fromAcceptInvitation,
                                child: Text(
                                  " Invite Comment",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),

                              Visibility(
                                visible: !widget.fromAcceptInvitation,
                                child: SizedBox(
                                  height: 8.h,
                                ),
                              ),
                              Visibility(
                                visible: !widget.fromAcceptInvitation,
                                child: Text(
                                  " Write a short descriptive about your relation",
                                  style: TextStyle(
                                    color: Color.fromRGBO(166, 166, 166, 1),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: !widget.fromAcceptInvitation,
                                child: SizedBox(
                                  height: 5.h,
                                ),
                              ),
                              Visibility(
                                visible: !widget.fromAcceptInvitation,
                                child: Container(
                                  width: 500.w,
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: commentController,
                                    autocorrect: true,
                                    textInputAction: TextInputAction.next,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 15.0,
                                        horizontal: 20,
                                      ),
                                      hintText: 'Write Comment',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14.sp,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .indicatorColor,
                                            width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Row(
                                children: [
                                  Text(
                                    " Given Relation",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
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

                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     children: [
                              //       DropdownButton(
                              //         dropdownColor: Colors.white,
                              //         menuMaxHeight: 200,
                              //         hint: Padding(
                              //           padding: EdgeInsets.only(left: sx(10)),
                              //           child: Text(
                              //             selectedRelation == "" ||
                              //                     selectedRelation == null
                              //                 ? "Select Relation"
                              //                 : selectedRelation.toString(),
                              //             style: TextStyle(
                              //                 fontSize: sy(9),
                              //                 fontWeight: FontWeight.w600,
                              //                 color: Colors.grey.shade400),
                              //           ),
                              //         ),
                              //         // isExpanded: true,
                              //         style: TextStyle(
                              //             fontSize: sy(12),
                              //             color: Colors.white),
                              //         // value: getRelation,
                              //         underline: SizedBox(),
                              //         onChanged: (newValue) {
                              //           RelationModel rm =
                              //               newValue as RelationModel;

                              //           setState(() {
                              //             selectedRelation = rm.relationName;
                              //             selectedRelationId = rm.id;
                              //           });
                              //         },
                              //         icon: Padding(
                              //           padding:
                              //               const EdgeInsets.only(left: 10.0),
                              //           child: Icon(
                              //             Icons.keyboard_arrow_down,
                              //             color: Colors.blue,
                              //           ),
                              //         ),
                              //         items: getRelation.map((valueItem) {
                              //           return DropdownMenuItem(
                              //             value: valueItem,
                              //             child: SizedBox(
                              //               width: MediaQuery.of(context)
                              //                       .size
                              //                       .width /
                              //                   1.35,
                              //               child: Text(
                              //                 "   ${valueItem.relationName}",
                              //                 style: TextStyle(
                              //                     color: Colors.black,
                              //                     fontSize: sy(11)),
                              //               ),
                              //             ),
                              //           );
                              //         }).toList(),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Column(
                                children: [
                                  Container(
                                    width: 500.w,
                                    // height: 60.h,
                                    // color: Colors.red,
                                    child: TextFormField(
                                      // keyboardType: TextInputType.emailAddress,
                                      controller: relationController,
                                      autocorrect: true,
                                      readOnly: true,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                      ),
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              showRelation = !showRelation;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 20.h,
                                            color: Theme.of(context)
                                                .backgroundColor,
                                          ),
                                        ),
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 15.0,
                                          horizontal: 12,
                                        ),
                                        hintText: 'Select Relation',
                                        hintStyle: TextStyle(
                                            fontSize: sy(9),
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey.shade400),
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .indicatorColor,
                                              width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                  showRelation
                                      ? Container(
                                          padding: EdgeInsets.fromLTRB(
                                              15.w, 0, 0, 10),
                                          height: 200,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: ListView.builder(
                                            itemCount: getRelation.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    relationController.text =
                                                        "${getRelation[index].relationName}";
                                                    selectedRelation =
                                                        getRelation[index]
                                                            .relationName;
                                                    selectedRelationId =
                                                        getRelation[index].id;
                                                  });
                                                  showRelation = false;
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 25.h,
                                                    ),
                                                    Text(
                                                      "   ${getRelation[index].relationName}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: sy(11)),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),

                              SizedBox(
                                height: 20.h,
                              ),
                              Row(
                                children: [
                                  Text(
                                    " Email",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
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
                                height: 10.h,
                              ),
                              Text(
                                " Email Address",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Container(
                                // width: 500.w,
                                height: 60.h,
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                  autocorrect: true,
                                  readOnly:
                                      emailController.text == "" ? false : true,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.sp,
                                  ),
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.mail_outline_rounded,
                                      size: 20.h,
                                      color: Colors.grey,
                                    ),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15.0,
                                      horizontal: 20,
                                    ),
                                    hintText: 'Email Auto Populated',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.sp,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).indicatorColor,
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
                              Row(
                                children: [
                                  Text(
                                    "Sharing Permissions",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
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
                                height: 10.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 9,
                                    child: Text(
                                      "Default Selection Sharing",
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.014,
                                        fontWeight: FontWeight.w800,
                                        color: Color.fromRGBO(168, 168, 168, 1),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: RadioListTile<PermissionValue>(
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      title: Transform(
                                          transform: Matrix4.translationValues(
                                              -12, 0, 0),
                                          child: Text(
                                            'Yes',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.014,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(
                                                  168, 168, 168, 1),
                                            ),
                                          )),
                                      value: PermissionValue.yes,
                                      groupValue: defaultPermission,
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      onChanged: (PermissionValue? value) {
                                        setState(() {
                                          defaultPermission = value!;
                                          storyBookPermission = value;
                                          familyTreePermission = value;
                                          // categorySubCategoryPermission = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: RadioListTile<PermissionValue>(
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      title: Transform(
                                          transform: Matrix4.translationValues(
                                              -15, 0, 0),
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.014,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(
                                                  168, 168, 168, 1),
                                            ),
                                          )),
                                      value: PermissionValue.no,
                                      groupValue: defaultPermission,
                                      activeColor: defaultPermission ==
                                              PermissionValue.no
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey,
                                      onChanged: (PermissionValue? value) {
                                        setState(() {
                                          defaultPermission = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              AbsorbPointer(
                                  absorbing:
                                      defaultPermission == PermissionValue.yes
                                          ? true
                                          : false,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 9,
                                        child: Text(
                                          "Family Tree Permissions",
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.014,
                                            fontWeight: FontWeight.w800,
                                            color: Color.fromRGBO(
                                                168, 168, 168, 1),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: RadioListTile<PermissionValue>(
                                          contentPadding: EdgeInsets.zero,
                                          dense: true,
                                          title: Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                      -12, 0, 0),
                                              child: Text(
                                                'Yes',
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.014,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromRGBO(
                                                      168, 168, 168, 1),
                                                ),
                                              )),
                                          value: PermissionValue.yes,
                                          groupValue: familyTreePermission,
                                          activeColor: defaultPermission ==
                                                  PermissionValue.no
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey,
                                          onChanged: (PermissionValue? value) {
                                            setState(() {
                                              familyTreePermission = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: RadioListTile<PermissionValue>(
                                          contentPadding: EdgeInsets.zero,
                                          dense: true,
                                          title: Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                      -15, 0, 0),
                                              child: Text(
                                                'No',
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.014,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromRGBO(
                                                      168, 168, 168, 1),
                                                ),
                                              )),
                                          value: PermissionValue.no,
                                          groupValue: familyTreePermission,
                                          activeColor: defaultPermission ==
                                                  PermissionValue.no
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey,
                                          onChanged: (PermissionValue? value) {
                                            setState(() {
                                              familyTreePermission = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  )),

                              AbsorbPointer(
                                  absorbing:
                                      defaultPermission == PermissionValue.yes
                                          ? true
                                          : false,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 9,
                                        child: Text(
                                          "StoryBook Permissions",
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.014,
                                            fontWeight: FontWeight.w800,
                                            color: Color.fromRGBO(
                                                168, 168, 168, 1),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: RadioListTile<PermissionValue>(
                                          contentPadding: EdgeInsets.zero,
                                          dense: true,
                                          title: Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                      -16, 0, 0),
                                              child: Text(
                                                'All',
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.014,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromRGBO(
                                                      168, 168, 168, 1),
                                                ),
                                              )),
                                          value: PermissionValue.yes,
                                          groupValue: storyBookPermission,
                                          activeColor: defaultPermission ==
                                                  PermissionValue.no
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey,
                                          onChanged: (PermissionValue? value) {
                                            setState(() {
                                              storyBookPermission = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: RadioListTile<PermissionValue>(
                                          contentPadding: EdgeInsets.zero,
                                          dense: true,
                                          title: Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                      -20, 0, 0),
                                              child: Text(
                                                'Custom',
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.014,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromRGBO(
                                                      168, 168, 168, 1),
                                                ),
                                              )),
                                          value: PermissionValue.no,
                                          groupValue: storyBookPermission,
                                          activeColor: defaultPermission ==
                                                  PermissionValue.no
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey,
                                          onChanged: (PermissionValue? value) {
                                            setState(() {
                                              storyBookPermission = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  )),

                              // Container(
                              //   margin: EdgeInsets.only(top: 5, bottom: 5),
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Container(
                              //         child: Text(
                              //           "Default Selection Sharing",
                              //           style: TextStyle(
                              //             fontSize: MediaQuery.of(context)
                              //                     .size
                              //                     .height *
                              //                 0.014,
                              //             fontWeight: FontWeight.w800,
                              //             color:
                              //                 Color.fromRGBO(168, 168, 168, 1),
                              //           ),
                              //         ),
                              //       ),
                              //       Row(
                              //         // mainAxisAlignment: MainAxisAlignment.end,
                              //         // crossAxisAlignment: CrossAxisAlignment.end,
                              //         children: [
                              //           Text(
                              //             "Yes",
                              //             style: TextStyle(
                              //               fontSize: MediaQuery.of(context)
                              //                       .size
                              //                       .height *
                              //                   0.014,
                              //               fontWeight: FontWeight.w600,
                              //               color: Color.fromRGBO(
                              //                   168, 168, 168, 1),
                              //             ),
                              //           ),
                              //           Radio(
                              //             value: 0,
                              //             groupValue: context
                              //                         .watch<InviteProvider>()
                              //                         .defaultSharingSelection ==
                              //                     0
                              //                 ? 0
                              //                 : val,
                              //             onChanged: (value) {
                              //               setState(() {
                              //                 val = value;
                              //                 context
                              //                     .read<InviteProvider>()
                              //                     .setDefaultSharingSelectionValue(
                              //                         value);
                              //               });
                              //             },
                              //             activeColor:
                              //                 Theme.of(context).primaryColor,
                              //           ),
                              //           SizedBox(
                              //             width: MediaQuery.of(context)
                              //                     .size
                              //                     .width *
                              //                 0.063,
                              //           ),
                              //           Text(
                              //             "No",
                              //             style: TextStyle(
                              //               fontSize: MediaQuery.of(context)
                              //                       .size
                              //                       .height *
                              //                   0.014,
                              //               fontWeight: FontWeight.w600,
                              //               color: Color.fromRGBO(
                              //                   168, 168, 168, 1),
                              //             ),
                              //           ),
                              //           Radio(
                              //             value: 1,
                              //             groupValue: context
                              //                         .watch<InviteProvider>()
                              //                         .defaultSharingSelection ==
                              //                     0
                              //                 ? 0
                              //                 : val,
                              //             onChanged: (value) {
                              //               setState(() {
                              //                 val = value;
                              //                 context
                              //                     .read<InviteProvider>()
                              //                     .setDefaultSharingSelectionValue(
                              //                         value);
                              //               });
                              //             },
                              //             activeColor:
                              //                 Theme.of(context).primaryColor,
                              //           ),
                              //         ],
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // AbsorbPointer(
                              //   absorbing: context
                              //               .watch<InviteProvider>()
                              //               .defaultSharingSelection ==
                              //           0
                              //       ? true
                              //       : false,
                              //   child: ListView.builder(
                              //       physics: NeverScrollableScrollPhysics(),
                              //       shrinkWrap: true,
                              //       itemCount: permision.length,
                              //       itemBuilder: (ctx, i) {
                              //         return SharningPermissionWidget(
                              //           data: permision[i],
                              //           index: i,
                              //           // tag: permision[i]['id'],
                              //           // action: active,
                              //           // active: tagId == permision[i]['id']
                              //           //     ? true
                              //           //     : false,
                              //         );
                              //       }),
                              // ),
                              SizedBox(
                                height: 20.h,
                              ),
                              storyBookPermission == PermissionValue.no
                                  ? Column(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Select Categories to remove access",
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            )),
                                        SizedBox(
                                          height: 10.h,
                                        ),

                                        Container(
                                          // padding:
                                          //     EdgeInsets.only(left: sx(4)),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                          child: DropdownButton(
                                            isExpanded: true,
                                            dropdownColor: Colors.white,
                                            menuMaxHeight: 200,

                                            hint: Padding(
                                              padding:
                                                  EdgeInsets.only(left: sx(10)),
                                              child: Text(
                                                selectedCategory == "" ||
                                                        selectedCategory == null
                                                    ? "Select Category"
                                                    : selectedCategory
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: sy(9),
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        Colors.grey.shade400),
                                              ),
                                            ),

                                            // isExpanded: true,
                                            style: TextStyle(
                                                fontSize: sy(12),
                                                color: Colors.white),
                                            // value: selectCategory,
                                            underline: SizedBox(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedCategory = newValue;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.blue,
                                            ),
                                            items: catListData.map((valueItem) {
                                              return DropdownMenuItem(
                                                onTap: () async {
                                                  setState(() {
                                                    isloading = true;
                                                  });
                                                  await Provider.of<
                                                              CategoryProvider>(
                                                          context,
                                                          listen: false)
                                                      .fetchSubCategoriesInviteMember(
                                                          id: valueItem.id);
                                                  setState(() {
                                                    isloading = false;
                                                  });
                                                },
                                                value: valueItem.categoryName ??
                                                    "",
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.22,
                                                  child: Text(
                                                    "   ${valueItem.categoryName}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: sy(11)),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        ///////////////
                                        // GridView.builder(
                                        //     physics:
                                        //         NeverScrollableScrollPhysics(),
                                        //     shrinkWrap: true,
                                        //     gridDelegate:
                                        //         SliverGridDelegateWithFixedCrossAxisCount(
                                        //       childAspectRatio: 4 / 0.6,
                                        //       crossAxisCount: 2,
                                        //       crossAxisSpacing: 1.0,
                                        //       mainAxisSpacing: 1.0,
                                        //     ),
                                        //     itemCount: context
                                        //         .read<CategoryProvider>()
                                        //         .categoryData
                                        //         .length,
                                        //     itemBuilder: (context, index) {
                                        //       return InviteCategoriesWidget(
                                        //         data: context
                                        //             .read<
                                        //                 CategoryProvider>()
                                        //             .categoryData[index],
                                        //         tag: context
                                        //             .read<
                                        //                 CategoryProvider>()
                                        //             .categoryData[index]
                                        //             .id,
                                        //         action: active1,
                                        //         active: tagId1 ==
                                        //                 context
                                        //                     .read<
                                        //                         CategoryProvider>()
                                        //                     .categoryData[
                                        //                         index]
                                        //                     .id
                                        //             ? true
                                        //             : false,
                                        //       );
                                        //     })
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                      ],
                                    )
                                  : Container(),
                              storyBookPermission == PermissionValue.no
                                  ? cat.categorySubDataInviteMember.isEmpty
                                      ? Container()
                                      : Column(
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  child: Text(
                                                    "Subcategories",
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            GridView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  childAspectRatio: 4 / 0.6,
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 1.0,
                                                  mainAxisSpacing: 1.0,
                                                ),
                                                itemCount: cat
                                                    .categorySubDataInviteMember
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  return InviteSubCategoriesWidget(
                                                    data:
                                                        cat.categorySubDataInviteMember[
                                                            index],
                                                  );
                                                }),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                          ],
                                        )
                                  : Container(),
                              storyBookPermission == PermissionValue.no
                                  ? cat.inviteSubCatSelectData.isEmpty
                                      ? Container()
                                      : Column(
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  child: Text(
                                                    "Access will be removed from",
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.h),
                                            GridView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  childAspectRatio: 4 / 0.6,
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 1.0,
                                                  mainAxisSpacing: 1.0,
                                                ),
                                                itemCount: cat
                                                    .inviteSubCatSelectData
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  return SelectedInviteSubCategoriesWidget(
                                                    data:
                                                        cat.inviteSubCatSelectData[
                                                            index],
                                                  );
                                                }),
                                          ],
                                        )
                                  : Container(),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    height: 45.h,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade400,
                                            spreadRadius: -3,
                                            blurRadius: 5,
                                            offset: Offset(1, 5))
                                      ],
                                      borderRadius: BorderRadius.circular(50.0),
                                      gradient: LinearGradient(
                                          colors: [
                                            Color.fromRGBO(91, 121, 229, 1),
                                            Color.fromRGBO(129, 109, 224, 1)
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.0, 0.99]),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (widget.fromAcceptInvitation) {
                                          var permission = {
                                            "default": defaultPermission ==
                                                    PermissionValue.yes
                                                ? true
                                                : false,
                                            // "storyBook": storyBookPermission ==
                                            //         PermissionValue.yes
                                            //     ? true
                                            //     : false,
                                            "familyTree":
                                                familyTreePermission ==
                                                        PermissionValue.yes
                                                    ? true
                                                    : false,
                                            "storyBook": true,
                                            "categorySubcategory":
                                                storyBookPermission ==
                                                        PermissionValue.yes
                                                    ? true
                                                    : false,
                                          };

                                          if (storyBookPermission ==
                                              PermissionValue.no) {
                                            for (var data
                                                in cat.inviteSubCatSelectData) {
                                              if (subCategoryIds
                                                  .contains(data["id"])) {
                                                print("removed");
                                                print(data["id"]);
                                                subCategoryIds
                                                    .remove(data["id"]);
                                              }
                                            }
                                          }
                                          var categories = subCategoryIds;
                                          var relation = {
                                            "id": selectedRelationId,
                                            "relationName": selectedRelation
                                          };
                                          var senderDetails = {
                                            "id": widget.data['data']['sender']
                                                ['id'],
                                            "firstName": widget.data['data']
                                                ['sender']['firstName'],
                                            "middleName": widget.data['data']
                                                    ['sender']['middleName'] ??
                                                "",
                                            "lastName": widget.data['data']
                                                ['sender']['lastName'],
                                            "profilePicture":
                                                widget.data['data']['sender']
                                                        ['profilePicture'] ??
                                                    "",
                                            "dob": widget.data['data']['sender']
                                                ['dob'],
                                            "address": widget.data['data']
                                                ['sender']['address'],
                                            "email": widget.data['data']
                                                ["receiverEmail"],
                                            "permission": permission,
                                            "categories": [],
                                            "subCategoryIds": categories,
                                            "relation": relation,
                                            "homeTown": widget.data['data']
                                                ['sender']['homeTown']
                                          };

                                          setState(() {
                                            isloading = true;
                                          });
                                          await Provider.of<InviteProvider>(
                                                  context,
                                                  listen: false)
                                              .inviteMembers(
                                            context: context,
                                            linkedStatus: "approved",
                                            id: widget.data['data']["id"],
                                            sender: senderDetails,
                                            notificationId: widget.data["id"],
                                          )
                                              .then((_) {
                                            context
                                                .read<ChatProvider>()
                                                .createChatRoom(
                                                    senderUser: widget.data,
                                                    receiverUser: user);
                                          });

                                          setState(() {
                                            isloading = false;
                                          });

                                          await Provider.of<
                                                      NotificationProvider>(
                                                  context,
                                                  listen: false)
                                              .removeInviteNotifications(
                                                  widget.data["id"]);
                                          utilService.showToast(
                                              // "Please first enable touch id from settings",
                                              "You are now added on their family tree.",
                                              context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (builder) =>
                                                      MainDashboardScreen(3)));
                                        } else {
                                          var reciever = {
                                            "id": getUserDetail["id"],
                                            "firstName":
                                                getUserDetail["firstName"],
                                            "middleName":
                                                getUserDetail["middleName"],
                                            "lastName":
                                                getUserDetail["lastName"],
                                            "profilePicture":
                                                getUserDetail["profilePicture"],
                                            "dob": getUserDetail["dob"],
                                            "address": getUserDetail["address"],
                                          };
                                          // var permission = {
                                          //   "default":
                                          //       invite.defaultSharingSelection ==
                                          //               0
                                          //           ? true
                                          //           : false,
                                          //   "storyBook":
                                          //       invite.storyBookPermissions == 0
                                          //           ? true
                                          //           : false,
                                          //   "familyTree":
                                          //       invite.storyBookPermissions == 0
                                          //           ? true
                                          //           : false,
                                          //   "categorySubcategory":
                                          //       invite.categoriesSubCategories ==
                                          //               0
                                          //           ? false
                                          //           : true,
                                          // };   // commented by chetu

                                          var permission = {
                                            "default": defaultPermission ==
                                                    PermissionValue.yes
                                                ? true
                                                : false,
                                            // "storyBook": storyBookPermission ==
                                            //         PermissionValue.yes
                                            //     ? true
                                            //     : false,
                                            "familyTree":
                                                familyTreePermission ==
                                                        PermissionValue.yes
                                                    ? true
                                                    : false,
                                            "storyBook": true,

                                            "categorySubcategory":
                                                storyBookPermission ==
                                                        PermissionValue.yes
                                                    ? true
                                                    : false,
                                          };

                                          // for (int i = 0;
                                          //     i < categoriesList.length;
                                          //     i++) {
                                          //   tempcategoriesList
                                          //       .add(categoriesList[i]["id"]);
                                          // }

                                          if (storyBookPermission ==
                                              PermissionValue.no) {
                                            for (var data
                                                in cat.inviteSubCatSelectData) {
                                              if (subCategoryIds
                                                  .contains(data["id"])) {
                                                print("removed");
                                                print(data["id"]);
                                                subCategoryIds
                                                    .remove(data["id"]);
                                              }
                                            }
                                          }

                                          // var categories =
                                          //     invite.categoriesSubCategories == 0
                                          //         ? []
                                          //         : tempcategoriesList;  // commented by chetu

                                          var categories = subCategoryIds;

                                          //  [
                                          //     {
                                          //       "id": "20_something_years",
                                          //       "categoryName":
                                          //           "20 Something Years",
                                          //       "parentId": "mystory"
                                          //     }
                                          //   ]

                                          var relation = {
                                            "id": selectedRelationId,
                                            "relationName": selectedRelation
                                          };

                                          if (selectedRelation == "" ||
                                              selectedRelation == null) {
                                            utilService.showToast(
                                                "Please fill all fields",
                                                context);
                                          } else {
                                            setState(() {
                                              isloading = true;
                                            });
                                            await Provider.of<InviteProvider>(
                                                    context,
                                                    listen: false)
                                                .createInviteMember(
                                              id: getUserDetail['id'],
                                              context: context,
                                              inviteComment:
                                                  commentController.text,
                                              receiverEmail:
                                                  emailController.text,
                                              reciever: reciever,
                                              relation: relation,
                                              permission: permission,
                                              categories: categories,
                                            );

                                            setState(() {
                                              isloading = false;
                                            });
                                          }
                                          invite.defaultSharingSelection = 0;

                                          invite.storyBookPermissions = 0;

                                          invite.storyBookPermissions = 0;

                                          invite.categoriesSubCategories = 0;
                                          Provider.of<CategoryProvider>(context,
                                                  listen: false)
                                              .nullInviteSubCatSelectList();

                                          tempcategoriesList = [];
                                          FocusScope.of(context).unfocus();
                                        }
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) =>
                                                      Colors.transparent),
                                          elevation:
                                              MaterialStateProperty.resolveWith(
                                                  (states) => 0)),
                                      child: Container(
                                          padding: EdgeInsets.only(
                                              left: 5, right: 10),
                                          child: new Text(
                                            widget.fromAcceptInvitation
                                                ? "Accept"
                                                : "Send",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                    ),
                                  ),
                                  Container(
                                    height: 45.h,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        relationController.text = '';
                                        invite.defaultSharingSelection = 0;

                                        invite.storyBookPermissions = 0;

                                        invite.storyBookPermissions = 0;

                                        invite.categoriesSubCategories = 0;
                                        Provider.of<CategoryProvider>(context,
                                                listen: false)
                                            .nullInviteSubCatSelectList();

                                        tempcategoriesList = [];
                                        navigationService.navigateTo(
                                            SearchStoryBookScreenRoute);
                                        FocusScope.of(context).unfocus();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        textStyle: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                            fontWeight: FontWeight.w600),
                                        fixedSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.43,
                                            MediaQuery.of(context).size.height *
                                                0.070),
                                        backgroundColor: Colors.transparent,
                                        side: BorderSide(
                                          color:
                                              Theme.of(context).indicatorColor,
                                        ),
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      child: Container(
                                          padding: EdgeInsets.only(
                                              left: 5, right: 10),
                                          child: new Text(
                                            "Cancel",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .indicatorColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    ),
                  );
                }));
          }),
          if (isloading)
            Positioned(
                child: Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ))
        ]),
      );
    });
  }

  Future<dynamic> getAllSubCategories() async {
    var responseData = await Provider.of<InviteProvider>(context, listen: false)
        .fetchAllCategoriesAndSubCategories(); //created by chetu
    if (responseData != null) {
      List<dynamic> listCategorySubCat = responseData;
      for (var data in listCategorySubCat) {
        for (var subData in data["subCategory"]) {
          subCategoryIds.add(subData['id']);
        }
      }
    }
  }
}
