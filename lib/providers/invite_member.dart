import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mystory_flutter/constant/enum.dart';
import 'package:mystory_flutter/models/email_invite.dart';
import 'package:mystory_flutter/models/relation.dart';
import 'package:mystory_flutter/services/http_service.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

class InviteProvider with ChangeNotifier {
  HttpService? http = locator<HttpService>();
  StorageService? storageService = locator<StorageService>();
  UtilService? utilService = locator<UtilService>();
  var navigationService = locator<NavigationService>();
  var message;
  bool isPaginaionLoading = false;
  var defaultSharingSelection = 0;
  var storyBookPermissions = 0;
  var familyTreePermissions = 0;
  var categoriesSubCategories = 0;
  var familyData;
  var familyTreeData;
  Map<String, dynamic> createMember = {};
  List<RelationModel> relationData = [];
  List<RelationModel> relationDataFamily = [];
  List images = [];
  List videos = [];
  List familyTree = [];

  ///////family tree search/////
  List<Map<String, dynamic>> newDataList = [];

  //User data
  List<Map<String, dynamic>> fetcFamilyTreeUserData = [];

  // List<Map<String, dynamic>> dataSearch = [];
  ////////////////////
  List<Map<String, dynamic>> fetcFamilyTree = [];
  List<Map<String, dynamic>> fetcFamilyTreePagination = [];
  List<Map<String, dynamic>> FilterFamilyTreeData = [];
  List<Map<String, dynamic>> tagFamilyTree = [];
  List<Map<String, dynamic>> tagFamilyTreePagination = [];
  Map<String, dynamic> searchUserData = {};
  Map<String, dynamic> memberMediaImageListData = {};
  Map<String, dynamic> memberMediaVidosListData = {};
  String? tempId;
  List fetcFilterFamilyTree = [];

  List fetchMember = [];

  setFamilyData(var data) {
    this.familyData = data;
  }

  get getFAmilyData {
    return this.familyData;
  }

  setFamilyTreeData(var data) {
    this.familyTreeData = data;
  }

  get getFAmilyTreeData {
    return this.familyTreeData;
  }

  clearnewDataList() {
    return newDataList = [];
  }

  clearFamilyTreeData() {
    return this.fetcFamilyTree = [];
  }

  clearInviteProviderData() {
    createMember.clear();
    relationData.clear();
    relationDataFamily.clear();
    images.clear();
    videos.clear();
    familyTree.clear();
    newDataList.clear();
    fetcFamilyTree.clear();
    fetcFamilyTreePagination.clear();
    FilterFamilyTreeData.clear();
    tagFamilyTree.clear();
    tagFamilyTreePagination.clear();
    searchUserData.clear();
    memberMediaImageListData.clear();
    memberMediaVidosListData.clear();
    fetcFilterFamilyTree.clear();
    fetchMember.clear();
  }

  setDefaultSharingSelectionValue(var value) {
    this.defaultSharingSelection = value;
    notifyListeners();
  }

  setDefaultStoryBookPermissionsValue(var value) {
    this.storyBookPermissions = value;
    notifyListeners();
  }

  setDefaultFamilyTreePermissionsValue(var value) {
    this.familyTreePermissions = value;
    notifyListeners();
  }

  setDefaultCategoriesSubCategoriesValue(var value) {
    categoriesSubCategories = value;
    notifyListeners();
  }

  setUserData(var value) {
    this.fetcFamilyTreeUserData = value;
    notifyListeners();
  }

// get getDefaultCategoriesSubCategoriesValue(var value) {
//     categoriesSubCategories = value;
//     notifyListeners();
//   }

  get getSearchUserData {
    return this.searchUserData;
  }

  get getMemberMediaImageListData {
    return this.memberMediaImageListData;
  }

  get getMemberMediaVideotData {
    return this.memberMediaVidosListData;
  }

  // show() {
  //   defaultSharingSelection = true;
  //   storyBookPermissions = true;
  //   familyTreePermissions = true;
  //   categoriesSubCategories = true;
  //   notifyListeners();
  // }

  get getRelationFamilyTree {
    return this.relationDataFamily;
  }

  get getRelation {
    return this.relationData;
  }

  get getFamilyTreeData {
    return this.fetcFamilyTree;
  }

  get getFitlerFamilyTreeData {
    return this.fetcFilterFamilyTree;
  }

  Future<void> fetchAllRelation() async {
    try {
      var response = await this.http!.getAllRelation();

      if (response == null) {
        return;
      }
      var data = response.data['data'];
      this.relationData = [];
      for (int i = 1; i < data.length; i++) {
        this.relationData.add(RelationModel.fromJson(data[i]));
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
    return;
  }

  Future<bool> deleteFamilyMember({var data, BuildContext? context}) async {
    try {
      var response = await this.http!.deleteUserPermanently(data: data);
      notifyListeners();
      utilService!.showToast(response.data["message"], context!);
      return response.data["isSuccess"];
    } catch (err) {
      Navigator.pop(context!);
      return false;
    }
  } // implemented by chetu.

  Future<void> fetchAllRelationFamilyTree() async {
    try {
      var response = await this.http!.getAllRelationFamilyTree();

      if (response == null) {
        return;
      }
      var data = response.data['data'];
      this.relationDataFamily = [];
      for (int i = 0; i < data.length; i++) {
        this.relationDataFamily.add(RelationModel.fromJson(data[i]));
        tempId = this.relationDataFamily[0].id;
      }
   //   this.relationDataFamily.sort((a,b)=>a.relationName!.compareTo(b.relationName!));
      notifyListeners();
    } catch (error) {
      throw (error);
    }
    return;
  }

//Invite Member
  Future<void> createInviteMember(
      {String? inviteComment,
      String? id,
      String? receiverEmail,
      var relation,
      var reciever,
      var sender,
      var permission,
      var categories,
      BuildContext? context}) async {
    reciever["receiverEmail"] = receiverEmail;
    reciever["permission"] = permission;
    reciever["categories"] = categories;
    reciever["relation"] =
        relation; // again adding things in receiver as per new APi suggestion - Done by chetu

    try {
      createMember = {
        "inviteComment": inviteComment,
        "receiverEmail": receiverEmail,
        "relation": relation,
        "reciever": reciever,
        "permission": permission,
        "categories": categories,
      };
      print("createMember");
      log(jsonEncode(createMember).toString());
      // var a =  {"inviteComment": inviteComment,
      //  "receiverEmail": receiverEmail,
      //  "permission": permission,
      //  "categories": categories,
      //   "relation": relation,
      //  "reciever": reciever,
      //  "receiverEmail": "user1@yopmail.com",
      //   "permission": permission,
      //  "categories": categories,
      //    "relation": relation };


      var response = await this.http!.createInviteMember(createMember);

      print(response.data);
      await this
          .storageService!
          .setData(StorageKeys.inviteMember.toString(), this.createMember);

      var user = Provider.of<AuthProviderr>(context!, listen: false).user;
      fetchSearchUserDetail(myId: user.id, viewuserId: id);
      utilService!.showToast(response.data["message"], context!);
      //   navigationService.navigateTo(SearchStoryBookScreenRoute);  //commented by chetu
      navigationService.closeScreen();
      notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  Future<void> editPermission({
    var id,
    var defaults,
    var storyBook,
    var familyTree,
    var categorySubcategory,
    var subCategoryIds,
    BuildContext? context,
  }) async {
    try {
      // final sendPermission = {
      //   "categorySubcategory": categorySubcategory,
      //   "storyBook": storyBook,
      //   "default": defaults,
      //   "familyTree": familyTree
      // };

      var data1 = {
        "permission": {
          "categorySubcategory": categorySubcategory,
          "storyBook": storyBook,
          "default": defaults,
          "familyTree": familyTree
        },
        "subCategoryIds": subCategoryIds
      };

      print(data1);


      var response = await this.http!.editPermission(data1, id!);

      var user = Provider.of<AuthProviderr>(context!, listen: false).user;
      fetchSearchUserDetail(myId: user.id, viewuserId: id);
      notifyListeners();
      utilService!.showToast(response.data["message"], context!);
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  Future<void> emailInviteMember(
      {EmailInvite? emailInvite, BuildContext? context}) async {
    try {
      print(
          'Email Invite: ${emailInvite!.message!.subject}, ${emailInvite.message!.text}, ${emailInvite.to}');
      Map<String, dynamic> invitation = {
        'to': emailInvite.to,
        'message': emailInvite.message,
      };
      var response =
          await this.http!.emailInviteMember(EmailInvite.fromJson(invitation));
      notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

  Future<void> fetchAllInviteMember(String? id) async {
    try {
      var response = await this.http!.getinviteMember();

      if (response == null) {
        return;
      }
      var data = response.data['data'];

      this.fetchMember = [];
      for (int i = 0; i < data.length; i++) {
        this.fetchMember.add(
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
          },
        );
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<dynamic> fetchAllCategoriesAndSubCategories() async {
    try {
      var response = await this.http!.getAllCategoryAndSubCategory();

      if (response == null) {
        return;
      }
      var data = response.data['data'];

      notifyListeners();
      return data;
    } catch (error) {
      return null;
      throw (error);
    }
  }

  Future<dynamic> fetchUserPermissions(String receiverId) async {
    print("receiverId");
    print(receiverId);
    try {
      var response = await this.http!.getParticularUserPermission(receiverId);
      if (response == null) {
        return;
      }
      // if(response.data['data'] == null){
      //   return {
      //
      //   };
      // }
      var data = response.data['data'];
      notifyListeners();
      return data;
    } catch (error) {
      throw (error);
    }
  }

  Future<void> inviteMembers(
      {String? linkedStatus,
      String? notificationId,
      String? id,
      var sender,
      BuildContext? context}) async {
    try {
      var data = {
        "linkedStatus": linkedStatus,
        "notificationId": notificationId,
        "sender": sender
      };
      print("data");
      print("id");
      print(id);
      log(data.toString());
      await this.http!.inviteMembers(data: data, id: id);

    } catch (err) {
      utilService!.showToast(err.toString(), context!);
      print(err);
    }
  }

  Future<void> fetchAllFamilyTree({String? id, count, page}) async {
    try {
      print(id);
      print(count);
      print(page);
      var response =
          await this.http!.getFamilyTree(id: id, count: count, page: page);

      if (response == null) {
        return;
      }
      var data = response.data['data'];
      this.tagFamilyTree = [];
      this.fetcFamilyTree = [];
      for (int i = 0; i < data.length; i++) {
        this.fetcFamilyTree.add(
          {
            // "profilePicture": data[i]['profilePicture'],
            "id": data[i]["id"],
            "firstName": data[i]["firstName"],
            "middleName": data[i]["middleName"],
            "lastName": data[i]["lastName"],
            "fullName": data[i]["fullName"],
            "relation": data[i]["relation"],
            "profilePicture": data[i]["profilePicture"],
            "dob": data[i]["dob"],
            "address": data[i]["address"],
            "email": data[i]['email'],
            "description": data[i]['description'],
            "treeAdminId": data[i]['treeAdminId'],
            "isRemove": data[i]['isRemove'] ?? false,
            "homeTown": data[i]['homeTown']
          },
        );
        this.tagFamilyTree.add({
          'id': data[i]["id"],
          'full_name': data[i]["firstName"] + data[i]["lastName"],
          'display': data[i]["firstName"] + data[i]["lastName"],
          "image": data[i]["profilePicture"],
        });
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchFilterFamilyTree(
      {String? id, count, page, reltationId}) async {
    try {
      var response = await this.http!.getFitlerFamilyTree(
          id: id, count: count, page: page, reltationId: reltationId);

      if (response == null) {
        return;
      }
      var data = response.data['data'];

      this.FilterFamilyTreeData = [];
      for (int i = 0; i < data.length; i++) {
        this.FilterFamilyTreeData.add(
          {
            "id": data[i]["id"],
            "firstName": data[i]["firstName"],
            "middleName": data[i]["middleName"],
            "lastName": data[i]["lastName"],
            "relation": data[i]["relation"],
            "profilePicture": data[i]["profilePicture"],
            "dob": data[i]["dob"],
            "address": data[i]["address"],
            "email": data[i]['email'],
            "description": data[i]['description'],
            "treeAdminId": data[i]['treeAdminId'],
            "isRemove": data[i]['isRemove'] ?? false,
            "homeTown": data[i]['homeTown']
          },
        );
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

//This method will fetch member profile from user's family tree
  Future<String?> fetchSearchUserDetail(
      {String? myId, String? viewuserId}) async {
    try {
      var response = await this
          .http!
          .getSearchUserDetails(myId: myId, viewuserId: viewuserId);
      print("myId");
      print(myId);
      print(viewuserId);
      log(response.toString());
      if (response == null || response.data["isSuccess"] == false) {
        return null;
      }
      var data = response.data["data"];
      this.searchUserData = {};
      // for (int i = 0; i < data.length; i++) {
      this.searchUserData = {
        "id": data["id"],
        "firstName": data["firstName"],
        "middleName": data["middleName"],
        "lastName": data["lastName"],
        "givenName": data["givenName"],
        "shortDescription": data["shortDescription"],
        "email": data["email"],
        "contact": data["contact"],
        "profilePicture": data["profilePicture"],
        "profileStory": data["profileStory"],
        "relation": data["relation"],
        "homeTown": data["homeTown"],
        // "notificationSettings": {
        //     "admin": true,
        //     "newStory": true,
        //     "storybookLikes": true,
        //     "linkedRequests": true,
        //     "acceptedLink": true,
        //     "pendingInvitaions": true,
        //     "chat": true,
        //     "inappNotifications": true
        // },
        "storyBookCount": data["storyBookCount"],
        "treeBookCount": data["treeBookCount"],
        "linkStoryCount": data["linkStoryCount"],
        "inviteStatus": data["inviteStatus"],
        "address": data["address"],
        // "address": {
        //     "cityValue": "Tokyo",
        //     "countryValue": "Japan",
        //     "stateValue": "Japan State"
        // },
        "dob": data["dob"],
        // "searchKey": "S",
        // "isActive": true,
        // "isBlock": false,
        // "isEmailVerified": false,
        // "loginSource": "default",
        "createdOnDate": data["createdOnDate"],
        "fullName": data["fullName"],
      };

      // }
      notifyListeners();
      return '';
    } catch (error) {
      throw (error);
    }
  }

//chetu

//  Future<Map<String,dynamic>> viewProfileFamilyTree({String? myId, String? viewuserId}) async {
//     try {
//       var response = await this
//           .http!
//           .getSearchUserDetails(myId: myId, viewuserId: viewuserId);

//       // if (response == null || response.data["isSuccess"] == false) {
//       //   return null;
//       // }
//       var data = response.data["data"];

//       notifyListeners();
//       return data;
//     } catch (error) {
//       throw (error);
//     }
//   }

//chetu //

  Future<void> fetchFamilyMediaGalleryImg(
      {String? id, int? page, int? count}) async {
    try {
      var response = await this
          .http!
          .familyMemberMediaGalleryImages(id: id!, page: page!, count: count!);
      if (response == null || response.data['isSuccess'] == false) {
        return;
      }

      var data = response.data["data"];

      this.images = [];

      for (int i = 0; i < data["posts"].length; i++) {
        for (int j = 0; j < data["posts"][i]["media"].length; j++) {
          if (data["posts"][i]["media"][j]["contentType"] == "image") {
            images.add(data["posts"][i]["media"][j]['url']);
          }
        }
      }

      this.memberMediaImageListData = {
        "posts": data["posts"],
        "images": this.images,
        "permission": data["permission"],
      };
      notifyListeners();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> fetchFamilyMediaGalleryVideos(
      {String? id, int? page, int? count, BuildContext? context}) async {
    try {
      var response = await this
          .http!
          .familyMemberMediaGalleryVideos(id: id!, page: page!, count: count!);
      if (response == null) {
        return;
      }

      var data = response.data["data"];

      this.videos = [];
      for (int i = 0; i < data["posts"].length; i++) {
        for (int j = 0; j < data["posts"][i]["media"].length; j++) {
          if (data["posts"][i]["media"][j]["contentType"] == "video") {
            videos.add(data["posts"][i]["media"][j]['thumbnail']);
          }
        }
      }

      this.memberMediaVidosListData = {
        "posts": data["posts"],
        "videos": this.videos,
        "permission": data["permission"],
      };
      notifyListeners();
    } catch (err) {
      print(err.toString());
      // utilService!.showToast(err.toString(), context!);
    }
  }

  Future<void> putChangeRelation(
      {String? id, Map<String, dynamic>? data, BuildContext? context}) async {
    try {
      await this.http!.changeRelation(id!, data!);
      var user = Provider.of<AuthProviderr>(context!, listen: false).user;
      fetchSearchUserDetail(myId: user.id, viewuserId: id);
      notifyListeners();
    } catch (err) {
      utilService!.showToast(err.toString(), context!);
    }
  }

/////////////////////////////////////
// Family Tree //
  Future<void> fetchFamiltTreeMember({
    String? id,
    int? page,
    int? count,
  }) async {
    try {
      this.familyTree.clear();
      var response =
          await this.http!.getUersFamilyTree(id: id, count: count, page: page);
print("response family tree");
log(response.toString());
      if (response == null || response.data['isSuccess'] == false) {
        return;
      }
      var data = response.data['data'];
      message = response.data['message'];

      for (int i = 0; i < data.length; i++) {
        this.familyTree.add({
          "id": data[i]["id"],
          "firstName": data[i]["firstName"],
          "lastName": data[i]["lastName"],
          "middleName": data[i]["middleName"],
          "relation": data[i]["relation"],
          "profilePicture": data[i]["profilePicture"],
          "dob": data[i]["dob"],
          "address": data[i]["address"],
          "email": data[i]['email'],
          "description": data[i]['description'],
          "treeAdminId": data[i]['treeAdminId'],
        });
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
    return;
  }

  void getMoreDatafamilyMemberTree(
      {int? count, int? page, String? id, BuildContext? context}) async {
    try {
      if (!isPaginaionLoading) {
        isPaginaionLoading = true;

        await fetchFamiltTreeMember(count: count, page: page, id: id);

        isPaginaionLoading = false;

        notifyListeners();
      }
    } catch (err) {
      isPaginaionLoading = false;
      print(err);
      // utilService!.showToast(err.toString(), context!);
    }
  }

  Future<void> fetchAllFamilyTreeForPagination(
      {String? id, count, page}) async {
    try {
      var response =
          await this.http!.getFamilyTree(id: id, count: count, page: page);

      if (response == null) {
        return;
      }
      var data = response.data['data'];
      this.tagFamilyTreePagination = [];
      this.fetcFamilyTreePagination = [];
      for (int i = 0; i < data.length; i++) {
        this.fetcFamilyTreePagination.add(
          {
            // "profilePicture": data[i]['profilePicture'],
            "id": data[i]["id"],
            "firstName": data[i]["firstName"],
            "lastName": data[i]["lastName"],
            "fullName": data[i]["fullName"],
            "relation": data[i]["relation"],
            "profilePicture": data[i]["profilePicture"],
            "dob": data[i]["dob"],
            "address": data[i]["address"],
            "email": data[i]['email'],
            "treeAdminId": data[i]['treeAdminId'],
            "isRemove": data[i]['isRemove'] ?? false,
            "homeTown": data[i]['homeTown']
          },
        );
        this.tagFamilyTreePagination.add({
          'id': data[i]["id"],
          'full_name': data[i]["firstName"] + data[i]["lastName"],
          'display': data[i]["firstName"] + data[i]["lastName"],
          "image": data[i]["profilePicture"],
        });
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  void getMoreDatafamilyTreeTab(
      {int? count, int? page, String? id, BuildContext? context}) async {
    try {
      if (!isPaginaionLoading) {
        isPaginaionLoading = true;

        await fetchAllFamilyTreeForPagination(count: count, page: page, id: id);
        if (this.fetcFamilyTreePagination.length == 0) {
          utilService!.showToast("No more family tree", context!);
        } else {
          this.fetcFamilyTree.addAll(this.fetcFamilyTreePagination);
        }
        // this.fetcFamilyTree.addAll(this.fetcFamilyTree);
        isPaginaionLoading = false;

        notifyListeners();
      }
    } catch (err) {
      isPaginaionLoading = false;
      print(err);
      // utilService!.showToast(err.toString(), context!);
    }
  }

////////family tree search
// void familyTreeSearch() {
//   this.dataSearch.addAll(this.fetcFamilyTree);
//   // for (int i = 0; i < this.fetcFamilyTree.length; i++) {
//   //   this.dataSearch.add(fetcFamilyTree[i]["firstName"]);
//   // }
//   // this.newDataList = List.from(this.fetcFamilyTree);
// }
//////
}
