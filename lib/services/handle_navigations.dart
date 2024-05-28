import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mystory_flutter/constant/enum.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/news_feed_widget_dynamic.dart';

class HandleLinkNavigation {
  Future<void> handleNavigation(String postId,String userId) async {
    var navigationService = locator<NavigationService>();
    var storageService = locator<StorageService>();
    try {
      var token = await storageService.getData(StorageKeys.token.toString());
      SelectTouchId.isTouched =
      await storageService.getBoolData(StorageKeys.touchID.toString());

      if (token != null) {
        var user = await storageService.getData(StorageKeys.user.toString());
        if (user != null) {
          await storageService.getBoolData(StorageKeys.touchID.toString());

          if (user["address"]["countryValue"] == "") {
            navigationService.navigateTo(CreaterofileScreenRoute);
          } else {
            final FirebaseFirestore _firestore = FirebaseFirestore.instance;
            final FirebaseAuth _auth = FirebaseAuth.instance;
            await _firestore
                .collection('users')
                .doc(_auth.currentUser!.uid)
                .update({
              "status": "Online",
            });
            locator<NavigationService>()
                .navigatorKey
                .currentState
                ?.push(MaterialPageRoute(
                builder: (builder) => NewsFeedWidgetDynamic(
                  postID: postId.substring(1),
                  postCreatorID:userId
                )));
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
  }

}