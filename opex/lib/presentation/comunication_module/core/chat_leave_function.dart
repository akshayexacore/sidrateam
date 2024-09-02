// import 'dart:core';
//
// import 'package:cluster/presentation/comunication_module/dummy_design_forTesting/dummy_user_list_model.dart';
// import 'package:cluster/presentation/comunication_module/models/communicationuser_model.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socket_io_client/socket_io_client.dart';
//
//
// class ChatLeave{
//
//   // Getter to ChatLeave the singleton instance
//  final bool? isGroup;
//  final bool? chat;
//  final Socket? socket;
//  final String? grpchatid;
//  final String? cmntgrpchatname;
//  final String? redirectchatid;
//  final String? redirectchatname;
//  final String? token;
//  final String? loginUserId;
//  final String? redirectionsenduserId;
//  final UserDummyList? communicationUserModel;
//  final CommunicationUserModel? communicationuser;
//  final GroupList? grpuser;
//  final bool? isg;
//   int activeUsersLength;
//   int sendMessageCount;
//  ChatLeave(this.activeUsersLength, this.sendMessageCount, { this.isGroup, this.chat, this.socket, this.grpchatid, this.cmntgrpchatname, this.redirectchatid, this.redirectchatname, this.token, this.loginUserId, this.redirectionsenduserId, this.communicationUserModel, this.communicationuser, this.grpuser, this.isg, });
//
//  void handleRedirectionAndLeaveRoom() {
//
//    if (isGroup==false) {
//    if (chat==false) {
//     socket?.emit("unread.messages.chat", {
//      'unreadMessageCount': 0,
//      'chatid': communicationUserModel?.chatid,
//      'userid': communicationUserModel?.id.toString(),
//     });
//     socket!.emit("leave.chat", {
//      "room": c ?? "",
//      "userid": communicationUserModel?.id ?? "",
//     });
//    } else {
//     socket?.emit("unread.messages.chat", {
//      'unreadMessageCount': 0,
//      'chatid': roomId,
//      'userid': communicationUser?.users?[0].id.toString(),
//     });
//     socket!.emit("leave.chat", {
//      "room": roomId ?? "",
//      "userid": communicationUserModel?.users?[0].id ?? "",
//     });
//    }
//   } else {
//    if (!isg) {
//     socket?.emit("unread.messages.chat", {
//      'unreadMessageCount': 0,
//      'chatid': grpChatId ?? communicationUserModel?.chatid,
//      'userid': loginUserId,
//     });
//     socket!.emit("leave.chat", {
//      "room": roomId ?? "",
//      "userid": loginUserId ?? "",
//     });
//    } else {
//     socket?.emit("unread.messages.chat", {
//      'unreadMessageCount': 0,
//      'chatid': grpChatId ?? grpUserChatId,
//      'userid': loginUserId,
//     });
//     socket!.emit("leave.chat", {
//      "room": roomId ?? "",
//      "userid": loginUserId ?? "",
//     });
//    }
//   }
//
//   socket!.on("left.room", (data) {
//    print("room left $data");
//    print("room left $data");
//    socket!.emit("get.clients", roomId);
//    socket!.on("active.length", handleActiveLength);
//   });
//
//   socket!.on("user.left", (data) {
//    print("user left $data");
//    if (data["userid"] == loginUserId) {
//     print("ACTIVE length sharedprefww");
//     saveUnreadMessageCount(0, roomId ?? "");
//     print("user left the room1 ${data["chatid"]}");
//    } else {
//     print("same user id");
//    }
//   });
//
//   if (grpChatId == "") {
//    // Navigator.pushAndRemoveUntil(
//    //  context,
//    //  MaterialPageRoute(builder: (context) => DashBoard(index: 1, fromChat: true)),
//    //      (route) => false,
//    // );
//   } else {
//    Navigator.pop(context);
//   }
//  }
//  void handleActiveLength(data) {
//   print("ACTIVE length sharedpref  $data");
//   saveactiveusers(data);
//
//   loadactiveusers();
//   print("ACTIVE load");
//   String? chatid= chat==false && isg==false
//       ?grpchatid!=""?"${grpchatid}": redirectchatid!=""?"${redirectchatid}": "${communicationUserModel?.chatid}":
//   chat==true&& isg==false?"${communicationuser?.id}": "${grpuser?.chatid}";
//   if(activeUsersLength == 2){
//    print("ACTIVE load $chatid");
//    sendMessageCount=0;
//    saveUnreadMessageCount(0,chatid);
//   }
//   // if(isactivelen){
//   //  setState(() {
//   //
//   //  });
//   // }
//
//  }
//  Future<void> saveactiveusers(int count) async {
//   print("my msg active count $count");
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   await pref!.setInt('activeuser', count);
//  }
//  Future<void> loadactiveusers() async {
//
//   SharedPreferences pref = await SharedPreferences.getInstance();
//
//   activeUsersLength = pref!.getInt('activeuser')??0;
//   print("ACTIVE length load $activeUsersLength");
//
//  }
//  Future<void> saveUnreadMessageCount(int count,String chatt) async {
//   print("my msg update counta $count $chatt");
//   SharedPreferences  pref = await SharedPreferences.getInstance();
//   await pref!.setInt(chatt, count);
//
//  }
// }
//
