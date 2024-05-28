import 'package:json_annotation/json_annotation.dart';

part 'appuser.g.dart';

// ignore: deprecated_member_use
@JsonSerializable(nullable: false)
class AppUser {
  String? firstName;
  String? lastName;
  String? fullName;
  String? status;
  String? id;
  String? email;
  bool? isEmailVerified = false;
  String? dob;
  String? profilePicture;
  bool? isPremium = false;
  int? lastNotificationReadTime = 0;
  Map<String, dynamic>? package;
  String? middleName;
  String? homeTown;
  String? givenName;
  String? shortDescription;
  String? relation;

  // dynamic relation;

  int? storyBookCount;
  int? treeBookCount;
  int? linkStoryCount;
  var address;

  // List? userImages;
  // List? userVideos;

  // List? userMediaVideos;
  // List? userMediaImages;

  var pushNotificationsSetting;

  var notificationSettting;

  AppUser(
      {
      //   this.userImages,
      // this.userVideos,
      this.relation,
      this.storyBookCount,
      this.treeBookCount,
      this.linkStoryCount,
      this.firstName,
      this.lastName,
      this.fullName,
      this.id,
      this.email,
      this.isEmailVerified,
      this.dob,
      this.profilePicture,
      this.isPremium,
      this.lastNotificationReadTime,
      this.package,
      this.middleName,
      this.givenName,
      this.homeTown,
      this.shortDescription,
      this.address,

      // this.userMediaImages,
      // this.userMediaVideos,
      this.notificationSettting,
      this.pushNotificationsSetting});

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
