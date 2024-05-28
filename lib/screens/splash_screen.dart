import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:mystory_flutter/constant/enum.dart';
import 'package:mystory_flutter/models/appuser.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/category_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/linkStories_familytree&storybook_provider.dart';
import 'package:mystory_flutter/providers/notification_provider.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/services/dynamic_link_service.dart';
import 'package:mystory_flutter/widgets/news_feed_widget_dynamic.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../utils/routes.dart';
import '../services/navigation_service.dart';
import '../utils/service_locator.dart';
// import '../widgets/exit_alert_dialog.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var navigationService = locator<NavigationService>();
  var storageService = locator<StorageService>();
  var dynamicLink = locator<DynamicLinksService>();


  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () async {
      try {
        // await dynamicLink.initDynamicLinks();
        var token =
            await this.storageService.getData(StorageKeys.token.toString());
        SelectTouchId.isTouched = await this
            .storageService
            .getBoolData(StorageKeys.touchID.toString());

        if (token != null) {
          await Provider.of<AuthProviderr>(context, listen: false)
              .refreshToken();
          var user =
              await this.storageService.getData(StorageKeys.user.toString());

          if (user != null) {
            var userData = AppUser.fromJson(user);
            await this
                .storageService
                .getBoolData(StorageKeys.touchID.toString());
            Provider.of<AuthProviderr>(context, listen: false).setuser(userData);
            await Provider.of<AuthProviderr>(context, listen: false)
                .getFCMToken();

            await Provider.of<CategoryProvider>(context, listen: false)
                .fetchAllCategories();
            await Provider.of<InviteProvider>(context, listen: false)
                .fetchAllRelation();
            await context
                .read<LinkFamilyStoryProvider>()
                .userLinkedStories(count: 10, page: 1);
            // await Provider.of<PostProvider>(context, listen: false)
            //     .fetchAllUserPost(user["id"]);
            await Provider.of<NotificationProvider>(context, listen: false)
                .getNotification(user['id']);
            await Provider.of<InviteProvider>(context, listen: false)
                .fetchAllFamilyTree(id: user['id'], count: 10, page: 1);



            if (user["address"]["countryValue"] == "") {
              navigationService.navigateTo(CreaterofileScreenRoute);
            } else {
              final FirebaseFirestore _firestore = FirebaseFirestore.instance;
              final FirebaseAuth _auth = FirebaseAuth.instance;
              await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
                "status": "Online",
              });
              navigationService.navigateTo(MaindeshboardRoute);

              // final PendingDynamicLinkData? initialLink =
              // await FirebaseDynamicLinks.instance.getInitialLink();

             //  if (initialLink != null) {
             //    print("initialLink");
             //    print(initialLink);
             //    final Uri deepLink = initialLink.link;
             //    String postId = deepLink.path;
             //    String userId = deepLink.queryParameters["userId"]!;
             //    locator<NavigationService>()
             //        .navigatorKey
             //        .currentState
             //        ?.push(MaterialPageRoute(
             //        builder: (builder) => NewsFeedWidgetDynamic(
             //            postID: postId.substring(1),
             //            postCreatorID:userId
             //        )));
             // }
            }
            return;
          } else {
            navigationService.navigateTo(LoginScreenRoute);
            return;
          }
        } else {
          navigationService.navigateTo(LoginScreenRoute);
        }
      } catch (err) {
        navigationService.navigateTo(LoginScreenRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Future<bool> _onBackPressed() {
    //   return showDialog(
    //         context: context,
    //         builder: (context) => ExitAlertDialog(),
    //       ) ??
    //       false;
    // }

    return WillPopScope(
      onWillPop: null,
      child: Stack(
          // fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/Splash.jpg'),
                    fit: BoxFit.cover),
              ),
            ),
            // Positioned(
            //   child: Align(
            //       alignment: FractionalOffset.center,
            //       child: Container(
            //         child:
            //             // Container(child: Image.asset('assets/images/logo.png')),
            //             ShowUpAnimation(
            //           delayStart: Duration(milliseconds: 200),
            //           animationDuration: Duration(seconds: 1),
            //           curve: Curves.bounceIn,
            //           direction: Direction.vertical,
            //           offset: 0.7,
            //           child: Image.asset(
            //             'assets/images/splash.jpg',
            //             scale: 3.5,
            //           ),
            //         ),
            //       )),
            // ),
          ]),
    );
  }
  onclick(){

  }
}
