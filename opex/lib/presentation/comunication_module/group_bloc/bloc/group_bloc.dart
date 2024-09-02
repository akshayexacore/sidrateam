import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cluster/presentation/comunication_module/communication_datasource.dart';
import 'package:cluster/presentation/comunication_module/models/communicationuser_model.dart';
import 'package:cluster/presentation/task_operation/employee_model/employee_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../dummy_design_forTesting/dummy_user_list_model.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc() : super(GroupInitial());
  final CommunicationDatasource _productData = CommunicationDatasource();
  @override
  Stream<GroupState> mapEventToState(
    GroupEvent event,
  ) async* {
    if (event is GetAllRegisteredUsersEvent) {
      yield* getAllRegisteredUsers(event.token);
    } else if (event is CreateGroupEvent) {
      yield* createGroupBloc(
          groupName: event.groupName,
          token: event.token,
          uploadPicGroup: event.groupPhotoUrl,
          description: event.description,
          userIdList: event.userIdList);
    } else if (event is GroupProfileGet) {
      yield* getGroupProfileDetails(chatId: event.chatid, token: event.token);
    }else if (event is GroupProfileGetdata) {
      yield* getGroupProfiledataDetails(chatId: event.chatid, token: event.token);
    }  
    else if (event is GroupLeaveEvent) {
      yield* groupLeaveMap(roomId: event.roomId, token: event.token);
    } 
    else if(event is GroupMemberAddEvent){
      yield* groupmemberadd(token:event.token,chatid:event.chatId,userid:event.userId,emailid: event.emailid,fname: event.fname,lname: event.lname,photo: event.photo,ishistory: event.ishistory);
    }
    else if(event is GroupMemberDeleteEvent){
      yield* groupmemberdelete(token:event.token,chatid:event.chatId,userid:event.userId);
    }
    else if(event is GroupProfileEditEvent){
      yield* groupprofileedit(token:event.token,chatid:event.chatId,groupname:event.groupname,groupdescription: event.groupdescription,image: event.image);
    }
    else if(event is GroupUploadPictureEvent){
      yield* uploadImageMap(image: event.image);
    }
  }

  Stream<GroupState> getAllRegisteredUsers(String? token) async* {
    yield GetAllRegisteredUsersLoading();
    print("sruthyy $token");
    final dataResponse = await _productData.getAllRegisteredUsers(token);
    if (dataResponse.isNotEmpty) {
      yield GetAllRegisteredUsersSuccess(registeresUsers: dataResponse);
    } else {
      yield GetAllRegisteredUsersFailed();
    }
  }

  Stream<GroupState> getGroupProfileDetails(
      {String? token, String? chatId}) async* {
    yield GetGroupProfileDetailsLoading();
    final dataResponse =
        await _productData.getGroupProfileGetData(token ?? "", chatId ?? "");
    if (dataResponse.groups != null) {
      yield GetGroupProfileDetailsSuccess(profileGetModel: dataResponse);
    } else {
      yield GetGroupProfileDetailsFailed();
    }
  }
  Stream<GroupState> getGroupProfiledataDetails(
      {String? token, String? chatId}) async* {
    yield GetGroupProfiledataDetailsLoading();
    final dataResponse =
        await _productData.getGroupProfileData(token ?? "", chatId ?? "");
        print("state found ${dataResponse.status}");
    if (dataResponse.status =="success") {
      yield GetGroupProfiledataDetailsSuccess(profileGetModel: dataResponse.data);
    } else {
      yield GetGroupProfiledataDetailsFailed();
    }
  }

 
  Stream<GroupState> createGroupBloc(
      {required String groupName,
      required String token,
      required String uploadPicGroup,
      required String description,
      required List<GetEmployeeList> userIdList}) async* {
    yield CreateGroupLoading();
    final dataResponse = await _productData.createGroupData(
        groupName: groupName,
        token: token,
        userIdList: userIdList,
        groupPicUrl: uploadPicGroup,
        description: description);
    if (dataResponse.chatid!=null) {
      yield CreateGroupSuccess(list: dataResponse);
    } else {
      yield CreateGroupFailed(error: "Failed");
    }
  }

  Stream<GroupState> groupLeaveMap(
      {required String token, required String roomId}) async* {
    yield GroupLeaveLoading();
    final dataResponse =
        await _productData.groupLeaveData(roomId: roomId, token: token);
    if (dataResponse.data1) {
      yield GroupLeaveSuccess(successMessage: dataResponse.data2);
    } else {
      yield GroupLeaveFailed(error: dataResponse.data2);
    }
  }
  
  Stream<GroupState> groupmemberadd(
      {required String token, required String chatid,required String userid,required String emailid,required bool ishistory,
  required String fname,
  required String lname,
  required String photo}) async* {
    yield GroupMemberAddLoading();
    final dataResponse =
        await _productData.addanGroupMember(chatId: chatid, userId: userid, token: token,emailid: emailid,fname: fname,lname: lname,photo: photo,ishistroy: ishistory);
    if (dataResponse.data1) {
      print("ghhsucess");
      yield GroupMemberAddSuccess(successmsg: dataResponse.data2);
    } else {
      yield GroupMemberAddFailed(error: dataResponse.data2);
    }
  }
  Stream<GroupState> groupmemberdelete(
      {required String token, required String chatid,required String userid}) async* {
    yield GroupMemberDeleteLoading();
    final dataResponse =
        await _productData.deleteGrpMembers(chatId: chatid, userId: userid, token: token);
    if (dataResponse.data1) {
      print("bloccccc${dataResponse.data2}");
      yield GroupMemberDeleteSuccess(successmsg:dataResponse.data2);
    } else {
      yield GroupMemberDeleteFailed(error: dataResponse.data2);
    }
  }
  Stream<GroupState> groupprofileedit(
      {required String token, required String chatid,required String groupname,required String groupdescription,String? image}) async* {
    yield GroupProfileEditLoading();
    final dataResponse =
        await _productData.editgroupprofile(chatId: chatid, grpname: groupname, grpdescription: groupdescription, token: token,image: image);
    if (dataResponse.data != null) {
      print("bloccccc${dataResponse}");
      yield GroupProfileEditSuccess(successmsg:"Updated");
    } else {
      yield GroupProfileEditFailed(error:"Updation Failed");
    }
  }
  Stream<GroupState> uploadImageMap(
      {required Uint8List image}) async* {
    yield GroupUploadPictureLoading();
    final dataResponse = await _productData.uploadImageData1(img: image!);
    if (dataResponse.isNotEmpty) {
      yield GroupUploadPictureSuccess(upload: dataResponse);
    } else {
      yield const GroupUploadPictureFailed(error: "failed");
    }
  }
}
