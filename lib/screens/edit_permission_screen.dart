import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/global.dart';
import 'package:mystory_flutter/models/relation.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/category_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/screens/family_member_profile_screen.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/invite_selected_sub_categories_widget.dart';
import 'package:mystory_flutter/widgets/invite_sub_categories_widget.dart';
import 'package:mystory_flutter/widgets/sharing_permission_widget.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';

import '../models/category.dart';

class EditPermissionScreen extends StatefulWidget {
  EditPermissionScreen({Key? key}) : super(key: key);

  @override
  _EditPermissionScreenState createState() => _EditPermissionScreenState();
}

enum PermissionValue { yes, no }

class _EditPermissionScreenState extends State<EditPermissionScreen> {
  var navigationService = locator<NavigationService>();
  UtilService? utilService = locator<UtilService>();
  var val;
  var selectedCategory;
  bool isloading = false;
  List categoriesList = [];
  List tempcategoriesList = [];
  var familyData;
  Map<String, dynamic> userData = {};
  List subCategoryIds = [];
  BuildContext? consumerContext;
  PermissionValue defaultPermission = PermissionValue.yes;
  PermissionValue storyBookPermission = PermissionValue.yes;
  PermissionValue familyTreePermission = PermissionValue.yes;

  PermissionValue categorySubCategoryPermission = PermissionValue.yes;
  var userId;

  @override
  void initState() {
    categoriesList = Provider.of<CategoryProvider>(context, listen: false)
        .inviteSubCatSelectData;
    familyData =
        Provider.of<InviteProvider>(context, listen: false).getFAmilyData;
    userData =
        Provider.of<InviteProvider>(context, listen: false).searchUserData;

    var user = Provider.of<AuthProviderr>(context, listen: false).user;
    Provider.of<CategoryProvider>(context, listen: false)
        .inviteSubCatSelectData
        .clear();
    Provider.of<CategoryProvider>(context, listen: false)
        .categorySubDataInviteMember
        .clear();
    getUserPermissions();

    userId = user.id;
  }

  List<Map<String, dynamic>> permision = [
    //     // {
    //   "id": "1",
    //   "title": "Default Sharing Selection",
    //   "mtitle": "Yes",
    //   "subtitle": "No",
    //
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

  cancelPermission(InviteProvider invite) {
    invite.defaultSharingSelection = 0;

    invite.storyBookPermissions = 0;

    invite.storyBookPermissions = 0;

    invite.categoriesSubCategories = 0;
    Provider.of<CategoryProvider>(context, listen: false)
        .nullInviteSubCatSelectList();

    tempcategoriesList = [];
  }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return AbsorbPointer(
        absorbing: isloading,
        child: Stack(
          children: [
            Consumer2<CategoryProvider, InviteProvider>(
                builder: (context, cat, invite, child) {
              consumerContext = context;
              List<CategoryModel> catListData = cat.categoryData
                  .skipWhile((value) => value.categoryName == "All")
                  .toList(); //implemented by chetu for remove all from drop down button
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  leading: IconButton(
                      onPressed: () {
                        cancelPermission(invite);
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      )),
                  centerTitle: true,
                  title: Text(
                    "Edit Permissions",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
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
                              height: 20.h,
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
                                    activeColor: Theme.of(context).primaryColor,
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
                                    activeColor:
                                        defaultPermission == PermissionValue.no
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
                            SizedBox(
                              height: 10.h,
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
                                          color:
                                              Color.fromRGBO(168, 168, 168, 1),
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
                            SizedBox(
                              height: 10.h,
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
                                        "StoryBook Permissions",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.014,
                                          fontWeight: FontWeight.w800,
                                          color:
                                              Color.fromRGBO(168, 168, 168, 1),
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
                                                    -15, 0, 0),
                                            child: Text(
                                              'Custom',
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
                            SizedBox(
                              height: 10.h,
                            ),
                            // AbsorbPointer(
                            //     absorbing:
                            //         defaultPermission == PermissionValue.yes
                            //             ? true
                            //             : false,
                            //     child: Row(
                            //       children: [
                            //         Expanded(
                            //           flex: 10,
                            //           child: Text(
                            //             "Categories & SubCategories",
                            //             style: TextStyle(
                            //               fontSize: MediaQuery.of(context)
                            //                       .size
                            //                       .height *
                            //                   0.014,
                            //               fontWeight: FontWeight.w800,
                            //               color:
                            //                   Color.fromRGBO(168, 168, 168, 1),
                            //             ),
                            //           ),
                            //         ),
                            //         Expanded(
                            //           flex: 4,
                            //           child: RadioListTile<PermissionValue>(
                            //             contentPadding: EdgeInsets.zero,
                            //             dense: true,
                            //             title: Transform(
                            //                 transform:
                            //                     Matrix4.translationValues(
                            //                         -20, 0, 0),
                            //                 child: Text(
                            //                   'All',
                            //                   style: TextStyle(
                            //                     fontSize: MediaQuery.of(context)
                            //                             .size
                            //                             .height *
                            //                         0.014,
                            //                     fontWeight: FontWeight.w600,
                            //                     color: Color.fromRGBO(
                            //                         168, 168, 168, 1),
                            //                   ),
                            //                 )),
                            //             value: PermissionValue.yes,
                            //             groupValue:
                            //                 categorySubCategoryPermission,
                            //             activeColor: defaultPermission ==
                            //                     PermissionValue.no
                            //                 ? Theme.of(context).primaryColor
                            //                 : Colors.grey,
                            //             onChanged: (PermissionValue? value) {
                            //               setState(() {
                            //                 categorySubCategoryPermission =
                            //                     value!;
                            //               });
                            //             },
                            //           ),
                            //         ),
                            //         Expanded(
                            //           flex: 6,
                            //           child: RadioListTile<PermissionValue>(
                            //             contentPadding: EdgeInsets.zero,
                            //             dense: true,
                            //             title: Transform(
                            //                 transform:
                            //                     Matrix4.translationValues(
                            //                         -23, 0, 0),
                            //                 child: Text(
                            //                   'Custom',
                            //                   style: TextStyle(
                            //                     fontSize: MediaQuery.of(context)
                            //                             .size
                            //                             .height *
                            //                         0.014,
                            //                     fontWeight: FontWeight.w600,
                            //                     color: Color.fromRGBO(
                            //                         168, 168, 168, 1),
                            //                   ),
                            //                 )),
                            //             value: PermissionValue.no,
                            //             groupValue:
                            //                 categorySubCategoryPermission,
                            //             activeColor: defaultPermission ==
                            //                     PermissionValue.no
                            //                 ? Theme.of(context).primaryColor
                            //                 : Colors.grey,
                            //             onChanged: (PermissionValue? value) {
                            //               setState(() {
                            //                 categorySubCategoryPermission =
                            //                     value!;
                            //               });
                            //             },
                            //           ),
                            //         ),
                            //       ],
                            //     )),
                            // Container(
                            //   margin: EdgeInsets.only(top: 5, bottom: 5),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Expanded(
                            //         child: Container(
                            //           child: Text(
                            //             "Default Selection Sharing",
                            //             style: TextStyle(
                            //               fontSize: MediaQuery.of(context)
                            //                       .size
                            //                       .height *
                            //                   0.014,
                            //               fontWeight: FontWeight.w800,
                            //               color:
                            //                   Color.fromRGBO(168, 168, 168, 1),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       Row(
                            //         children: [
                            //           Text(
                            //             "Yes",
                            //             style: TextStyle(
                            //               fontSize: MediaQuery.of(context)
                            //                       .size
                            //                       .height *
                            //                   0.014,
                            //               fontWeight: FontWeight.w600,
                            //               color:
                            //                   Color.fromRGBO(168, 168, 168, 1),
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
                            //             width:
                            //                 MediaQuery.of(context).size.width *
                            //                     0.063,
                            //           ),
                            //           Text(
                            //             "No",
                            //             style: TextStyle(
                            //               fontSize: MediaQuery.of(context)
                            //                       .size
                            //                       .height *
                            //                   0.014,
                            //               fontWeight: FontWeight.w600,
                            //               color:
                            //                   Color.fromRGBO(168, 168, 168, 1),
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
                            //           // action: ,
                            //
                            //           // tag: permision[i]['id'],
                            //           // action: active,
                            //           // active: tagId == permision[i]['id']
                            //           //     ? true
                            //           //     : false,
                            //         );
                            //       }),
                            // ),

                            //   categorySubCategoryPermission == PermissionValue.no
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
                                                    fontWeight: FontWeight.w500,
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
                                                  : selectedCategory.toString(),
                                              style: TextStyle(
                                                  fontSize: sy(9),
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey.shade400),
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
                                          items:
                                          catListData.map((valueItem) {
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
                                              value:
                                                  valueItem.categoryName ?? "",
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
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                    ],
                                  )
                                : Container(),
                            //         categorySubCategoryPermission == PermissionValue.no
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
                                          SizedBox(
                                            height: 10,
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
                            //   categorySubCategoryPermission == PermissionValue.no
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
                                          SizedBox(
                                            height: 15,
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
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.43,
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
                                      // var relation = {
                                      //   "id": "",
                                      //   "relationName": ""
                                      // };
                                      // var reciever = {
                                      //   "id": familyData["id"],
                                      //   "firstName":
                                      //   familyData["firstName"],
                                      //   "middleName":
                                      //   familyData["middleName"],
                                      //   "lastName": familyData["lastName"],
                                      //   "profilePicture":
                                      //   familyData["profilePicture"],
                                      //   "dob": familyData["dob"],
                                      //   "address": familyData["address"],
                                      // };
                                      // var permission = {
                                      //   "default":
                                      //       invite.defaultSharingSelection == 0
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
                                      //       invite.categoriesSubCategories == 0
                                      //           ? false
                                      //           : true,
                                      // };

                                      // for (int i = 0;
                                      //     i < categoriesList.length;
                                      //     i++) {
                                      //   tempcategoriesList
                                      //       .add(categoriesList[i]["id"]);
                                      // }
                                      //
                                      // var categories =
                                      //     invite.categoriesSubCategories == 0
                                      //         ? []
                                      //         : tempcategoriesList;

                                      setState(() {
                                        isloading = true;
                                      });
                                      // if (categorySubCategoryPermission ==
                                      //     PermissionValue.no){
                                      // List subCategoryIdsFinal = [];
                                      // subCategoryIdsFinal
                                      //     .addAll(subCategoryIds);

                                      if (storyBookPermission ==
                                          PermissionValue.no) {
                                        for (var data
                                            in cat.inviteSubCatSelectData) {
                                          if (subCategoryIds
                                              .contains(data["id"])) {
                                            print("removed");
                                            print(data["id"]);
                                               subCategoryIds.remove(data["id"]);
                                            // subCategoryIdsFinal
                                            //     .remove(data["id"]);
                                          }
                                        }
                                      }

                                      await Provider.of<InviteProvider>(context,
                                              listen: false)
                                          .editPermission(
                                              id: familyData['id'],
                                              context: context,
                                              defaults: defaultPermission ==
                                                      PermissionValue.yes
                                                  ? true
                                                  : false,
                                              storyBook: true,
                                              // storyBook: storyBookPermission ==
                                              //             PermissionValue.yes
                                              //         ? true
                                              //         : false,
                                              familyTree:
                                                  familyTreePermission ==
                                                          PermissionValue.yes
                                                      ? true
                                                      : false,
                                              categorySubcategory:
                                              storyBookPermission ==
                                                      PermissionValue.yes
                                                  ? true
                                                  : false,
                                              subCategoryIds:
                                              subCategoryIds
                                              // inviteComment:"",
                                              // receiverEmail: "",
                                              // reciever: reciever,
                                              // relation: relation,
                                              //
                                              // categories: categories,
                                              );
                                      setState(() {
                                        isloading = false;
                                      });
                                      //    cancelPermission(invite);
                                      navigationService.closeScreen();
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.transparent),
                                        elevation:
                                            MaterialStateProperty.resolveWith(
                                                (states) => 0)),
                                    child: Container(
                                        padding:
                                            EdgeInsets.only(left: 5, right: 10),
                                        child: new Text(
                                          "Submit",
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
                                    onPressed: () {
                                      cancelPermission(invite);
                                      Navigator.pop(context);
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
                                        color: Theme.of(context).indicatorColor,
                                      ),
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0),
                                      ),
                                    ),
                                    child: Container(
                                        padding:
                                            EdgeInsets.only(left: 5, right: 10),
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
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 50, 10, 20),
                          child: Text(
                            "Remove the member from your family tree",
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.43,
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
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      content: Text(
                                          'Do you want to remove relation with this member?'),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              Map<String, dynamic> data = {
                                                "treeAdminId": userId,
                                                // pass user id by which you want to remove
                                                "id": userData["id"],
                                                // pass user id which you want to remove
                                                "isRemove": true
                                              };
                                              showLoadingAnimation(context);
                                              await Provider.of<AuthProviderr>(
                                                      context,
                                                      listen: false)
                                                  .removeFamilyMember(
                                                      data: data,
                                                      context: context)
                                                  .then((value) {
                                                if (value) {
                                                  navigationService!.navigateTo(
                                                      MaindeshboardRoute);
                                                } else {
                                                  Navigator.pop(context);
                                                }
                                              });
                                            },
                                            child: Text('Yes!')),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('No'))
                                      ],
                                    );
                                  });
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.transparent),
                                elevation: MaterialStateProperty.resolveWith(
                                    (states) => 0)),
                            child: Container(
                                padding: EdgeInsets.only(left: 5, right: 10),
                                child: new Text(
                                  "Remove",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            if (isloading)
              Positioned(
                  child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ))
          ],
        ),
      );
    });
  }

  // void getUserPermissions() async {
  //   var data = await Provider.of<InviteProvider>(context, listen: false)
  //       .fetchUserPermissions(familyData['id']);
  //   // if (data[0].contains("0")) {
  //
  //   if (data is List) {
  //     print("aaya 1");
  //     print(data[0]["permission"]["default"]);
  //     print(data[0]["permission"]["storyBook"]);
  //     print(data[0]["permission"]["familyTree"]);
  //   //  print(data);
  //     defaultPermission = data[0]["permission"]["default"] == true
  //         ? PermissionValue.yes
  //         : PermissionValue.no;
  //     familyTreePermission = data[0]["permission"]["familyTree"] == true
  //         ? PermissionValue.yes
  //         : PermissionValue.no;
  //     storyBookPermission = data[0]["permission"]["categorySubcategory"] == true
  //         ? PermissionValue.yes
  //         : PermissionValue.no;
  //     // storyBookPermission = data[0]["permission"]["storyBook"] == true
  //     //     ? PermissionValue.yes
  //     //     : PermissionValue.no;
  //   //  categorySubCategoryPermission = data[0]["permission"]["categorySubcategory"] == true
  //     //         ? PermissionValue.yes
  //     //         : PermissionValue.no;
  //
  //     await getAllSubCategories(
  //             selectedSubCategories: data[0]["subCategoryIds"])
  //         .then((value) => null);
  //   } else {
  //     // var data = await Provider.of<InviteProvider>(context, listen: false)
  //     //     .fetchUserSenderPermissions(userId);
  //     // if (data[0].contains("0")) {
  //     print("aaya 2");
  //     print(data["permission"]["default"]);
  //     print(data["permission"]["storyBook"]);
  //     print(data["permission"]["familyTree"]);
  //     defaultPermission = data["permission"]["default"] == true
  //         ? PermissionValue.yes
  //         : PermissionValue.no;
  //     familyTreePermission = data["permission"]["familyTree"] == true
  //         ? PermissionValue.yes
  //         : PermissionValue.no;
  //     storyBookPermission = data["permission"]["categorySubcategory"] == true
  //         ? PermissionValue.yes
  //         : PermissionValue.no;
  //     // storyBookPermission = data]["permission"]["storyBook"] == true
  //     //     ? PermissionValue.yes
  //     //     : PermissionValue.no;
  //     //
  //     await getAllSubCategories(
  //             selectedSubCategories: data["categories"])
  //         .then((value) => null);
  //   }
  // }
  void getUserPermissions() async {
    var data = await Provider.of<InviteProvider>(context, listen: false)
        .fetchUserPermissions(familyData['id']);
    // if (data[0].contains("0")) {

    if (data[0]["receiverId"]!=userId) {
      print("aaya 1");
      print(data[0]["permission"]["default"]);
      print(data[0]["permission"]["storyBook"]);
      print(data[0]["permission"]["familyTree"]);
    //  print(data);
      defaultPermission = data[0]["permission"]["default"] == true
          ? PermissionValue.yes
          : PermissionValue.no;
      familyTreePermission = data[0]["permission"]["familyTree"] == true
          ? PermissionValue.yes
          : PermissionValue.no;
      storyBookPermission = data[0]["permission"]["categorySubcategory"] == true
          ? PermissionValue.yes
          : PermissionValue.no;
      // storyBookPermission = data[0]["permission"]["storyBook"] == true
      //     ? PermissionValue.yes
      //     : PermissionValue.no;
    //  categorySubCategoryPermission = data[0]["permission"]["categorySubcategory"] == true
      //         ? PermissionValue.yes
      //         : PermissionValue.no;

      await getAllSubCategories(
              selectedSubCategories: data[0]["subCategoryIds"])
          .then((value) => null);
    } else {
      // var data = await Provider.of<InviteProvider>(context, listen: false)
      //     .fetchUserSenderPermissions(userId);
      // if (data[0].contains("0")) {
      print("aaya 2");
      print(data[0]["sender"]["permission"]["default"]);
      print(data[0]["sender"]["permission"]["storyBook"]);
      print(data[0]["sender"]["permission"]["familyTree"]);
      defaultPermission = data[0]["sender"]["permission"]["default"] == true
          ? PermissionValue.yes
          : PermissionValue.no;
      familyTreePermission = data[0]["sender"]["permission"]["familyTree"] == true
          ? PermissionValue.yes
          : PermissionValue.no;
      storyBookPermission = data[0]["sender"]["permission"]["categorySubcategory"] == true
          ? PermissionValue.yes
          : PermissionValue.no;
      // storyBookPermission = data]["permission"]["storyBook"] == true
      //     ? PermissionValue.yes
      //     : PermissionValue.no;
      //
      await getAllSubCategories(
              selectedSubCategories: data[0]["sender"]["subCategoryIds"])
          .then((value) => null);
    }
  }

  Future<dynamic> getAllSubCategories(
      {required List<dynamic> selectedSubCategories}) async {
    var responseData = await Provider.of<InviteProvider>(context, listen: false)
        .fetchAllCategoriesAndSubCategories(); //created by chetu
    if (responseData != null) {
      List<dynamic> listCategorySubCat = responseData;
      for (var data in listCategorySubCat) {
        for (var subData in data["subCategory"]) {
          subCategoryIds.add(subData['id']);
          if (!selectedSubCategories.contains(subData['id'])) {
            print("subData");
            print(subData);
            Provider.of<CategoryProvider>(context, listen: false)
                .setInviteSubCategories(subData);
          }
        }
      }
    }
  }
}
