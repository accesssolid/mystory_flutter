// import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:mystory_flutter/models/category.dart';
import 'package:mystory_flutter/services/http_service.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:supercharged/supercharged.dart';

class CategoryProvider with ChangeNotifier {
  HttpService? http = locator<HttpService>();

  List<CategoryModel> categoryData = [];

  List categorySubDataCreateStory = [];
  List categorySubDataStoryBook = [];
  List categorySubDataHomeScreen = [];
  List categorySubDataInviteMember = [];

  List inviteSubCatSelectData = [];
  List<CategoryModel> createStoryParentCategoriesId = [];

  List createStorySubCatSelectData = [];

  List addImages = [];
  var categoryObj;
  var subCategoryObj;

  var selectHomeText;
  // var selectStoryText;
  var selectStoryText;
  get getCategorySubDataInviteMember {
    return this.categorySubDataInviteMember;
  }

  get getSubCategory {
    return this.categorySubDataStoryBook;
  }

  get subCategoryDataHomeScreen {
    return this.categorySubDataHomeScreen;
  }


  clearSubCategoryDataHomeScreen (){
     this.categorySubDataHomeScreen =[];
     
  }

  get getselectStory {
    return this.selectStoryText;
  }

  get getAllCategories {
    return this.categoryData;
  }

  get getMedia {
    return this.addImages;
  }

  setCreateStoryParentCategoriesId(var data) {
    if (!this.createStoryParentCategoriesId.contains(data)) {
      this.createStoryParentCategoriesId.add(data);
    }
  }

  nullCreateStoryParentCategoriesId() {
    this.createStoryParentCategoriesId = [];
  }

  setInviteSubCategories(var data) {
    this.inviteSubCatSelectData.add(data);
    notifyListeners();
  }

  setCreateStorySubCatSelectData(var data) {
    this.createStorySubCatSelectData.add(data);

    notifyListeners();
  }

  nullCreateStorySubCatSelectData() {
    this.createStorySubCatSelectData = [];

    notifyListeners();
  }

  nullCategorySubDataCreateStory() {
    this.categorySubDataCreateStory = [];

    notifyListeners();
  }

  removeCategorySubDataCreateStory(var data) {
    this.categorySubDataCreateStory.remove(data);
    notifyListeners();
  }

  removeCreateStorySubCatSelectData(var data) {
    this.createStorySubCatSelectData.remove(data);
    notifyListeners();
  }

  insertInCategorySubDataInviteMember(var data) {
    this.categorySubDataInviteMember.insert(0, data);
    notifyListeners();
  }

  insertInCategorySubDataCreateStory(var data) {
    this.categorySubDataCreateStory.insert(0, data);
    notifyListeners();
  }

  removeInviteSubCatSelectData(var data) {
    this.inviteSubCatSelectData.remove(data);
    notifyListeners();
  }

  nullInviteSubCatSelectList() {
    this.inviteSubCatSelectData = [];
  }

  nullCreateStorySubCatSelectList() {
    this.createStorySubCatSelectData = [];
  }

  removreCategorySubDataInviteMember(var data) {
    this.categorySubDataInviteMember.remove(data);
    notifyListeners();
  }

  setMedia(var data) {
    this.addImages.add(data);
  }

  removeMedia() {
    this.addImages = [];
  }

  selectHome(var data) {
    this.selectHomeText = data;
  }

  selectStoryBook(var data) {
    this.selectStoryText = data;
  }

  setImages(var data) {
    this.addImages.add(data);
  }

  setCategory(var data) {
    this.categoryObj = data;
  }

  setSubCategory(var data) {
    this.subCategoryObj = data;
  }

  Future<void> fetchAllCategories() async {
    try {
      var response = await this.http!.getAllCategories();

      if (response == null) {
        return;
      }
      var data = response.data['data'];
      this.categoryData = [];
      for (int i = 0; i < data.length; i++) {
        this.categoryData.add(CategoryModel.fromJson(data[i]));
      }

      notifyListeners();
    } catch (error) {
      throw (error);
    }
    return;
  }

  Future<void> fetchSubCategoriesCreateStory({
    String? id,
  }) async {
    try {
      var response = await this.http!.getSubCategories(id);

      if (response == null) {
        return;
      }
      var data = response.data['data'];

      this.categorySubDataCreateStory = [];

      for (int i = 0; i < data.length; i++) {
        this.categorySubDataCreateStory.add({
          "parentId": data[i]["parentId"] ?? "",
          "id": data[i]["id"] ?? "",
          "categoryName": data[i]["categoryName"] ?? "",
        });
      }

      if (this.createStorySubCatSelectData.isNotEmpty) {
        for (int i = 0; i < this.createStorySubCatSelectData.length; i++) {
          for (int j = 0; j < this.categorySubDataCreateStory.length; j++) {
            if (this.categorySubDataCreateStory[j]["id"] ==
                this.createStorySubCatSelectData[i]["id"]) {
              this.categorySubDataCreateStory.removeAt(j);
            }
          }
        }
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
    return;
  }

  Future<void> fetchSubCategoriesStoryBook({
    String? id,
  }) async {
    try {
      var response = await this.http!.getSubCategories(id);

      if (response == null) {
        return;
      }
      var data = response.data['data'];

      this.categorySubDataStoryBook = [];

      for (int i = 0; i < data.length; i++) {
        this.categorySubDataStoryBook.add({
          "parentId": data[i]["parentId"] ?? "",
          "id": data[i]["id"] ?? "",
          "categoryName": data[i]["categoryName"] ?? "",
        });
      }
      // this.categorySubDataStoryBook.insert(0,{
      //   "parentId": "all",
      //   "id": "all",
      //   "categoryName": "All",
      // });
      notifyListeners();
    } catch (error) {
      throw (error);
    }
    return;
  }

  Future<void> fetchSubCategoriesHomeScreen({
    String? id,
  }) async {
    try {
      print("CODE IS RUNNING HERE fetchSubCategoriesHomeScreen");
      var response = await this.http!.getSubCategories(id);

      if (response == null) {
        return;
      }
      var data = response.data['data'];

      this.categorySubDataHomeScreen = [];

      for (int i = 0; i < data.length; i++) {
        this.categorySubDataHomeScreen.add({
          "parentId": data[i]["parentId"] ?? "",
          "id": data[i]["id"] ?? "",
          "categoryName": data[i]["categoryName"] ?? "",
        });
      }
      this.categorySubDataHomeScreen.insert(0,{
        "parentId": "all",
        "id": "all",
        "categoryName": "All",
      });
      notifyListeners();
    } catch (error) {
      throw (error);
    }
    return;
  }

  Future<void> fetchSubCategoriesInviteMember({
    String? id,
  }) async {
    try {
      var response = await this.http!.getSubCategories(id);

      if (response == null) {
        return;
      }
      var data = response.data['data'];

      this.categorySubDataInviteMember = [];

      for (int i = 0; i < data.length; i++) {
        this.categorySubDataInviteMember.add({
          "parentId": data[i]["parentId"] ?? "",
          "id": data[i]["id"] ?? "",
          "categoryName": data[i]["categoryName"] ?? "",
        });
      }
      if (this.inviteSubCatSelectData.isNotEmpty) {
        for (int i = 0; i < this.inviteSubCatSelectData.length; i++) {
          for (int j = 0; j < this.categorySubDataInviteMember.length; j++) {
            if (this.categorySubDataInviteMember[j]["id"] ==
                this.inviteSubCatSelectData[i]["id"]) {
              this.categorySubDataInviteMember.removeAt(j);
            }
          }
        }
      }

      notifyListeners();
    } catch (error) {
      throw (error);
    }
    return;
  }
}
