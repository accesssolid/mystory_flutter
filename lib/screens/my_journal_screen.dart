import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/screens/create_journal_story_screen.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/my_journal_widget.dart';
import 'package:mystory_flutter/widgets/no_data_yet.dart';
import 'package:provider/provider.dart';

import '../global.dart';

class MyJournalScreen extends StatefulWidget {
  MyJournalScreen({Key? key}) : super(key: key);

  @override
  _MyJournalScreenState createState() => _MyJournalScreenState();
}

class _MyJournalScreenState extends State<MyJournalScreen> {
  var navigationService = locator<NavigationService>();
  var utilService = locator<UtilService>();
  List journalPostData = [];
  List journalPostDataPagination = [];

  int page = 2;
  int count = 10;
  var _scroll = ScrollController();
  var user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<AuthProviderr>(context, listen: false).user;
    journalPostData =
        Provider.of<PostProvider>(context, listen: false).journalPostData;
    journal();

    _scroll.addListener(() {
      if (_scroll.position.pixels == _scroll.position.maxScrollExtent) {
        setState(() {
          print('Page reached end of page');
          getMoreData(count: count, page: page);
        });
        setState(() {
          page = page + 1;
        });
      }
    });
  }

  bool isLoading = false;
  // callback(bool data) {
  //   setState(() {
  //     isLoadingProgress = data;
  //   });
  // }
  void getMoreData({int? count, int? page}) async {
    try {
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });

        await Provider.of<PostProvider>(context, listen: false)
            .fetchJournalPagination(
                count: count, page: page, userId: user.id, context: context);
        journalPostDataPagination =
            Provider.of<PostProvider>(context, listen: false)
                .journalPostDataPagination;
        setState(() {
          isLoading = false;
          journalPostData.addAll(journalPostDataPagination);
          // page += 1;
          // print(page);
        });
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      utilService.showToast(err.toString(), context);
    }
  }

  journal() async {
    if (journalPostData.isEmpty) {
      setState(() {
        isLoading = true;
      });

      await Provider.of<PostProvider>(context, listen: false)
          .fetchJournal(count: 10, page: 1, userId: user.id);
      journalPostData =
          Provider.of<PostProvider>(context, listen: false).getJournalPost;
      // categoryAllPost =
      //     Provider.of<PostProvider>(context, listen: false).getCategoryAllPost;

      setState(() {
        isLoading = false;
      });
      // });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      WillPopScope(
        onWillPop: () async {
          Provider.of<PostProvider>(context, listen: false)
              .fetchJournal(count: 10, page: 1, userId: user.id);
          navigationService.navigateTo(MaindeshboardRoute);
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Provider.of<PostProvider>(context, listen: false)
                    .fetchJournal(count: 10, page: 1, userId: user.id);
               Navigator.pop(context);
               // navigationService!.navigateTo(MaindeshboardRoute);
          //     navigationService.navigateTo(MaindeshboardRoute);    // commented by chetu
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black38,
                size: 25.h,
              ),
            ),
            centerTitle: true,
            title: Text(
              "My Journal",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                  Colors.black
              )
            ),
            actions: <Widget>[
              // IconButton(onPressed: (){}, icon: Icon(Icons.search)),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    context.read<AuthProviderr>().tempRoute =
                        "/myjournal-screen";
                    var storageService = locator<StorageService>();
                    await storageService.setData("route", "/myjournal-screen");
                    navigationService.navigateTo(MyProfileScreenRoute);
                  },
                  child: user.profilePicture == "" ||
                          user.profilePicture == null
                      ? CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/place_holder.png"),
                        )
                      : CircleAvatar(
                          backgroundColor: Theme.of(context).backgroundColor,
                          backgroundImage:
                              NetworkImage(user.profilePicture.toString())),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              navigationService.navigateTo(CreateJournalStoryScreenRoute);
            },
            child: Container(
              height: 60.h,
              width: 60.h,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: new LinearGradient(
                    colors: [
                      Colors.orange,
                      Colors.red,
                    ],
                  )),
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
            backgroundColor: Colors.transparent,
            elevation: 2,
          ),
          body: Consumer<PostProvider>(builder: (context, post, child) {
            return post.journalPostData.length == 0 && !isLoading
                ? NoDataYet(title: "No journal yet", image: "Vector.png")
                : Container(
                    padding: EdgeInsets.all(20),
                    child: ListView.builder(
                      controller: _scroll,
                      itemCount: post.journalPostData.length,
                      itemBuilder: (BuildContext context, int i) {
                        return JournalWidget(
                          data: post.journalPostData[i],
                          // callback: callback,
                        );
                      },
                    ),
                  );
          }),
        ),
      ),
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
