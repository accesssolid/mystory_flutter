// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:crypto/crypto.dart';
import 'package:mystory_flutter/constant/enum.dart';
import 'package:mystory_flutter/global.dart';
import 'package:mystory_flutter/models/appuser.dart';
import 'package:mystory_flutter/models/email_invite.dart';
import 'package:mystory_flutter/models/relationship_model.dart';
import 'package:mystory_flutter/providers/category_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/notification_provider.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/screens/change_password_sucessfully_screen.dart';
import 'package:mystory_flutter/screens/login_screen.dart';
import 'package:mystory_flutter/screens/maindeshboard_screen.dart';

import 'package:mystory_flutter/services/firebase_service.dart';
import 'package:mystory_flutter/services/http_service.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'linkStories_familytree&storybook_provider.dart';

class AuthProviderr with ChangeNotifier {
  NavigationService? navigationService = locator<NavigationService>();
  UtilService? utilService = locator<UtilService>();
  LocalAuthentication authentication = LocalAuthentication();
  StorageService? storageService = locator<StorageService>();
  HttpService? http = locator<HttpService>();
  FirebaseService? _firebase = locator<FirebaseService>();
  AppUser? _user;
  List<Data> _relationShip = [];


  List<QueryDocumentSnapshot<Object?>> allUserDataList = [];

  List<Data> get getRelationShip => _relationShip;
  bool isFirsttime = true;
  bool isLoadingProgress = false;
  String? tempRoute = "";
  List userImages = [];
  int loadingprogress=0;
  List userVideos = [];

  // Map<String, dynamic> userMediaListData = {};
  String? token;

  // ignore: unused_field
  String? _password;

  // bool? touchId;
  String? phoneNumber;
  bool _isRemeber = false;
  bool _touchIdRemeber = false;
  Map<String, String> latlng = {};
  Map<String, dynamic> createProfiledata = {};
  Map<String, dynamic> userProfileData = {};
  Map<String, dynamic> updateProfilesdata = {};
  Map<String, dynamic> updatedata = {};
  var _searchUserDetail;
  String? _accessToken;
  String? _googleId;
  String? _googleToken;

  get getUserImages {
    return this.userImages;
  }

  get getLoadingProgress{
    return this.loadingprogress;
  }

  get getUserVideos {
    return this.userVideos;
  }

  // set addContact(AddContact userInfo) {
  //   this.userContactInfo = userInfo;
  // }
  setSplashTempRoute() {
    this.isFirsttime = false;
  }

  get getSplashTempRoute {
    return this.isFirsttime;
  }

  get user {
    return this._user;
  }

  setuser(AppUser user) {
    this._user = user;
  }

  // setRelationShip(Data relation) {
  //   this._relationShip = relation;
  // }

  bool get loader {
    return this.isLoadingProgress;
  }

  setIsRemeber(bool val) async {
    await this.storageService!.setBoolData('isRemember', val);
    this._isRemeber = val;
  }

  setLoadingProgresss(int val)async{
    print("IN setLoadingProgresss $val");
    this.loadingprogress=val;
    notifyListeners();
  }

  Future<bool> getIsRemember() async {
    var data = await this.storageService!.getBoolData('isRemember');
    return data ?? false;
  }

  setEnableTouch(bool val) async {
    await this.storageService!.setBoolData(StorageKeys.touchID.toString(), val);
    this._touchIdRemeber = val;
  }

  Future<bool> getEnableTouch() async {
    var data =
        await this.storageService!.getBoolData(StorageKeys.touchID.toString());
    return data ?? false;
  }

// Touch Id //
//   setTouchIdRemeber(bool val) async {
//     await this.storageService!.setBoolData('touchIdRemember', val);
//     this._isRemeber = val;
//   }

// // Touch Id //
//   Future<bool> getTouchIdRemember() async {
//     var data = await this.storageService!.getBoolData('touchIdRemember');
//     return data ?? false;
//   }

  setisLoadingProgress(bool check) {
    this.isLoadingProgress = check;
    notifyListeners();
  }

  Future<void> resendVerificationEmail(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var user = _auth.currentUser!;
    user.sendEmailVerification();
    utilService!.showToast("A verification email has been sent.", context);
  }

  Future<void> fetchRelationShip() async {
    try {
      var response = await this.http!.getRelationShip();

      if (response == null || response.data["isSuccess"] == false) {
        return;
      }

      RelationShipModel arso = RelationShipModel.fromJson(response.data);
      arso.data!.forEach((element) {
        _relationShip.add(element);
        print('arso data here');
        print(element.address);
      });
      notifyListeners();
    } catch (error) {
      throw (error);
    }
    return;
  }

  Future<void> signinWithEmailAndPassword(
      {String? email, String? password, BuildContext? context}) async {
    var result;
    print("aaya yaha");
    try {
      this._password = password;
      await storageService!
          .setData(StorageKeys.password.toString(), this._password);
      await storageService!.setData(StorageKeys.touchEmail.toString(), email);
      await storageService!
          .setData(StorageKeys.touchPassword.toString(), this._password);

      var dataIsremember = await storageService!.haveData('isRemember');
      // var dataEnableTouch =
      //     await storageService!.haveData(StorageKeys.touchID.toString());
      if (dataIsremember) {
        this._isRemeber = await storageService!.getBoolData('isRemember');
      }

      // this._touchIdRemeber =
      //     await storageService!.getBoolData(StorageKeys.touchID.toString());

      // Touch ID //
      // var dataTouchIdremember =
      //     await storageService!.haveData('touchIdRemember');
      // if (dataTouchIdremember) {
      //   this._isRemeber = await storageService!.getBoolData('touchIdRemember');
      // }
print("\n\n\n\n\=========================...");
      final user =
          await _firebase!.signinWithEmailAndPassword(email!, password!);
      var token = await user.getIdToken();
      print(user.uid);
      print(user);
      print("token new $token");
      await this
          .storageService!
          .setData(StorageKeys.token.toString(), token.toString());
      this.token = token.toString();
      var response = await this.http!.getUserById(user.uid);
      print("aaaaaa=    a====a     aaa==========\n\n\n");
      print(response.data);
      print("aaaaaa=    a====a     aaa==========\n\n\n");
      result = response.data;
      print("result user");
      print(result);
      print(result['data']['relation']);
      if (user.emailVerified) {
        this._user = AppUser(
          email: user.email,
          id: user.uid,
          firstName: result['data']['firstName'].toString(),
          lastName: result['data']['lastName'].toString(),
          fullName: result['data']['fullName'].toString(),
          relation: result['data']['relation'].toString(),
          profilePicture: result['data']['profilePicture'],
          linkStoryCount: result['data']['linkStoryCount'],
          storyBookCount: result['data']['storyBookCount'],
          treeBookCount: result['data']['treeBookCount'],
          notificationSettting: result['data']['notificationSettings'],
        );

        if (this._isRemeber) {
          await this.storageService!.setData("userEmail", this._user!.email);
          await this.storageService!.setData("password", this._password);
          await this.storageService!.setBoolData("rememberMe", this._isRemeber);
        } else {
          await this.storageService!.setBoolData("rememberMe", this._isRemeber);
        }
        await fetchRelationShip();
        await Provider.of<NotificationProvider>(context!, listen: false)
            .getNotification(this._user!.id!);
        await Provider.of<CategoryProvider>(context, listen: false)
            .fetchAllCategories();
        await Provider.of<InviteProvider>(context, listen: false)
            .fetchAllRelation();
        await context
            .read<LinkFamilyStoryProvider>()
            .userLinkedStories(count: 10, page: 1);
        await Provider.of<InviteProvider>(context, listen: false)
            .fetchAllFamilyTree(id: this._user!.id!, count: 10, page: 1);
        // TOUCH ID //
        // if (this._touchIdRemeber) {

        //   await this.storageService!.setBoolData("touchRemember", this._touchIdRemeber);
        // } else {
        //   await this.storageService!.setBoolData("touchRemember", this._touchIdRemeber);
        // }

        this._user!.isEmailVerified = user.emailVerified;

        this._user!.fullName = result['data']['fullName'];
        this._user!.dob = result['data']['dob'];
        this._user!.email = result['data']['email'];
        this._user!.firstName = result['data']['firstName'];
        this._user!.lastName = result['data']['lastName'];
        this._user!.profilePicture = result['data']['profilePicture'];
        this._user!.address = result['data']['address'];
        this._user!.homeTown = result['data']['homeTown'];
        this._user!.shortDescription = result['data']['shortDescription'];
        this._user!.givenName = result['data']['givenName'];

        this._user!.middleName = result['data']['middleName'];

        this._user!.storyBookCount = result['data']['storyBookCount'];

        this._user!.treeBookCount = result['data']['treeBookCount'];

        this._user!.linkStoryCount = result['data']['linkStoryCount'];
        this._user!.relation = result['data']['relation'];
        this._user!.notificationSettting =
            result['data']['notificationSettings'];
        this.storageService!.setData(StorageKeys.user.toString(), this._user);
        await this.getFCMToken();
        if (this._user!.profilePicture != "") {
          changeOnlineStatus("Online");
          navigationService!.navigateTo(MaindeshboardRoute);
        } else {
          navigationService!.navigateTo(CreaterofileScreenRoute);
        }

        return;
      } else {
        await _firebase!.sendEmailVerification(context!);
        this._user = AppUser(
          email: email,
          id: user.uid,
          // fullName: user.displayName,
        );

        navigationService!.navigateTo(EmailVerificationScreenRoute);
        return;
      }
    } on FirebaseAuthException catch (err) {
      print("COMING HEREEE======= $err");
      if (err.code == 'user-not-found') {
        utilService!.showToast('Invalid email.', context!);
      } else if (err.code == 'too-many-requests') {
        utilService!.showToast(
            "We have blocked all requests from this device due to unusual activity. Try again later.",
            context!);
      } else if (err.code == 'email-already-in-use') {
        utilService!.showToast(
            "The email address is already in use by another account.",
            context!);
      } else if (err.code == 'wrong-password') {
        utilService!.showToast('Invalid password.', context!);
      } else if (user == null)
        utilService!.showToast(err.toString(), context!);
      else
        utilService!.showToast(err.toString(), context!);
    }
  }

  Future<void> createUserWithEmailPassword({
    required String? email,
    required String? password,
    required String? firstName,
    required String? lastName,
    required String? date,
    String? searchKey,
    BuildContext? context,
  }) async {
    try {
      final user =
          await _firebase!.createUserWithEmailAndPassword(email!, password!);
      var token = await user.getIdToken();
      await this
          .storageService!
          .setData(StorageKeys.token.toString(), token.toString());
      this._user = AppUser(
        id: user.uid,
        email: user.email,
        firstName: firstName,
        fullName: firstName![0].toUpperCase() +
            firstName +
            " " +
            lastName![0].toUpperCase() +
            lastName,
        lastName: lastName,
        dob: date,
      );
      print("a");
      print(
        {
          "id": user.uid,
          "email": user.email,
          "firstName": firstName,
          "lastName": lastName,
          // "searchKey":searchKey,
          "dob": date,
          "fullName": firstName[0].toUpperCase() +
              firstName.substring(1) +
              " " +
              lastName[0].toUpperCase() +
              lastName.substring(1),
        },
      );

      await this.http!.signUp(
        {
          "id": user.uid,
          "email": user.email,
          "firstName": firstName,
          "lastName": lastName,
          // "searchKey":searchKey,
          "dob": date,
          "fullName": firstName[0].toUpperCase() +
              firstName.substring(1) +
              " " +
              lastName[0].toUpperCase() +
              lastName.substring(1),
        },
      );
      await user!.sendEmailVerification(); // ye uncommitn ho ga
      navigationService!.navigateTo(EmailVerificationScreenRoute);
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        utilService!.showToast('Invalid email.', context!);
      } else if (err.code == 'too-many-requests') {
        utilService!.showToast(
            "We have blocked all requests from this device due to unusual activity. Try again later.",
            context!);
      } else if (err.code == 'email-already-in-use') {
        utilService!.showToast(
            "The email address is already in use by another account.",
            context!);
      } else if (err.code == 'wrong-password') {
        utilService!.showToast('Invalid password.', context!);
      } else if (user == null)
        utilService!.showToast(err.toString(), context!);
      else
        utilService!.showToast(err.toString(), context!);
    }
  }

  Future signUpUser(BuildContext context) async {
    try {
      await _firebase!.sendEmailVerification(context);
      navigationService!.navigateTo(EmailVerificationScreenRoute);
    } on FirebaseAuthException catch (err) {
      utilService!.showToast(err.message.toString(), context);
    }
  }

  refreshToken() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var user = _auth.currentUser!;
    var token = await user.getIdToken(true);
    await storageService!.setData(StorageKeys.token.toString(), token);
  }

  Future<void> getFCMToken() async {
    try {
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
      _firebaseMessaging.requestPermission();
      _firebaseMessaging.setForegroundNotificationPresentationOptions(
        sound: true,
        badge: true,
        alert: true,
      );
      String? token = await _firebaseMessaging.getToken();
      print("\n\n============TOKEN check ==========\n\n");

      LogPrint(token!);
      print("\n\n============TOKEN check ==========\n\n");
      Map<String, dynamic> data = {
        "fcmToken": token,
        "userId": this._user!.id,
        "type": Platform.isAndroid ? "android" : "ios"
      };
      await this.http!.registerDevice(data);
    } catch (err) {
      print(err);
    }
  }
  static void LogPrint(Object object) async {
    int defaultPrintLength = 1020;
    if (object == null || object.toString().length <= defaultPrintLength) {
      print(object);
    } else {
      String log = object.toString();
      int start = 0;
      int endIndex = defaultPrintLength;
      int logLength = log.length;
      int tmpLogLength = log.length;
      while (endIndex < logLength) {
        print(log.substring(start, endIndex));
        endIndex += defaultPrintLength;
        start += defaultPrintLength;
        tmpLogLength -= defaultPrintLength;
      }
      if (tmpLogLength > 0) {
        print(log.substring(start, logLength));
      }
    }
  }
  Future<void> changePassword(
      {String? oldPassword, String? newPassword, BuildContext? context}) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final user = await _firebase!
          .signinWithEmailAndPassword(this._user!.email!, oldPassword!);
      await user.updatePassword(newPassword);
      showDialog(
          context: context!,
          barrierDismissible: false,
          builder: (_) {
            return ChangePasswordSuccessfullyScreen(
              title: 'Successfully changed your password',
              routeName: MaindeshboardRoute,
            );
          });
      // navigationService!.navigateTo(ResetPasswordSuccessfullyScreenRoute);
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        utilService!.showToast('Invalid password.', context!);
      } else if (err.code == 'wrong-password') {
        utilService!.showToast("The old password is invalid.", context!);
      } else {
        utilService!.showToast(err.toString(), context!);
      }
    }
  }

  Future<void> forgotPassword(String email, BuildContext context) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      await _auth.sendPasswordResetEmail(email: email);
      utilService!.showToast(
          "An email has been sent please follow the instructions and recover your password.",
          context);
      navigationService!.navigateTo(LoginScreenRoute);
    } catch (err) {
      utilService!.showToast(err.toString(), context);
    }
  }

// Search Screen  //

  setDataForUserDetail(var data) {
    this._searchUserDetail = data;
  }

  get getUserDetailData {
    return this._searchUserDetail;
  }

// create profile information //

  get getUserProfile {
    return this.userProfileData;
  }

  setUserProfile(var data) {
    this.userProfileData = data;
  }

  Future<void> createProfileInformation({
    String? profilePic,
    String? firstName,
    String? lastName,
    String? emailAddress,
    String? middleName,
    String? givenName,
    String? shortDescription,
    String? homeTown,
    String? dateOfBirth,
    var location,
    String? searchKey,
    BuildContext? context,
  }) async {
    try {
      createProfiledata = {
        "id": this.user.id,
        "profilePicture": profilePic,
        "firstName": firstName![0].toUpperCase() + firstName.substring(1),
        "lastName": lastName![0].toUpperCase() + lastName.substring(1),
        "email": emailAddress,
        "middleName": middleName,
        "givenName": givenName,
        "shortDescription": shortDescription,
        "homeTown": homeTown,
        "dob": dateOfBirth,
        "address": location,
        "searchKey": searchKey!.toUpperCase(),
        // "user": user,
      };
      print("createProfiledata");
      print(createProfiledata);
      var response =
          await this.http!.createProfileInformation(createProfiledata);
      var result = response.data;
      this._user = AppUser.fromJson(result['data']);
      //set notification settings;
      this._user!.notificationSettting = result['data']['notificationSettings'];
      print(
          'User Notitification Settings: ${this._user!.notificationSettting}');
      await this
          .storageService!
          .setData(StorageKeys.user.toString(), this._user);

      // notifyListeners();
      // this.userProfileData = {
      //   // "id": result['data']['id'],
      //   "profilePicture": result['data']['profilePicture'],
      //   "firstName": result['data']['firstName'],
      //   "lastName": result['data']['lastName'],
      //   "email": result['data']['email'],
      //   "middleName": result['data']['middleName'],
      //   "givenName": result['data']['givenName'],
      //   "shortDescription": result['data']['shortDescription'],
      //   "homeTown": result['data']['homeTown'],
      //   "dob": result['data']['dob'],
      //   "address": result['data']['address'],
      // };
      // await this
      //     .storageService!
      //     .setData(StorageKeys.user.toString(), this.userProfileData);
      notifyListeners();
      navigationService!.navigateTo(MaindeshboardRoute);
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  Future<bool> removeFamilyMember({var data, BuildContext? context}) async {
    print("data");
    print(data);
    try {
      var response =
          await this.http!.removeFamilyMemberRelationship(data: data);
      notifyListeners();
      //    utilService!.showToast(response.data["message"], context!);    // commented for change worng message from backend chetu.
      utilService!.showToast("Removed successfully.", context!);
      //     return response.data["isSuccess"];   // commented for change worng message from backend chetu
      return true;
    } catch (err) {
      Navigator.pop(context!);
      return false;
    }
  }

  Future<bool> deleteUser(
      {required EmailInvite emailInvite, BuildContext? context}) async {
    print("userEmailID");
    print(emailInvite);
    Map<String, dynamic> data = {
      'to': emailInvite.to,
      'message': emailInvite.message,
    };
    try {
      var response = await this
          .http!
          .deleteUserAccountRequestToAdmin(EmailInvite.fromJson(data));
      notifyListeners();
      utilService!.showToast("Request sent successfully.", context!);
      return response.data["isSuccess"];
    } catch (err) {
      Navigator.pop(context!);
      return false;
    }
  }

  Future<void> addFamilyMemberManually(
      {String? profilePic,
      String? firstName,
      String? lastName,
      String? description,
      String? middleName,
      String? dateOfBirth,
      String? homeTown,
      Map<String, String>? relation,
      BuildContext? context,
      var location,
      Map<String, dynamic>? data}) async {
    try {
      final familyMemberData;
      if (data!.isEmpty) {
        familyMemberData = {
          "profilePicture": profilePic,
          "firstName": firstName![0].toUpperCase() + firstName.substring(1),
          "lastName": lastName![0].toUpperCase() + lastName.substring(1),
          "description": description,
          "middleName": middleName ?? "",
          "dob": dateOfBirth,
          "address": location,
          "relation": relation,
          "homeTown": homeTown
        };
      } else {
        familyMemberData = {
          "id": data["id"],
          "userID": "",
          "profilePicture": profilePic,
          "firstName": firstName![0].toUpperCase() + firstName.substring(1),
          "lastName": lastName![0].toUpperCase() + lastName.substring(1),
          "description": description,
          "middleName": middleName ?? "",
          "dob": dateOfBirth,
          "address": location,
          "relation": relation,
          "homeTown": homeTown
        }; // implemented by chetu.
      }
      var response = await this.http!.addFamilyMemberManually(familyMemberData);
      var result = response.data;
      utilService!.showToast(response.data["message"], context!);
      notifyListeners();
      //  Navigator.pop(context,familyMemberData);
      // navigationService!.navigateTo(MaindeshboardRoute);
      Navigator.push(context,
          MaterialPageRoute(builder: (builder) => MainDashboardScreen(3)));
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  Future<void> updateProfile(
      {String? profilePic,
      String? firstName,
      String? lastName,
      String? emailAddress,
      String? middleName,
      String? givenName,
      String? shortDescription,
      String? homeTown,
      String? dateOfBirth,
      var location,
      String? searchKey,
      BuildContext? context,
      var user}) async {
    var response;
    try {
      updateProfilesdata = {
        "id": this.user.id,
        "profilePicture": profilePic,
        "firstName": firstName![0].toUpperCase() + firstName.substring(1),
        "lastName": lastName![0].toUpperCase() + lastName.substring(1),
        "email": emailAddress,
        "middleName": middleName,
        "givenName": givenName,
        "fullName":
            "${firstName![0].toUpperCase() + firstName.substring(1)} ${lastName![0].toUpperCase() + lastName.substring(1)}",
        "shortDescription": shortDescription,
        "homeTown": homeTown,
        "dob": dateOfBirth,
        "address": location,
        "searchKey": searchKey!.toUpperCase(),
        //  "relation": {"id": "", "relationName": ""}
        "relation": ""
      };

      print(updateProfilesdata);
      response = await this.http!.editProfileInformation(updateProfilesdata);
      var result = response.data;
      this._user = AppUser.fromJson(result['data']);
      this._user!.notificationSettting = result['data']['notificationSettings'];
      await this
          .storageService!
          .setData(StorageKeys.user.toString(), this._user);

      // this.updatedata = {
      //   "id": result['data']['id'],
      //   "profilePicture": result['data']['profilePicture'],
      //   "firstName": result['data']['firstName'],
      //   "lastName": result['data']['lastName'],
      //   "email": result['data']['email'],
      //   "middleName": result['data']['middleName'],
      //   "givenName": result['data']['givenName'],
      //   "shortDescription": result['data']['shortDescription'],
      //   "homeTown": result['data']['homeTown'],
      //   "dob": result['data']['dob'],
      //   "address": result['data']['address'],
      // };
      // await this.storageService!.setData('updatedata', this.updatedata);
      notifyListeners();
      navigationService!.navigateTo(MyProfileScreenRoute);
      utilService!.showToast(response.data["message"].toString(), context!);
    } catch (err) {
      print(err);
      print(response);
      if (err is DioError) {
        if (err.response?.statusCode == 500) {
          var response = await this.http!.getUserById(this.user.id);
          var result = response.data;
          AppUser _user = AppUser.fromJson(result['data']);
          _user.notificationSettting = result['data']['notificationSettings'];
          this._user = AppUser.fromJson(result['data']);
          this._user!.notificationSettting =
              result['data']['notificationSettings'];
          await this
              .storageService!
              .setData(StorageKeys.user.toString(), this._user);
          notifyListeners();
          navigationService!.navigateTo(MyProfileScreenRoute);
          utilService!.showToast("Profile updated successfully.", context!);
        } else {
          utilService!.showToast(err.toString(), context!);
        }
      } else {
        utilService!.showToast(err.toString(), context!);
      }
    }
  }

// Notification permistion Enable or Disable //

  get getNotificationStatus {
    return _user!.pushNotificationsSetting;
  }

  Future<void> notificationPermision(
      var notificationPermisiton, BuildContext context) async {
    try {
      var response =
          await this.http!.notificationPermision(notificationPermisiton);
      print(this._user!.id);
      var u = await this.http!.getUserById(this._user!.id!);
      var result = u.data;

      this._user = this._user = AppUser.fromJson(result['data']);
      this._user!.notificationSettting = result['data']['notificationSettings'];
      //     AppUser(
      //   email: result['data']['email'],
      //   id: result['data']['id'],
      //   firstName: result['data']['firstName'].toString(),
      //   lastName: result['data']['lastName'].toString(),
      //   fullName: result['data']['fullName'].toString(),
      //   profilePicture: result['data']['profilePicture'],
      //   notificationSettting: result['data']['notificationSettings'],
      // );
      await this
          .storageService!
          .setData(StorageKeys.user.toString(), this._user);

      notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context);
    }
  }

  // End Create or update user //

  changeOnlineStatus(String status) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  getAllUserData() async {
    //* method created by chetu
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("users").get();
    allUserDataList = querySnapshot.docs;
    // userDataListFiltered = querySnapshot.docs;
  }

  Future<void> logoutFirebaseUser(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    var sharedPreferences = await SharedPreferences.getInstance();
    // stopStream();
    try {
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
      _firebaseMessaging.requestPermission(
          //     const IosNotificationSettings(sound: true, badge: true, alert: true));
          // _firebaseMessaging.onIosSettingsRegistered
          //     .listen((IosNotificationSettings settings) {
          //   print("Settings registered: $settings");
          //
          // }
          );

      _firebaseMessaging.setForegroundNotificationPresentationOptions(
        sound: true,
        badge: true,
        alert: true,
      );
      String? token = await _firebaseMessaging.getToken();
      var data = {
        "UserId": this._user!.id,
        "DeviceId": token,
        "type": Platform.isAndroid ? "android" : "ios"
      };

      context.read<PostProvider>().clearNewsFeedPost();
      context.read<CategoryProvider>().clearSubCategoryDataHomeScreen();
      context.read<PostProvider>().clearalldata();
      context.read<InviteProvider>().clearInviteProviderData();
      _relationShip = [];
      await this.http!.unRegisterDevice(data);
      changeOnlineStatus("Offline");
      var rememberMe = await this.storageService!.getBoolData("rememberMe");
      // await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      //   "status": "Offline",
      // });
      String? emai =
          await this.storageService!.getData(StorageKeys.touchEmail.toString());
      String? pass = await this
          .storageService!
          .getData(StorageKeys.touchPassword.toString());
      if (rememberMe ?? false) {
        sharedPreferences.remove("StorageKeys.token");
        sharedPreferences.remove("StorageKeys.facebooktoken");
        sharedPreferences.remove("StorageKeys.user");

        // sharedPreferences.remove("route");
      } else {
        await sharedPreferences.clear();
        sharedPreferences.remove("StorageKeys.user");
        // Provider.of(context). dispose();
      }
      await storageService!.setData(StorageKeys.touchEmail.toString(), emai);
      await storageService!.setData(StorageKeys.touchPassword.toString(), pass);
    } catch (err) {
      print(err);
    }

    // Navigator.pushReplacement<void, void>(
    //   // this use is account switch problem
    //   context,
    //   MaterialPageRoute<void>(
    //     builder: (BuildContext context) => LogInScreen(),
    //   ),
    // );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (builder) => LogInScreen()),
      (route) => true,
    );
    // Provider.of(context). dispose();
  }

  // Facebook auth //

  // Future<void> signinWithfacebook(BuildContext? context) async {
  //   try {
  //     final FirebaseAuth _auth = FirebaseAuth.instance;
  //
  //     final LoginResult fbResult = await FacebookAuth.instance.login(
  //       permissions: [
  //         'public_profile',
  //         'email',
  //       ],
  //     ); // by default we request the email and the public profile
  //     // if (result.status == LoginStatus.success) {
  //     //   // you are logged
  //     //   final AccessToken? accessToken = result.accessToken;
  //     // }
  //
  //     this._accessToken = fbResult.accessToken!.token;
  //     await storageService!.setData("facebooktoken", this._accessToken);
  //     AuthCredential credential =
  //         FacebookAuthProviderr.credential(fbResult.accessToken!.token);
  //     print(fbResult);
  //     var user = await _auth.signInWithCredential(credential);
  //
  //     this._user = AppUser(
  //         email: user.user!.email,
  //         fullName: user.user!.displayName,
  //         id: user.user!.uid,
  //         profilePicture: user.user!.photoURL);
  //     this._user!.isEmailVerified = user.user!.emailVerified;
  //
  //     var token = await user.user!.getIdToken();
  //     this.token = token;
  //     this.storageService!.setData(StorageKeys.token.toString(), this.token);
  //     this.storageService!.setData(StorageKeys.user.toString(), this._user);
  //     await this.getFCMToken();
  //
  //     await this.http!.signUp({
  //       "email": user.user!.email,
  //       "fullName": user.user!.displayName,
  //       "id": user.user!.uid.toString(),
  //     });
  //
  //     // app state for facebook login
  //     var dataIsremember = await storageService!.haveData('isRemember');
  //     if (dataIsremember) {
  //       this._isRemeber = await storageService!.getBoolData('isRemember');
  //     }
  //     this.storageService!.setData(StorageKeys.token.toString(), this.token);
  //     var userByIdData = await this.http!.getUserById(user.user!.uid);
  //     var result = userByIdData.data;
  //     await Provider.of<NotificationProvider>(context!, listen: false)
  //         .getNotification(this._user!.id!);
  //     await Provider.of<CategoryProvider>(context, listen: false)
  //         .fetchAllCategories();
  //     await Provider.of<InviteProvider>(context, listen: false)
  //         .fetchAllRelation();
  //     await context
  //         .read<LinkFamilyStoryProvider>()
  //         .userLinkedStories(count: 10, page: 1);
  //     await Provider.of<InviteProvider>(context, listen: false)
  //         .fetchAllFamilyTree(id: this._user!.id!, count: 10, page: 1);
  //     this._user!.fullName = result['data']['fullName'];
  //     this._user!.dob = result['data']['dob'];
  //     this._user!.email = result['data']['email'];
  //     this._user!.firstName = result['data']['firstName'];
  //     this._user!.lastName = result['data']['lastName'];
  //     this._user!.profilePicture = result['data']['profilePicture'];
  //     this._user!.address = result['data']['address'];
  //     this._user!.homeTown = result['data']['homeTown'];
  //     this._user!.shortDescription = result['data']['shortDescription'];
  //     this._user!.givenName = result['data']['givenName'];
  //
  //     this._user!.middleName = result['data']['middleName'];
  //     this._user!.storyBookCount = result['data']['storyBookCount'];
  //
  //     this._user!.treeBookCount = result['data']['treeBookCount'];
  //
  //     this._user!.linkStoryCount = result['data']['linkStoryCount'];
  //     this._user!.relation = result['data']['relation'];
  //     this._user!.notificationSettting = result['data']['notificationSettings'];
  //     await this.getFCMToken();
  //     this.storageService!.setData(StorageKeys.user.toString(), this._user);
  //     if (this._isRemeber) {
  //       await this.storageService!.setData("userEmail", this._user!.email);
  //
  //       await this.storageService!.setBoolData("rememberMe", this._isRemeber);
  //     } else {
  //       await this.storageService!.setBoolData("rememberMe", this._isRemeber);
  //     }
  //
  //     if (this._user!.dob == null || this._user!.dob == '') {
  //       navigationService!.navigateTo(CreaterofileScreenRoute);
  //     } else {
  //       navigationService!.navigateTo(MaindeshboardRoute);
  //     }
  //   } catch (err) {
  //     this._user = null;
  //     print(err);
  //     utilService!.showToast(err.toString(), context!);
  //   }
  // }

// Google SIGN IN KA Function //

  Future<void> googleAuthProvider(BuildContext? context) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final GoogleSignIn? _googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      if (await _googleSignIn!.isSignedIn()) {
        _googleSignIn.disconnect();
      }
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      this._googleId = googleAuth.idToken;
      this._googleToken = googleAuth.accessToken;
      await storageService!.setData("googleId", this._googleId);
      await storageService!.setData("googleToken", this._googleToken);
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final user = await _auth.signInWithCredential(credential);
      print("signed in " + user.user!.displayName!);

      this._user = AppUser(
          email: user.user!.email,
          fullName: user.user!.displayName,
          id: user.user!.uid,
          profilePicture: user.user!.photoURL);
      this._user!.isEmailVerified = user.user!.emailVerified;
      // if (user.user.phoneNumber != null) {
      //   this._user.contact = user.user.phoneNumber;
      // }
      var token = await user.user!.getIdToken();
      this.token = token;
      this.storageService!.setData(StorageKeys.token.toString(), this.token);
      this.storageService!.setData(StorageKeys.user.toString(), this._user);
      await this.getFCMToken();

      await this.http!.signUp({
        "email": user.user!.email,
        "fullName": user.user!.displayName,
        "id": user.user!.uid.toString(),
      });

      // app state for facebook login
      var dataIsremember = await storageService!.haveData('isRemember');
      if (dataIsremember) {
        this._isRemeber = await storageService!.getBoolData('isRemember');
      }
      this.storageService!.setData(StorageKeys.token.toString(), this.token);
      var userByIdData = await this.http!.getUserById(user.user!.uid);
      var result = userByIdData.data;
      await Provider.of<NotificationProvider>(context!, listen: false)
          .getNotification(this._user!.id!);
      await Provider.of<CategoryProvider>(context, listen: false)
          .fetchAllCategories();
      await Provider.of<InviteProvider>(context, listen: false)
          .fetchAllRelation();
      await context
          .read<LinkFamilyStoryProvider>()
          .userLinkedStories(count: 10, page: 1);
      await Provider.of<InviteProvider>(context, listen: false)
          .fetchAllFamilyTree(id: this._user!.id!, count: 10, page: 1);
      this._user!.fullName = result['data']['fullName'];
      this._user!.dob = result['data']['dob'];
      this._user!.email = result['data']['email'];
      this._user!.firstName = result['data']['firstName'];
      this._user!.lastName = result['data']['lastName'];
      this._user!.profilePicture = result['data']['profilePicture'];
      this._user!.address = result['data']['address'];
      this._user!.homeTown = result['data']['homeTown'];
      this._user!.shortDescription = result['data']['shortDescription'];
      this._user!.givenName = result['data']['givenName'];

      this._user!.middleName = result['data']['middleName'];
      this._user!.storyBookCount = result['data']['storyBookCount'];

      this._user!.treeBookCount = result['data']['treeBookCount'];

      this._user!.linkStoryCount = result['data']['linkStoryCount'];
      this._user!.relation = result['data']['relation'];
      this._user!.notificationSettting = result['data']['notificationSettings'];
      await this.getFCMToken();
      this.storageService!.setData(StorageKeys.user.toString(), this._user);
      if (this._isRemeber) {
        await this.storageService!.setData("userEmail", this._user!.email);

        await this.storageService!.setBoolData("rememberMe", this._isRemeber);
      } else {
        await this.storageService!.setBoolData("rememberMe", this._isRemeber);
      }

      if (this._user!.dob == null || this._user!.dob == '') {
        navigationService!.navigateTo(CreaterofileScreenRoute);
      } else {
        navigationService!.navigateTo(MaindeshboardRoute);
      }

      //end of app state for facebook login
      // navigationService.navigateTo(MainDashboardScreenRoute);
      // print(response);
    } catch (err) {
      this._user = null;
      utilService!.showToast(err.toString(), context!);
    }
  }

  Future<void> localAuth({BuildContext? context}) async {
    List<BiometricType> listSeb = await authentication.getAvailableBiometrics();
    print(listSeb);
    var result;
    // final baseUrl = "https://mystory-app-9a032.firebaseapp.com/mystory/api/v1/";

    // bool isAutherized = false;

    try {
      var isLogin = false;
      await authentication
          .authenticate(
        localizedReason: "Please verify your access for use app",
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        )

            // localizedReason: "Scane face to authenticate",
            //localizedReason: "SCAN YOUR FINGER PRINT TO GET AUTHORIZED",
            //useErrorDialogs: true,
            //stickyAuth: false,
          )
          .then((value) => {isLogin = value});

      if (isLogin) {
        String? email = await this
            .storageService!
            .getData(StorageKeys.touchEmail.toString());
        String? password = await this
            .storageService!
            .getData(StorageKeys.touchPassword.toString());
        final user =
            await _firebase!.signinWithEmailAndPassword(email!, password!);
        var token = await user.getIdToken();
        await this
            .storageService!
            .setData(StorageKeys.token.toString(), token.toString());
        this.token = token.toString();
        print(user.uid);
        // var response = await http!.get(baseUrl + "user/userDetails/${user.uid}");
        var response = await this.http!.getUserById(user.uid);
        result = response.data;
        this._user = AppUser(
          email: user.email,
          id: user.uid,
          firstName: result['data']['firstName'].toString(),
          lastName: result['data']['lastName'].toString(),
          fullName: result['data']['fullName'].toString(),
          profilePicture: result['data']['profilePicture'],
          linkStoryCount: result['data']['linkStoryCount'],
          storyBookCount: result['data']['storyBookCount'],
          treeBookCount: result['data']['treeBookCount'],
          notificationSettting: result['data']['notificationSettings'],
        );
        await Provider.of<NotificationProvider>(context!, listen: false)
            .getNotification(this._user!.id!);
        await Provider.of<CategoryProvider>(context, listen: false)
            .fetchAllCategories();
        await Provider.of<InviteProvider>(context, listen: false)
            .fetchAllRelation();
        await context
            .read<LinkFamilyStoryProvider>()
            .userLinkedStories(count: 10, page: 1);
        await Provider.of<InviteProvider>(context, listen: false)
            .fetchAllFamilyTree(id: this._user!.id!, count: 10, page: 1);
        this._user!.fullName = result['data']['fullName'];
        this._user!.dob = result['data']['dob'];
        this._user!.email = result['data']['email'];
        this._user!.firstName = result['data']['firstName'];
        this._user!.lastName = result['data']['lastName'];
        this._user!.profilePicture = result['data']['profilePicture'];
        this._user!.address = result['data']['address'];
        this._user!.homeTown = result['data']['homeTown'];
        this._user!.shortDescription = result['data']['shortDescription'];
        this._user!.givenName = result['data']['givenName'];

        this._user!.middleName = result['data']['middleName'];

        this._user!.storyBookCount = result['data']['storyBookCount'];

        this._user!.treeBookCount = result['data']['treeBookCount'];

        this._user!.linkStoryCount = result['data']['linkStoryCount'];
        this._user!.relation = result['data']['relation'];
        this._user!.notificationSettting =
            result['data']['notificationSettings'];
        this.storageService!.setData(StorageKeys.user.toString(), this._user);
        await this.getFCMToken();

        // isAutherized =
        navigationService!.navigateTo(MaindeshboardRoute);
      } else {
        return;
      }
    } on PlatformException catch (err) {
      print('arso ${err.code}');
      if (err.code == 'NotAvailable') {
        utilService!
            .showToast('Fingerprint ID / Face ID not registered', context!);
      } else {
        utilService!.showToast(err.toString(), context!);
      }
    }
  }

  Future<void> fetchUserMediaGalleryImages(
      {String? id, int? page, int? count, BuildContext? context}) async {
    try {
      var response =
          await this.http!.userMediaGallery(id!, "image", page!, count!);
      if (response == null) {
        return;
      }

      var data = response.data["data"];

      this.userImages = [];
      // this.userVideos = [];

      for (int i = 0; i < data.length; i++) {
        for (int j = 0; j < data[i]["media"].length; j++) {
          if (data[i]["media"][j]["contentType"] == "image") {
            this.userImages.add({
              "url": data[i]["media"][j]['url'],
              "id": data[i]["id"],
              "createdOnDate": data[i]["createdOnDate"]
            });
          }
        }
      }

      // this._user!.userVideos = this.userVideos;
      // this._user!.userImages = this.userImages;

      notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  Future<void> fetchUserMediaGalleryVideos(
      {String? id, int? page, int? count, BuildContext? context}) async {
    try {
      var response =
          await this.http!.userMediaGallery(id!, "video", page!, count!);
      if (response == null) {
        return;
      }

      var data = response.data["data"];

      this.userVideos = [];

      for (int i = 0; i < data.length; i++) {
        for (int j = 0; j < data[i]["media"].length; j++) {
          if (data[i]["media"][j]["contentType"] == "video") {
            this.userVideos.add({
              "url": data[i]["media"][j]['thumbnail'],
              "id": data[i]["id"],
              "createdOnDate": data[i]["createdOnDate"]
            });
          }
        }
      }

      // this._user!.userVideos = this.userVideos;
      // this._user!.userImages = this.userImages;

      notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  // Future<void> fetchUserMediaGallery old(
  //     {String? id, int? page, int? count}) async {
  //   try {
  //     var response = await this.http!.userMediaGallery(id!, page!, count!);
  //     if (response == null) {
  //       return;
  //     }

  //     var data = response.data["data"];

  //     this.userImages = [];
  //     this.userVideos = [];

  //     for (int i = 0; i < data.length; i++) {
  //       for (int j = 0; j < data[i]["media"].length; j++) {
  //         if (data[i]["media"][j]["contentType"] == "image") {
  //           this.userImages.add({
  //             "url": data[i]["media"][j]['url'],
  //             "id": data[i]["id"],
  //             "createdOnDate": data[i]["createdOnDate"]
  //           });
  //         } else {
  //           this.userVideos.add({
  //             "url": data[i]["media"][j]['thumbnail'],
  //             "id": data[i]["id"],
  //             "createdOnDate": data[i]["createdOnDate"]
  //           });
  //         }
  //       }
  //     }

  //     // this._user!.userVideos = this.userVideos;
  //     // this._user!.userImages = this.userImages;

  //     notifyListeners();
  //   } catch (err) {
  //     utilService!.showToast(err.toString());
  //   }
  // }

//apple login
  Future<void> signInWithApple(BuildContext context) async {
    try {
      showLoadingAnimation(context);
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      final user = await _auth.signInWithCredential(oauthCredential);
      print(user);
      // print("signed in " + user.user!.displayName!);
      // print("signed in " + user.user!.displayName!);
      this._user = AppUser(
          email: user.user!.email,
          fullName: user.user!.displayName ?? "",
          id: user.user!.uid,
          profilePicture: user.user!.photoURL ?? "");
      this._user!.isEmailVerified = user.user!.emailVerified;
      // if (user.user.phoneNumber != null) {
      //   this._user.contact = user.user.phoneNumber;
      // }
      var token = await user.user!.getIdToken();
      this.token = token;
      this.storageService!.setData(StorageKeys.token.toString(), this.token);
      this.storageService!.setData(StorageKeys.user.toString(), this._user);
      // await this.getFCMToken();

      var userByIdData = await this.http!.getUserById(user.user!.uid);
      var result = userByIdData.data;
      print(result);

      if (result['data'] == null) {
        await this.http!.signUp({
          "email": user.user!.email,
          "fullName": user.user!.displayName ?? "Apple User",
          "id": user.user!.uid.toString(),
        });
      }

      await Provider.of<NotificationProvider>(context, listen: false)
          .getNotification(this._user!.id!);
      await Provider.of<CategoryProvider>(context, listen: false)
          .fetchAllCategories();
      await Provider.of<InviteProvider>(context, listen: false)
          .fetchAllRelation();
      await context
          .read<LinkFamilyStoryProvider>()
          .userLinkedStories(count: 10, page: 1);
      await Provider.of<InviteProvider>(context, listen: false)
          .fetchAllFamilyTree(id: this._user!.id!, count: 10, page: 1);
      // await fetchUserMediaGallery(id: this.user.id, count: 10, page: 1);

      // app state for facebook login
      var dataIsremember = await storageService!.haveData('isRemember');
      if (dataIsremember) {
        this._isRemeber = await storageService!.getBoolData('isRemember');
      }
      this.storageService!.setData(StorageKeys.token.toString(), this.token);

      this._user!.fullName = result['data']['fullName'];
      this._user!.dob = result['data']['dob'];
      this._user!.email = result['data']['email'];
      this._user!.firstName = result['data']['firstName'];
      this._user!.lastName = result['data']['lastName'];
      this._user!.profilePicture = result['data']['profilePicture'];
      this._user!.address = result['data']['address'];
      this._user!.homeTown = result['data']['homeTown'];
      this._user!.shortDescription = result['data']['shortDescription'];
      this._user!.givenName = result['data']['givenName'];

      this._user!.middleName = result['data']['middleName'];
      this._user!.storyBookCount = result['data']['storyBookCount'];

      this._user!.treeBookCount = result['data']['treeBookCount'];

      this._user!.linkStoryCount = result['data']['linkStoryCount'];
      this._user!.relation = result['data']['relation'];
      this._user!.notificationSettting = result['data']['notificationSettings'];
      await this.getFCMToken();
      this.storageService!.setData(StorageKeys.user.toString(), this._user);
      if (this._isRemeber) {
        await this.storageService!.setData("userEmail", this._user!.email);

        await this.storageService!.setBoolData("rememberMe", this._isRemeber);
      } else {
        await this.storageService!.setBoolData("rememberMe", this._isRemeber);
      }

      if (this._user!.dob == null || this._user!.dob == '') {
        navigationService!.navigateTo(CreaterofileScreenRoute);
      } else {
        navigationService!.navigateTo(MaindeshboardRoute);
      }
    } catch (err) {
      this._user = null;
      utilService!.showToast(err.toString(), context);
    }
  }

//for Apple sign in
  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

//for Apple sign in
  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

class SelectTouchId {
  static bool isTouched = false;
}
