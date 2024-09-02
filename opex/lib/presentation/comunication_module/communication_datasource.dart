import 'dart:convert';
import 'dart:io';
import 'package:cluster/core/utils/variables.dart';
import 'package:http/http.dart'as http;

import 'package:cluster/core/utils/data_response.dart';
import 'package:cluster/presentation/authentication/authentication.dart';
import 'package:cluster/presentation/comunication_module/communication_urls.dart';
import 'package:cluster/presentation/comunication_module/dummy_design_forTesting/dummy_user_list_model.dart';
import 'package:cluster/presentation/comunication_module/models/communicationuser_model.dart';
import 'package:cluster/presentation/task_operation/employee_model/employee_model.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommunicationDatasource {
  Dio client = Dio();
  Future<List<GetEmployeeList>> getSearchedUsers(
      String searchQuery, String token) async {
    List<GetEmployeeList> searchedUserList = [];
    
    final response = await client.get(
      CommunicationUrls.searchUser + searchQuery,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'token ${authentication.authenticatedUser.token}',
        },
      ),
    );
    (response.data['data']['results'] as List).forEach((element) {
      searchedUserList.add(GetEmployeeList.fromJson(element));
    });
    return searchedUserList;
  }

  Future<List<GetEmployeeList>> getAllRegisteredUsers(String? token) async {
    List<GetEmployeeList> allRegisteredUsers = [];
   print("sruthyyy $token");
  String path="https://api-task-and-operation.hilalcart.com/task-manage/list-user";
  String api="";
  if(token == "")
  {
    api=path;
  }else{
    api="${path}?name=$token";
  }
  print(" sruthyyyy $api");
    final response = await client.get(
      api,
      options: Options(
        validateStatus: (status) => true,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': '${authentication.authenticatedUser.token}',
        },
      ),
    );
     print("auth ${authentication.authenticatedUser.token}");
    print("got the response ${response.data}");
    (response.data['data']['results'] as List).forEach((element) {
      allRegisteredUsers.add(GetEmployeeList.fromJson(element));
    });
    // print("got the final ${allRegisteredUsers}");
    return allRegisteredUsers;
  }

  Future<GroupList> createGroupData(
      {required String token,
      required String groupPicUrl,
      required List<GetEmployeeList>? userIdList,
      required String groupName,
      required String description
      }) async {
        print("asdd${userIdList![0].userCode}");
        print("asdd$description");
        GroupList? grpuserlist=GroupList();
    List<Map<String, dynamic>> map = [];
  for (var i = 0; i < userIdList.length; i++) {
    print("asdd${userIdList.length}");
      map.add({
        "fname": userIdList[i].fname,
        "lname": userIdList[i].lname,
        "email": userIdList[i].email,
        "photo": userIdList[i].profile,
        "user_code":userIdList[i].code
      });
    }
    final response = await client.post(
      CommunicationUrls.createGroupUrl,
      data: {"name": groupName, "friends": map, "groupPhotoUrl": groupPicUrl, "description":description},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    print("create a grp ${response.data}");
    grpuserlist = GroupList.fromJson(response.data);
    return grpuserlist;
  //   DoubleResponse(
  //       response.data['status'] == 'success', response.data['chatid']);
  }

  Future<DoubleResponse> groupLeaveData(
      {required String roomId, required String token}) async {
    print("at datasource");
    print(roomId);
    final response = await client.post(
      CommunicationUrls.leaveGroupUrl,
      data: {"chatid": roomId},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    print(response.data);
    return DoubleResponse(
        response.data['status'] == 'success', response.data['message']);
  }
  Future<DoubleResponse> addanGroupMember(
      {required String chatId, required String userId, required String token,required String emailid,required bool ishistroy,
        required String fname,
        required String lname,
        required String photo}) async {
    print("at datasource");
    print("....$chatId...$userId....$fname....$lname......$emailid....$photo");
    final response = await client.post(
      CommunicationUrls.addGroupMember+chatId,
      data: {
        "userCode": userId,
        "fname": fname, "lname": lname, "email": emailid, "photo": photo,"chatHistory":ishistroy
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    print("add memmej ${response.data}");
    return DoubleResponse(
        response.data['status'] == 'success', response.data['message']);
  }
  Future<DoubleResponse> deleteGrpMembers(
      {required String chatId, required String userId, required String token}) async {
    print("at datasource");
    print("....$chatId  $userId");
    final response = await client.delete(
      CommunicationUrls.deleteGroupMember+"$chatId/$userId",
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    print("response at datasource ${response.data}");
    return DoubleResponse(
        response.data['status'] == 'success', response.data['userid']);
  }
    Future<DataResponse> deleteMessage(
      {required String chatId, required int msgId, required String token}) async {
    print("at datasource");
    print("....$chatId  $msgId");
    final response = await client.delete(
      CommunicationUrls.messagedelete,
      data: {
        "messageId":msgId
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    print("response at datasource ${response.data}");
    return DataResponse(data: response.data['message']);
  }
      Future<DataResponse> editgroupprofile(
      {required String chatId, required String grpname,required String grpdescription,required String token, String? image}) async {
        print("total result ${image}");
    print("at datasource");
    print("....$chatId  $grpname");
    final response;
    if (image != null) {
      response = await client.post(
      CommunicationUrls.groupeditdetails+"$chatId",
      data: {
        "groupName":grpname,
        "description":grpdescription,
        "groupPhotoUrl":image
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
     
    }else{
       response = await client.post(
      CommunicationUrls.groupeditdetails+"$chatId",
      data: {
        "groupName":grpname,
        "description":grpdescription,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    }
    
    print("response at group edit ${response.data}");
    return DataResponse(data: response.data['message']);
  }
  

  Future<CommunicationUserModel> addAFriendUser(String token, String fname,
      String lname, String mail, String photo,String usercode) async {
        
        CommunicationUserModel chatListData1 = CommunicationUserModel();
    print("token is ${token}");
    print("fname is ${fname}");
    print("lname is ${lname}");
    print("email is ${mail}");
    print("photo is ${photo}");
    print("photo is ${usercode}");
    print(token);
    final response = await client.post(
      CommunicationUrls.addAFriendUser,
      data: {"fname": fname, "lname": lname, "email": mail, "photo": photo,"code":usercode},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    print(response.data);
    if(response.data['status']=="success"){
    chatListData1 = CommunicationUserModel.fromJson(response.data['data']);
    }else{
       chatListData1 = CommunicationUserModel.fromJson(response.data['data']);
    }
    return chatListData1;
  }

  Future<List<CommunicationUserModel>> getChatListData(String token) async {
    List<CommunicationUserModel> chatListData = [];
    final response = await client.get(CommunicationUrls.getChatList,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ));
      print(response.data);
      // if(response.data)
    (response.data['data'] as List).forEach((element) {
      chatListData.add(CommunicationUserModel.fromJson(element));
    });
    return chatListData;
  }

  Future<List<CommunicationUserModel>> getFilteredChatListData(
      String token, String chatFilter) async {
    List<CommunicationUserModel> chatListData = [];
    print(CommunicationUrls.getFilteredChatList);
    final response =
        await client.get(CommunicationUrls.getFilteredChatList + chatFilter,
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
            ));
            print("kngwlk... ${response.data}");
    (response.data['data'] as List).forEach((element) {
      chatListData.add(CommunicationUserModel.fromJson(element));
    });
    return chatListData;
  }

  Future<List<ChatMessagaeData>> getChatScreenData(
      String token,String chatId,String grpchatId,int pageNo,String userId) async {
   List<ChatMessagaeData>? chatScreenData =[];
  String api="";
  print("shifas++@@ $grpchatId, userid $userId ..");
  if(grpchatId != "")
  {
    print("if grpchatId $grpchatId");
    api="${CommunicationUrls.commentGroupUrl}$grpchatId?page=$pageNo";
  }else{
    print("else chatId $chatId ..");
    api="${CommunicationUrls.getChatScreenUrl}$chatId/$userId?page=$pageNo";
  }
   print("display $api "); // print(
    //     "got it but just api${CommunicationUrls.getChatScreenUrl}$userId?page=$pageNo}");
    final response = await client.get(
        // "${CommunicationUrls.getChatScreenUrl}$chatId?page=$pageNo",
        api,
        options: Options(
          validateStatus: (status) => true,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ));
    print("got it ${response.data}");
    if(response.data['status']=="success"){
    chatScreenData.add(ChatMessagaeData.fromJson(response.data['data']));}
    //  (response.data['data'] as List).forEach((element) {
    //   chatScreenData.add(ChatMessagaeData.fromJson(element));
    // });
    // if(response.data['status']=="success"){
    // chatScreenData = ChatMessagaeData.fromJson(response.data['data']);}
    return chatScreenData;
  }
  // Future<ChatMessagaeData> getcommentScreen(
  //     String token,String grpchatId,int pageNo) async {
  //   ChatMessagaeData chatScreenData =ChatMessagaeData();
  //   // print(
  //   //     "got it but just api${CommunicationUrls.getChatScreenUrl}$userId?page=$pageNo}");
  //   final response = await client.get(
  //       "${CommunicationUrls.commentGroupUrl}$grpchatId",
  //       options: Options(
  //         validateStatus: (status) => true,
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Accept': 'application/json',
  //           'Authorization': 'Bearer $token',
  //         },
  //       ));
  //   print("got it ${response.data}");
  //   if(response.data['status']=="success"){
  //   chatScreenData = ChatMessagaeData.fromJson(response.data['data']);}
  //   return chatScreenData;
  // }
  Future<ProfileGetModel> getGroupProfileGetData(
      String token, String chatId) async {
    ProfileGetModel profileGetModel;
    print("profile get api ${CommunicationUrls.getGroupProfileDetailsUrl + chatId}");
    final response =
        await client.get(CommunicationUrls.getGroupProfileDetailsUrl + chatId,
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
            ));
            print("profile get ${response.data}");
    profileGetModel = ProfileGetModel.fromJson(response.data['data']);
    return profileGetModel;
  }
 Future<ProfileGroupGetModel> getGroupProfileData(
      String token, String chatId) async {
    ProfileGroupGetModel profileGetModel;
    print("profile get api ${CommunicationUrls.getGroupProfileDataUrl + chatId}");
    final response =
        await client.get(CommunicationUrls.getGroupProfileDataUrl + chatId,
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
            ));
            print("profile get ${response.data}");
    profileGetModel = ProfileGroupGetModel.fromJson(response.data);
    return profileGetModel;
  }
  Future<ProfileGetModel> getGroupAttachmentsData(
      String token, String chatId) async {
    ProfileGetModel profileGetModel;
    print("get attachment ${CommunicationUrls.getGroupAttachmentsInProfileUrl+chatId }");
    final response = await client.get(
        CommunicationUrls.getGroupAttachmentsInProfileUrl+chatId,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ));
    profileGetModel = ProfileGetModel.fromJson(response.data['data']);
    return profileGetModel;
  }
  Future<String> uploadImageData1({Uint8List? img,}) async {
    String statusCode="";

    Map valueMap=Map();
    final url=Uri.parse(  CommunicationUrls.uploadImageUrl);
    print("the url$url");
    print("the url$img");
    print("the url${Variable.imageName
    }");
    int fileSizeInBytes = img!.length;
    int maxSizeInBytes = 10 * 1024 * 1024; // 10 M
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024);// B
    print("maxSizeInBytes$maxSizeInBytes");
    print("maxSizeInBytes$fileSizeInMB");

try{

  final response = await client.post(
    CommunicationUrls.uploadImageUrl,
    data: {"filename": Variable.imageName, "file": img},
    options: Options(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
          // "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",


      },
    ),
  );
  print(response.data);
  print(response.data['url']);
  statusCode=response.data['url'];

  return statusCode;
}catch(e){
 print("the image Eoorr is here$e");
}

    final response = await client.post(
      CommunicationUrls.uploadImageUrl,
      data: {"filename": Variable.imageName, "file": img},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',

        },
      ),
    );
    print(response.data);
    print(response.data['url']);
    statusCode=response.data['url'];

    return statusCode;
  }

  // Future<String> uploadImageData1({File? img}) async {
  //   String statusCode;
  //
  //   print("total result ${img}");
  //   String filePath = "";
  //
  //   if (img != null) filePath = img.path;
  //   final mime = lookupMimeType(filePath)!.split("/");
  //
  //   final fileData = await MultipartFile.fromFile(
  //     filePath,
  //     contentType: MediaType(mime.first, mime.last),
  //   );
  //   final FormData formData = FormData.fromMap({"upload": fileData});
  //
  //   final response = await client.post(
  //     CommunicationUrls.uploadImageUrl,
  //     data: formData,
  //     options: Options(
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //     ),
  //   );
  //   print("response is here ${response.data}");
  //   statusCode = (response.data['data']['upload']);
  //   return statusCode;
  // }
  
  //   Future<String> groupimage({File? img}) async {
  //   String statusCode;

  //   print("total result ${img}");
  //   String filePath = "";

  //   if (img != null) filePath = img.path;
  //   final mime = lookupMimeType(filePath)!.split("/");

  //   final fileData = await MultipartFile.fromFile(
  //     filePath,
  //     contentType: MediaType(mime.first, mime.last),
  //   );
  //   final FormData formData = FormData.fromMap({"upload": fileData});

  //   final response = await client.post(
  //     CommunicationUrls.groupeditdetails+'chat'
  //     data: formData,
  //     options: Options(
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //     ),
  //   );
  //   print("response is here ${response.data}");
  //   statusCode = (response.data['data']['upload']);
  //   return statusCode;
  // }
  Future<String> uploadImageData({Uint8List? img,String? name}) async {
    String statusCode;

    Map valueMap=Map();
    final url=Uri.parse(  CommunicationUrls.uploadImageUrl);
    print("the url$url");
    print("the url$img");
    print("the url${Variable.imageName
    }");


    final response = await client.post(
      CommunicationUrls.uploadImageUrl,
      data: {"filename": Variable.imageName, "file": img},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',

        },
      ),
    );
    print(response.data);
    print(response.data['url']);


    // print("the bytes$bytes");
//     final request = http.MultipartRequest('POST', url);
//     print("responseee$request");
//
//     if(img!=null) {
//       final imageFile = http.MultipartFile.fromBytes(
//         'file',
//         img,
//         filename: name,
//       );
//
//       try
//       {
//       request.files.add(imageFile);
//       final response = await request.send();
// //  final responseBody = await response.stream.bytesToString();
//
//
//       // final completer = Completer<void>();
//
//       final responseStream =
//       Stream.fromIterable(await response.stream.toList());
//       print("rressspondseee stream ${responseStream.transform(utf8.decoder).first}");
//
//
//
//         // await completer.future;
//         final responseBody = await responseStream.transform(utf8.decoder).join();
//         print(responseBody);
//         valueMap  = jsonDecode(responseBody);
//         print(valueMap["data"]);
//
//
//
//
//
//
//
//
//
//       }
//       catch(e) {
//         print("response stream exceotiojn $e");
//       }
//     }
    statusCode =  (response.data['url']);
    return statusCode;
  }
  // Future<String> uploadImageData({FilePickerResult? img}) async {
  //   String statusCode;
  //
  //   print("total result ${img}");
  //   String filePath = "";
  //
  //   if (img != null) filePath = img.files[0].path ?? "";
  //   final mime = lookupMimeType(filePath)!.split("/");
  //
  //   final fileData = await MultipartFile.fromFile(
  //     filePath,
  //     contentType: MediaType(mime.first, mime.last),
  //   );
  //   final FormData formData = FormData.fromMap({"upload": fileData});
  //
  //   final response = await client.post(
  //     CommunicationUrls.uploadImageUrl,
  //     data: formData,
  //     options: Options(
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //     ),
  //   );
  //   print("response is here ${response.data}");
  //   statusCode = (response.data['data']['upload']);
  //   return statusCode;
  // }

  Future<String> uploadLiveAudioData({Uint8List? img,bool comment=false}) async {
    String statusCode;
    Map valueMap=Map();
    final url=Uri.parse(  CommunicationUrls.uploadImageUrl);
    print("the url$url");
    print("the url$img");
    print("the url${Variable.imageName
    }");


    final response = await client.post(
      CommunicationUrls.uploadImageUrl,
      data: {"filename": Variable.imageName, "file": img},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',

        },
      ),
    );
    print(response.data);
    print(response.data['url']);


    // if (img != null) filePath = img.path;
    // final mime = lookupMimeType(filePath)!.split("/");
    //
    // final fileData = await MultipartFile.fromFile(
    //   filePath,
    //   contentType: MediaType(mime.first, mime.last),
    // );
    // final FormData formData = FormData.fromMap({"upload": fileData});
    //
    // final response = await client.post(
    //   CommunicationUrls.uploadImageUrl,
    //   data: formData,
    //   options: Options(
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //     },
    //   ),
    // );
    // print("response is here ${response.data}");
    statusCode = (response.data['url']);
    return statusCode;
  }

  Future<DataResponse> updateGroupPicture(
    File? img,
  ) async {
    String? uploadLink;
    String statusCode;
    String filePath = "";
    if (img != null) filePath = img.path;
    final mime = lookupMimeType(filePath)!.split("/");
    final fileData = await MultipartFile.fromFile(
      filePath,
      contentType: MediaType(mime.first, mime.last),
    );
    final FormData formData = FormData.fromMap({"upload": fileData});
    final response = await client.post(
      CommunicationUrls.uploadImageUrl,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    uploadLink = response.data['data']['upload'];
    return DataResponse(data: uploadLink, error: response.data['message']);
  }
}
