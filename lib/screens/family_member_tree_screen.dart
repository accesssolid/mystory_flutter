import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/global.dart';
import 'package:mystory_flutter/models/relation.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/linkStories_familytree&storybook_provider.dart';
import 'package:mystory_flutter/screens/family_member_manual_profile_screen.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/familtyMemberTreeWidget.dart';
import 'package:mystory_flutter/widgets/no_data_yet.dart';
import 'package:provider/provider.dart';

class FamilyMemberTreeScreen extends StatefulWidget {
  const FamilyMemberTreeScreen({Key? key}) : super(key: key);

  @override
  _FamilyMemberTreeScreenState createState() => _FamilyMemberTreeScreenState();
}

class _FamilyMemberTreeScreenState extends State<FamilyMemberTreeScreen> {
  var navigationService = locator<NavigationService>();
  var utilService = locator<UtilService>();
  var user;
  int page = 2;
  int count = 10;

  var _scroll = ScrollController();
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      user = Provider.of<AuthProviderr>(context, listen: false).user;
      _scroll.addListener(() {
        if (_scroll.position.pixels == _scroll.position.maxScrollExtent) {
          context.read<InviteProvider>().getMoreDatafamilyMemberTree(
              context: context,
              count: count,
              page: page,
              id: context.read<LinkFamilyStoryProvider>().familyMemberId);

          setState(() {
            page++;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () async {

            navigationService.navigateTo(FamilyMemberProfileScreenRoute);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Family Tree",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 15.sp),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(5),
        child: Consumer<InviteProvider>(builder: (context, familyMember, child) {
          return  familyMember.familyTree.length == 0
              ? Expanded(
                  child: NoDataYet(
                      title: "No family tree yet", image: "3 User1.png"),
                )
              : SingleChildScrollView(
                child: ListView.builder(
                    controller: _scroll,
                    shrinkWrap: true,
                    itemCount: familyMember.familyTree.length,
                    itemBuilder: (ctx, i) {
                      print("amilyMember.familyTree.length");
                      print(familyMember.familyTree.length);
                      if (i == familyMember.familyTree.length) {
                        return familyMember.isPaginaionLoading == true
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            : Container();
                      } else {
                        return GestureDetector(
                          //*** code by chetu on dated 16.08.2023*/
                          onTap: () async {
                                             // showLoadingAnimation(context);
                                                await Provider.of<InviteProvider>(
                                                        context,
                                                        listen: false)
                                                    .fetchSearchUserDetail(
                                                        myId: user.id,
                                                        viewuserId:
                                                            familyMember.familyTree[i]['id']
                                                            )
                                                    .then((value) async {
                                                      if(value==null){

                                                        //* navigated on manually user screen by chetu

                                                        var storageService =
                                                        locator<StorageService>();
                                                        await storageService.setData(
                                                            "route",
                                                            "/familytree-screen");
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (builder) =>
                                                                    FamilyMemberManualProfileScreen(
                                                                      userData:
                                                                      familyMember.familyTree[i],showRelationButton: false,
                                                                    )));
                                                       // utilService.showToast("User is not exists", context);
                                                       // Navigator.pop(context);
                                                      }
                                                      else{
                                                        Provider.of<InviteProvider>(
                                                            context,
                                                            listen: false)
                                                            .setFamilyData(
                                                            familyMember.searchUserData);

                                                            if (context.read<InviteProvider>().searchUserData['inviteStatus'] ==
                                            "approved")
                                            {
                                               await Provider.of<InviteProvider>(
                                                            context,
                                                            listen: false)
                                                            .fetchFamiltTreeMember(
                                                            id: familyMember.familyTree[i]['id'],
                                                            count: 10,
                                                            page: 1);
                                                        Navigator.pop(context);
              
                                                        var storageService =
                                                        locator<StorageService>();
                                                        await storageService.setData(
                                                            "route",
                                                            "/familytree-screen");
                                                        navigationService.navigateTo(
                                                            FamilyMemberProfileScreenRoute);
                                            }
                                            else {
                                              navigationService.navigateTo(
                                              SearchStoryBookScreenRoute);
                                            }                                                      
                                            }
              
                                         });
                                             Provider.of<InviteProvider>(context, listen: false)
                              .setUserData(familyMember.fetcFamilyTree[i]);
                           },
              
                           //code by chetu
                          child: FamilyMemberWidget(
                            data: familyMember.familyTree[i],
                          ),
                        );
                      }
                    }
                    ),
              );
        }),
      ),
    );
  
  }

 
}
