// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return MessageModel(
    id: json['id'] as String?,
    createdOnDate: json['createdOnDate'] as int?,
    lastMessage: json['lastMessage'] as String?,
    lastMessagetime: json['lastMessagetime'] as int?,
    modifiedOn: json['modifiedOn'] as int?,
    receiverEmail: json['receiverEmail'] as String?,
    receiverId: json['receiverId'] as String?,
    receiverLivesIn: json['receiverLivesIn'] as String?,
    receiverName: json['receiverName'] as String?,
    receiverPhoneNumber: json['receiverPhoneNumber'] as String?,
    receiverProfilePic: json['receiverProfilePic'] as String?,
    userId: json['userId'] as String?,
    userName: json['userName'] as String?,
    userProfilePic: json['userProfilePic'] as String?,
    userIds:
        (json['userIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
    lastReadTimeUser1: json['lastReadTimeUser1'] as int?,
    lastReadTimeUser2: json['lastReadTimeUser2'] as int?,
  );
}

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdOnDate': instance.createdOnDate,
      'receiverId': instance.receiverId,
      'receiverName': instance.receiverName,
      'userId': instance.userId,
      'userName': instance.userName,
      'userProfilePic': instance.userProfilePic,
      'receiverProfilePic': instance.receiverProfilePic,
      'receiverEmail': instance.receiverEmail,
      'receiverPhoneNumber': instance.receiverPhoneNumber,
      'receiverLivesIn': instance.receiverLivesIn,
      'modifiedOn': instance.modifiedOn,
      'lastMessage': instance.lastMessage,
      'lastMessagetime': instance.lastMessagetime,
      'userIds': instance.userIds,
      'lastReadTimeUser1': instance.lastReadTimeUser1,
      'lastReadTimeUser2': instance.lastReadTimeUser2,
    };
