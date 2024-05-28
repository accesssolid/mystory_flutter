import 'package:flutter/material.dart';
import 'package:mystory_flutter/constant/enum.dart';
import 'package:mystory_flutter/models/appuser.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/category_provider.dart';
import 'package:mystory_flutter/screens/my_journal_screen.dart';
import 'package:mystory_flutter/services/http_service.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class PostProvider with ChangeNotifier {
  NavigationService? navigationService = locator<NavigationService>();

  StorageService? storageService = locator<StorageService>();
  HttpService? http = locator<HttpService>();
  UtilService? utilService = locator<UtilService>();
  Map<String, dynamic> createPost = {};
  Map<String, dynamic> updatePost = {};
  Map<String, dynamic> deletePost = {};
  Map<String, dynamic> likePost = {};
  List newNewsFeedPostData = [];
  String catId = '';

  String storyCatId = '';
  bool isPaginaionLoading = false;
  bool isStoryBookLoading = false;
  List<Map<String, dynamic>> tagUsersObj = [];
  String? searchMessage;
  List tempNewsFeedMedia = [];

  List fetchUserPost = [];
  List journalPostData = [];
  List journalPostDataPagination = [];
  List categoryAllPost = [];
  List categoryAllPostPagination = [];
  List<String> fetchMSCatByIdAllTN = [];
  List newsFeedPost = [];
  List newsFeedPostPagination = [];

  List categoryAlreadyAllPost = [];
  List gallaryPost = [];
  Map<String, dynamic> postById = {};

  List fetchMediaGallary = [];
  List userMediaImages = [];
  List userMediaVideos = [];
  List userMediaAudio = [];
  List searchNewsFeedPost = [];
  List searchNewsFeedPhotos = [];
  List searchNewsFeedVideos = [];
  int _pageCount = 1;

  // Getter for myInt
  int get pageCount => _pageCount;

  // Setter for myInt
  set pageCount(int newValue) {
    _pageCount = newValue;
    notifyListeners();
  }


  get getSearchPhotos {
    return this.searchNewsFeedPhotos;
  }

  get getSearchVideos {
    return this.searchNewsFeedVideos;
  }

  // var tempComment;
  get getJournalPost {
    return this.journalPostData;
  }

  get getJournalPostPagination {
    return this.journalPostDataPagination;
  }

  get getNewsFeedPost {
    return this.newsFeedPost;
  }

  clearNewsFeedPost() {
    this.newsFeedPost = [];
  }

  clearSearchPhotos() {
    searchNewsFeedPhotos.clear();
  }

  clearSearchVideos() {
    searchNewsFeedVideos.clear();
  }

  clearalldata() {
    this.categoryAllPost = [];
    this.categoryAllPostPagination = [];
    this.categoryAlreadyAllPost = [];
    this.fetchMSCatByIdAllTN = [];
    this.fetchMediaGallary = [];
    this.fetchUserPost = [];
    this.gallaryPost = [];
    this.journalPostData = [];
    this.journalPostDataPagination = [];
    this.searchNewsFeedPost = [];
    this.searchNewsFeedPhotos = [];
    this.newNewsFeedPostData = [];
    this.newNewsFeedPostData = [];
    this.newsFeedPost = [];
    this.newsFeedPostPagination = [];
    this.userMediaAudio = [];
    this.tempNewsFeedMedia = [];
    this.userMediaImages = [];
    this.userMediaVideos = [];
  }

  get getNewsFeedPostPagination {
    return this.newsFeedPostPagination;
  }

  get getCategoryAllPost {
    return this.categoryAllPost;
  }

  get getCategoryAllPostPagination {
    return this.categoryAllPostPagination;
  }

  clearPostData() {
    this.newsFeedPost = [];
    notifyListeners();
  }

  clearStoeyPostData() {
    this.categoryAllPost = [];
    notifyListeners();
  }

  setTempData(var data) {
    this.tempNewsFeedMedia = [];
    for (var i = 0; i < data.length; i++) {
      this.tempNewsFeedMedia.add(data[i]["contentType"] == "video"
          ? data[i]["thumbnail"]
          : data[i]["url"]);
    }
  }

  clearTempNewsFeedMedia() {
    this.tempNewsFeedMedia.clear();
    notifyListeners();
  }

  get getFeeds {
    return this.tempNewsFeedMedia;
  }

  clearGetFeeds() {
    return this.tempNewsFeedMedia.clear();
  }

  setTagUsersObj(
      {String? id, String? tagedUserName, String? tagedUserPRofilePic}) {
    this.tagUsersObj.add({
      "id": id,
      "TagedUserName": tagedUserName,
      "TagedUserPRofilePic": tagedUserPRofilePic,
    });
  }

  get getTagUsersObj {
    return this.tagUsersObj;
  }

  cleargetTagUsersObj() {
    this.tagUsersObj = [];
  }

  removeMedia() {
    this.createPost = {};
  }

  Future<void> createStoryPost(
      {BuildContext? context,
      String? storyTitle,
      String? addedByProfilePic,
      String? addedByName,
      String? description,
      String? year,
      String? month,
      String? day,
      List? catagory,
      List<Map<String, dynamic>>? taggedUser,
      var media,
      String? addedById,
      var parentsId,
      var subCatagoriesId,
      bool? isConfidential,
      String? subCatID}) async {
    try {
      createPost = {
        "addedById": addedById,
        "storyTitle": storyTitle,
        "addedByProfilePic": addedByProfilePic,
        "addedByName": addedByName,
        "description": description,
        "year": year,
        "month": month,
        "day": day,
        "catagory": catagory,
        "taggedUser": taggedUser,
        "media": media,
        "parentsCatagories": parentsId,
        "subCatagories": subCatagoriesId,
        "isConfidential": isConfidential
      };
      print("object");
      //print(createPost);
      await this.http!.createStory(createPost);
      this.newsFeedPost = [];
      var user = Provider.of<AuthProviderr>(context!, listen: false).user;
      fetchAllNewsFeedByCategoryId(
        count: 10,
        page: 1,
        subCategoryId:
            context.read<CategoryProvider>().categorySubDataHomeScreen[0]["id"],
        userId: user.id,
      );
      fetchAllNewsFeedPost(id: 'all', page: 1, count: 10);
      var response = await this.http!.getUserById(user.id);
      var result = response.data;
      AppUser _user = AppUser.fromJson(result['data']);
      _user.notificationSettting = result['data']['notificationSettings'];

      context.read<AuthProviderr>().setuser(_user);

      this.storageService!.setData(StorageKeys.user.toString(), _user);
      navigationService!.closeScreen();
      notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  Future<void> updateStoryPost(
      {String? id,
      String? storyTitle,
      String? addedByProfilePic,
      String? addedByName,
      String? description,
      List? catagory,
      var media,
      var newMedia,
      var deletedMedia,
      var subCatagories,
      String? year,
      String? month,
      String? day,
      String? addedById,
      List<Map<String, dynamic>>? taggedUser,
      BuildContext? context,
      String? subCatID,
      bool? isConfidential,
      String? route}) async {
    try {
      updatePost = {
        // "id": id,
        "addedById": addedById,
        "storyTitle": storyTitle,
        "addedByProfilePic": addedByProfilePic,
        "addedByName": addedByName,
        "description": description,
        "catagory": catagory,
        "media": media,
        "newMedia": newMedia,
        "deletedMedia": deletedMedia,
        "taggedUser": taggedUser,
        "subCatagories": subCatagories,
        "year": year,
        "month": month,
        "day": day,
        "isConfidential": isConfidential
      };
      await this.http!.updateStory(updatePost, id);
      var user = Provider.of<AuthProviderr>(context!, listen: false).user;
      if (route == "Storybook") {
        this.categoryAllPost = [];
        fetchAllCategoryPost(
          count: 10,
          page: 1,
          childId: subCatID,
          userId: user.id,
        );
      } else {
        this.newsFeedPost = [];

        fetchAllNewsFeedByCategoryId(
          count: 10,
          page: 1,
          subCategoryId: subCatID,
          userId: user.id,
        );
        fetchAllNewsFeedPost(
          count: 10,
          page: 1,
          id: 'all',
        );
      }

      navigationService!.closeScreen();
      // await this
      //     .storageService!
      //     .setData(StorageKeys.post.toString(), this.updatePost);
      // Navigator.pushReplacement(
      //     context!,
      //     MaterialPageRoute(
      //       builder: (context) => MainDashboardScreen(0),
      //     ));
      // navigationService!.navigateTo(MaindeshboardRoute);
      // await fetchAllUserPost(addedById);
      notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  Future<void> deleteStoryPost({
    data,
    BuildContext? context,
    String? subID,
    int? index,
    String? route,
    // String? addedByProfilePic,
    // String? addedByName,
    // String? description,
    // List? catagory,
    // var media,
    // String? addedById,
  }) async {
    try {
      // deletePost = {
      //   // "id": id,
      //   "addedById": addedById,
      //   "storyTitle": storyTitle,
      //   "addedByProfilePic": addedByProfilePic,
      //   "addedByName": addedByName,
      //   "description": description,
      //   "catagory": catagory,
      //   "media": media,
      //   // "user": user,
      // };
      await this.http!.deleteStory(data["id"]);
      route == "Storybook"
          ? this.categoryAllPost.removeAt(index!)
          : this.newsFeedPost.removeAt(index!);

      await this
          .storageService!
          .setData(StorageKeys.post.toString(), this.updatePost);
      var user = Provider.of<AuthProviderr>(context!, listen: false).user;
      var response = await this.http!.getUserById(user.id);
      var result = response.data;
      AppUser _user = AppUser.fromJson(result['data']);
      _user.notificationSettting = result['data']['notificationSettings'];

      context.read<AuthProviderr>().setuser(_user);

      this.storageService!.setData(StorageKeys.user.toString(), _user);
      // await fetchAllUserPost(data["addedById"]);

      // var user = Provider.of<AuthProviderr>(context!, listen: false).user;
      // fetchAllNewsFeedByCategoryId(
      //   count: 10,
      //   page: 1,
      //   subCategoryId: subID,
      //   userId: user.id,
      // );
      // navigationService!.navigateTo(MaindeshboardRoute);

      notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  // get getAllUserPost {
  //   return this.fetchUserPost;
  // }

  // Future<void> fetchAllUserPost(String? id) async {
  //   try {
  //     var response = await this.http!.getAllUserPost(id!);

  //     if (response == null) {
  //       return;
  //     }
  //     var data = response.data['data'];

  //     this.fetchUserPost = [];
  //     for (int i = 0; i < data.length; i++) {
  //       this.fetchUserPost.add(
  //         {
  //           "id": data[i]["id"],
  //           "addedByProfilePic": data[i]["addedByProfilePic"],
  //           "addedByName": data[i]["addedByName"],
  //           "addedById": data[i]["addedById"],
  //           "storyTitle": data[i]["storyTitle"],
  //           "description": data[i]["description"],
  //           "catagory": data[i]["catagory"],
  //           "media": data[i]["media"],
  //           "createdOnDate": data[i]["createdOnDate"],
  //           "likes": data[i]["likes"],
  //           "taggedUser": data[i]["taggedUser"],
  //         },
  //       );
  //     }
  //     notifyListeners();
  //   } catch (error) {
  //     throw (error);
  //   }
  // }

  Future<void> fetchAllCategoryPost({
    int? page,
    int? count,
    String? childId,
    String? userId,
  }) async {
    try {
      var response =
          await this.http!.getPostByCategoryId(page, count, childId, userId);

      if (response == null) {
        return;
      }
      var data = response.data['data'];

      if (data == null) {
        return;
      }
      // this.categoryAllPost = [];
      this.fetchMSCatByIdAllTN = [];
      for (int i = 0; i < data.length; i++) {
        this.categoryAllPost.add(
          {
            "id": data[i]["id"],
            "addedByProfilePic": data[i]["addedByProfilePic"],
            "addedByName": data[i]["addedByName"],
            "addedById": data[i]["addedById"],
            "storyTitle": data[i]["storyTitle"],
            "description": data[i]["description"],
            "catagory": data[i]["catagory"],
            "media": data[i]["media"],
            "createdOnDate": data[i]["createdOnDate"],
            "likes": data[i]["likes"],
            "taggedUser": data[i]["taggedUser"],
            "subCatagories": data[i]["subCatagories"],
            "year": data[i]["year"],
            "month": data[i]["month"],
            "day": data[i]["day"]
          },
        );
        for (int j = 0; j < data[i]["taggedUser"].length; j++) {
          this
              .fetchMSCatByIdAllTN
              .add(data[i]["taggedUser"][j]["TagedUserName"]);
        }
      }

      // if (this.categoryAllPost[1]["id"] != childId) {
      //   this.categoryAlreadyAllPost.add(categoryAllPost);
      // }
      this.notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

Future<void> fetchAllCategoryPostByCategoryIdForParticularUser({
    int? page,
    int? count,
    String? childId,
    String? userId,
  }) async {
    try {
      var response =
          await this.http!.fetchAllNewsFeedByCategoryIdForParticularUser(page, count, childId, userId);

      if (response == null) {
        return;
      }
      var data = response.data['data'];

      if (data == null) {
        return;
      }
      // this.categoryAllPost = [];
      this.fetchMSCatByIdAllTN = [];
      for (int i = 0; i < data.length; i++) {
        this.categoryAllPost.add(
          {
            "id": data[i]["id"],
            "addedByProfilePic": data[i]["addedByProfilePic"],
            "addedByName": data[i]["addedByName"],
            "addedById": data[i]["addedById"],
            "storyTitle": data[i]["storyTitle"],
            "description": data[i]["description"],
            "catagory": data[i]["catagory"],
            "media": data[i]["media"],
            "createdOnDate": data[i]["createdOnDate"],
            "likes": data[i]["likes"],
            "taggedUser": data[i]["taggedUser"],
            "subCatagories": data[i]["subCatagories"],
            "year": data[i]["year"],
            "month": data[i]["month"],
            "day": data[i]["day"]
          },
        );
        for (int j = 0; j < data[i]["taggedUser"].length; j++) {
          this
              .fetchMSCatByIdAllTN
              .add(data[i]["taggedUser"][j]["TagedUserName"]);
        }
      }

      // if (this.categoryAllPost[1]["id"] != childId) {
      //   this.categoryAlreadyAllPost.add(categoryAllPost);
      // }
      this.notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAllMyStoryPost({int? page, int? count, String? id}) async {
    try {
      if (id == 'all') {
        var response1 = await this.http!.fetchAllSubCategories(page, count);

        if (response1 == null) {
          return;
        }
        var data1 = response1.data['data'];

        // this.categoryAllPost = [];
        this.fetchMSCatByIdAllTN = [];

        for (int i = 0; i < data1.length; i++) {
          this.categoryAllPost.insert(
            0,
            {
              "id": data1[i]["id"],
              "addedByProfilePic": data1[i]["addedByProfilePic"],
              "addedByName": data1[i]["addedByName"],
              "addedById": data1[i]["addedById"],
              "storyTitle": data1[i]["storyTitle"],
              "description": data1[i]["description"],
              "catagory": data1[i]["catagory"],
              "media": data1[i]["media"],
              "createdOnDate": data1[i]["createdOnDate"],
              "likes": data1[i]["likes"],
              "taggedUser": data1[i]["taggedUser"],
              "subCatagories": data1[i]["subCatagories"],
              "year": data1[i]["year"],
              "month": data1[i]["month"],
              "day": data1[i]["day"]
            },
          );
          for (int j = 0; j < data1[i]["taggedUser"].length; j++) {
            this
                .fetchMSCatByIdAllTN
                .insert(0, data1[i]["taggedUser"][j]["TagedUserName"]);
          }
        }
      } else {
        return;
      }

      // if (this.categoryAllPost[1]["id"] != childId) {
      //   this.categoryAlreadyAllPost.add(categoryAllPost);
      // }
      this.notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAllCategoryPostPagination(
      {int? page,
      int? count,
      String? childId,
      String? userId,
      BuildContext? context}) async {
    try {
      var response =
          await this.http!.getPostByCategoryId(page, count, childId, userId);

      if (response == null) {
        return;
      }
      var data2 = response.data['data'];

      this.categoryAllPostPagination = [];
      this.fetchMSCatByIdAllTN = [];
      if (data2.length > 0) {
        for (int i = 0; i < data2.length; i++) {
          this.categoryAllPostPagination.add(
            {
              "id": data2[i]["id"],
              "addedByProfilePic": data2[i]["addedByProfilePic"],
              "addedByName": data2[i]["addedByName"],
              "addedById": data2[i]["addedById"],
              "storyTitle": data2[i]["storyTitle"],
              "description": data2[i]["description"],
              "catagory": data2[i]["catagory"],
              "media": data2[i]["media"],
              "createdOnDate": data2[i]["createdOnDate"],
              "likes": data2[i]["likes"],
              "taggedUser": data2[i]["taggedUser"],
            },
          );
          for (int j = 0; j < data2[i]["taggedUser"].length; j++) {
            this
                .fetchMSCatByIdAllTN
                .add(data2[i]["taggedUser"][j]["TagedUserName"]);
          }
        }
      } else {
        utilService!.showToast("No More Post", context!);
      }

      // if (this.categoryAllPost[1]["id"] != childId) {
      //   this.categoryAlreadyAllPost.add(categoryAllPost);
      // }
      this.notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  /*sdasds*/
  Future<void> fetchAllNewsFeedByCategoryId({
    int? page,
    int? count,
    String? subCategoryId,
    String? userId,
  }) async {
    try {
      var response = await this
          .http!
          .fetchAllNewsFeedByCategoryId(page, count, subCategoryId, userId);
      if (response == null) {
        return;
      }

      var data = response.data['data'];
    //  LogPrint("data fetchAllNewsFeedByCategoryId "+data);
      if(data.isEmpty){
        print("============No Data Found======fetchAllNewsFeedByCategoryId=======\n");

      }else{
        pageCount=pageCount+1;
        notifyListeners();
      }
print("CHECK HERE and page  fetchAllNewsFeedByCategoryId is $page DATA====${data}  and page is $page");
      // this.tempNewsFeedMedia = [];
      this.fetchMSCatByIdAllTN = [];
      // this.newsFeedPost = [];
      for (int i = 0; i < data.length; i++) {
        this.newsFeedPost.add(
          {
            "id": data[i]["id"],
            "addedByProfilePic": data[i]["addedByProfilePic"],
            "addedByName": data[i]["addedByName"],
            "addedById": data[i]["addedById"],
            "storyTitle": data[i]["storyTitle"],
            "description": data[i]["description"],
            "catagory": data[i]["catagory"],
            "media": data[i]["media"],
            "createdOnDate": data[i]["createdOnDate"],
            "likes": data[i]["likes"],
            "taggedUser": data[i]["taggedUser"],
            "subCatagories": data[i]["subCatagories"],
            "year": data[i]["year"],
            "month": data[i]["month"],
            "day": data[i]["day"]
          },
        );
        for (int j = 0; j < data[i]["taggedUser"].length; j++) {
          this
              .fetchMSCatByIdAllTN
              .add(data[i]["taggedUser"][j]["TagedUserName"]);
        }

        // for (var j = 0; j < data[i]["media"].length; j++) {
        //   this.tempNewsFeedMedia.add(
        //       data[i]["media"][j]["contentType"] == "video"
        //           ? data[i]["media"][j]["thumbnail"]
        //           : data[i]["media"][j]["url"]);
        //    print("list:${this.tempNewsFeedMedia}");
        // }
      }

      // if (this.categoryAllPost[1]["id"] != childId) {
      //   this.categoryAlreadyAllPost.add(categoryAllPost);
      // }

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }


  Future<void> fetchNewsFeedOnlyByCategoryId({
    int? page,
    int? count,
    String? categoryId,
    String? userId,
  }) async {
    try {
      print("CODE IS RUNNING HERE fetchNewsFeedOnlyByCategoryId");
      //print(categoryId);
      var response = await this
          .http!
          .fetchAllNewsFeedByCategoryIdNew(page, count, categoryId, userId);
      if (response == null) {
        return;
      }

      var data = response.data['data'];

      // this.tempNewsFeedMedia = [];
      this.fetchMSCatByIdAllTN = [];
      // this.newsFeedPost = [];
      for (int i = 0; i < data.length; i++) {
        this.newsFeedPost.add(
          {
            "id": data[i]["id"],
            "addedByProfilePic": data[i]["addedByProfilePic"],
            "addedByName": data[i]["addedByName"],
            "addedById": data[i]["addedById"],
            "storyTitle": data[i]["storyTitle"],
            "description": data[i]["description"],
            "catagory": data[i]["catagory"],
            "media": data[i]["media"],
            "createdOnDate": data[i]["createdOnDate"],
            "likes": data[i]["likes"],
            "taggedUser": data[i]["taggedUser"],
            "subCatagories": data[i]["subCatagories"],
            "year": data[i]["year"],
            "month": data[i]["month"],
            "day": data[i]["day"]
          },
        );
        for (int j = 0; j < data[i]["taggedUser"].length; j++) {
          this
              .fetchMSCatByIdAllTN
              .add(data[i]["taggedUser"][j]["TagedUserName"]);
        }

        // for (var j = 0; j < data[i]["media"].length; j++) {
        //   this.tempNewsFeedMedia.add(
        //       data[i]["media"][j]["contentType"] == "video"
        //           ? data[i]["media"][j]["thumbnail"]
        //           : data[i]["media"][j]["url"]);
        //    print("list:${this.tempNewsFeedMedia}");
        // }
      }

      // if (this.categoryAllPost[1]["id"] != childId) {
      //   this.categoryAlreadyAllPost.add(categoryAllPost);
      // }

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  /*all news feed */
  Future<void> fetchAllNewsFeedPost({
    int? page,
    int? count,
    String? id,
  }) async {
    print("Calling here with page no $page");
    try {
      if (id == "all") {
        var response = await this.http!.fetchAllNewsFeedPost(
              page,
              count,
            );

        print("=========SDF $pageCount SDF SDF ==========\n\n");
        notifyListeners();
        //print(response['message']??"");
        print(response);

        print("=========SDF SDF SDF ==========\n\n");
        if (response == null) {
          return;
        }

        var data = response.data['data'];
    //    LogPrint("data fetchAllNewsFeedPost "+data);
if(data.isEmpty){

 print("============No Data Found======fetchAllNewsFeedPost=======\n");
}else{
  pageCount=pageCount+1;
  notifyListeners();
}
        // this.tempNewsFeedMedia = [];
        this.fetchMSCatByIdAllTN = [];
        //if (response.data['data'].isNotEmpty) {
        //  this.newsFeedPost = [];
        //}

        for (int i = 0; i < data.length; i++) {

          // this.newsFeedPost.insert(
          //
          //   {
          //     "id": data[i]["id"],
          //     "addedByProfilePic": data[i]["addedByProfilePic"],
          //     "addedByName": data[i]["addedByName"],
          //     "addedById": data[i]["addedById"],
          //     "storyTitle": data[i]["storyTitle"],
          //     "description": data[i]["description"],
          //     "catagory": data[i]["catagory"],
          //     "media": data[i]["media"],
          //     "createdOnDate": data[i]["createdOnDate"],
          //     "likes": data[i]["likes"],
          //     "taggedUser": data[i]["taggedUser"],
          //     "subCatagories": data[i]["subCatagories"],
          //     "year": data[i]["year"],
          //     "month": data[i]["month"],
          //     "day": data[i]["day"]
          //   }
          // );

          this.newsFeedPost.add(  {
            "id": data[i]["id"],
            "addedByProfilePic": data[i]["addedByProfilePic"],
            "addedByName": data[i]["addedByName"],
            "addedById": data[i]["addedById"],
            "storyTitle": data[i]["storyTitle"],
            "description": data[i]["description"],
            "catagory": data[i]["catagory"],
            "media": data[i]["media"],
            "createdOnDate": data[i]["createdOnDate"],
            "likes": data[i]["likes"],
            "taggedUser": data[i]["taggedUser"],
            "subCatagories": data[i]["subCatagories"],
            "year": data[i]["year"],
            "month": data[i]["month"],
            "day": data[i]["day"]
          });

          for (int j = 0; j < data[i]["taggedUser"].length; j++) {
            this
                .fetchMSCatByIdAllTN
                .insert(0, data[i]["taggedUser"][j]["TagedUserName"]);
          }
          notifyListeners();
         }
        notifyListeners();

        // for (int i = 0; i < data.length; i++) {
        //   this.newsFeedPost.insert(
        //     0,
        //     {
        //       "id": data[i]["_source"]["id"],
        //       "addedByProfilePic": data[i]["_source"]["addedByProfilePic"],
        //       "addedByName": data[i]["_source"]["addedByName"],
        //       "addedById": data[i]["_source"]["addedById"],
        //       "storyTitle": data[i]["_source"]["storyTitle"],
        //       "description": data[i]["_source"]["description"],
        //       "catagory": data[i]["_source"]["catagory"],
        //       "media": data[i]["_source"]["media"],
        //       "createdOnDate": data[i]["_source"]["createdOnDate"],
        //       "likes": data[i]["_source"]["likes"],
        //       "taggedUser": data[i]["_source"]["taggedUser"],
        //       "subCatagories": data[i]["_source"]["subCatagories"],
        //       "year": data[i]["_source"]["year"],
        //       "month": data[i]["_source"]["month"],
        //       "day": data[i]["_source"]["day"]
        //     },
        //   );
        //   for (int j = 0; j < data[i]["_source"]["taggedUser"].length; j++) {
        //     this
        //         .fetchMSCatByIdAllTN
        //         .insert(0, data[i]["_source"]["taggedUser"][j]["TagedUserName"]);
        //   }
        // }
      } else {
        return;
      }

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAllNewsFeedByCategoryIdPagination(
      {int? page,
      int? count,
      String? subCategoryId,
      String? userId,
      BuildContext? context}) async {
    try {
      var response = await this
          .http!
          .fetchAllNewsFeedByCategoryId(page, count, subCategoryId, userId);

      if (response == null) {
        return;
      }

      var data2 = response.data['data'];
      // this.tempNewsFeedMedia = [];
      this.newsFeedPostPagination = [];
      if (data2.length > 0) {
        for (int i = 0; i < data2.length; i++) {
          this.newsFeedPostPagination.add(
            {
              "id": data2[i]["id"],
              "addedByProfilePic": data2[i]["addedByProfilePic"],
              "addedByName": data2[i]["addedByName"],
              "addedById": data2[i]["addedById"],
              "storyTitle": data2[i]["storyTitle"],
              "description": data2[i]["description"],
              "catagory": data2[i]["catagory"],
              "media": data2[i]["media"],
              "createdOnDate": data2[i]["createdOnDate"],
              "likes": data2[i]["likes"],
              "taggedUser": data2[i]["taggedUser"],
            },
          );
          // for (var j = 0; j < data[i]["media"].length; j++) {
          //   this.tempNewsFeedMedia.add(
          //       data[i]["media"][j]["contentType"] == "video"
          //           ? data[i]["media"][j]["thumbnail"]
          //           : data[i]["media"][j]["url"]);
          //    print("list:${this.tempNewsFeedMedia}");
          // }
        }
      } else {
        utilService!.showToast("No More Post", context!);
      }

      // if (this.categoryAllPost[1]["id"] != childId) {
      //   this.categoryAlreadyAllPost.add(categoryAllPost);
      // }

      this.notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> getPostById({String? id, BuildContext? context}) async {
    try {
      var response = await this.http!.getPostByuserId(id);

      if (response == null) {
        return;
      }

      var data = response.data['data'];

      this.postById = {};
      if (data == null) {
        utilService!.showToast("This post has been deleted", context!);
        navigationService!.navigateTo(NotificationsScreenRoute);
      } else {
        this.postById = {
          "id": data["id"],
          "addedByProfilePic": data["addedByProfilePic"],
          "addedByName": data["addedByName"],
          "addedById": data["addedById"],
          "storyTitle": data["storyTitle"],
          "description": data["description"],
          "catagory": data["catagory"],
          "media": data["media"],
          "createdOnDate": data["createdOnDate"],
          "likes": data["likes"],
          "taggedUser": data["taggedUser"],
        };
      }

      // if (this.categoryAllPost[1]["id"] != childId) {
      //   this.categoryAlreadyAllPost.add(categoryAllPost);
      // }
      this.notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<Map<String, dynamic>> getPostByPostId(
      {required String id, BuildContext? context}) async {
    try {
      var response = await this.http!.getPostDetailByPostId(id);

      if (response == null) {
        return {};
      }

      var data = response.data['data'];

      if (data == null) {
        utilService!.showToast("This post has been deleted", context!);
        navigationService!.navigateTo(NotificationsScreenRoute);
        return {};
      } else {
        var postByPostId = {
          "id": data["id"],
          "addedByProfilePic": data["addedByProfilePic"],
          "addedByName": data["addedByName"],
          "addedById": data["addedById"],
          "storyTitle": data["storyTitle"],
          "description": data["description"],
          "catagory": data["catagory"],
          "media": data["media"],
          "createdOnDate": data["createdOnDate"],
          "likes": data["likes"],
          "taggedUser": data["taggedUser"],
          "year": data["year"],
          "month": data["month"],
          "day": data["day"]
        };
        return postByPostId;
      }

      // if (this.categoryAllPost[1]["id"] != childId) {
      //   this.categoryAlreadyAllPost.add(categoryAllPost);
      // }
      this.notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> createJournalPost(
      {String? addedById,
      String? addedByName,
      String? addedByProfilePic,
      String? journalTitle,
      String? description,
      var media,
      BuildContext? context}) async {
    try {
      var data = {
        "addedById": addedById,
        "journalTitle": journalTitle,
        "addedByProfilePic": addedByProfilePic,
        "addedByName": addedByName,
        "description": description,
        "media": media,
      };
      await this.http!.createJournal(data);
      // await this
      //     .storageService!
      //     .setData(StorageKeys.post.toString(), this.createPost);
      // var user =
      // await this.storageService!.getData(StorageKeys.user.toString());
      await fetchJournal(count: 10, page: 1, userId: addedById);
      Navigator.pushReplacement(
          context!,
          MaterialPageRoute(
            builder: (context) => MyJournalScreen(),
          ));

      // navigationService!.navigateTo(MyJournalScreenRoute);
      notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  Future<void> fetchJournal({
    int? count,
    int? page,
    String? userId,
  }) async {
    try {
      var response = await this.http!.getMyJournalPost(count, page, userId);

      if (response == null) {
        return;
      }
      var data = response.data['data'];

      this.journalPostData = [];
      for (int i = 0; i < data.length; i++) {
        this.journalPostData.add(
          {
            "id": data[i]["id"],
            "addedByProfilePic": data[i]["addedByProfilePic"],
            "addedByName": data[i]["addedByName"],
            "addedById": data[i]["addedById"],
            "journalTitle": data[i]["journalTitle"],
            "description": data[i]["description"],
            "media": data[i]["media"],
            "createdOnDate": data[i]["createdOnDate"],
          },
        );
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchJournalPagination(
      {int? count, int? page, String? userId, BuildContext? context}) async {
    try {
      var response = await this.http!.getMyJournalPost(count, page, userId);

      if (response == null) {
        return;
      }
      var data2 = response.data['data'];

      this.journalPostDataPagination = [];
      if (data2.length > 0) {
        for (int i = 0; i < data2.length; i++) {
          this.journalPostDataPagination.add(
            {
              "id": data2[i]["id"],
              "addedByProfilePic": data2[i]["addedByProfilePic"],
              "addedByName": data2[i]["addedByName"],
              "addedById": data2[i]["addedById"],
              "journalTitle": data2[i]["journalTitle"],
              "description": data2[i]["description"],
              "media": data2[i]["media"],
              "createdOnDate": data2[i]["createdOnDate"],
            },
          );
        }
      } else {
        utilService!.showToast("No More Post", context!);
      }

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateJournalPost(
      {String? id,
      String? addedById,
      String? addedByName,
      String? addedByProfilePic,
      String? journalTitle,
      String? description,
      var media,
      var newMedia,
      var deletedMedia,
      BuildContext? context}) async {
    try {
      var updatejournal = {
        "id": id,
        "addedById": addedById,
        "journalTitle": journalTitle,
        "addedByProfilePic": addedByProfilePic,
        "addedByName": addedByName,
        "description": description,
        "media": media,
        "newMedia": newMedia,
        "deletedMedia": deletedMedia,
        // "user": user,
      };
      await this.http!.updateJournal(updatejournal);
      await fetchJournal(count: 10, page: 1, userId: addedById);
      Navigator.pushReplacement(
          context!,
          MaterialPageRoute(
            builder: (context) => MyJournalScreen(),
          ));

      // navigationService!.navigateTo(MyJournalScreenRoute);
      notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  Future<void> deleteJournalPost({data, BuildContext? context}) async {
    try {
      await this.http!.deleteMyJournal(data["addedById"], data["id"]);
      await fetchJournal(count: 10, page: 1, userId: data["addedById"]);

      notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  // like post //
  Future<void> likePostByUser(
      {
      // BuildContext? context,
      String? entityUserID,
      String? addedByName,
      String? addedByProfilePic,
      String? addedById,
      String? postId,
      BuildContext? context}) async {
    try {
      likePost = {
        "addedById": addedById,
        "postId": postId,
        "entityUserID": entityUserID,
        "addedByName": addedByName,
        "addedByProfilePic": addedByProfilePic,
      };
      await this.http!.likePost(likePost);
      // Navigator.push(
      //   context!,
      //   MaterialPageRoute(builder: (context) => MainDashboardScreen(0)),
      // );
      // await fetchAllUserPost(addedById);
      notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  Future<void> commentPost(
      {var media,
      var taggedUser,
      String? description,
      String? entityUserID,
      String? addedByName,
      String? addedByProfilePic,
      String? addedById,
      String? postId,
      var tecmpComLength,
      BuildContext? context}) async {
    try {
      var commentsData = {
        "addedById": addedById,
        "entityUserID": entityUserID,
        "postId": postId,
        "description": description,
        "addedByName": addedByName,
        "addedByProfilePic": addedByProfilePic,
        "media": media,
        "taggedUser": taggedUser
      };
      await this.http!.comment(commentsData);

      // tempComment = tecmpComLength;
      notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  // Media Gallary fetching data  //

  get getMediaImages {
    return this.userMediaImages;
  }

  Future<void> fetchAllMediaGallaryImages(
      {int? page, int? count, BuildContext? context}) async {
    try {
      var response =
          await this.http!.mediaGalleryImages(count: count!, page: page!);
      if (response == null) {
        return;
      }

      var data = response.data["data"];

      this.userMediaImages = [];

      for (int i = 0; i < data.length; i++) {
        // for (int j = 0; j < data[i]["media"].length; j++) {
        if (data[i]["contentType"] == "image") {
          this.userMediaImages.add({
            "id": data[i]["id"],
            "url": data[i]["url"],
            "fileName": data[i]["fileName"],
            "entityId": data[i]["entityId"],
            "entityType": data[i]["entityType"],
            "contentType": data[i]["contentType"],
            "createdOnDate": data[i]["createdOnDate"],
            "thumbnail": data[i]["thumbnail"],
          });
        }
      }

      // this._user!.userMediaVideos = this.userMediaVideos;
      // this._user!.userMediaImages = this.userMediaImages;

      notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  get getMediaAudios {
    return this.userMediaAudio;
  }

  Future<void> fetchAllMediaGallaryAudio(
      {int? page, int? count, BuildContext? context}) async {
    try {
      var response =
          await this.http!.mediaGalleryAudio(count: count!, page: page!);
      if (response == null) {
        return;
      }

      var data = response.data["data"];

      this.userMediaAudio = [];

      for (int i = 0; i < data.length; i++) {
        // for (int j = 0; j < data[i]["media"].length; j++) {
        if (data[i]["contentType"] == "audio") {
          this.userMediaAudio.add({
            "id": data[i]["id"],
            "url": data[i]["url"],
            "fileName": data[i]["fileName"],
            "entityId": data[i]["entityId"],
            "entityType": data[i]["entityType"],
            "contentType": data[i]["contentType"],
            "createdOnDate": data[i]["createdOnDate"],
            "thumbnail": data[i]["thumbnail"],
          });
        }
      }

      // this._user!.userMediaVideos = this.userMediaVideos;
      // this._user!.userMediaImages = this.userMediaImages;

      notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  get getMediaVideos {
    return this.userMediaVideos;
  }

  removeUserMediaVideos(int index) {
    this.userMediaVideos.removeAt(index);
    notifyListeners();
  }

  Future<void> fetchAllMediaGallaryVideos(
      {int? page, int? count, BuildContext? context}) async {
    try {
      var response =
          await this.http!.mediaGalleryViedos(count: count!, page: page!);
      if (response == null) {
        return;
      }

      var data = response.data["data"];

      this.userMediaVideos = [];

      for (int i = 0; i < data.length; i++) {
        // for (int j = 0; j < data[i]["media"].length; j++) {
        if (data[i]["contentType"] == "video") {
          this.userMediaVideos.add({
            "url": data[i]["url"],
            "thumbnail": data[i]["thumbnail"],
            "id": data[i]["id"],
            "fileName": data[i]["fileName"],
            "entityId": data[i]["entityId"],
            "entityType": data[i]["entityType"],
            "contentType": data[i]["contentType"],
            "createdOnDate": data[i]["createdOnDate"]
          });
          //}
        }
      }

      // this._user!.userMediaVideos = this.userMediaVideos;
      // this._user!.userMediaImages = this.userMediaImages;

      notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  //   Media Gallary End  //

  Future<void> searchNewsFeed(
      {String? userId,
      String? keyWord,
      int? page,
      int? count,
      BuildContext? context}) async {
    try {
      isPaginaionLoading = true;
      var response =
          await http!.searchNewsFeeds(userId!, keyWord!, page!, count!);
      if (response == null) {
        return;
      }
      var data = response.data["data"];
      var msg = response.data;
      this.fetchMSCatByIdAllTN = [];
      this.searchNewsFeedPost = [];
      for (int i = 0; i < data.length; i++) {
        this.searchNewsFeedPost.add(
          {
            "id": data[i]["id"],
            "addedByProfilePic": data[i]["addedByProfilePic"],
            "addedByName": data[i]["addedByName"],
            "addedById": data[i]["addedById"],
            "storyTitle": data[i]["storyTitle"],
            "description": data[i]["description"],
            "catagory": data[i]["catagory"],
            "media": data[i]["media"],
            "createdOnDate": data[i]["createdOnDate"],
            "likes": data[i]["likes"],
            "taggedUser": data[i]["taggedUser"],
          },
        );

        for (int j = 0; j < data[i]["taggedUser"].length; j++) {
          this
              .fetchMSCatByIdAllTN
              .add(data[i]["taggedUser"][j]["TagedUserName"]);
        }
      }
      searchMessage = msg["message"];
      isPaginaionLoading = false;
      this.notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  Future<void> searchPhotos(
      {String? userId,
      String? keyWord,
      int? page,
      int? count,
      BuildContext? context}) async {
    try {
      isPaginaionLoading = true;
      var response = await http!.searchPhotos(userId!, keyWord!, page!, count!);
      if (response == null) {
        return;
      }
      var data = response.data["data"];
      this.searchNewsFeedPhotos = [];
     // print('ID ${data.length}');
      for (int i = 0; i < data.length; i++) {
      //  print('ID ${data[i][0]["id"]}');
        this.searchNewsFeedPhotos.add(
          {
            "id": data[i][0]["id"],
            "url": data[i][0]["url"],
            "fileName": data[i][0]["fileName"],
            "entityId": data[i][0]["entityId"],
            "entityType": data[i][0]["entityType"],
            "contentType": data[i][0]["contentType"],
            "createdOnDate": data[i][0]["createdOnDate"],
            "thumbnail": data[i][0]["thumbnail"],
          },
        );
      }
      isPaginaionLoading = false;
      this.notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  Future<void> searchVideos(
      {String? userId,
      String? keyWord,
      int? page,
      int? count,
      BuildContext? context}) async {
    try {
      isPaginaionLoading = true;
      var response = await http!.searchVideos(userId!, keyWord!, page!, count!);
      if (response == null) {
        return;
      }
      var data = response.data["data"];
      this.searchNewsFeedVideos = [];
      for (int i = 0; i < data.length; i++) {
        this.searchNewsFeedVideos.add(
          {
            "id": data[i][0]["id"],
            "url": data[i][0]["url"],
            "fileName": data[i][0]["fileName"],
            "entityId": data[i][0]["entityId"],
            "entityType": data[i][0]["entityType"],
            "contentType": data[i][0]["contentType"],
            "createdOnDate": data[i][0]["createdOnDate"],
            "thumbnail": data[i][0]["thumbnail"],
          },
        );
      }
      isPaginaionLoading = false;
      this.notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  /////////home page pagination method//////////////////////// ///

  void getMoreData({int? count, int? page, BuildContext? context}) async {
    try {
      var user = Provider.of<AuthProviderr>(context!, listen: false).user;
      if (!isPaginaionLoading) {
        isPaginaionLoading = true;

        await fetchAllNewsFeedByCategoryId(
          count: count,
          page: page,
          subCategoryId: this.catId,
          //  newsFeedSubCategoryData[0]["id"],
          userId: user.id,
        );
        await fetchAllNewsFeedPost(
          count: count,
          page: page,
          id: this.catId,
        );

        isPaginaionLoading = false;
        // newNewsFeedPostData = this.newsFeedPost;
        // if (newNewsFeedPostData.length == 0) {
        //   utilService!.showToast("No more Newsfeeds");
        // } else {
        // this.newsFeedPost.addAll(newNewsFeedPostData);
        // }
        // page += 1;

        // print(page);
        notifyListeners();
      }
    } catch (err) {
      isPaginaionLoading = false;

      utilService!.showToast(err.toString(), context!);
    }
  }

  //// story book pagination////////
  void storyDataGetMoreData(
      {int? count, int? page, BuildContext? context}) async {
    try {
      var user = Provider.of<AuthProviderr>(context!, listen: false).user;
      if (!isStoryBookLoading) {
        isStoryBookLoading = true;

        await Provider.of<PostProvider>(context, listen: false)
            .fetchAllCategoryPost(
          count: count,
          page: page,
          childId: this.storyCatId,
          userId: user.id,
        );
        await Provider.of<PostProvider>(context, listen: false)
            .fetchAllMyStoryPost(page: page, count: count, id: this.storyCatId);

        isStoryBookLoading = false;
        notifyListeners();
      }
    } catch (err) {
      isStoryBookLoading = false;

      utilService!.showToast(err.toString(), context!);
    }
  }
}
