import 'package:json_annotation/json_annotation.dart';

part 'search_model.g.dart';

@JsonSerializable()
class SearchModel {
  String? id;
  String? firstName;
  String? middleName;
  String? lastName;
  String? givenName;
  String? shortDescription;
  String? email;
  String? contact;

  String? profilePicture;
  String? fullName;

  String? profileStory;

  String? homeTown;

  int? storyBookCount;
  int? treeBookCount;
  int? linkStoryCount;
  String? inviteStatus;
  String? dob;
  int? createdOnDate;

  SearchModel({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.givenName,
    this.shortDescription,
    this.email,
    this.contact,
    this.profilePicture,
    this.fullName,
    this.profileStory,
    this.homeTown,
    this.storyBookCount,
    this.treeBookCount,
    this.linkStoryCount,
    this.inviteStatus,
    this.dob,
    this.createdOnDate,
  });
  // "notificationSettings": {
  //     "newStory": true,
  //     "storybookLikes": true,
  //     "chat": true,
  //     "inappNotifications": true,
  //     "acceptedLink": true,
  //     "admin": true,
  //     "pendingInvitaions": true,
  //     "linkedRequests": true
  // },

  // "address": {
  //     "countryValue": "Japan",
  //     "stateValue": "Japan State",
  //     "cityValue": "Tokyo"
  // },

  // "searchKey": "S",
  // "isActive": true,
  // "isBlock": false,
  // "isEmailVerified": false,
  // "loginSource": "default",
  // "createdOnDate": 1642516019405,

  factory SearchModel.fromJson(Map<String, dynamic> json) =>
      _$SearchModelFromJson(json);
  Map<String, dynamic> toJson() => _$SearchModelToJson(this);
}
