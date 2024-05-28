import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  String? id;
  int? createdOnDate;
  String? receiverId;
  String? receiverName;
  String? userId;
  String? userName;
  String? userProfilePic;
  String? receiverProfilePic;
  String? receiverEmail;
  String? receiverPhoneNumber;
  String? receiverLivesIn;
  int? modifiedOn;
  String? lastMessage;
  int? lastMessagetime;
  List<String>? userIds;
  int? lastReadTimeUser1;
  int? lastReadTimeUser2;

  MessageModel({
    this.id,
    this.createdOnDate,
    this.lastMessage,
    this.lastMessagetime,
    this.modifiedOn,
    this.receiverEmail,
    this.receiverId,
    this.receiverLivesIn,
    this.receiverName,
    this.receiverPhoneNumber,
    this.receiverProfilePic,
    this.userId,
    this.userName,
    this.userProfilePic,
    this.userIds,
    this.lastReadTimeUser1,
    this.lastReadTimeUser2,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}
