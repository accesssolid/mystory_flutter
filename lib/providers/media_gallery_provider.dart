import 'package:flutter/cupertino.dart';
import 'package:mystory_flutter/services/http_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:path/path.dart';

class MediaGalleryProvider with ChangeNotifier {
  HttpService? http = locator<HttpService>();
  UtilService? utilService = locator<UtilService>();
  String mediaGalleryRoute = '';
  String ImageUrlForChat = '';
  String postTitle = '';
  Map<String, dynamic> mediaVideoData = {};
  List mediaImages = [];
  List newMediaImages = [];
  List journalMediaImages = [];
  List journalNewMediaImages = [];
  clearMediaImages() {
    return mediaImages = [];
  }

  clearMewMediaImages() {
    newMediaImages = [];
    notifyListeners();
  }

  clearjournalNewMediaImages() {
    journalNewMediaImages.clear();
    notifyListeners();
  }

  addMediaImage(var data) {
    this.mediaImages.add(data);
    notifyListeners();
  }

  addNewMediaImage(var data) {
    this.newMediaImages.add(data);
    notifyListeners();
  }

  addJournalMediaImage(var data) {
    journalMediaImages.add(data);
    notifyListeners();
  }

  addJournalNewMediaImage(var data) {
    journalNewMediaImages.add(data);
    notifyListeners();
  }

  clearjournalMediaImages() {
    journalMediaImages.clear();
    notifyListeners();
  }

  Future<void> uploadMedia({var media, BuildContext? context}) async {
    var data = {"media": media};
    try {
      await this.http!.uploadMediaGallery(data);

      notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  Future<void> deleteMedia({var media, BuildContext? context}) async {
    var data = {"media": media};
    try {
      await this.http!.deleteMediaGallery(data);

      notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

//////for updarte create journal////////
  void journalNewListDataAndOldList() {
    // if (editLength != mediaImages.length) {
    //   for (int i = editLength - 1; i < mediaImages.length; i++) {
    //     mediaImages.removeAt(i);
    //   }
    // }
    this.journalMediaImages.length =
        this.journalMediaImages.length - this.journalNewMediaImages.length;
    notifyListeners();
  }

  void createStorynewListDataAndOldList() {
    // if (editLength != mediaImages.length) {
    //   for (int i = editLength - 1; i < mediaImages.length; i++) {
    //     mediaImages.removeAt(i);
    //   }
    // }
    this
      ..mediaImages.length =
          this.mediaImages.length - this.newMediaImages.length;
  }

  notifyListeners();
}
