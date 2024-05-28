import 'package:flutter/material.dart';
import 'package:mystory_flutter/services/http_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:path/path.dart';

class LinkFamilyStoryProvider with ChangeNotifier {
  HttpService? http = locator<HttpService>();
  UtilService? utilService = locator<UtilService>();
  bool isPaginaionLoading = false;
  List userLinkedStoriesData = [];
  List familyLinkedStoriesData = [];
  List familyMemberStoriesData = [];
  List<String> fetchTagUserColorLinkStory = [];
  String linkRoute = "";
  String familyMemberId = "";

  Future<void> userLinkedStories({
    int? page,
    int? count,
  }) async {
    try {
      var response = await this.http!.getUersLinkedStories(
            page!,
            count!,
          );
      print('Linked Story Response: $response');
      if (response.data['data'].isEmpty) {
        return;
      }
      var data = response.data['data'];

      print('Hello Linked Story Response: $data');

      this.fetchTagUserColorLinkStory = [];
      this.userLinkedStoriesData = [];
      for (int i = 0; i < data.length; i++) {
        this.userLinkedStoriesData.add(
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
          },
        );
        for (int j = 0; j < data[i]["taggedUser"].length; j++) {
          this
              .fetchTagUserColorLinkStory
              .add(data[i]["taggedUser"][j]["TagedUserName"]);
        }
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  void getMoreDataUserLinkedStories(
      {int? count, int? page, BuildContext? context}) async {
    try {
      if (!isPaginaionLoading) {
        isPaginaionLoading = true;

        await userLinkedStories(
          count: count,
          page: page,
        );

        isPaginaionLoading = false;

        notifyListeners();
      }
    } catch (err) {
      isPaginaionLoading = false;

      utilService!.showToast(err.toString(), context!);
    }
  }

  /////////////////////////////

  Future<void> familyMemberLinkedStories({
    int? page,
    int? count,
    String? id,
  }) async {
    try {
      var response = await this.http!.getFamilyMemberLinkedStories(
            page!,
            count!,
            id!,
          );

      if (response == null || response.data['data'].isEmpty) {
        return;
      }

      var data = response.data['data'];

      this.fetchTagUserColorLinkStory = [];
      // this.familyLinkedStoriesData = [];
      for (int i = 0; i < data.length; i++) {
        this.familyLinkedStoriesData.add(
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
          },
        );
        for (int j = 0; j < data[i]["taggedUser"].length; j++) {
          this
              .fetchTagUserColorLinkStory
              .add(data[i]["taggedUser"][j]["TagedUserName"]);
        }
      }

      notifyListeners();
    } catch (error) {
      print('Error 2: $error');
      throw (error);
    }
  }

  void getMoreDatafamilyMemberLinkedStories(
      {int? count, int? page, String? id, BuildContext? context}) async {
    try {
      if (!isPaginaionLoading) {
        isPaginaionLoading = true;

        await familyMemberLinkedStories(count: count, page: page, id: id);

        isPaginaionLoading = false;

        notifyListeners();
      }
    } catch (err) {
      isPaginaionLoading = false;

      utilService!.showToast(err.toString(), context!);
    }
  }

  ////////////////////////////////////////
  Future<void> familyMemberStories({
    int? page,
    int? count,
    String? id,
  }) async {
    try {
      var response = await this.http!.getFamilyMemberStories(
            page!,
            count!,
            id!,
          );

      if (response == null) {
        return;
      }

      var data = response.data['data'];

      // this.fetchTagUserColorLinkStory = [];
      this.familyMemberStoriesData = [];
      for (int i = 0; i < data.length; i++) {
        this.familyMemberStoriesData.add(
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
          },
        );
        for (int j = 0; j < data[i]["taggedUser"].length; j++) {
          this
              .fetchTagUserColorLinkStory
              .add(data[i]["taggedUser"][j]["TagedUserName"]);
        }
      }
      print(familyMemberStoriesData.length);

      notifyListeners();
    } catch (error) {
      print('Error1: $error}');
      throw (error);
    }
  }

  Future<void> filterFamilyMemberStories(
      {int? page, int? count, String? id, String? categories}) async {
    if (categories == "all" || categories == "All") {
      this.familyMemberStoriesData.clear();
      await familyMemberStories(count: count, id: id, page: page);
    } else {
      this.familyMemberStoriesData.clear();
    //  await familyMemberStories(count: count, id: id, page: page);     // commented by chetu
      await fetchAllCategoryPostByCategoryIdForParticularUser(count: count,page: page,childId: categories,userId: id);
      List data = [];
      // data = this
      //     .familyMemberStoriesData
      //     .where((element)=>
      //   element["subCatagories"].forEach((ele) => ele==categories)
      // )
      //     .toList();    // not commented by chetu, already commented by client




      // this.familyMemberStoriesData.forEach((element) {
      //   print(element["subCatagories"]);
      //   print(categories);
      //   element['subCatagories'].forEach((ele){
      //     if (ele == categories) {
      //       data.add(element);
      //     }
      //   });
      // });
      // if (data.length != 0) {
      //   print('Clear');
      //   this.familyMemberStoriesData.clear();
      //   for (int i = 0; i < data.length; i++) {
      //     this.familyMemberStoriesData.add(
      //       {
      //         "id": data[i]["id"],
      //         "addedByProfilePic": data[i]["addedByProfilePic"],
      //         "addedByName": data[i]["addedByName"],
      //         "addedById": data[i]["addedById"],
      //         "storyTitle": data[i]["storyTitle"],
      //         "description": data[i]["description"],
      //         "catagory": data[i]["catagory"],
      //         "media": data[i]["media"],
      //         "createdOnDate": data[i]["createdOnDate"],
      //         "likes": data[i]["likes"],
      //         "taggedUser": data[i]["taggedUser"],
      //         "subCatagories": data[i]["subCatagories"],
      //       },
      //     );
      //     for (int j = 0; j < data[i]["taggedUser"].length; j++) {
      //       this
      //           .fetchTagUserColorLinkStory
      //           .add(data[i]["taggedUser"][j]["TagedUserName"]);
      //     }
      //   }
      // } else {
      //   this.familyMemberStoriesData.clear();
      // }          // commented by chetu
    }

    notifyListeners();
  }

  void getMoreDatafamilyMemberStories(
      {int? count, int? page, String? id, BuildContext? context}) async {
    try {
      if (!isPaginaionLoading) {
        isPaginaionLoading = true;

        await familyMemberStories(count: count, page: page, id: id);

        isPaginaionLoading = false;

        notifyListeners();
      }
    } catch (err) {
      isPaginaionLoading = false;

      utilService!.showToast(err.toString(), context!);
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

      // this.fetchTagUserColorLinkStory = [];
      this.familyMemberStoriesData = [];
      for (int i = 0; i < data.length; i++) {
        this.familyMemberStoriesData.add(
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
          },
        );
        for (int j = 0; j < data[i]["taggedUser"].length; j++) {
          this
              .fetchTagUserColorLinkStory
              .add(data[i]["taggedUser"][j]["TagedUserName"]);
        }
      }
      print(familyMemberStoriesData.length);

      notifyListeners();
    } catch (error) {
      print('Error1: $error}');
      throw (error);
    }
  }

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

      // this.fetchTagUserColorLinkStory = [];
      this.familyMemberStoriesData = [];
      for (int i = 0; i < data.length; i++) {
        this.familyMemberStoriesData.add(
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
          },
        );
        for (int j = 0; j < data[i]["taggedUser"].length; j++) {
          this
              .fetchTagUserColorLinkStory
              .add(data[i]["taggedUser"][j]["TagedUserName"]);
        }
      }
      print(familyMemberStoriesData.length);

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }


  Future<void> fetchAllCategoryPostNew({
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

      // this.fetchTagUserColorLinkStory = [];
      this.familyMemberStoriesData = [];
      for (int i = 0; i < data.length; i++) {
        this.familyMemberStoriesData.add(
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
          },
        );
        for (int j = 0; j < data[i]["taggedUser"].length; j++) {
          this
              .fetchTagUserColorLinkStory
              .add(data[i]["taggedUser"][j]["TagedUserName"]);
        }
      }
      print(familyMemberStoriesData.length);

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }


}
