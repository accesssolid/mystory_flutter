import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../global.dart';
import '../providers/auth_provider.dart';

class UtilService {
  FToast? fToast;
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  // FirebaseService firebaseService = locator<FirebaseService>();
  nameToFirstLetterCapital(String name) {
    var displayName =
        name.trim().substring(0, 1).toUpperCase() + name.trim().substring(1);

    // var displayName = name[0].toUpperCase() + name.substring(1).toLowerCase();
    return displayName;
  }

  var fileName = "";

  // showToast(String msg) {
  //   // Future.delayed(const Duration(seconds: 5), () {

  //   Fluttertoast.showToast(
  //       msg: msg,
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.TOP,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Color.fromRGBO(31, 106, 247, 1),
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  //   // });
  // }

  showToast(String msg, BuildContext context) {
    fToast = FToast();
    fToast!.init(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Color.fromRGBO(31, 106, 247, 1),
      ),
      child: Text(
        msg,
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );

    fToast!.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 3),
    );
  }

  cancelAllToast(BuildContext context) {
    fToast = FToast();
    fToast!.init(context);
    fToast!.removeQueuedCustomToasts();
  }

  Future<String> captureImage(String? userId, BuildContext? context) async {
    var status = await Permission.camera.status;
    firebase_storage.Reference storageReference;
    // ignore: deprecated_member_use
    final picker = ImagePicker();
    File _image;
    var imageFile;
    // if (status.isDenied && Platform.isIOS) {
    //   showDialog(
    //       context: context!,
    //       builder: (BuildContext context) => CupertinoAlertDialog(
    //             title: Text('Camera Permission'),
    //             content: Text(
    //                 'This app needs camera access to take pictures for upload user profile photo'),
    //             actions: <Widget>[
    //               CupertinoDialogAction(
    //                 child: Text('Deny'),
    //                 onPressed: () => Navigator.of(context).pop(),
    //               ),
    //               CupertinoDialogAction(
    //                 child: Text('Settings'),
    //                 onPressed: () => openAppSettings(),
    //               ),
    //             ],
    //           ));
    // }
    // else {
    imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (imageFile == null) {
      return '';
    }

    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
            minimumAspectRatio: 1.0,
          ),
          WebUiSettings(
            context: context!,
          ),
        ],

    );

    _image = File(croppedFile!.path);
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await _image.copy('${appDir.path}/$fileName');
    storageReference =
        firebase_storage.FirebaseStorage.instance.ref().child("images/$userId");
    final firebase_storage.UploadTask uploadTask =
        storageReference.putFile(savedImage);
    final firebase_storage.TaskSnapshot downloadUrl =
        (await uploadTask.whenComplete(() => null));
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
    // }
    // return "";
  }

  Future<String> browseImage(String userId, BuildContext? context) async {
    var status = await Permission.photos.status;
    firebase_storage.Reference storageReference;
    // ignore: deprecated_member_use
    final picker = ImagePicker();
    File _image;
    var imageFile;
    // if (status.isDenied && Platform.isIOS) {
    //   showDialog(
    //       context: context!,
    //       builder: (BuildContext context) => CupertinoAlertDialog(
    //             title: Text('Camera Permission'),
    //             content: Text(
    //                 'This app needs camera access to take pictures for upload user profile photo'),
    //             actions: <Widget>[
    //               CupertinoDialogAction(
    //                 child: Text('Deny'),
    //                 onPressed: () => Navigator.of(context).pop(),
    //               ),
    //               CupertinoDialogAction(
    //                 child: Text('Settings'),
    //                 onPressed: () => openAppSettings(),
    //               ),
    //             ],
    //           ));
    // }
    // else {
    imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );

    if (imageFile == null) {
      return '';
    }
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
          minimumAspectRatio: 1.0,
        ),
        WebUiSettings(
          context: context!,
        ),
      ],
    );
    _image = File(croppedFile!.path);
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await _image.copy('${appDir.path}/$fileName');
    storageReference =
        firebase_storage.FirebaseStorage.instance.ref().child("images/$userId");
    final firebase_storage.UploadTask uploadTask =
        storageReference.putFile(savedImage);
    final firebase_storage.TaskSnapshot downloadUrl =
        (await uploadTask.whenComplete(() => null));
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
    // }
    // return "";
  }

  Future<String> captureImageManuallyAddedUser(
      String? userId, BuildContext? context) async {
    var status = await Permission.camera.status;
    firebase_storage.Reference storageReference;
    var date = DateTime.now().microsecondsSinceEpoch;
    final picker = ImagePicker();
    File _image;
    var imageFile;
    imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return '';
    }
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
          minimumAspectRatio: 1.0,
        ),
        WebUiSettings(
          context: context!,
        ),
      ],);

    _image = File(croppedFile!.path);
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await _image.copy('${appDir.path}/$fileName');
    storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("Manually Added User Image/$userId$date");
    final firebase_storage.UploadTask uploadTask =
        storageReference.putFile(savedImage);
    final firebase_storage.TaskSnapshot downloadUrl =
        (await uploadTask.whenComplete(() => null));
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
    // }
    // return "";
  }

  Future<String> browseImageManuallyAddedUser(
      String userId, BuildContext? context) async {
    var status = await Permission.photos.status;
    firebase_storage.Reference storageReference;
    var date = DateTime.now().microsecondsSinceEpoch;

    final picker = ImagePicker();
    File _image;
    var imageFile;

    imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );

    if (imageFile == null) {
      return '';
    }
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
          minimumAspectRatio: 1.0,
        ),
        WebUiSettings(
          context: context!,
        ),
      ],);
    _image = File(croppedFile!.path);
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await _image.copy('${appDir.path}/$fileName');
    storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("Manually Added User Image/$userId$date");
    final firebase_storage.UploadTask uploadTask =
        storageReference.putFile(savedImage);
    final firebase_storage.TaskSnapshot downloadUrl =
        (await uploadTask.whenComplete(() => null));
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
    // }
    // return "";
  }

// post //
  Future<String> postBrowseImage(
      {String? folder, BuildContext? context}) async {
    var status = await Permission.photos.status;
    print('Photo Status Permission: ${status}');
    try {
      if (status.isDenied || status.isGranted) {
        var date = DateTime.now().microsecondsSinceEpoch;
        firebase_storage.Reference storageReference;
        // ignore: deprecated_member_use
        final picker = ImagePicker();
        File _image;

        // if (status.isDenied && Platform.isIOS) {
        //   showDialog(
        //       context: context!,
        //       builder: (BuildContext context) => CupertinoAlertDialog(
        //             title: Text('Camera Permission'),
        //             content: Text('This app needs camera access to take pictures'),
        //             actions: <Widget>[
        //               CupertinoDialogAction(
        //                 child: Text('Deny'),
        //                 onPressed: () => Navigator.of(context).pop(),
        //               ),
        //               CupertinoDialogAction(
        //                 child: Text('Settings'),
        //                 onPressed: () => openAppSettings(),
        //               ),
        //             ],
        //           ));
        // } else {
        imageFile = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 600,
        );
        if (imageFile == null) {
          return '';
        }

        CroppedFile? croppedFile = await ImageCropper().cropImage(
            sourcePath: imageFile.path,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
              minimumAspectRatio: 1.0,
            ),
            WebUiSettings(
              context: context!,
            ),
          ],);
        if (croppedFile == null) {
          return '';
        }
        _image = File(croppedFile.path);
        final appDir = await syspaths.getApplicationDocumentsDirectory();
        fileName = path.basename(imageFile.path);
        final savedImage = await _image.copy('${appDir.path}/$fileName');
        storageReference = firebase_storage.FirebaseStorage.instance
            .ref()
            .child("$folder/$date");
        final firebase_storage.UploadTask uploadTask =
            storageReference.putFile(savedImage);
        final firebase_storage.TaskSnapshot downloadUrl =
            (await uploadTask.whenComplete(() => null));
        final String url = (await downloadUrl.ref.getDownloadURL());
        return url;
      }
    } on PlatformException catch (e) {
      showToast('please enable permission', context!);
      return "";
    }
    showToast('please enable permission', context!);
    return '';

    // }
    // return "";
  }

  Future<String> postBrowseAudio(
      {String? folder, BuildContext? context}) async {
    var date = DateTime.now().microsecondsSinceEpoch;
    var status = await Permission.mediaLibrary.status;
    print('Photo Status Permission: ${status}');
    if (status.isDenied || status.isGranted) {
      final picker = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );
      if (picker == null) {
        return "";
      }
      final selectedFilePath = picker.files.first.path;
      firebase_storage.Reference storageReference;
      storageReference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("$folder/$date");
      // .child(_image.name);
      final firebase_storage.UploadTask uploadTask =
          storageReference.putFile(File(selectedFilePath!));
      await uploadTask.whenComplete(() {
        print(storageReference.getDownloadURL());
      });
      final String url = (await storageReference.getDownloadURL());

      return url;
    }
    showToast('please enable permission', context!);
    return "";
  }

  var imageFile;

  Future<String> postCaptureImage({
    String? folder,
    BuildContext? context,
  }) async {
    var status = await Permission.photos.status;
    var date = DateTime.now().microsecondsSinceEpoch;
    firebase_storage.Reference storageReference;
    // ignore: deprecated_member_use
    print('Camera Status Permission: ${status}');
    final picker = ImagePicker();
    File _image;

    // if (status.isDenied && Platform.isIOS) {
    //   showDialog(
    //       context: context!,
    //       builder: (BuildContext context) => CupertinoAlertDialog(
    //             title: Text('Camera Permission'),
    //             content: Text(
    //                 'This app needs camera access to take pictures for upload user profile photo'),
    //             actions: <Widget>[
    //               CupertinoDialogAction(
    //                 child: Text('Deny'),
    //                 onPressed: () => Navigator.of(context).pop(),
    //               ),
    //               CupertinoDialogAction(
    //                 child: Text('Settings'),
    //                 onPressed: () => openAppSettings(),
    //               ),
    //             ],
    //           ));
    // } else {
    try {
      if (status.isDenied || status.isGranted) {
        imageFile = await picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 600,
        );

        // cropImage(imageFile);
        if (imageFile == null) {
          return '';
        }

        CroppedFile? croppedFile = await ImageCropper().cropImage(
            sourcePath: imageFile.path,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
              minimumAspectRatio: 1.0,
            ),
            WebUiSettings(
              context: context!,
            ),
          ],);
        _image = File(croppedFile!.path);

        final appDir = await syspaths.getApplicationDocumentsDirectory();
        fileName = path.basename(imageFile.path);

        final savedImage = await _image.copy('${appDir.path}/$fileName');
        storageReference = firebase_storage.FirebaseStorage.instance
            .ref()
            .child("$folder/$date");
        final firebase_storage.UploadTask uploadTask =
            storageReference.putFile(savedImage);
        final firebase_storage.TaskSnapshot downloadUrl =
            (await uploadTask.whenComplete(() => null));

        final String url = (await downloadUrl.ref.getDownloadURL());

        return url;
      }
    } on PlatformException catch (e) {
      showToast('please enable permission', context!);
      return "";
    }
    // }
    showToast('please enable permission', context!);

    return '';
  }

  Future<String?> postPickVideos({String? folder, BuildContext? context}) async {
    final filesizeLimit = 698571846; // in bytes  666.21

    var status = await Permission.photos.status;
    print('Video Status Permission: ${status}');

    if (status.isDenied || status.isGranted) {
      try {
        final FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.video,
          allowCompression: true,
        );

        if (result == null || result.files.isEmpty) {
          return null;
        }

        final PlatformFile file = result.files.first;
        final File video = File(file.path!);
        final filesize = await video.length();

        if (filesize > filesizeLimit) {
          showToast("Video is too long", context!);
          return null;
        }

        final appDir = await getApplicationDocumentsDirectory();
        final fileName = path.basename(file.name!);
        final savedVideo = await video.copy('${appDir.path}/$fileName');

        // Perform the upload task asynchronously
        final url = await _uploadVideo(savedVideo, folder,context);

        return url;
      } on PlatformException catch (e) {
        showToast('Please enable permission', context!);
        return null;
      }
    }

    showToast('Please enable permission', context!);
    return null;
  }

  Future<String> _uploadVideo(File videoFile, String? folder,context) async {
    final date = DateTime.now().microsecondsSinceEpoch;
    final storageReference = FirebaseStorage.instance.ref().child("$folder/$date");
    final uploadTask = storageReference.putFile(videoFile);

    // Listen to the uploadTask's snapshot stream to get the upload progress

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double percentage = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      // Round the percentage to the nearest whole number
      int roundedPercentage = percentage.round();
      // Update UI with the rounded percentage value
      print('Upload VIDEO IS is $roundedPercentage% done');
      Provider.of<AuthProviderr>(context, listen: false).setLoadingProgresss(roundedPercentage);

    });
    // Wait for the uploadTask to complete
    final TaskSnapshot completedTask = await uploadTask;
    final String url = await completedTask.ref.getDownloadURL();

    return url;
  }

  // Future<String> _uploadVideo(File videoFile, String? folder) async {
  //   final date = DateTime.now().microsecondsSinceEpoch;
  //   final storageReference = FirebaseStorage.instance.ref().child("$folder/$date");
  //   final uploadTask = storageReference.putFile(videoFile);
  //
  //   // Listen for state changes, errors, and completion of the upload.
  //   final TaskSnapshot snapshot = await uploadTask;
  //
  //   // Get the download URL
  //   final String url = await snapshot.ref.getDownloadURL();
  //
  //   return url;
  // }
  // Future<String?> postPickVideos({String? folder, BuildContext? context}) async {
  //   final filesizeLimit = 471859200; // in bytes
  //   var status = await Permission.photos.status;
  //   print('Video Status Permission: ${status}');
  //
  //   if (status.isDenied || status.isGranted) {
  //     try {
  //       final picker = ImagePicker();
  //       final videoFile = await picker.pickVideo(source: ImageSource.gallery);
  //
  //       if (videoFile == null) {
  //         return null;
  //       }
  //
  //       final File video = File(videoFile.path);
  //       final filesize = await video.length();
  //
  //       if (filesize > filesizeLimit) {
  //         showToast("Video is too long", context!);
  //         return null;
  //       }
  //
  //       final appDir = await getApplicationDocumentsDirectory();
  //       final fileName = path.basename(videoFile.path);
  //       final savedVideo = await video.copy('${appDir.path}/$fileName');
  //
  //       // Perform the upload task asynchronously
  //       final url = await _uploadVideo(savedVideo, folder);
  //
  //       return url;
  //     } on PlatformException catch (e) {
  //       showToast('Please enable permission', context!);
  //       return null;
  //     }
  //   }
  //
  //   showToast('Please enable permission', context!);
  //   return null;
  // }
  //
  // Future<String> _uploadVideo(File videoFile, String? folder) async {
  //   final date = DateTime.now().microsecondsSinceEpoch;
  //   final storageReference = FirebaseStorage.instance.ref().child("$folder/$date");
  //   final uploadTask = storageReference.putFile(videoFile);
  //
  //   // Listen for state changes, errors, and completion of the upload.
  //   final TaskSnapshot snapshot = await uploadTask;
  //
  //   // Get the download URL
  //   final String url = await snapshot.ref.getDownloadURL();
  //
  //   return url;
  // }
//   Future<String> postPickVideos({String? folder, BuildContext? context}) async {
//     final filesizeLimit = 471859200; // in bytes
// // in bytes
//     var status = await Permission.photos.status;
//     print('Video Status Permission: ${status}');
//     if (status.isDenied || status.isGranted) {
//       try {
//         var date = DateTime.now().microsecondsSinceEpoch;
//         // final filesizeLimit = 999999;
//         firebase_storage.Reference storageReference;
//         // ignore: deprecated_member_use
//         final picker = ImagePicker();
//
//         File _video;
//         var videoFile = await picker.pickVideo(
//           source: ImageSource.gallery,
//         );
//
//         if (videoFile == null) {
//           return '';
//         }
//         _video = File(videoFile.path);
//
//         final filesize = await _video.length();
//         // final isValidFilesize = filesize < filesizeLimit;
//         // if (isValidFilesize) {
//         if (filesize <= filesizeLimit) {
//           final appDir = await syspaths.getApplicationDocumentsDirectory();
//           fileName = path.basename(videoFile.path);
//           final savedVideo = await _video.copy('${appDir.path}/$fileName');
//           storageReference = firebase_storage.FirebaseStorage.instance
//               .ref()
//               .child("$folder/$date");
//           final firebase_storage.UploadTask uploadTask =
//               storageReference.putFile(savedVideo);
//           final firebase_storage.TaskSnapshot downloadUrl =
//               (await uploadTask.whenComplete(() => null));
//           final String url = (await downloadUrl.ref.getDownloadURL());
//           return url;
//         } else {
//           showToast("Video is too long", context!);
//           // Navigator.pop(context);
//           // Navigator.pop(context);
//         }
//       } on PlatformException catch (e) {
//         showToast('please enable permission', context!);
//         return "";
//       }
//     }
//     // }
//     showToast('please enable permission', context!);
//     return "";
//   }

  //following code is only reserved for chat work //

  //following function is used to get the image for chat

  Future<String> captureImageForChat() async {
    final picker = ImagePicker();

    var imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (imageFile == null) {
      return '';
    }
    return imageFile.path;
  }

//following function is used to get the image for chat
  Future<String> browseImageForChat() async {
    final picker = ImagePicker();

    var imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );

    if (imageFile == null) {
      return '';
    }
    return imageFile.path;
  }

  Future<String> sendImageForChat(String mediaPath) async {
    String imageName = getRandomString(15);
    firebase_storage.Reference storageReference;
    File _image;
    _image = File(mediaPath);

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(mediaPath);
    final savedImage = await _image.copy('${appDir.path}/$fileName');

    storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("chats/$imageName");
    final firebase_storage.UploadTask uploadTask =
        storageReference.putFile(savedImage);
    final firebase_storage.TaskSnapshot downloadUrl =
        (await uploadTask.whenComplete(() => null));
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }

  //following function is used to get the image for chat
  Future<String> browseVideoForChat(BuildContext context) async {
    final filesizeLimit = 20062535;
    String videoName = getRandomString(15);
    firebase_storage.Reference storageReference;

    final picker = ImagePicker();
    File _video;
    var videoFile = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: Duration(seconds: 180),
    );

    if (videoFile == null) {
      return '';
    }
    _video = File(videoFile.path);
    final filesize = await _video.length();
    if (filesize <= filesizeLimit) {
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final fileName = path.basename(videoFile.path);
      final savedVideo = await _video.copy('${appDir.path}/$fileName');
      storageReference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("chats/videos/$videoName");
      final firebase_storage.UploadTask uploadTask =
          storageReference.putFile(savedVideo);
      final firebase_storage.TaskSnapshot downloadUrl =
          (await uploadTask.whenComplete(() => null));
      final String url = (await downloadUrl.ref.getDownloadURL());
      return url;
    } else {
      showToast("Video is too long must be less than 20MB", context);
      return "";
    }
  }

  Future<String> sendAudioToStorage(chatAudio) async {
    String audioName = getRandomString(15);
    firebase_storage.Reference storageReference;
    File _audio;

    _audio = File(chatAudio);
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(chatAudio);
    final savedAudio = await _audio.copy('${appDir.path}/$fileName');
    storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("chats/audios/$audioName.aac");
    final firebase_storage.UploadTask uploadTask =
        storageReference.putFile(savedAudio);
    final firebase_storage.TaskSnapshot downloadUrl =
        (await uploadTask.whenComplete(() => null));
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }

  // }
  //////media gallery////////////
  Future<String> browseMediamages() async {
    var date = DateTime.now().microsecondsSinceEpoch;
    List<XFile> selectedFiles = [];
    firebase_storage.Reference storageReference;
    // ignore: deprecated_member_use
    final picker = ImagePicker();
    // List<File> _image = [];
    final List<XFile>? selectedImages = await picker.pickMultiImage();

    if (selectedImages!.isNotEmpty) {
      selectedFiles.addAll(selectedImages);
    }
    storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("mediaGallery/$date");
    // .child(_image.name);
    for (int i = 0; i < selectedFiles.length; i++) {
      final firebase_storage.UploadTask uploadTask =
          storageReference.putFile(File(selectedFiles[i].path));
      await uploadTask.whenComplete(() {
        print(storageReference.getDownloadURL());
      });
      final String url = (await storageReference.getDownloadURL());
      return url;
    }
    return "";
  }

  Future<void> browseMediaImages(List<XFile> _images) async {
    // List<XFile> selectedFiles = [];
    var status = await Permission.photos.status;
    print('Photo Status Permission: ${status}');

    final picker = ImagePicker();

    final List<XFile>? selectedImages = await picker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      _images.addAll(selectedImages);
    }

    // showToast('please enable permission', context!);
  }

  Future<List<PlatformFile>?> browseAudioFile(
      List<PlatformFile> _audios, BuildContext context) async {
    // List<XFile> selectedFiles = [];
    var status = await Permission.mediaLibrary.status;
    print('Photo Status Permission: ${status}');
    if (status.isDenied || status.isGranted) {
      final picker = await FilePicker.platform
          .pickFiles(type: FileType.audio, allowMultiple: false);
      if (picker == null) {
        return null;
      }
      final selectedFile = picker.files;
      _audios.addAll(selectedFile);
      return picker.files;
    }
    showToast('please enable permission', context);
    return null;
  }

  Future uploadAudioFunction(List<PlatformFile> _audio) async {
    // List<String> storeUplodUrl = [];
    var date = DateTime.now().microsecondsSinceEpoch;
    List<String> urlss = [];
    for (int i = 0; i < _audio.length; i++) {
      // var imageUrl =
      await uploadAudioFile(audio: File(_audio[i].path!), name: date)
          .then((value) => urlss.add(value));
      //  storeUplodUrl.add(imageUrl.toString());
      // print(storeUplodUrl);
    }

    return urlss;
  }

  Future<String> uploadAudioFile({File? audio, int? name}) async {
    // List<String> urlList = [];
    // ignore: unused_local_variable

    firebase_storage.Reference storageReference;
    storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("mediaGallery/$name");
    // .child(_image.name);
    final firebase_storage.UploadTask uploadTask =
        storageReference.putFile(File(audio!.path));
    await uploadTask.whenComplete(() {
      print(storageReference.getDownloadURL());
    });
    final String url = (await storageReference.getDownloadURL());
    // urlList.add(url);
    return url;
  }

  Future<String> uploadFile(XFile _image) async {
    var date = DateTime.now().microsecondsSinceEpoch;
    // List<String> urlList = [];
    // ignore: unused_local_variable
    firebase_storage.Reference storageReference;
    storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("mediaGallery/$date");
    // .child(_image.name);
    final firebase_storage.UploadTask uploadTask =
        storageReference.putFile(File(_image.path));
    await uploadTask.whenComplete(() {
      print(storageReference.getDownloadURL());
    });
    final String url = (await storageReference.getDownloadURL());
    // urlList.add(url);
    return url;
  }

  Future uploadFunction(List<XFile> _images) async {
    // List<String> storeUplodUrl = [];
    List<String> urlss = [];
    for (int i = 0; i < _images.length; i++) {
      // var imageUrl =
      await uploadFile(_images[i]).then((value) => urlss.add(value));
      //  storeUplodUrl.add(imageUrl.toString());
      // print(storeUplodUrl);
    }

    return urlss;
  }

  Future<String> videoThumbnail({String? url, String? folder}) async {
    String? fileName = await VideoThumbnail.thumbnailFile(
      video: url!,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 0,
      // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 0,
    );
    var date = DateTime.now().microsecondsSinceEpoch;
    firebase_storage.Reference storageReference;

    final file = File(fileName!);

    storageReference =
        firebase_storage.FirebaseStorage.instance.ref().child("$folder/$date");
    final firebase_storage.UploadTask uploadTask =
        storageReference.putFile(file);
    final firebase_storage.TaskSnapshot downloadUrl =
        (await uploadTask.whenComplete(() => null));
    var urlasset = (await downloadUrl.ref.getDownloadURL());
    return urlasset;
  }
}
