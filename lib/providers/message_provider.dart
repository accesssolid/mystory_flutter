import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mystory_flutter/models/message.dart' as mess;
import 'package:mystory_flutter/models/message_count.dart';
import 'package:mystory_flutter/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class MessageProvider with ChangeNotifier {
  List<MessageModel>? _chats;
  MessageModel? _currentChat;
  List<MessageCount>? _messageCount;
  List<mess.Message>? _currentChatMessages;
  bool newMessage = false;
  var _currentChatId;
  var chatId = "";
  List<Map<String, dynamic>> chatData = [];
  setClearMessageIcon(bool value) {
    this.newMessage = value;
    // notifyListeners();
  }

  MessageModel get currentChat {
    return _currentChat!;
  }

  bool get isNewMessage {
    return this.newMessage;
  }

  setNewMessage(bool data) {
    this.newMessage = data;
    // notifyListeners();
  }

  setIsNewMessageNotification(bool val) {
    this.newMessage = val;
  }

  setNewMessageReceived(bool msg) {
    this.newMessage = msg;
  }

  get getCurrentChatId {
    return this._currentChatId;
  }

  setNewMessageStatus(bool data) {}

  List<mess.Message> get currentChatMessages {
    if (this._currentChatMessages != null) {
      return [...this._currentChatMessages!];
    } else {
      return this._currentChatMessages!;
    }
  }

  removeCurrentChat() {
    this._currentChat = null;
    notifyListeners();
  }

  setCurrentChat(MessageModel message) {
    this._currentChat = MessageModel();
    this._currentChat!.id = message.id;
    this._currentChat!.receiverId = message.receiverId;
    this._currentChat!.receiverName = message.receiverName;
    this._currentChat!.receiverProfilePic = message.receiverProfilePic;
    this._currentChat!.userId = message.userId;
    this._currentChat!.userName = message.userName;
    this._currentChat!.userProfilePic = message.userProfilePic;
    this._currentChat!.createdOnDate = message.createdOnDate;
    this._currentChat!.lastMessage = message.lastMessage;
    this._currentChat!.userIds = [message.userId!, message.receiverId!];
    notifyListeners();
  }

  List<MessageModel> get chats {
    if (this._chats != null) {
      return [..._chats!];
    } else {
      return this._chats!;
    }
  }

  get messageCounts {
    if (_messageCount != null) {
      return [...this._messageCount!];
    } else {
      return null;
    }
  }

  clearData() {
    this._chats = [];
    this._currentChatMessages = [];
  }

  deleteUserChat(String chatId) {
    this._chats!.removeWhere((item) => item.id == chatId);
    this._currentChatMessages = [];
  }

  setFlagFalse() {
    this.newMessage = false;
  }

  markAsRead(String chatId, String userId) async {
    var index =
        this._messageCount!.indexWhere((element) => element.id == chatId);
    var chatData =
        await FirebaseFirestore.instance.collection("chats").doc(chatId).get();
    var temp = chatData.data();
    if (temp!["userId"] == userId) {
      await FirebaseFirestore.instance.collection("chats").doc(chatId).set(
          {"lastReadTimeUser1": DateTime.now().millisecondsSinceEpoch},
          SetOptions(merge: true));
      this._messageCount![index].unreadCount = 0;
    } else {
      await FirebaseFirestore.instance.collection("chats").doc(chatId).set(
          {"lastReadTimeUser2": DateTime.now().millisecondsSinceEpoch},
          SetOptions(merge: true));
      this._messageCount![index].unreadCount = 0;
    }
    notifyListeners();
  }

  getMessageCount(String userId) {
    if (_messageCount == null) {
      this._messageCount = [];
    }
    FirebaseFirestore.instance
        .collection("chats")
        .where("userIds", arrayContains: userId)
        .snapshots()
        .listen((event) {
      event.docChanges.forEach((element) async {
        if (element.newIndex != -1 && element.newIndex < 1000) {
          var elementData = element.doc.data();
          var index = this
              ._messageCount!
              .indexWhere((item) => item.id == element.doc["id"]);
          if (index == -1) {
            var messageCount = MessageCount();
            messageCount.id = element.doc.id;
            messageCount.unreadCount = 0;

            if (userId == elementData!["userId"] &&
                elementData["lastReadTimeUser1"] != null) {
              var data = await FirebaseFirestore.instance
                  .collection('chats')
                  .doc(element.doc.id)
                  .collection("conversation")
                  .where("createdOnDate",
                      isGreaterThan: elementData["lastReadTimeUser1"])
                  .get();
              messageCount.unreadCount = data.docs.length;
              if (data.docs.length > 0) {
                this.newMessage = true;
              }
            } else if (userId == elementData["receiverId"] &&
                elementData["lastReadTimeUser2"] != null) {
              var data = await FirebaseFirestore.instance
                  .collection('chats')
                  .doc(element.doc.id)
                  .collection("conversation")
                  .where("createdOnDate",
                      isGreaterThan: elementData["lastReadTimeUser2"])
                  .get();
              messageCount.unreadCount = data.docs.length;
              if (data.docs.length > 0) {
                this.newMessage = true;
              }
            }
            _messageCount!.add(messageCount);
          } else {
            if (userId == elementData!["userId"] &&
                elementData["lastReadTimeUser1"] != null) {
              var data = await FirebaseFirestore.instance
                  .collection('chats')
                  .doc(element.doc.id)
                  .collection("conversation")
                  .where("createdOnDate",
                      isGreaterThan: elementData["lastReadTimeUser1"])
                  .get();
              this._messageCount![index].unreadCount = data.docs.length;
              if (data.docs.length > 0) {
                this.newMessage = true;
              }
            } else if (userId == elementData["receiverId"] &&
                elementData["lastReadTimeUser2"] != null) {
              var data = await FirebaseFirestore.instance
                  .collection('chats')
                  .doc(element.doc.id)
                  .collection("conversation")
                  .where("createdOnDate",
                      isGreaterThan: elementData["lastReadTimeUser2"])
                  .get();
              this._messageCount![index].unreadCount = data.docs.length;
              if (data.docs.length > 0) {
                this.newMessage = true;
              }
            }
          }
        } else {
          this._messageCount!.removeWhere((item) => item.id == element.doc.id);
        }
        notifyListeners();
      });
    });
  }

  getSingleMessageCount(String messageId) {
    try {
      if (messageId != null) {
        var message =
            _messageCount!.firstWhere((element) => element.id == messageId);
        return message.unreadCount;
      }
      return 0;
    } catch (err) {
      print(err);
      return 0;
    }
  }

  fetchCurrentChatMessages(String? chatId) {
    if (this._currentChatMessages == null) {
      this._currentChatMessages = [];
    } else {
      this._currentChatMessages = [];
    }

    FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .collection("conversation")
        .snapshots()
        .listen((event) {
      event.docChanges.forEach((element) {
        var index = this
            ._currentChatMessages!
            // ignore: deprecated_member_use
            .indexWhere((item) => item.id == element.doc.id);
        if (index == -1) {
          var data = element.doc.data();
          var temp = mess.Message();
          temp.id = element.doc.id;
          temp.createdOnDate = data!["createdOnDate"];
          temp.messageMediaUrl = data["messageMediaUrl"];
          temp.messageText = data["messageText"];
          temp.senderId = data["senderId"];
          temp.messageMediaUrl = data['messageMediaUrl'];
          temp.messageMediaType = data['messageMediaType'];
          this._currentChatMessages!.add(temp);
        } else {
          var data = element.doc.data();
          this._currentChatMessages![index].id = element.doc.id;
          this._currentChatMessages![index].createdOnDate =
              data!["createdOnDate"];
          this._currentChatMessages![index].messageMediaUrl =
              data["messageMediaUrl"];
          this._currentChatMessages![index].messageText = data["messageText"];
          this._currentChatMessages![index].senderId = data["senderId"];
          this._currentChatMessages![index].messageMediaType =
              data['messageMediaType'];
          this._currentChatMessages![index].messageMediaUrl =
              data['messageMediaUrl'];
        }
        this
            ._currentChatMessages!
            .sort((a, b) => b.createdOnDate! - a.createdOnDate!);

        notifyListeners();
      });
    });
  }

  listenToMessages(String userId) {
    if (this._chats == null) {
      this._chats = [];
    }
    // ignore: deprecated_member_use
    FirebaseFirestore.instance
        .collection("chats")
        .where("userId", isEqualTo: userId)
        .snapshots()
        .listen((data) {
      // ignore: deprecated_member_use
      data.docChanges.forEach((element) {
        var index = this
            ._chats!
            // ignore: deprecated_member_use
            .indexWhere((item) => item.id == element.doc.id);
        if (index == -1) {
          var data = element.doc.data();

          var tempMessage = MessageModel();
          // ignore: deprecated_member_use
          if (element.doc.id != null) {
            tempMessage.id = element.doc.id;
            tempMessage.receiverId = data!["receiverId"];
            tempMessage.receiverName = data["receiverName"];
            tempMessage.receiverProfilePic = data["receiverProfilePic"];
            tempMessage.userId = data["userId"];
            tempMessage.userName = data["userName"];
            tempMessage.userProfilePic = data["userProfilePic"] ?? "";
            tempMessage.createdOnDate = data["createdOnDate"];
            tempMessage.lastMessage = data["lastMessage"] ?? "";
            tempMessage.lastMessagetime =
                data["lastMessagetime"] != null ? data["lastMessagetime"] : 0;
            this._chats!.add(tempMessage); // ye new chat la ta hai

          }

          notifyListeners();
        } else {
          var data = element.doc.data();
          if (element.doc.data() != null) {
            this._chats![index].id = element.doc.id;
            this._chats![index].receiverId = data!["receiverId"];
            this._chats![index].receiverName = data["receiverName"];
            this._chats![index].receiverProfilePic = data["receiverProfilePic"];
            this._chats![index].userId = data["userId"];
            this._chats![index].userName = data["userName"];
            this._chats![index].userProfilePic = data["userProfilePic"];
            this._chats![index].createdOnDate = data["createdOnDate"];
            this._chats![index].lastMessage = data["lastMessage"];
            this._chats![index].lastMessagetime =
                data["lastMessagetime"] != null ? data["lastMessagetime"] : 0;
          }
        }
        this._chats!.sort((a, b) => b.createdOnDate! - a.createdOnDate!);

        notifyListeners();
      });
    });

    FirebaseFirestore.instance
        .collection("chats")
        .where("receiverId", isEqualTo: userId)
        .snapshots()
        .listen((data) {
      // ignore: deprecated_member_use
      data.docChanges.forEach((element) {
        var index = this
            ._chats!
            // ignore: deprecated_member_use
            .indexWhere((item) => item.id == element.doc.id);
        if (index == -1) {
          var data = element.doc.data();
          var tempMessage = MessageModel();
          if (element.doc.id != null) {
            tempMessage.id = element.doc.id;
            tempMessage.receiverId = data!["receiverId"];
            tempMessage.receiverName = data["receiverName"];
            tempMessage.receiverProfilePic = data["receiverProfilePic"];
            tempMessage.userId = data["userId"];
            tempMessage.userName = data["userName"];
            tempMessage.userProfilePic = data["userProfilePic"] ?? "";
            tempMessage.createdOnDate = data["createdOnDate"];
            tempMessage.lastMessage = data["lastMessage"] ?? "";
            tempMessage.lastMessagetime =
                data["lastMessagetime"] != null ? data["lastMessagetime"] : 0;
            this._chats!.add(tempMessage); // ye new chat la ta hai

          }
          // ignore: deprecated_member_use

        } else {
          var data = element.doc.data();

          if (element.doc.id != null) {
            this._chats![index].id = element.doc.id;
            this._chats![index].receiverId = data!["receiverId"];
            this._chats![index].receiverName = data["receiverName"];
            this._chats![index].receiverProfilePic = data["receiverProfilePic"];
            this._chats![index].userId = data["userId"];
            this._chats![index].userName = data["userName"];
            this._chats![index].userProfilePic = data["userProfilePic"];
            this._chats![index].createdOnDate = data["createdOnDate"];
            this._chats![index].lastMessage = data["lastMessage"];
            this._chats![index].lastMessagetime =
                data["lastMessagetime"] != null ? data["lastMessagetime"] : 0;

            //  if (_currentChatMessages!.first.senderId != userId) {

            //    this.newMessage = true;}
          }
        }
        this._chats!.sort((a, b) => b.createdOnDate! - a.createdOnDate!);

        notifyListeners();
      });
    });
  }

  checkIfChatExists(userId, receiverId) async {
    var data = await FirebaseFirestore.instance
        .collection("chats")
        .where("userId", isEqualTo: userId)
        .where("receiverId", isEqualTo: receiverId)
        .get();
    if (data.docs.length > 0) {
      data.docs.forEach((e) {
        var data = e.data();
        if (data['userId'] == userId && data['receiverId'] == receiverId) {
          this._currentChatId = e.id;
        }
      });
      return true;
    } else {
      var data2 = await FirebaseFirestore.instance
          .collection("chats")
          .where("userId", isEqualTo: receiverId)
          .where("receiverId", isEqualTo: userId)
          .get();
      if (data2.docs.length > 0) {
        if (data2.docs.length > 0) {
          data2.docs.forEach((e) {
            var data = e.data();
            if (data['userId'] == userId && data['receiverId'] == receiverId) {
              this._currentChatId = e.id;
            }
            // if()
          });
          return true;
        }
      } else {
        return null;
      }
    }
  }

  addNewChat(MessageModel message) async {
    chatId = DateTime.now().millisecondsSinceEpoch.toString();

    MessageModel tempMessage = MessageModel();
    tempMessage.userId = message.userId;
    tempMessage.userName = message.userName;
    tempMessage.userProfilePic = message.userProfilePic;
    tempMessage.receiverProfilePic = message.receiverProfilePic;
    tempMessage.receiverName = message.receiverName;
    tempMessage.createdOnDate = message.createdOnDate;
    tempMessage.receiverId = message.receiverId;
    tempMessage.lastMessage = null;
    tempMessage.userIds = [message.userId!, message.receiverId!];
    tempMessage.lastReadTimeUser1 = 0;
    tempMessage.lastReadTimeUser2 = 0;

    await FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .set(tempMessage.toJson());

    chatId = "";

    this._currentChat!.id = message.id;
    this._currentChat!.receiverId = message.receiverId;
    this._currentChat!.receiverName = message.receiverName;
    this._currentChat!.receiverProfilePic = message.receiverProfilePic;
    this._currentChat!.userId = message.userId;
    this._currentChat!.userName = message.userName;
    this._currentChat!.userProfilePic = message.userProfilePic;
    this._currentChat!.createdOnDate = message.createdOnDate;
    this._currentChat!.lastMessage = null;
    this._currentChat!.userIds = [message.userId!, message.receiverId!];
    this._currentChat!.lastReadTimeUser1 = 0;
    this._currentChat!.lastReadTimeUser2 = 0;

    notifyListeners();
  }

  sendMessage(String chatId, mess.Message item) async {
    try {
      Map<String, dynamic> data = {
        "id": item.id,
        "createdOnDate": item.createdOnDate,
        "messageMediaUrl": item.messageMediaUrl ?? "",
        "messageText": item.messageText,
        "senderId": item.senderId,
        "messageMediaType": item.messageMediaType ?? ""
      };
      // ignore: deprecated_member_use
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(chatId)
          .collection("conversation")
          .doc(item.id)
          .set(data, SetOptions(merge: true));
      await FirebaseFirestore.instance.collection("chats").doc(chatId).set({
        "lastMessage": item.messageText,
        "modifiedOn": DateTime.now().millisecondsSinceEpoch
      }, SetOptions(merge: true));
    } catch (err) {
      // print(err);
    }
  }
}
