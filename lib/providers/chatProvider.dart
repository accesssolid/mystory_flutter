import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:mystory_flutter/providers/auth_provider.dart';

import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:provider/src/provider.dart';

class ChatProvider with ChangeNotifier {
  var utilService = locator<UtilService>();

  String chatRoomId = '';
  String senderId = '';
  String receverId = '';

// unread count start //
  int unreadCount = 0;
  get getUnreadCount {
    return this.unreadCount;
  }

  updateUnreadCount(int count, String message) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .update({
      'lastMessage': message,
      'time': DateTime.now(),
      'members.$senderId.time': DateTime.now(),
      'members.$receverId.unreadCount': ++count,
      'members.$senderId.unreadCount': 0,
    });
  }

  resetUnreadCount(BuildContext context) async {
    print(senderId);
    unreadCount = 0;
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .update({
      'time': DateTime.now(),
      'members.$senderId.time': DateTime.now(),
      'members.$senderId.unreadCount': 0,
    });

    updateLastSeen(senderId);
  }

  updateLastSeen(
    String? userId,
  ) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .get()
        .then((value) async {
      Map<String, dynamic> members =
          value.data()!['members'] as Map<String, dynamic>;
      members.forEach((key, value) async {
        if (value['id'] == userId) {
          value['lastSeen'] = DateTime.now();
          print(key);
          await FirebaseFirestore.instance
              .collection('chats')
              .doc(chatRoomId)
              .update({'members.$key.lastSeen': value['lastSeen']});
          // unreadCount = 0;
          notifyListeners();
        }
      });
    });
  }

  getMessageCount(String chatRoomId, String? userId) async {
    var data = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .get();
    // .then((value) async {
    Map<String, dynamic> currentUserID = data.data()!['members'];
    var lastseen;
    currentUserID.forEach((key, value) {
      if (key == userId) {
        lastseen = value['lastSeen'];
        print(value['lastSeen']);
      }
      // });
    });
    var data2 = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .collection("conversation")
        .where("time", isGreaterThan: lastseen)
        .get();
    this.unreadCount = data2.docs.length;
    notifyListeners();
  }

// unread count End //

  Future getChatPersonProfile() async {
    var memberData;
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .get()
        .then((response) {
      memberData = response.data()!['members'][receverId] ?? '';
    });
    return memberData;
  }


  sendMessage(String message) async {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .collection('conversation')
        .add({
      'message': message.trim(),
      'senderId': senderId,
      'type': 'text',
      'time': DateTime.now(),
      // 'unreadCount': 0,
    });
    FirebaseFirestore.instance.collection('chats').doc(chatRoomId).update({
      'lastMessage': message,
      'time': DateTime.now(),
      'members.$senderId.time': DateTime.now(),
      // 'unreadCount': 0,
    });
    await getMessageCount(chatRoomId, receverId);
    updateLastSeen(senderId);
  }

  Future sendMediaMessage(String url,
      {String message = '',
      String type = 'image',
      BuildContext? context}) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .collection('conversation')
        .add({
      'message': message.trim(),
      'url': url,
      'senderId': senderId,
      'type': type,
      'time': DateTime.now(),
    });
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .update({
      'lastMessage': message == ''
          ? type == 'image'
              ? 'image'
              : type == 'video'
                  ? 'video'
                  : 'audio'
          : message,
      'time': DateTime.now(),
      'members.$senderId.time': DateTime.now(),
    });
    updateLastSeen(senderId);
  }

  Future getChatRoomId() async {
    chatRoomId = '';
    await FirebaseFirestore.instance
        .collection('chats')
        .where('members.$senderId.id', isEqualTo: senderId)
        .where('members.$receverId.id', isEqualTo: receverId)
        .get()
        .then((response) {
          print('arso doc');
          print(response);
      print(response.docs.length);
      response.docs.forEach((doc) {
        chatRoomId = doc.id;
      });
    });
    notifyListeners();
    print('get roomid fun $chatRoomId');
  }


  createChatRoom({required var senderUser, required var receiverUser}) {
    FirebaseFirestore.instance
        .collection('chats')
        .where('members.${senderUser['senderId']}.id',
            isEqualTo: senderUser['senderId'])
        .where('members.${receiverUser.id.toString()}.id',
            isEqualTo: receiverUser.id.toString())
        .get()
        .then((response) {
      if (response.docs.length == 0) {
        FirebaseFirestore.instance.collection('chats').add({
          'time': DateTime.now(),
          'lastMessage': "",
          'members': {
            senderUser['senderId']: {
              'id': senderUser['senderId'],
              'name': senderUser['firstName'] + ' ' + senderUser['lastName'],
              'profile': senderUser['profilePicture'],
              'relation': senderUser['relation'],
              'time': DateTime.now(),
              'unreadCount': 0,
            },
            receiverUser.id.toString(): {
              'id': receiverUser.id.toString(),
              'name': receiverUser.firstName.toString() +
                  ' ' +
                  receiverUser.lastName.toString(),
              'profile': receiverUser.profilePicture.toString(),
              'relation': receiverUser.relation,
              'time': DateTime.now(),
              'unreadCount': 0,
            },
          },
        });
      }
    });
  }

  createChatRoom2({required var senderUser, required var receiverUser}) async{
    FirebaseFirestore.instance
        .collection('chats')
        .where('members.${senderUser.id.toString()}.id',
        isEqualTo: senderUser.id.toString())
        .where('members.${receiverUser['id']}.id',
        isEqualTo: receiverUser['id'])
        .get()
        .then((response) {
      if (response.docs.length == 0) {
        FirebaseFirestore.instance.collection('chats').add({
          'time': DateTime.now(),
          'lastMessage': "",
          'members': {
            senderUser.id: {
              'id': senderUser.id,
              'name': senderUser.firstName.toString() +
                  ' ' +
                  senderUser.lastName.toString(),
              'profile': senderUser.profilePicture.toString(),
              'relation': senderUser.relation,
              'time': DateTime.now(),
              'unreadCount': 0,
            },
            receiverUser['id']: {
              'id': receiverUser['id'],
              'name': receiverUser['firstName'] +
                  ' ' +
                  receiverUser['lastName'],
              'profile': receiverUser['profilePicture'],
              'relation': receiverUser['relation'],
              'time': DateTime.now(),
              'unreadCount': 0,
            },
          },
        }).then((_)async{
         await FirebaseFirestore.instance
              .collection('chats')
              .where('members.${senderUser.id.toString()}.id',
              isEqualTo: senderUser.id.toString())
              .where('members.${receiverUser['id']}.id',
              isEqualTo: receiverUser['id'])
              .get().then((response)async{
                chatRoomId = await response.docs.first.id;
                print(response.docs.first.id);
                print('arso doc length ${response.docs.length}');
          });
        });
      }
    });
  }


}
