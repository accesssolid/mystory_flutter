import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import '../services/storage_service.dart';
import '../services/navigation_service.dart';
import '../services/util_service.dart';
import '../utils/service_locator.dart';
import '../utils/routes.dart';

class FirebaseService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  UtilService _util = locator<UtilService>();
  NavigationService _navigation = locator<NavigationService>();
  StorageService _storage = locator<StorageService>();
  ////////finger print//////////
  // final _localAuth = LocalAuthentication();
  bool? _hasBiometricSenson;
  // list of finger print added in local device settings
  List<BiometricType>? _availableBiomatrics;
  String _isAuthorized = "NOT AUTHORIZED";

  LocalAuthentication authentication = LocalAuthentication();
  /////////finger print//////////

  Future<void> forgotPassword(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _util.showToast(
          "An email has been sent please follow the instructions and recover your password.",
          context);
      _navigation.navigateTo(LoginScreenRoute);
    } on FirebaseAuthException catch (err) {
      _util.showToast(err.message.toString(), context);
    }
  }

  Future<void> logoutFirebaseUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    await _storage.clearData();
  }

  signinWithEmailAndPassword(String email, String password) async {
    final authResult = await _auth.signInWithEmailAndPassword(
        email: email.trim(), password: password.trim());
    return authResult.user;
  }

  sendEmailVerification(BuildContext context) async {
    try {
      final user = _auth.currentUser;
      user!.sendEmailVerification();
      _util.showToast("A Verification email has been sent", context);
    } catch (err) {
      print(err);
    }
  }

  resendEmailVerification(BuildContext context) async {
    final user = _auth.currentUser;
    await user!.sendEmailVerification();
    _util.showToast(
        "A Verification Link Resend to your email kindly check your inbox",
        context);
  }

  createUserWithEmailAndPassword(String email, String password) async {
    final authResult = await _auth.createUserWithEmailAndPassword(
        email: email.trim(), password: password.trim());
    return authResult.user;
  }

  // uploadPicture(File file, String fileName, String id) async {
  //   try {
  //     StorageReference storageReference;
  //     storageReference = FirebaseStorage.instance.ref().child("files/$id");
  //     final StorageUploadTask uploadTask = storageReference.putFile(file);
  //     final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
  //     final String url = (await downloadUrl.ref.getDownloadURL());
  //     return url;
  //   } catch (err) {
  //     // print(err);
  //   }
  // }

  getFCMToken() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();
    return token;
  }

  // Future<void> _checkForBiometric() async {
  //   bool? hasBiometric;
  //   try {
  //     hasBiometric = await authentication.canCheckBiometrics;
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _hasBiometricSenson = hasBiometric;
  //   });
  // }

  // //future function to get the list of Biometric or faceID added into device
  // Future<void> _getListofBiometric() async {
  //   List<BiometricType>? ListofBiometric;
  //   try {
  //     ListofBiometric = await authentication.getAvailableBiometrics();
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _availableBiomatrics = ListofBiometric;
  //   });
  // }

  // ////future function to check is the use is authorized or no
  // Future<void> _getAuthentication() async {
  //   bool isAutherized = false;
  //   try {
  //     isAutherized = await authentication.authenticateWithBiometrics(
  //         localizedReason: "SCAN YOUR FINGER PRINT TO GET AUTHORIZED",
  //         useErrorDialogs: true,
  //         stickyAuth: false);
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _isAuthorized = isAutherized ? "AUTHORIZED" : "NOT AUTHORIZED";
  //   });
  // }
}
