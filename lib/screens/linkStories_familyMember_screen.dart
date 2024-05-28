import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/linkStories_familytree&storybook_provider.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/linked_story_book_widget.dart';
import 'package:mystory_flutter/widgets/no_data_yet.dart';
import 'package:provider/provider.dart';

class FamilyMemberLinkedStoryBookScreen extends StatefulWidget {
  const FamilyMemberLinkedStoryBookScreen({Key? key}) : super(key: key);

  @override
  _FamilyMemberLinkedStoryBookScreenState createState() =>
      _FamilyMemberLinkedStoryBookScreenState();
}

class _FamilyMemberLinkedStoryBookScreenState
    extends State<FamilyMemberLinkedStoryBookScreen> {
  var navigationService = locator<NavigationService>();
  var utilService = locator<UtilService>();
  var user;
  var _scroll = ScrollController();
  bool isLoading = false;

  int page = 2;
  int count = 10;

  @override
  void initState() {
    user = Provider.of<AuthProviderr>(context, listen: false).user;

    _scroll.addListener(() {
      if (_scroll.position.pixels == _scroll.position.maxScrollExtent) {
        context
            .read<LinkFamilyStoryProvider>()
            .getMoreDatafamilyMemberLinkedStories(
              context: context,
                count: count,
                page: page,
                id: context.read<LinkFamilyStoryProvider>().familyMemberId);

        setState(() {
          page++;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      //BoxConstraints(
      //    maxWidth: MediaQuery.of(context).size.width,
      //    maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(360, 690),
      //orientation: Orientation.portrait
    );
    return Stack(children: [
      Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  navigationService.navigateTo(FamilyMemberProfileScreenRoute);
                }),
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  "Linked StoryBook",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ],
            ),
          ),
          body: Consumer<LinkFamilyStoryProvider>(
              builder: (context, invite, child) {
            return invite.familyLinkedStoriesData.length == 0 && !isLoading
                ? NoDataYet(title: "No linked stories yet", image: "add.png")
                : Container(
                    padding: EdgeInsets.all(20),
                    child: ListView.builder(
                      controller: _scroll,
                      itemCount: invite.familyLinkedStoriesData.length + 1,
                      itemBuilder: (BuildContext context, int i) {
                        if (i == invite.familyLinkedStoriesData.length) {
                          return invite.isPaginaionLoading == true
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : Container();
                        } else {
                          return LinkedStoryBookWidget(
                            data: invite.familyLinkedStoriesData[i],
                          );
                        }
                      },
                    ));
          })),
      if (isLoading)
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        )
    ]);
  }
}
