// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appuser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) {
  return AppUser(
    // userImages: json['userImages'] as List<dynamic>?,
    // userVideos: json['userVideos'] as List<dynamic>?,
    storyBookCount: json['storyBookCount'] as int?,
    treeBookCount: json['treeBookCount'] as int?,
    linkStoryCount: json['linkStoryCount'] as int?,
    firstName: json['firstName'] as String?,
    lastName: json['lastName'] as String?,
    fullName: json['fullName'] as String?,
    id: json['id'] as String?,
    email: json['email'] as String?,
    isEmailVerified: json['isEmailVerified'] as bool?,
    dob: json['dob'] as String?,
    profilePicture: json['profilePicture'] as String?,
    isPremium: json['isPremium'] as bool?,
    lastNotificationReadTime: json['lastNotificationReadTime'] as int?,
    package: json['package'] as Map<String, dynamic>?,
    middleName: json['middleName'] as String?,
    givenName: json['givenName'] as String?,
    homeTown: json['homeTown'] as String?,
    shortDescription: json['shortDescription'] as String?,
    relation: json['relation'] as String?,
    address: json['address'],

    // userMediaImages: json['userMediaImages'] as List<dynamic>?,
    // userMediaVideos: json['userMediaVideos'] as List<dynamic>?,
    notificationSettting: json['notificationSettting'],
    pushNotificationsSetting: json['pushNotificationsSetting'],
  );
}

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'fullName': instance.fullName,
      'id': instance.id,
      'email': instance.email,
      'isEmailVerified': instance.isEmailVerified,
      'dob': instance.dob,
      'profilePicture': instance.profilePicture,
      'isPremium': instance.isPremium,
      'lastNotificationReadTime': instance.lastNotificationReadTime,
      'package': instance.package,
      'middleName': instance.middleName,
      'homeTown': instance.homeTown,
      'givenName': instance.givenName,
      'shortDescription': instance.shortDescription,
      'storyBookCount': instance.storyBookCount,
      'treeBookCount': instance.treeBookCount,
      'linkStoryCount': instance.linkStoryCount,
      'address': instance.address,
      // 'userImages': instance.userImages,
      // 'userVideos': instance.userVideos,
      // 'userMediaVideos': instance.userMediaVideos,
      // 'userMediaImages': instance.userMediaImages,
      'pushNotificationsSetting': instance.pushNotificationsSetting,
      'notificationSettting': instance.notificationSettting,
      'relation': instance.relation
    };
