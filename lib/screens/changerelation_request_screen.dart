import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/global.dart';
import 'package:mystory_flutter/models/relation.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/screens/family_member_profile_screen.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';

class ChanngeRelationScreen extends StatefulWidget {
  RouteSettings? settings;
  ChanngeRelationScreen({Key? key,this.settings}) : super(key: key);

  @override
  _ChanngeRelationScreenState createState() => _ChanngeRelationScreenState();
}

class _ChanngeRelationScreenState extends State<ChanngeRelationScreen> {
  var navigationService = locator<NavigationService>();
  UtilService? utilService = locator<UtilService>();
  String? selectedRelation;
  String? selectedRelationId;
  TextEditingController emailController = TextEditingController();
  var familyData;
  String from = "";
  @override
  void initState() {
   from = widget.settings?.arguments as String;
   print(from);
    familyData =
        Provider.of<InviteProvider>(context, listen: false).getFAmilyData;
    super.initState();
    emailController.text = familyData["email"];
  }

  @override
  Widget build(BuildContext context) {
    // final data= ModalRoute.of(context)!.settings.arguments as Map;
    // print(data);
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {

           //     navigationService.navigateTo(FamilyMemberProfileScreenRoute);
                 Navigator.pop(context);
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (ctx) => SisterScreen(
                //       route: "Family Screen",
                //       // familyMember:
                //       //     family.fetcFamilyTree[i]
                //     ),
                //   ),
                // );
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          centerTitle: true,
          title: Text(
            "Change Relation",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Consumer<InviteProvider>(builder: (context, relation, child) {
          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Given Relation",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: sx(4)),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          DropdownButton(
                            dropdownColor: Colors.white,
                            menuMaxHeight: 200,
                            hint: Padding(
                              padding: EdgeInsets.only(left: sx(10)),
                              child: Text(
                                selectedRelation == "" ||
                                        selectedRelation == null
                                    ? "Select Relation"
                                    : selectedRelation.toString(),
                                style: TextStyle(
                                    fontSize: sy(9),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade400),
                              ),
                            ),
                            // isExpanded: true,
                            style: TextStyle(
                                fontSize: sy(12), color: Colors.white),
                            // value: getRelation,
                            underline: SizedBox(),
                            onChanged: (newValue) {
                              RelationModel rm = newValue as RelationModel;

                              setState(() {
                                selectedRelation = rm.relationName;
                                selectedRelationId = rm.id;
                              });
                            },
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.blue,
                              ),
                            ),
                            items: relation.relationData.map((valueItem) {
                              return DropdownMenuItem(
                                value: valueItem,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.35,
                                  child: Text(
                                    "   ${valueItem.relationName}",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: sy(11)),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: from !="manualUser",
                      child: Text(
                        "Email",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Visibility(
                      visible: from !="manualUser",
                      child: Text(
                        "Email Address",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Visibility(
                      visible: from !="manualUser",
                      child: Container(
                        width: 500.w,
                        height: 60.h,
                        child: TextFormField(
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          autocorrect: true,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13.sp,
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
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                        onPressed: () async {
                          Map<String, dynamic> data = {
                            "id": selectedRelationId,
                            "relationName": selectedRelation
                          };
                          if (selectedRelation == "" ||
                              selectedRelation == null) {
                            utilService!.showToast("Please select relation",context);
                          } else {
                            showLoadingAnimation(context);
                            await Provider.of<InviteProvider>(context,
                                    listen: false)
                                .putChangeRelation(
                                    id: familyData["id"],
                                    data: data,
                                    context: context)
                                .then((_) async {
                              Navigator.pop(context,selectedRelation);
                             Navigator.pop(context,selectedRelation);
                              // navigationService
                              //     .navigateTo(FamilyMemberProfileScreenRoute);
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (ctx) => SisterScreen(
                              //       // route: "Family Screen",
                              //       // familyMember:
                              //       //     family.fetcFamilyTree[i]
                              //     ),
                              //   ),
                              // );
                            });
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent),
                            elevation: MaterialStateProperty.resolveWith(
                                (states) => 0)),
                        child: Container(
                            padding: EdgeInsets.only(left: 5, right: 10),
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
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          textStyle: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.03,
                              fontWeight: FontWeight.w600),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.43,
                              MediaQuery.of(context).size.height * 0.070),
                          backgroundColor: Colors.transparent,
                          side: BorderSide(
                            color: Theme.of(context).indicatorColor,
                          ),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Container(
                            padding: EdgeInsets.only(left: 5, right: 10),
                            child: new Text(
                              "Cancel",
                              style: TextStyle(
                                color: Theme.of(context).indicatorColor,
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
          );
        }),
      );
    });
  }
}
