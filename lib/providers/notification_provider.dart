import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:mystory_flutter/services/http_service.dart';
import 'package:mystory_flutter/utils/service_locator.dart';

class NotificationProvider with ChangeNotifier {
  List<Map<String, dynamic>> notifications = [];
  // List<Map<String, dynamic>> likesData = [];
  List<Map<String, dynamic>> inviteNotifications = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? notificationSub;
  bool _isNewNotification = false;
  HttpService http = locator<HttpService>();

  setNewNotification({bool? flag, String? userId}) async {
    this._isNewNotification = false;

    await FirebaseFirestore.instance.collection("users").doc(userId).update(
      {"lastNotificationReadTime": DateTime.now().millisecondsSinceEpoch},
    );
    notifyListeners();
  }

  get newNotification {
    return this._isNewNotification;
  }

  setClearNotificationIcon(bool value) {
    this._isNewNotification = value;
    notifyListeners();
  }

  setToNull() {
    this.notifications = [];
    this.inviteNotifications = [];
  }

  get userNotification {
    if (this.notifications != null) {
      return [
        //  this.notifications.toList().removeWhere((item) => item["isActive"] == false )
        ...this.notifications.toList()
      ];
    } else {
      return null;
    }
  }

  // get userNotification {
  //   if (this.notifications != null) {
  //     this.notifications = []; // ahsan changes
  //     return [...this.notifications.toList()];
  //   } else {
  //     return null;
  //   }
  // }

  getById(String id) {
    for (var i = 0; i < this.notifications.length; i++) {
      if (this.notifications[i]["id"] == id) {
        return this.notifications[i];
      }
    }
    return null;
  }

  removeNotification(String notId) {
    this.notifications.removeWhere((element) => element['id'] == notId);
    notifyListeners();
  }

  removeInviteNotifications(String notId) {
    this.inviteNotifications.removeWhere((element) => element['id'] == notId);
    notifyListeners();
  }

  // Future responseNotification({
  //   String notificationId,
  //   String reactionType,
  // }) async {
  //   try {
  //     var response =
  //         await this.http.responseNotification(notificationId, reactionType);
  //     // print(response);
  //   } catch (e) {
  //     // print(e);
  //   }
  // }

  removeAllNotifications() {
    this.notifications = [];
    this.inviteNotifications = [];
  }

  // getLikes(String postId) async {
  //   if (this.likesData.length == 0) {
  //     this.likesData = [];
  //   }
  //   await FirebaseFirestore.instance.collection("post").doc(postId).get();
  // }

  getNotification(String userId) async {
    if (this.notifications.length == 0) {
      this.notifications = [];
    }

    notificationSub = FirebaseFirestore.instance
        .collection('notifications')
        .where("userId", isEqualTo: userId)
    // .where("isActive", isEqualTo: true)
    // .orderBy('createdOnDate')
        .snapshots()
        .listen(
          (data) => data?.docs?.forEach((doc) async {
            print('arso docs length');
            print(data.docs.length);
        var dt = doc.data();
        var index = this
            .notifications
            .indexWhere((element) => element['id'] == dt['id']);
        if (index == -1) {
          var user = await FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .get();
          try {
            var usr = user.data();
            if (usr!["lastNotificationReadTime"] < dt['createdOnDate']) {
              this._isNewNotification = true;
            }
          } catch (err) {
            print(err);
          }
          // if (dt['id'] != "" && dt['type'] == "invite" && dt['data']['linkedStatus'] == 'pending') {
          //
          //     inviteNotifications.insert(0, {
          //       'type': dt['type'],
          //       'id': dt['id'],
          //       'profilePicture': dt['data']['sender']['profilePicture'],
          //       'inviteId': dt['data']['id'],
          //       'firstName': dt['data']['sender']['firstName'],
          //       'lastName': dt['data']['sender']['lastName'],
          //       'middleName': dt['data']['sender']['middleName'],
          //       'message': dt['message'],
          //       'userId': dt['userId'],
          //       'senderId': dt['data']['sender']['id'],
          //       "relation": dt['data']['relation']['relationName'],
          //       'date': DateFormat.yMMMd().format(
          //           DateTime.fromMillisecondsSinceEpoch(
          //               dt['createdOnDate'])),
          //       'createdOnDate': dt['createdOnDate']
          //       // timeago.format(
          //       //     DateTime.fromMillisecondsSinceEpoch(dt['createdOnDate'])),
          //     });
          //
          // }
          // notifyListeners();
          if (dt['id'] != "" && dt['type'] == "like") {
            notifications.insert(0, {
              'type': dt['type'],
              'id': dt['id'],
              'userId': dt['userId'],
              'message': dt['message'],
              'profilePicture': dt['icon'],
              'firstName': dt['data']["addedByName"],
              'postId': dt['data']["postId"],
              // 'lastName': dt['data']['reciever']['lastName'],
              // 'middleName': dt['data']['reciever']['middleName'],

              'date': DateFormat.yMMMd().format(
                  DateTime.fromMillisecondsSinceEpoch(dt['createdOnDate'])),
              'createdOnDate': dt['createdOnDate']
              // timeago.format(
              //     DateTime.fromMillisecondsSinceEpoch(dt['createdOnDate'])),
            });
          }

          notifyListeners();
          if (dt['id'] != "" && dt['type'] == "comment") {
            notifications.insert(0, {
              'type': dt['type'],
              'id': dt['id'],
              'userId': dt['userId'],
              'message': dt['message'],
              'profilePicture': dt['icon'],
              'firstName': dt['data']["addedByName"],
              'postId': dt['data']["postId"],
              // 'lastName': dt['data']['reciever']['lastName'],
              // 'middleName': dt['data']['reciever']['middleName'],

              'date': DateFormat.yMMMd().format(
                  DateTime.fromMillisecondsSinceEpoch(dt['createdOnDate'])),
              'createdOnDate': dt['createdOnDate']
              // timeago.format(
              //     DateTime.fromMillisecondsSinceEpoch(dt['createdOnDate'])),
            });
          }

          notifyListeners();
          if (dt['id'] != "" && dt['type'] == "invite-approved") {
            notifications.insert(0, {
              'type': dt['type'],
              'id': dt['id'],
              'userId': dt['userId'],
              'message': dt['message'],
              'profilePicture': dt['icon'],
              'firstName': dt['data']['reciever']['firstName'],
              'lastName': dt['data']['reciever']['lastName'],
              'middleName': dt['data']['reciever']['middleName'],
              'recieverId': dt['data']['reciever']['id'],

              'date': DateFormat.yMMMd().format(
                  DateTime.fromMillisecondsSinceEpoch(dt['createdOnDate'])),
              'createdOnDate': dt['createdOnDate']
              // timeago.format(
              //     DateTime.fromMillisecondsSinceEpoch(dt['createdOnDate'])),
            });
          }

          notifyListeners();
        }
        else {
          if (dt['id'] != "" && dt['type'] == "invite") {
            if (dt['data']['linkedStatus'] == 'pending') {
              print(dt['data']['linkedStatus']);
              this.notifications[index]['type'] = dt['type'];
              this.notifications[index]['firstName'] = dt['firstName'];
              this.notifications[index]['middleName'] = dt['middleName'];
              this.notifications[index]['lastName'] = dt['lastName'];
              this.notifications[index]['inviteId'] = dt['data']['id'];
              this.notifications[index]['id'] = dt['id'];
              this.notifications[index]['data']['profilePicture'] =
              dt['data']['profilePicture'];
              this.notifications[index]['message'] = dt['message'];
              this.notifications[index]['userId'] = dt['userId'];
              this.notifications[index]['data']['relation']
              ['relationName'] = dt['data']['relation']['relationName'];
              // this.notifications[index]['senderId'] = dt['senderId'];

              this.notifications[index]['createdOnDate'] =
              dt['createdOnDate'];
              // timeago.format(
              //     DateTime.fromMillisecondsSinceEpoch(dt['createdOnDate']));
              this.notifications[index]['date'] = DateFormat.yMMMd().format(
                  DateTime.fromMillisecondsSinceEpoch(dt['createdOnDate']));
            }
          }
          notifyListeners();
          if (dt['id'] != "" && dt['type'] == "like") {
            this.notifications[index]['type'] = dt['type'];
            this.notifications[index]['id'] = dt['id'];
            this.notifications[index]['userId'] = dt['userId'];
            this.notifications[index]['message'] = dt['message'];
            this.notifications[index]['icon'] = dt['icon'];
            this.notifications[index]['postId'] = dt['postId'];

            this.notifications[index]['data']['addedByName'] =
            dt['data']['addedByName'];

            this.notifications[index]['createdOnDate'] =
            dt['createdOnDate'];
            // timeago.format(
            //     DateTime.fromMillisecondsSinceEpoch(dt['createdOnDate']));
            this.notifications[index]['date'] = DateFormat.yMMMd().format(
                DateTime.fromMillisecondsSinceEpoch(dt['createdOnDate']));
          }
          notifyListeners();
          if (dt['id'] != "" && dt['type'] == "comment") {
            this.notifications[index]['type'] = dt['type'];
            this.notifications[index]['id'] = dt['id'];
            this.notifications[index]['userId'] = dt['userId'];
            this.notifications[index]['message'] = dt['message'];
            this.notifications[index]['icon'] = dt['icon'];

            this.notifications[index]['data']['addedByName'] =
            dt['data']['addedByName']??"";
            this.notifications[index]['postId'] = dt['postId'];
            this.notifications[index]['createdOnDate'] =
            dt['createdOnDate'];
            // timeago.format(
            //     DateTime.fromMillisecondsSinceEpoch(dt['createdOnDate']));
            this.notifications[index]['date'] = DateFormat.yMMMd().format(
                DateTime.fromMillisecondsSinceEpoch(dt['createdOnDate']));
          }
          notifyListeners();

          if (dt['id'] != "" && dt['type'] == "invite-approved") {
            this.notifications[index]['type'] = dt['type'];
            this.notifications[index]['id'] = dt['id'];
            this.notifications[index]['userId'] = dt['userId'];

            this.notifications[index]['message'] = dt['message'];
            this.notifications[index]['profilePicture'] = dt['icon'];
            this.notifications[index]['data']['reciever']['id'] =
            dt['data']['reciever']['id'];

            this.notifications[index]['data']['reciever']['firstName'] =
            dt['data']['reciever']['firstName'];
            this.notifications[index]['data']['reciever']['lastName'] =
            dt['data']['reciever']['lastName'];

            this.notifications[index]['data']['reciever']['middleName'] =
            dt['data']['reciever']['middleName'];

            this.notifications[index]['createdOnDate'] =
            dt['createdOnDate'];
            // timeago.format(
            //     DateTime.fromMillisecondsSinceEpoch(dt['createdOnDate']));
            this.notifications[index]['date'] = DateFormat.yMMMd().format(
                DateTime.fromMillisecondsSinceEpoch(dt['createdOnDate']));
          }
          notifyListeners();
        }
      }),
    );
  }
}