import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mystory_flutter/constant/enum.dart';
import 'package:mystory_flutter/models/email_invite.dart';

// import 'package:firebase_auth/firebase_auth.dart';
import '/utils/service_locator.dart';

import '../services/storage_service.dart';

class HttpService {
  Dio _dio = Dio(); //builtin
  StorageService? storage = locator<StorageService>();
  final baseUrl =
     "https://mystory-app-9a032.firebaseapp.com/mystory/api/v1/"; // old Live
      //"https://1e4b-223-178-209-38.ngrok-free.app/mystory-app-9a032/us-central1/mystory/mystory/api/v1/"; // new Live


  //https://1e4b-223-178-209-38.ngrok-free.app/mystory-app-9a032/us-central1/mystory/mystory/api/v1/
  //   "http://127.0.0.1:4000/mystory-app-9a032/us-central1/mystory/mystory/api/v1/"; // Local
  // final baseUrl =
  //     "https://us-central1-mystory-app-9a032.cloudfunctions.net/newDevEnv/newDevEnv/api/v1/"; // new

  Future<Dio> getApiClient() async {
    try {
      var token = await storage!.getData(StorageKeys.token.toString());
      print("ttt ==== tttt ==== ttt ====");
      LogPrint("Bearer " + token.toString());
      print("\n\n\n==========");
      print('Token: $token');
      _dio.interceptors.clear();
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, interceptorHandler) {
            // Do something before request is sent
            options.headers["Authorization"] = "Bearer " + token.toString();
            return interceptorHandler.next(options);
            // ignore: non_constant_identifier_names
          },
          onResponse: (response, interceptorHandler) {
            // Do something with response data
            return interceptorHandler.next(response); // continue
            // ignore: non_constant_identifier_names
          },
          onError: (error, interceptorHandler) async {
            // Do something with response error
            if (error.response?.statusCode == 403 ||
                error.response?.statusCode == 401) {
              _dio.interceptors.requestLock.lock();
              _dio.interceptors.responseLock.lock();
              // ignore: unused_local_variable
              RequestOptions options = error.response!.requestOptions;
              // ignore: unused_local_variable
              Options? opt;
              var user = FirebaseAuth.instance.currentUser!;
              token = await user.getIdToken(true);
              await storage!.setData(StorageKeys.token.toString(), token);
              options.headers["Authorization"] = "Bearer " + token.toString();

              _dio.interceptors.requestLock.unlock();
              _dio.interceptors.responseLock.unlock();
              //  return _dio.request(options.path, options: opt);
            } else {
              return interceptorHandler.next(error);
            }
          },
        ),
      );
      //  _dio.options.baseUrl = baseUrl;
    } catch (err) {
      print(err);
    }

    return _dio;
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
        String message = log.substring(start, endIndex);
        // Remove the "I/flutter (30018): " prefix
        message = message.replaceFirst(RegExp(r'I/flutter \(\d+\): '), '');
        print(message);
        endIndex += defaultPrintLength;
        start += defaultPrintLength;
        tmpLogLength -= defaultPrintLength;
      }
      if (tmpLogLength > 0) {
        String message = log.substring(start, logLength);
        // Remove the "I/flutter (30018): " prefix
        message = message.replaceFirst(RegExp(r'I/flutter \(\d+\): '), '');
        print(message);
      }
    }
  }


  registerDevice(Map<String, dynamic> data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + "user/device", data: data);
    return response;
  }

  unRegisterDevice(Map<String, dynamic> data) async {
    var http = await getApiClient();
    var response = await http.delete(baseUrl + "user/device", data: data);
    return response;
  }

  signUp(Map<String, dynamic> data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + "user/signup", data: data);
    return response;
  }

  signIn() async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + 'user/signin');
    return response;
  }

  createProfileInformation(Map<String, dynamic> data) async {
    var http = await getApiClient();
    var response = await http.put(baseUrl + "user/edit", data: data);
    return response;
  }

  addFamilyMemberManually(Map<String, dynamic> data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + "user/tree", data: data);
    print('Add Family Member Response: $response');
    return response;
  }

  // updateProfileInformation(Map<String, dynamic> data) async {
  //   var http = await getApiClient();
  //   var response = await http.put(baseUrl + "user/edit", data: data);
  //   log(response.toString());
  //   return response;
  // }

  editProfileInformation(Map<String, dynamic> data) async {
    var token = await storage!.getData(StorageKeys.token.toString());
    var dio = Dio();
    dio.options.headers.addAll(
        {"content-json": "application/json", "Authorization": "Bearer $token"});
    var response = await dio.patch(baseUrl + "user/edits", data: data);
    print(response.toString());
    //  log(response.toString());
    return response;
  }

  getUser() async {
    try {
      var http = await getApiClient();
      var response = await http.get(baseUrl + "users/getuser");
      return response;
    } catch (er) {
      // print(er.toString());
    }
  }

  getRelationShip() async {
    try {
      var http = await getApiClient();
      var response = await http.get(baseUrl + "user/members/profile");
      return response;
    } catch (er) {
      // print(er.toString());
    }
  }

  getUserById(String id) async {
    try {
      var http = await getApiClient();
      print(baseUrl + "user/userDetails/$id");
      var response = await http.get(baseUrl + "user/userDetails/$id");
      print(response.data);
      return response;
    } catch (er) {
      // print(er.toString());
    }
  }

  createStory(Map<String, dynamic> data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + "post/", data: data);

    return response;
  }

  updateStory(Map<String, dynamic> data, id) async {
    var http = await getApiClient();
    var response = await http.put(baseUrl + "post/$id", data: data);
    return response;
  }

  deleteStory(id) async {
    var http = await getApiClient();
    var response = await http.delete(
      baseUrl + "post/$id",
    );
    return response;
  }

  getAllUserPost(String id) async {
    try {
      var http = await getApiClient();
      var response = await http.get(
        baseUrl + "post/user/$id",
        // queryParameters: {"count": count, "page": page}
      );
      return response;
    } catch (er) {
      // print(er.toString());
    }
  }

  getPostDetailByPostId(String id) async {
    try {
      var http = await getApiClient();
      var response = await http.get(
        baseUrl + "post/$id",
      );
      return response;
    } catch (er) {
      debugPrint(er.toString());
    }
  }

//Create Invitaion for invite member
  createInviteMember(Map<String, dynamic> data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + "invite", data: data);
    return response;
  }

//api to edit user permission
  editPermission(dynamic data, String receiverId) async {
    var http = await getApiClient();
    var response = await http.put(baseUrl + "invite/permission",
        data: jsonEncode(data),
        queryParameters: {
          "receiverId": receiverId,
        });
    print(receiverId);
    //  print('EditPermission Response: ${response.data}');
    log("EditPermission Response: ${response.data}".toString());
    return response;
  }

  emailInviteMember(EmailInvite data) async {
    var http = await getApiClient();
    var response =
        await http.post(baseUrl + "email/userInvite", data: json.encode(data));
    return response;
  }

  // like post //

  likePost(Map<String, dynamic> data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + "post/like", data: data);
    return response;
  }

  // releation data fetch in dropdown for invite member screen//

  getAllRelation() async {
    try {
      var http = await getApiClient();
      var response = await http.get(baseUrl + "relation");
      return response;
    } catch (er) {
      print(er.toString());
    }
  }

  getAllRelationFamilyTree() async {
    try {
      var http = await getApiClient();
      // var response = await http.get(baseUrl + "relation/all");
      var response = await http.get(baseUrl + "relation");
      print("response");
      print(response.data);
      return response;
    } catch (er) {
      print(er.toString());
    }
  }

  // invite member data fetch in My Family Screen //

  getinviteMember() async {
    try {
      var http = await getApiClient();
      var response = await http.get(
        baseUrl + "invite",
      );
      return response;
    } catch (er) {
      // print(er.toString());
    }
  }

  responseNotification(notificationId, reactionType) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + "reaction/match/$reactionType",
        queryParameters: {"notificationId": notificationId});
    return response;
  }

  // QUERY PARAMETER INCLUDE
  getCurrentSession(String? userId) async {
    var http = await getApiClient();

    var response = await http.get(baseUrl + 'session/getSessionsByUserId',
        queryParameters: {"userId": userId});
    return response;
  }

  previousSession(String? userId) async {
    var http = await getApiClient();
    var response = await http.get(
        baseUrl + 'session/getPreviousSessionsByUserId',
        queryParameters: {'userId': userId});
    return response;
  }

  deleteUser(String? userId) async {
    var http = await getApiClient();

    var response = await http
        .post(baseUrl + "users/delete", queryParameters: {'userId': userId});
    return response;
  }

  deleteChats(String? chatId) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + 'users/deletechats',
        queryParameters: {"chatId": chatId});
    return response;
  }

  addNewSession(Map<String, dynamic> data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + 'session/add', data: data);
    return response;
  }

  markAsPremium(Map<String, dynamic> data, String? userId) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + "users/premium",
        data: data, queryParameters: {'userId': userId});
    return response;
  }

  updateSessionStatus(Map<String, dynamic> data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + 'session/update', data: data);
    return response;
  }

  addUserContact(Map<String, dynamic> data, String? userId) async {
    var http = await getApiClient();
    var response = await http
        .post(baseUrl + 'users/addcontact', data: data, queryParameters: {
      'userId': userId,
    });
    return response;
  }

  getAllUserContacts(String? userId) async {
    var http = await getApiClient();
    var response =
        await http.get(baseUrl + 'users/allcontacts', queryParameters: {
      'userId': userId,
    });
    return response;
  }

  getAllCategories() async {
    try {
      var http = await getApiClient();
      var response = await http.get(baseUrl + "category/parent");
      return response;
    } catch (er) {
      print(er.toString());
    }
  }

  getSubCategories(String? id) async {
    try {
      var http = await getApiClient();
      var response = await http.get(baseUrl + "category/sub/$id");
      return response;
    } catch (er) {
      print(er.toString());
    }
  }

  //All in story book
  fetchAllSubCategories(
    int? page,
    int? count,
    // String? subCategoryId,
    // String? userId,
  ) async {
    try {
      var http = await getApiClient();
      var response =
          await http.get(baseUrl + "post/user/unfilterpost", queryParameters: {
        'page': page,
        'count': count,
        // 'userId': userId,
        // 'subCategoryId': subCategoryId,
      });
     // print('Fetch AllNews Feed Item ${response.data}');
      return response;
    } catch (er) {
      print(er.toString());
    }
  }

  getPostByCategoryId(
    int? page,
    int? count,
    String? childId,
    String? userId,
  ) async {
    try {
      var http = await getApiClient();
      var response =
      //Changed by chetu // API endpoint and childID as subCategoryId
      //     await http.get(baseUrl + "post/users/filterpost", queryParameters: {
      await http.get(baseUrl + "post/elasticSearch/subcategory/post", queryParameters: {
        'page': page,
        'count': count,
        // 'childId': childId,
        'subCategoryId': childId,
        'memberId': userId,
        // 'userId': userId,
      });
      print("response cat data");
      print(response);
      return response;
    } catch (er) {
      print(er.toString());
    }
  }

  getPostByCategoryIdNew(
    int? page,
    int? count,
    String? childId,
    String? userId,
  ) async {
    try {
      var http = await getApiClient();
      var response =
          await http.get(baseUrl + "post/users/memeberPost", queryParameters: {
        'page': page,
        'count': count,
        'childId': childId,
        'memberId': userId,
      });
      print("response cat data new");
      print({'page': page,
        'count': count,
        'childId': childId,
        'memberId': userId,});
      print(response);
      return response;
    } catch (er) {
      print(er.toString());
    }
  }

  fetchAllNewsFeedByCategoryId(
    int? page,
    int? count,
    String? subCategoryId,
    String? userId,
  ) async {
    try {
      var http = await getApiClient();
      var response = await http
      //Change by Chetu also parameters
      //     .get(baseUrl + "post/elasticSearch/newfeeds", queryParameters: {
          .get(baseUrl + "post/elasticSearch/subcategory/post", queryParameters: {
        'page': page,
        'count': count,
        // 'userId': userId,
        'memberId': userId,
        'subCategoryId': subCategoryId,
      });
      print(baseUrl + "post/elasticSearch/subcategory/post");
     print("check abhay post cat page is queryParameters is ${{
       'page': page,
       'count': count,
       // 'userId': userId,
       'memberId': userId,
       'subCategoryId': subCategoryId,
     }}");
    // log(response.toString());
      return response;
    } catch (er) {
      print(er.toString());
    }
  }

fetchAllNewsFeedByCategoryIdNew(
    int? page,
    int? count,
    String? categoryId,
    String? userId,
  ) async {
    try {
      var http = await getApiClient();
      var response = await http
      //changed by Chetu API
          // .get(baseUrl + "post/elasticSearch/category/usernewfeeds", queryParameters: {
          .get(baseUrl + "post/elasticSearch/category/newfeeds", queryParameters: {
        'page': page,
        'count': count,
        // 'memberId': userId,
        'userId': userId,
        'CategoryId': categoryId,
      });
      //https://mystory-app-9a032.firebaseapp.com/mystory/api/v1/post/elasticSearch/catgeory/newfeeds?page=1&count=10&userId=86Fhjbq6GYeudUPr98SHKrLtCwP2&CategoryId=interests
      print(baseUrl + "post/elasticSearch/category/newfeeds");
     print("response post cat new page is queryParameters is  ${{
       'page': page,
       'count': count,
       // 'memberId': userId,
       'userId': userId,
       'CategoryId': categoryId,
     }}");
     log(response.toString());
      return response;
    } catch (er) {
      print(er.toString());
    }
  }

  fetchAllNewsFeedByCategoryIdForParticularUser(
    int? page,
    int? count,
    String? categoryId,
    String? userId,
  ) async {
    try {
      var http = await getApiClient();
      var response = await http
      //Changed by Chetu for testing for profile main Category
      //     .get(baseUrl + "post/elasticSearch/categorywise/usernewfeeds", queryParameters: {
          .get(baseUrl + "post/elasticSearch/userprofile/parentcategory/newfeeds", queryParameters: {
        'page': page,
        'count': count,
        // 'userId': userId,
        'memberId': userId,
        'parentCategoryId': categoryId,
        // 'userId': "OWO4lCo6zNSwxValrIkITHerjUV2",
        // 'CategoryId': categoryId,
      });
     print("response post cat new storybook");
     //log(response.toString());
      return response;
    } catch (er) {
      print(er.toString());
    }
  }

  fetchAllNewsFeedPost(
    int? page,
    int? count,
  ) async {
    try {
      print("fetchAllNewsFeedPost API CALLING HEREEE");
      var http = await getApiClient();
      var response = await http
          .get(baseUrl + "post/elasticSearch/post/all",
          queryParameters: {
        'page': page,
        'count': 10
      }
      );
      print("check abhay response post  $page, count $count");
    //  print("===========RESPONSE RESPONSE page $page, count $count  ${jsonEncode(response.data).toString()}RESPONSE==========================");
    log("\n===========RESPONSE RESPONSE page $page, count $count  ${jsonEncode(response.data).toString()}RESPONSE==========================");
     log("\n\n==================\n\n");
      return response;

    } catch (er) {
      print(er.toString());
    }
  }

  createJournal(Map<String, dynamic> data) async {
    var http = await getApiClient();
    var response = await http.post(baseUrl + "user/journal", data: data);

    return response;
  }

  updateJournal(Map<String, dynamic> data) async {
    var http = await getApiClient();
    var response = await http.put(baseUrl + "user/journal", data: data);

    return response;
  }

  getMyJournalPost(
    int? count,
    int? page,
    String? userId,
  ) async {
    try {
      var http = await getApiClient();
      var response = await http.get(baseUrl + "user/journal", queryParameters: {
        'count': count,
        'page': page,
        'userId': userId,
      });
      return response;
    } catch (er) {
      // print(er.toString());
    }
  }

  deleteMyJournal(String? userId, String? journalId) async {
    var http = await getApiClient();
    var response =
        await http.delete(baseUrl + "user/journal", queryParameters: {
      "userId": userId,
      'journalId': journalId,
    });
    return response;
  }

  //accept invite member
  inviteMembers({String? id, Map<String, dynamic>? data}) async {
   // print("id1");
   // print(id);
    var http = await getApiClient();
    // var response = await http.patch(baseUrl + "/invite/$id", data: data);
    var token = await storage!.getData(StorageKeys.token.toString());
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var dio = Dio();
    var response = await dio.request(
      'https://mystory-app-9a032.firebaseapp.com/mystory/api/v1/invite/$id',
      options: Options(
        method: 'PATCH',
        headers: headers,
      ),
      data: data,
    );

   // print("response2");
   // print(response);
    return response;
  }

//fetch members of family tree
  getFamilyTree({String? id, count, page}) async {
    try {
      var http = await getApiClient();
      // var response = await http.get(baseUrl + "user/members/$id",options: Options(),
      //     queryParameters: {"count": count, "page": page});

      var response = await http.post(baseUrl + "user/members/$id",
          data: {"count": count, "page": page}); //done by chetu.

     // print(id);
     // print("response1");
     // print(response.data);

      return response;
    } catch (er) {
      print(er.toString());
    }
  }

  //{{productionUrl}}{{post}}/member/tester_2?page=1&count=10

  getFitlerFamilyTree({String? id, count, page, reltationId}) async {
    try {
      var http = await getApiClient();
      var response = await http.get(
          baseUrl + "user/members/$id/relation/$reltationId",
          queryParameters: {"count": count, "page": page});
      //print("reltationId");
      //print(reltationId);
      //print(response);
      return response;
    } catch (er) {
      print(er.toString());
    }
  }

  comment(Map<String, dynamic> data) async {
    try {
      var http = await getApiClient();
      var response = await http.post(baseUrl + "post/comment", data: data);

      return response;
    } catch (er) {
      print(er.toString());
    }
  }

  getPostByuserId(id) async {
    var http = await getApiClient();
    var response = await http.get(
      baseUrl + "post/$id",
    );
    return response;
  }

//fetch family member details
  getSearchUserDetails({String? myId, String? viewuserId}) async {
    try {
      var http = await getApiClient();

      var response = await http.get(baseUrl + "user/search",
          queryParameters: {"senderId": myId, "receverId": viewuserId});
      return response;
    } catch (er) {
      print(er.toString());
    }
  }

  familyMemberMediaGalleryImages(
      {String? id, int? page, int? count, String mediaType = "image"}) async {
    try {
      var http = await getApiClient();
      var response = await http.get(baseUrl + "post/member/$id",
          queryParameters: {
            "page": page,
            "count": count,
            "mediaType": mediaType
          });
      print("response media");
      //log(response.toString());
      return response;
    } catch (err) {
      print(err.toString());
    }
  }

  familyMemberMediaGalleryVideos(
      {String? id, int? page, int? count, String mediaType = "video"}) async {
    try {
      var http = await getApiClient();
      var response = await http.get(baseUrl + "post/member/$id",
          queryParameters: {
            "page": page,
            "count": count,
            "mediaType": mediaType
          });
      return response;
    } catch (err) {
      print(err.toString());
    }
  }

  changeRelation(String id, Map<String, dynamic> data) async {
    try {
      var http = await getApiClient();
      var response =
          await http.put(baseUrl + "invite/update-relation/$id", data: data);
      return response;
    } catch (err) {
      print(err.toString());
    }
  }

  // userMediaGallery(String id, int page, int count) async {
  //   try {
  //     var http = await getApiClient();
  //     var response = await http.get(baseUrl + "post/user/$id",
  //         queryParameters: {"page": page, "count": count});
  //     return response;
  //   } catch (err) {
  //     print(err.toString());
  //   }
  // }
  userMediaGallery(String id, String mediaType, int page, int count) async {
    try {
      var http = await getApiClient();
      var response = await http.get(baseUrl + "post/user/$id",
          queryParameters: {
            "page": page,
            "count": count,
            "mediaType": mediaType
          });
      return response;
    } catch (err) {
      print(err.toString());
    }
  }

  mediaGalleryImages(
      {int? page, int? count, String? mediaType = "image"}) async {
    try {
      var http = await getApiClient();
      var response = await http.get(baseUrl + "user/media", queryParameters: {
        "page": page,
        "count": count,
        "mediaType": mediaType
      });
      return response;
    } catch (err) {
      print(err.toString());
    }
  }

  mediaGalleryAudio(
      {int? page, int? count, String? mediaType = "audio"}) async {
    try {
      var http = await getApiClient();
      var response = await http.get(baseUrl + "user/media", queryParameters: {
        "page": page,
        "count": count,
        "mediaType": mediaType
      });
      return response;
    } catch (err) {
      print(err.toString());
    }
  }

  mediaGalleryViedos(
      {int? page, int? count, String? mediaType = "video"}) async {
    try {
      var http = await getApiClient();
      var response = await http.get(baseUrl + "user/media", queryParameters: {
        "page": page,
        "count": count,
        "mediaType": mediaType
      });
      return response;
    } catch (err) {
      print(err.toString());
    }
  }

  searchNewsFeeds(String userId, String keyWord, int page, int count) async {
    try {
      var http = await getApiClient();
      var response = await http
          .get(baseUrl + "post/elasticSearch/newfeedSearch", queryParameters: {
        "userId": userId,
        "keyWord": keyWord,
        "page": page,
        "count": count
      });

      return response;
    } catch (err) {
      print(err.toString());
    }
  }

  searchPhotos(String userId, String keyWord, int page, int count) async {
    try {
      var http = await getApiClient();
      var response = await http.get(baseUrl + "post/elasticSearch/postImage",
          queryParameters: {
            "userId": userId,
            "keyWord": keyWord,
            "page": page,
            "count": count
          });

      return response;
    } catch (err) {
      print(err.toString());
    }
  }

  searchVideos(String userId, String keyWord, int page, int count) async {
    try {
      var http = await getApiClient();
      var response = await http.get(baseUrl + "post/elasticSearch/postVideo",
          queryParameters: {
            "userId": userId,
            "keyWord": keyWord,
            "page": page,
            "count": count
          });

      return response;
    } catch (err) {
      print(err.toString());
    }
  }

  // Notification In-App Permision//

  notificationPermision(var data) async {
    try {
      var http = await getApiClient();
      var response =
          await http.put(baseUrl + "user/user-permissions", data: data);
      return response;
    } catch (err) {
      print(err.toString());
    }
  }

  uploadMediaGallery(var data) async {
    try {
      var http = await getApiClient();
      var response = await http.post(baseUrl + "user/addMedia", data: data);

      return response;
    } catch (er) {
      print(er.toString());
    }
  }

  deleteMediaGallery(var data) async {
    try {
      var http = await getApiClient();
      var response =
          await http.delete(baseUrl + "user/deleteMedia", data: data);

      return response;
    } catch (er) {
      print(er.toString());
    }
  }

  getUersLinkedStories(int page, int count) async {
    try {
      var http = await getApiClient();
      var response = await http.get(baseUrl + "post/likedPost",
          queryParameters: {"page": page, "count": count});

      return response;
    } catch (err) {
      print(err.toString());
    }
  }

  getFamilyMemberLinkedStories(int page, int count, String id) async {
    try {
      var http = await getApiClient();
      var response = await http.get(baseUrl + "post/user/likedPost",
          queryParameters: {"page": page, "count": count, "uid": id});

      return response;
    } catch (err) {
      print(err.toString());
    }
  }

  getFamilyMemberStories(int page, int count, String id) async {
    try {
      var http = await getApiClient();
      var response = await http.get(baseUrl + "post/user/userPosts",
          queryParameters: {"page": page, "count": count, "uid": id});
print("response userpost");
//(response.toString());
      return response;
    } catch (err) {
      print(err.toString());
    }
  }

  getUersFamilyTree({int? page, int? count, String? id}) async {
    try {
      var http = await getApiClient();
      var response = await http.get(baseUrl + "user/familyTree",
          queryParameters: {"page": page, "count": count, "uid": id});
      print("response2");
      //log(response.toString());
      return response;
    } catch (err) {
      print(err.toString());
    }
  }

  deleteUserPermanently({var data}) async {
    try {
      var http = await getApiClient();

      var response =
          await http.delete(baseUrl + "user/delete-manual-user", data: data);
      return response;
    } catch (err) {
      print(err.toString());
    }
  } // implemented by chetu.

  removeFamilyMemberRelationship({var data}) async {
    try {
      var http = await getApiClient();
      var response =
          await http.patch(baseUrl + "user/remove-register-user", data: data);

      print("response remove");
      print(response);
      return response;
    } catch (err) {
      print(err.toString());
    }
  }

  getAllCategoryAndSubCategory() async {
    try {
      var http = await getApiClient();
      var response = await http.get(
        baseUrl + "category/alls/cat",
      );
      print("response cat");
      print(response);
      return response;
    } catch (er) {
      // print(er.toString());
    }
  }

  getParticularUserPermission(String id) async {
    try {
      var http = await getApiClient();
      var response = await http.get(baseUrl + "invite/user/permissions",
          queryParameters: {"receiverId": id});
      print("response permission");
      //log(response.toString());
      return response;
    } catch (er) {
      // print(er.toString());
    }
  }



  deleteUserAccountRequestToAdmin(EmailInvite data) async {
    try {
      var http = await getApiClient();
      var response = await http.post(baseUrl + "email/delete/account",data: jsonEncode(data));
      print(response);
      return response;
    } catch (er) {
      print(er.toString());
    }
  }
}
