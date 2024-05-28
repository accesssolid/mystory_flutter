// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchModel _$SearchModelFromJson(Map<String, dynamic> json) {
  return SearchModel(
    id: json['id'] as String?,
    firstName: json['firstName'] as String?,
    middleName: json['middleName'] as String?,
    lastName: json['lastName'] as String?,
    givenName: json['givenName'] as String?,
    shortDescription: json['shortDescription'] as String?,
    email: json['email'] as String?,
    contact: json['contact'] as String?,
    profilePicture: json['profilePicture'] as String?,
    fullName: json['fullName'] as String?,
    profileStory: json['profileStory'] as String?,
    homeTown: json['homeTown'] as String?,
    storyBookCount: json['storyBookCount'] as int?,
    treeBookCount: json['treeBookCount'] as int?,
    linkStoryCount: json['linkStoryCount'] as int?,
    inviteStatus: json['inviteStatus'] as String?,
    dob: json['dob'] as String?,
    createdOnDate: json['createdOnDate'] as int?,
  );
}

Map<String, dynamic> _$SearchModelToJson(SearchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'lastName': instance.lastName,
      'givenName': instance.givenName,
      'shortDescription': instance.shortDescription,
      'email': instance.email,
      'contact': instance.contact,
      'profilePicture': instance.profilePicture,
      'fullName': instance.fullName,
      'profileStory': instance.profileStory,
      'homeTown': instance.homeTown,
      'storyBookCount': instance.storyBookCount,
      'treeBookCount': instance.treeBookCount,
      'linkStoryCount': instance.linkStoryCount,
      'inviteStatus': instance.inviteStatus,
      'dob': instance.dob,
      'createdOnDate': instance.createdOnDate,
    };
