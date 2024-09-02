import 'package:cluster/common_widgets/loading.dart';
import 'package:cluster/common_widgets/string_extensions.dart';
import 'package:cluster/common_widgets/switch.dart';
import 'package:cluster/core/color_palatte.dart';
import 'package:cluster/core/utils/platform_check.dart';
import '../../../core/common_snackBar.dart';
import 'package:cluster/presentation/base/dashboard.dart';
import 'package:cluster/presentation/comunication_module/bloc/communication_bloc.dart';
import 'package:cluster/presentation/comunication_module/chat-profile_screengrp.dart';
import 'package:cluster/presentation/comunication_module/chat_profile_screen.dart';
import 'package:cluster/presentation/comunication_module/communication_homescreen.dart';
import 'package:cluster/presentation/comunication_module/dummy_design_forTesting/dummy_user_list_model.dart';
import 'package:cluster/presentation/comunication_module/group_bloc/bloc/group_bloc.dart';
import 'package:cluster/presentation/comunication_module/models/communicationuser_model.dart';
import 'package:cluster/presentation/task_operation/task_svg.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:socket_io_client/socket_io_client.dart';

class ChatAppBar extends StatefulWidget {
  final UserDummyList? communicationUserModel;
  final CommunicationUserModel? communicationuser;
  final bool? typing;
  final bool chat;
  final bool isgrp;
  final String? loginUserId;
  final FromUser? groupTypingUser;
  final String redirectchatid;
  final String redirectchatname;
  final String? token;
  final Socket? socket;
  final String? roomId;
  final bool? isGroup;
  final String cmntgrpid;
  final String cmntgrpname;
  final GroupList? grpuser;
  final String? redirectionsenduserId;
  List<GroupUserList>? grpmember = [];
  final bool? isadmin;
  final VoidCallback? ontap;
  // final VoidCallback ontap;
  ChatAppBar(
      {Key? key,
      this.communicationUserModel,
      this.communicationuser,
      this.grpuser,
      this.isadmin,
      this.cmntgrpid = "",
      this.cmntgrpname = "",
      this.redirectchatid="",
      this.redirectchatname="",
      this.loginUserId,
      this.typing,
      this.socket,
      this.redirectionsenduserId="",
      this.isGroup,
      this.token,
      this.ontap,
      this.roomId,
      this.chat = false,
      this.isgrp = false,
      this.groupTypingUser,
      this.grpmember
      // required this.ontap
      })
      : super(key: key);

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();
}

class _ChatAppBarState extends State<ChatAppBar> {
  bool mounted = true;
  bool ismounted = true;
  bool ismount = true;
  SharedPreferences? pref;
  List<messageSeenList> left = [];
  Future<void> saveactiveusers(int count) async {
    print("my msg update count $count");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('activeuser', count);
  }

  @override
  void initState() {
    print("isadminn ${widget.isadmin} ${widget.loginUserId} name ${widget.redirectchatname} ame ${widget.redirectchatid} ${widget.isGroup}");
    // TODO: implement initState
    super.initState();
  }
  Future<void> saveUnreadMessageCount1(int count,String chatt) async {
    print("inside the funcion");
    pref = await SharedPreferences.getInstance();
    await pref!.setInt(chatt,0);
    setState(() {
      print("my msg update counta $count $chatt");

    });

  }
  @override
  void dispose() {
    widget.socket!.off('active.length');
    widget.socket!.off("user.left");
    mounted = false;
    ismounted = false;
    ismount = false;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("shifas${widget.cmntgrpid}");
    double w1 = MediaQuery.of(context).size.width ;
    double w = w1 > 700
        ? 400
        : w1;
    var h = MediaQuery.of(context).size.height;
    return Container(
      // width: w/2,
      color: ColorPalette.primary,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                  onTap:widget.ontap,
    //               {
    //                 //widget.ontap,
    //                 widget.socket!.emit("update.list",{
    //   print("update")
    // });
    // if(widget.isGroup==false){
    //   print("Leave chat");
    //   //   if(widget.redirectchatid != ""){
    //   //     print("push notificstion redirection");
    //   //
    //   //     widget.socket?.emit("unread.messages.chat",{'unreadMessageCount':0,'chatid':widget.redirectchatid.toString(),'userid':widget.redirectionsenduserId??""});
    //   //     widget.socket!.emit("leave.chat",{
    //   //       "room": roomId??"",
    //   //       "userid":widget.loginUserId??""
    //   //     }
    //   //     );
    //   //
    //   //     print("user left too");
    //   //
    //   //     print("user left too");
    //   //
    //   //     widget.socket!.on("left.room", (data) {
    //   //       print("room left $data");
    //   //       if(ismounted){
    //   //         print("roooom left $data");
    //   //         widget.socket!.emit("get.clients",roomId);
    //   //         widget.socket!.on("active.length", handleActiveLength
    //   //         );
    //   //       }
    //   //
    //   //       widget.socket!.on("msg1.seen", (data) {
    //   //         print("room leave message $data");
    //   //
    //   //
    //   //       } );
    //   //     });
    //   //
    //   //
    //   //     widget.socket!.on("user.left", (data){
    //   //       print("user left $data");
    //   //
    //   //       if(data["userid"] == widget.loginUserId){
    //   //         print("ACTIVE length sharedprefww");
    //   //         saveUnreadMessageCount(0,roomId??"");
    //   //         print("user left the room1 ${data["chatid"]}");
    //   //
    //   //       }else{
    //   //         print("same user id");
    //   //       }
    //   //     });
    //   //     // Navigator.pop(context);
    //   //     // Navigator.pop(context);
    //   // if(isMobile)   {
    //   //   Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (context) => DashBoard(index: 1,)), (route) => false);
    //   // }
    //   // else{
    //   //   // chabeTAbIndex(0) ;
    //   //   objectGlobal=   objectGlobal.changeScreen(current: CommunicationModule(),previous: this.widget,tabIndex: 0);
    //   //   print(objectGlobal.existing);
    //   //   objectGlobal.changeData();
    //   //
    //   // }
    //   //
    //   //     //               PersistentNavBarNavigator.pushNewScreen(
    //   //     //   context,
    //   //     //   screen: DashBoard(
    //   //     //     // token: widget.token ?? ""
    //   //     //     // socket: widget.socket,
    //   //     //   ),
    //   //     //   withNavBar: true, // OPTIONAL VALUE. True by default.
    //   //     //   pageTransitionAnimation: PageTransitionAnimation.fade,
    //   //     // );
    //   //   }
    //   //
    //   if( widget.chat==false){
    //     widget.socket?.emit("unread.messages.chat",{'unreadMessageCount':0,'chatid':widget.communicationUserModel?.chatid,'userid':widget.communicationUserModel?.id.toString()});
    //     widget.socket!.emit("leave.chat",{
    //       "room": widget.roomId??"",
    //       "userid":widget.communicationUserModel?.id??""
    //     }
    //     );
    //
    //     print("user left too");
    //
    //     print("user left too");
    //     widget.socket!.on("left.room", (data) {
    //       print("room left $mounted $data");
    //       // mountedactive = true;
    //       if(mounted) {
    //         widget.socket!.emit("get.clients", widget.roomId);
    //         widget.socket!.on("active.length", handleActiveLength
    //         );
    //       }
    //       // mountedactive = false;
    //
    //       widget.socket!.on("msg1.seen", (data) {
    //         print("room leave message $data");
    //
    //
    //       } );
    //     });    widget.socket!.on("user.left", (data){
    //       print("user left");
    //
    //       if(data["userid"] == widget.loginUserId){
    //         print("ACTIVE length sharedprefww");
    //         saveUnreadMessageCount1(0,widget.roomId??"");
    //         print("user left the room1 ${data["chatid"]}");
    //         setState(() {
    //
    //         });
    //       }else{
    //         print("same user id");
    //       }
    //     });
    //     isMobile? Navigator.pop(context):
    //     objectGlobal=   objectGlobal.changeScreen(current: CommunicationModule(),previous: this.widget,tabIndex: 0);
    //     print(objectGlobal.existing);
    //     objectGlobal.changeData();
    //     // chabeTAbIndex(0) ;
    //   }
    //   else{
    //     BlocProvider.of<CommunicationBloc>(context).add(
    //         GetFilterdChatListEvent(
    //             token: widget.token ?? "",
    //             chatFilter: "chats"
    //         ));
    //     Navigator.pop(context);
    //
    //     widget.socket?.emit("unread.messages.chat",{'unreadMessageCount':0,'chatid':widget.roomId,'userid':widget.communicationuser?.users?[0].id.toString()});
    //     widget.socket!.emit("leave.chat",{
    //       "room": widget.roomId??"",
    //       "userid":widget.communicationuser?.users?[0].id??""
    //     }
    //     );
    //
    //     print("user left too");
    //
    //     print("user left too");
    //     widget.socket!.on("left.room", (data) {
    //       print("room left $data");
    //       //  if(mounted){
    //       widget.socket!.emit("get.clients",widget.roomId);
    //       widget.socket!.on("active.length", handleActiveLength
    //       );
    //       // }
    //
    //       widget.socket!.on("msg1.seen", (data) {
    //         print("room leave message $data");
    //
    //
    //       } );
    //     });
    //
    //     widget.socket!.on("user.left", (data){
    //       print("user left");
    //
    //       if(data["userid"] == widget.loginUserId){
    //         print("ACTIVE length sharedprefww");
    //         saveUnreadMessageCount1(0,widget.roomId??"");
    //         print("user left the room1 ${data["chatid"]}");
    //         setState(() {
    //
    //         });
    //       }else{
    //         print("same user id");
    //       }
    //     });
    //     isMobile? Navigator.pop(context):
    //     objectGlobal=   objectGlobal.changeScreen(current: CommunicationModule(),previous: this.widget,tabIndex: 0);
    //     print(objectGlobal.existing);
    //     objectGlobal.changeData();
    //   }
    //
    // }
    // else{
    //   //  if(widget.redirectchatid != ""){
    //   //    print("push notificstion redirection");
    //   //
    //   //    widget.socket?.emit("unread.messages.chat",{'unreadMessageCount':0,'chatid':widget.redirectchatid,'userid':widget.loginUserId});
    //   //    widget.socket!.emit("leave.chat",{
    //   //      "room": roomId??"",
    //   //      "userid": widget.redirectionsenduserId??""                             //widget.isg==false?widget.grpchatid!=""?widget.grpchatid:widget.redirectchatid!=""?"${widget.redirectchatid}": widget.communicationUserModel?.id??"":widget.loginUserId??""
    //   //    }
    //   //    );
    //   //
    //   //    print("user left too");
    //   //
    //   //    print("user left too");
    //   //    widget.socket!.on("left.room", (data) {
    //   //      print("room left $data");
    //   //      if(mounted){
    //   //        widget.socket!.emit("get.clients",roomId);
    //   //        widget.socket!.on("active.length", handleActiveLength
    //   //        );
    //   //      }
    //   //      if(ismount1){
    //   //        widget.socket?.emit("group.message.seen",roomId);
    //   //        widget.socket?.on("msg.seen.by",activeuserlist);
    //   //      }
    //   //
    //   //    });
    //   //
    //   //    widget.socket!.on("msg1.seen", (data) {
    //   //      print("room leave message $data");
    //   //
    //   //
    //   //    } );
    //   //    widget.socket!.on("user.left", (data){
    //   //      print("user left");
    //   //
    //   //      if(data["userid"] == widget.loginUserId){
    //   //        print("ACTIVE length sharedprefww");
    //   //        saveUnreadMessageCount1(0,roomId??"");
    //   //        print("user left the room1 ${data["chatid"]}");
    //   //        setState(() {
    //   //
    //   //        });
    //   //      }else{
    //   //        print("same user id");
    //   //      }
    //   //    });
    //   //
    //   // isMobile?   Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (context) => DashBoard(index: 1,)), (route) => false):chabeTAbIndex(0) ;
    //   //    //               Navigator.pop(context);
    //   //    //               PersistentNavBarNavigator.pushNewScreen(
    //   //    //   context,
    //   //    //   screen: DashBoard(
    //   //    //     // token: widget.token ?? ""
    //   //    //     // socket: widget.socket,
    //   //    //   ),
    //   //    //   withNavBar: true, // OPTIONAL VALUE. True by default.
    //   //    //   pageTransitionAnimation: PageTransitionAnimation.fade,
    //   //    // );
    //   //  }
    //   //
    //   if( widget.isgrp==false){
    //     widget.socket?.emit("unread.messages.chat",{'unreadMessageCount':0,'chatid': widget.cmntgrpid ==""?widget.cmntgrpid: widget.communicationUserModel?.chatid,'userid':widget.loginUserId});
    //     widget.socket!.emit("leave.chat",{
    //       "room": widget.roomId??"",
    //       "userid": widget.loginUserId??""               //widget.isg==false?widget.grpchatid!=""?widget.grpchatid:widget.redirectchatid!=""?"${widget.redirectchatid}": widget.communicationUserModel?.id??"":widget.loginUserId??""
    //     }
    //     );
    //
    //     print("user left too");
    //
    //     print("user left too");
    //     widget.socket!.on("left.room", (data) {
    //       print("room left $data");
    //       if(mounted){
    //         widget.socket!.emit("get.clients",widget.roomId);
    //         widget.socket!.on("active.length", handleActiveLength
    //         );
    //       }
    //
    //       // if(ismount1){
    //       //   widget.socket?.emit("group.message.seen",widget.roomId);
    //       //   widget.socket?.on("msg.seen.by",activeuserlist);
    //       // }
    //
    //       widget.socket!.on("msg1.seen", (data) {
    //         print("room leave message $data");
    //
    //
    //       } );
    //     });
    //
    //
    //     widget.socket!.on("user.left", (data){
    //       print("user left");
    //
    //       if(data["userid"] == widget.loginUserId){
    //         print("ACTIVE length sharedprefww");
    //         saveUnreadMessageCount1(0,widget.roomId??"");
    //         print("user left the room1 ${data["chatid"]}");
    //         setState(() {
    //
    //         });
    //       }else{
    //         print("same user id");
    //       }
    //     });
    //
    //     isMobile? Navigator.pop(context):
    //     // chabeTAbIndex(0) ;
    //     objectGlobal=   objectGlobal.changeScreen(current: CommunicationModule(),previous: this.widget,tabIndex: 0);
    //     print(objectGlobal.existing);
    //     objectGlobal.changeData();
    //   }else{
    //     widget.socket?.emit("unread.messages.chat",{'unreadMessageCount':0,'chatid':widget.cmntgrpid!=""?widget.cmntgrpid: widget.grpuser?.chatid,'userid':widget.loginUserId});
    //     widget.socket!.emit("leave.chat",{
    //       "room":widget.roomId??"",
    //       "userid":widget.loginUserId ?? ""
    //     }
    //     );
    //     widget.socket!.on("left.room", (data) {
    //       print("active length left room");
    //       if(mounted){
    //         widget.socket!.emit("get.clients",widget.roomId);
    //         widget.socket!.on("active.length", handleActiveLength
    //         );
    //       }
    //
    //       // if(ismount1){
    //       //   widget.socket?.emit("group.message.seen",roomId);
    //       //   widget.socket?.on("msg.seen.by",activeuserlist);
    //       // }
    //       print("room left $data");
    //
    //       widget.socket!.on("msg1.seen", (data) {
    //         print("room leave message $data");
    //
    //
    //       } );
    //     });
    //
    //     widget.socket!.on("user.left", (data){
    //       print("user left");
    //
    //       if(data["userid"] == widget.loginUserId){
    //         print("ACTIVE length sharedprefww");
    //         saveUnreadMessageCount1(0,widget.roomId??"");
    //         print("user left the room1 ${data["chatid"]}");
    //         setState(() {
    //
    //         });
    //       }else{
    //         print("same user id");
    //       }
    //     });
    //
    //     isMobile? Navigator.pop(context):
    //     objectGlobal=   objectGlobal.changeScreen(current: CommunicationModule(),previous: this.widget,tabIndex: 0);
    //     print(objectGlobal.existing);
    //     objectGlobal.changeData();
    //     // chabeTAbIndex(0) ;
    //     //                  PersistentNavBarNavigator.pushNewScreen(
    //     //   context,
    //     //   screen: CommunicationModule(),
    //     //   withNavBar: true, // OPTIONAL VALUE. True by default.
    //     //   pageTransitionAnimation: PageTransitionAnimation.fade,
    //     // );
    //   }
    //
    // }
    // },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  )),
              const SizedBox(
                width: 5,
              ),
             widget.isGroup==true? BlocBuilder<GroupBloc,GroupState>(
                builder: (context,state){
                if(state is GetGroupProfiledataDetailsLoading){
                  customCupertinoLoading();
                }else if(state is GetGroupProfiledataDetailsSuccess){
                  return GestureDetector(
                onTap: () {
                  if (widget.isGroup == false) {
                    // PersistentNavBarNavigator.pushNewScreen(
                    //   context,
                    //   screen: ChatProfileScreen(
                    //     chat: widget.chat,
                    //     token: widget.token,
                    //     roomId: widget.roomId,
                    //     socket: widget.socket,
                    //     isGroup: widget.communicationUserModel?.isgrp ?? false,
                    //     communicationUserModel: widget.communicationUserModel,
                    //     communicationuser: widget.communicationuser,
                    //   ),
                    //   withNavBar: true, // OPTIONAL VALUE. True by default.
                    //   pageTransitionAnimation: PageTransitionAnimation.fade,
                    // );
                  }
                  else if(widget.cmntgrpid=="") {
                    // BlocProvider(
          //   create: (context) => GroupBloc()
          //     ..add(GroupProfileGet(
          //         chatid: widget.communicationUserModel?.chatid ?? "",
          //         token: widget.token ?? "")),
          // ),
          context.read<GroupBloc>().add(
            GroupProfileGetdata(chatid: widget.roomId??"", token: widget.token??"")
          );
              if(isMobile) {
                PersistentNavBarNavigator.pushNewScreen(
                context,
                screen:
                ChatProfileScreen2(
                  chat: widget.isgrp,
                  token: widget.token,
                  roomId: widget.roomId,
                  socket: widget.socket,
                  loginuserid: widget.loginUserId,
                  isGroup: true,
                  isadmin: widget.isadmin,
                  redirectchatid: widget.redirectchatid,
                  redirectchatname: widget.redirectchatname,
                  communicationUserModel: widget.communicationUserModel,
                  communicationuser: widget.grpuser,
                  grpmember: widget.grpmember,

                ),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.fade,
              );} else{

                showDailogPopUp(
                    context,
                    //     AdminCreationUser()
                  ChatProfileScreen2(
                    chat: widget.isgrp,
                    token: widget.token,
                    roomId: widget.roomId,
                    socket: widget.socket,
                    loginuserid: widget.loginUserId,
                    isGroup: true,
                    isadmin: widget.isadmin,
                    redirectchatid: widget.redirectchatid,
                    redirectchatname: widget.redirectchatname,
                    communicationUserModel: widget.communicationUserModel,
                    communicationuser: widget.grpuser,
                    grpmember: widget.grpmember,

                  ),);


              }
                  }
                },
                child:
               Container(
                 child: Row(
                  children: [
                     state.profileGetModel?.photo==null||
                          state.profileGetModel!.photo!.isEmpty ?
                       CircleAvatar(
                            radius: 24,
                            backgroundColor: ColorPalette.inactiveGrey,
                            backgroundImage:
                                AssetImage("asset/chatgrpimg.png")
                          )
                          :CircleAvatar(
                            radius: w / 23,
                            backgroundColor: ColorPalette.inactiveGrey,
                            backgroundImage:
                             NetworkImage(
                                state.profileGetModel?.photo ?? ""
                                // "https://api-uat-user.sidrabazar.com/media/${widget.communicationUserModel?.users?[0].photo}"
                                // "${widget.communicationUserModel?.photo}"
                                ),
                          ),
                          const SizedBox(
                  width: 10,
                               ),
                  //              Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // children: [
                     Text("${state.profileGetModel?.name?.toTitleCase()}",

                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: w / 25,
                                  fontWeight: FontWeight.w500,
                                ),
                              )

                    // groupTypingUser != null
                    //     ? Row(
                    //         children: [
                    //           CircleAvatar(
                    //               backgroundColor: Colors.white,
                    //               radius: 14,
                    //               child: CircleAvatar(
                    //                 backgroundImage: NetworkImage(
                    //                     groupTypingUser?.photo ?? ""),
                    //                 radius: 12,
                    //               )),
                    //           Text(
                    //             "${groupTypingUser?.name} typing",
                    //             style: const TextStyle(
                    //               color: Color(0xff151522),
                    //               fontSize: 16,
                    //             ),
                    //           ),
                    //         ],
                    //       )
                    //     : Text(
                    //         typing == true ? "typing" : "",
                    //         style: const TextStyle(
                    //           color: Color(0xff151522),
                    //           fontSize: 16,
                    //         ),
                    //       )
                  // ],
                  //              )
                  ],
                 ),
               )
              );
                }
               return
              GestureDetector(
                onTap: () {
                  if (widget.isGroup == false) {
                    // PersistentNavBarNavigator.pushNewScreen(
                    //   context,
                    //   screen: ChatProfileScreen(
                    //     chat: widget.chat,
                    //     token: widget.token,
                    //     roomId: widget.roomId,
                    //     socket: widget.socket,
                    //     isGroup: widget.communicationUserModel?.isgrp ?? false,
                    //     communicationUserModel: widget.communicationUserModel,
                    //     communicationuser: widget.communicationuser,
                    //   ),
                    //   withNavBar: true, // OPTIONAL VALUE. True by default.
                    //   pageTransitionAnimation: PageTransitionAnimation.fade,
                    // );
                  }
                  else if(widget.cmntgrpid=="") {
                    // BlocProvider(
          //   create: (context) => GroupBloc()
          //     ..add(GroupProfileGet(
          //         chatid: widget.communicationUserModel?.chatid ?? "",
          //         token: widget.token ?? "")),
          // ),
          context.read<GroupBloc>().add(
            GroupProfileGetdata(chatid: widget.roomId??"", token: widget.token??"")
          );
            if(isMobile){
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: ChatProfileScreen2(
                  chat: widget.isgrp,
                  token: widget.token,
                  roomId: widget.roomId,
                  socket: widget.socket,
                  loginuserid: widget.loginUserId,
                  isGroup: true,
                  isadmin: widget.isadmin,
                  redirectchatid: widget.redirectchatid,
                  redirectchatname: widget.redirectchatname,
                  communicationUserModel: widget.communicationUserModel,
                  communicationuser: widget.grpuser,
                  grpmember: widget.grpmember,

                ),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.fade,
              );
            } else{
              objectGlobal=   objectGlobal.changeScreen(current:
              ChatProfileScreen2(
                chat: widget.isgrp,
                token: widget.token,
                roomId: widget.roomId,
                socket: widget.socket,
                loginuserid: widget.loginUserId,
                isGroup: true,
                isadmin: widget.isadmin,
                redirectchatid: widget.redirectchatid,
                redirectchatname: widget.redirectchatname,
                communicationUserModel: widget.communicationUserModel,
                communicationuser: widget.grpuser,
                grpmember: widget.grpmember,

              ),
                  previous: this.widget,tabIndex: -1);
              print(objectGlobal.existing);
              objectGlobal.changeData();
            }

                  }
                },
                child:
               Container(
                 child: Row(
                  children: [
                     widget.isGroup==false?
                              widget.chat==true?widget.communicationuser?.users![0].photo == null||widget.communicationuser!.users![0].photo!.isEmpty?
                              TextAvatar(
                          shape: Shape.Circular,
                          size: h / 95,
                          numberLetters: 2,
                          fontSize: w / 22,
                          textColor: Colors.white,
                          fontWeight: FontWeight.w500,
                          text: widget.isGroup == false
                              ? widget.chat == false
                                ?widget.redirectchatname!=""?widget.redirectchatname:  "${widget.communicationUserModel?.name.toString().toUpperCase()}"
                                  : "${widget.communicationuser?.name.toString().toUpperCase()}"
                              : widget.isgrp == false
                                  ? "${widget.communicationUserModel?.name.toString().toUpperCase()}"
                                  : widget.cmntgrpid == ""
                                      ? "${widget.grpuser?.gname.toString().toUpperCase()}"
                                      : "${widget.cmntgrpname.toString().toUpperCase()}",
                        )
                      :  CircleAvatar(
                              radius: w / 23,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                      widget.communicationuser?.users![0].photo ?? ""
                                  //  "https://api-uat-user.sidrabazar.com/media/${communicationUserModel?.users?[0].photo}"
                                  // "${widget.communicationUserModel?.photo}"
                                  // widget.isgrp==false ? widget.communicationUserModel?.photo?? "": widget.grpuser?.gphoto??"",
                                  ))

                  :widget.communicationUserModel?.photoindividual == null ||
                          widget.communicationUserModel!.photoindividual!.isEmpty
                      ? TextAvatar(
                          shape: Shape.Circular,
                          size: h / 95,
                          numberLetters: 2,
                          fontSize: w / 22,
                          textColor: Colors.white,
                          fontWeight: FontWeight.w500,
                          text: widget.isGroup == false
                              ? widget.chat == false
                                ?widget.redirectchatname!=""?widget.redirectchatname:  "${widget.communicationUserModel?.name.toString().toUpperCase()}"
                                  : "${widget.communicationuser?.name.toString().toUpperCase()}"
                              : widget.isgrp == false
                                  ? "${widget.communicationUserModel?.name.toString().toUpperCase()}"
                                  : widget.cmntgrpid == ""
                                      ? "${widget.grpuser?.gname.toString().toUpperCase()}"
                                      : "${widget.cmntgrpname.toString().toUpperCase()}",
                        )
                      :  CircleAvatar(
                              radius: w / 23,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(widget.communicationUserModel?.photoindividual ?? ""
                                  //  "https://api-uat-user.sidrabazar.com/media/${communicationUserModel?.users?[0].photo}"
                                  // "${widget.communicationUserModel?.photo}"
                                  // widget.isgrp==false ? widget.communicationUserModel?.photo?? "": widget.grpuser?.gphoto??"",
                                  ))
                          // : CircleAvatar(
                          //     radius: w / 23,
                          //     backgroundColor: Colors.grey,
                          //     backgroundImage:
                          //         AssetImage("asset/chatgrpimg.png"))
                                  :widget.communicationUserModel?.photo==null||
                          widget.communicationUserModel!.photo!.isEmpty ?
                       CircleAvatar(
                            radius: 24,
                            backgroundColor: ColorPalette.inactiveGrey,
                            backgroundImage:
                                AssetImage("asset/chatgrpimg.png")
                          )
                          :CircleAvatar(
                            radius: w / 23,
                            backgroundColor: ColorPalette.inactiveGrey,
                            backgroundImage:
                             NetworkImage(
                                widget.communicationUserModel?.photo ?? ""
                                // "https://api-uat-user.sidrabazar.com/media/${widget.communicationUserModel?.users?[0].photo}"
                                // "${widget.communicationUserModel?.photo}"
                                ),
                          ),
                          const SizedBox(
                  width: 10,
                               ),
                  //              Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // children: [
                    widget.isGroup == false
                        ? Container(
                            // color: Colors.green,
                            width: w / 1.9,
                            child: Text(
                              widget.chat == false
                                  ?  widget.redirectchatid!=""?"${widget.redirectchatname.toTitleCase()}":"${widget.communicationUserModel?.name?.toTitleCase()}"
                                  : widget.redirectchatid!=""?"${widget.redirectchatname.toTitleCase()}":"${widget.communicationuser?.users![0].name?.toTitleCase()}",
                              // maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: w / 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : widget.cmntgrpid == ""
                            ? Text(
                                widget.isgrp == false
                                    ? widget.redirectchatid!=""?"${widget.redirectchatname.toTitleCase()}":"${widget.communicationUserModel?.name?.toTitleCase()}"
                                    : widget.redirectchatid!=""?"${widget.redirectchatname.toTitleCase()}":"${widget.grpuser?.gname?.toTitleCase()}",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: w / 25,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : Container(
                                width: w / 1.8,
                                child: Text(
                                 widget.redirectchatid!=""?"${widget.redirectchatname.toTitleCase()}": "${widget.cmntgrpname.toTitleCase()}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: w / 25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )

                    // groupTypingUser != null
                    //     ? Row(
                    //         children: [
                    //           CircleAvatar(
                    //               backgroundColor: Colors.white,
                    //               radius: 14,
                    //               child: CircleAvatar(
                    //                 backgroundImage: NetworkImage(
                    //                     groupTypingUser?.photo ?? ""),
                    //                 radius: 12,
                    //               )),
                    //           Text(
                    //             "${groupTypingUser?.name} typing",
                    //             style: const TextStyle(
                    //               color: Color(0xff151522),
                    //               fontSize: 16,
                    //             ),
                    //           ),
                    //         ],
                    //       )
                    //     : Text(
                    //         typing == true ? "typing" : "",
                    //         style: const TextStyle(
                    //           color: Color(0xff151522),
                    //           fontSize: 16,
                    //         ),
                    //       )
                  // ],
                  //              )
                  ],
                 ),
               )
              );
               }
              ):GestureDetector(
                onTap: () {
                  // if (widget.isGroup == false) {
                    // PersistentNavBarNavigator.pushNewScreen(
                    //   context,
                    //   screen: ChatProfileScreen(
                    //     chat: widget.chat,
                    //     token: widget.token,
                    //     roomId: widget.roomId,
                    //     socket: widget.socket,
                    //     isGroup: widget.communicationUserModel?.isgrp ?? false,
                    //     communicationUserModel: widget.communicationUserModel,
                    //     communicationuser: widget.communicationuser,
                    //   ),
                    //   withNavBar: true, // OPTIONAL VALUE. True by default.
                    //   pageTransitionAnimation: PageTransitionAnimation.fade,
                    // );
                  // } else if(widget.cmntgrpid=="") {
                    // BlocProvider(
          //   create: (context) => GroupBloc()
          //     ..add(GroupProfileGet(
          //         chatid: widget.communicationUserModel?.chatid ?? "",
          //         token: widget.token ?? "")),
          // ),
          // context.read<GroupBloc>().add(
          //   GroupProfileGetdata(chatid: widget.roomId??"", token: widget.token??"")
          // );
          //           PersistentNavBarNavigator.pushNewScreen(
          //             context,
          //             screen: ChatProfileScreen2(
          //               chat: widget.isgrp,
          //               token: widget.token,
          //               roomId: widget.roomId,
          //               socket: widget.socket,
          //               loginuserid: widget.loginUserId,
          //               isGroup: true,
          //               isadmin: widget.isadmin,
          //               redirectchatid: widget.redirectchatid,
          //               redirectchatname: widget.redirectchatname,
          //               communicationUserModel: widget.communicationUserModel,
          //               communicationuser: widget.grpuser,
          //               grpmember: widget.grpmember,

          //             ),
          //             withNavBar: true, // OPTIONAL VALUE. True by default.
          //             pageTransitionAnimation: PageTransitionAnimation.fade,
          //           );
                  // }
                },
                child: 
               Container(
                 child: Row(
                  children: [
                     
                              widget.chat==true?widget.communicationuser?.users![0].photo == null||widget.communicationuser!.users![0].photo!.isEmpty?
                              TextAvatar(
                          shape: Shape.Circular,
                          size: h / 95,
                          numberLetters: 2,
                          fontSize: w / 22,
                          textColor: Colors.white,
                          fontWeight: FontWeight.w500,
                          text: widget.isGroup == false
                              ? widget.chat == false
                                ?widget.redirectchatname!=""?widget.redirectchatname:  "${widget.communicationUserModel?.name.toString().toUpperCase()}"
                                  : "${widget.communicationuser?.name.toString().toUpperCase()}"
                              : widget.isgrp == false
                                  ? "${widget.communicationUserModel?.name.toString().toUpperCase()}"
                                  : widget.cmntgrpid == ""
                                      ? "${widget.grpuser?.gname.toString().toUpperCase()}"
                                      : "${widget.cmntgrpname.toString().toUpperCase()}",
                        )
                      :  CircleAvatar(
                              radius: w / 23,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                      widget.communicationuser?.users![0].photo ?? ""
                                  //  "https://api-uat-user.sidrabazar.com/media/${communicationUserModel?.users?[0].photo}"
                                  // "${widget.communicationUserModel?.photo}"
                                  // widget.isgrp==false ? widget.communicationUserModel?.photo?? "": widget.grpuser?.gphoto??"",
                                  ))
                              
                  :widget.communicationUserModel?.photoindividual == null ||
                          widget.communicationUserModel!.photoindividual!.isEmpty 
                      ? TextAvatar(
                          shape: Shape.Circular,
                          size: h / 95,
                          numberLetters: 2,
                          fontSize: w / 22,
                          textColor: Colors.white,
                          fontWeight: FontWeight.w500,
                          text: widget.isGroup == false
                              ? widget.chat == false
                                ?widget.redirectchatname!=""?widget.redirectchatname:  "${widget.communicationUserModel?.name.toString().toUpperCase()}"
                                  : "${widget.communicationuser?.name.toString().toUpperCase()}"
                              : widget.isgrp == false
                                  ? "${widget.communicationUserModel?.name.toString().toUpperCase()}"
                                  : widget.cmntgrpid == ""
                                      ? "${widget.grpuser?.gname.toString().toUpperCase()}"
                                      : "${widget.cmntgrpname.toString().toUpperCase()}",
                        )
                      :  CircleAvatar(
                              radius: w / 23,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(widget.communicationUserModel?.photoindividual ?? ""
                                  //  "https://api-uat-user.sidrabazar.com/media/${communicationUserModel?.users?[0].photo}"
                                  // "${widget.communicationUserModel?.photo}"
                                  // widget.isgrp==false ? widget.communicationUserModel?.photo?? "": widget.grpuser?.gphoto??"",
                                  )),
                          // : CircleAvatar(
                          //     radius: w / 23,
                          //     backgroundColor: Colors.grey,
                          //     backgroundImage:
                          //         AssetImage("asset/chatgrpimg.png"))
                                  
                          const SizedBox(
                  width: 10,
                               ),
                  //              Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // children: [
                    widget.isGroup == false
                        ? Container(
                            // color: Colors.green,
                            width: w / 1.9,
                            child: Text(
                              widget.chat == false
                                  ?  widget.redirectchatid!=""?"${widget.redirectchatname.toTitleCase()}":"${widget.communicationUserModel?.name?.toTitleCase()}"
                                  : widget.redirectchatid!=""?"${widget.redirectchatname.toTitleCase()}":"${widget.communicationuser?.users![0].name?.toTitleCase()}",
                              // maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: w / 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : widget.cmntgrpid == ""
                            ? Text(
                                widget.isgrp == false
                                    ? widget.redirectchatid!=""?"${widget.redirectchatname.toTitleCase()}":"${widget.communicationUserModel?.name?.toTitleCase()}"
                                    : widget.redirectchatid!=""?"${widget.redirectchatname.toTitleCase()}":"${widget.grpuser?.gname?.toTitleCase()}",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: w / 25,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : Container(
                                width: w / 1.8,
                                child: Text(
                                 widget.redirectchatid!=""?"${widget.redirectchatname.toTitleCase()}": "${widget.cmntgrpname.toTitleCase()}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: w / 25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                               
                    // groupTypingUser != null
                    //     ? Row(
                    //         children: [
                    //           CircleAvatar(
                    //               backgroundColor: Colors.white,
                    //               radius: 14,
                    //               child: CircleAvatar(
                    //                 backgroundImage: NetworkImage(
                    //                     groupTypingUser?.photo ?? ""),
                    //                 radius: 12,
                    //               )),
                    //           Text(
                    //             "${groupTypingUser?.name} typing",
                    //             style: const TextStyle(
                    //               color: Color(0xff151522),
                    //               fontSize: 16,
                    //             ),
                    //           ),
                    //         ],
                    //       )
                    //     : Text(
                    //         typing == true ? "typing" : "",
                    //         style: const TextStyle(
                    //           color: Color(0xff151522),
                    //           fontSize: 16,
                    //         ),
                    //       )
                  // ],
                  //              )
                  ],
                 ),
               )
              ),
              
            ],
          ),
          // PopupMenuButton(
          //   icon: SvgPicture.string(TaskSvg().moreIcon2,height: w/14,),
          //  offset: Offset(-9,45),
          //   //don't specify icon if you want 3 dot menu
          //   color: Color.fromARGB(255, 255, 255, 255),
          //   elevation: 2,
          //   shape:
          //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          //   itemBuilder: (context) => [
          //     PopupMenuItem(
          //         padding: const EdgeInsets.symmetric(horizontal:9),
          //         value: 'a',
          //         enabled: true,
          //         child: Padding(
          //           padding: const EdgeInsets.only(top: 5,bottom: 5),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Container(
          //                 width: w/2.735,
          //                 child: Row(
          //                   children: [
          //                     SvgPicture.string(TaskSvg().profileIcon,width: w/13,),
          //                     const SizedBox(
          //                       width: 10,
          //                     ),
          //                     Text(
          //                       'Profile Details',
          //                       style: GoogleFonts.roboto(
          //                           color: Color(0xFF151522),
          //                           fontSize: w/26.5,
          //                           fontWeight: FontWeight.w400),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               SizedBox(
          //                 height:20,
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(left: 40),
          //                   child: const Divider(),
          //                 ),
          //               ),
          //               Container(
          //                 child: Row(
          //                   children: [
          //                     SvgPicture.string(TaskSvg().shareIcon2,width: w/13),
          //                     // SvgPicture.string(TaskSvg().msgSendIcon),
          //                     const SizedBox(
          //                       width: 10,
          //                     ),
          //                     Text(
          //                       'Share Profile',
          //                       style: GoogleFonts.roboto(
          //                           color: Color(0xFF151522),
          //                           fontSize: w/26.5,
          //                           fontWeight: FontWeight.w400),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //                SizedBox(
          //                 height: 20,
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(left:40),
          //                   child: const Divider(),
          //                 ),
          //               ),
          //               Container(
          //                 child: Row(
          //                   children: [
          //                     SvgPicture.string(TaskSvg().pinICon,width: w/13),
          //                     const SizedBox(
          //                       width: 10,
          //                     ),
          //                     Text(
          //                       'Pin this chat',
          //                       style: GoogleFonts.roboto(
          //                           color: Color(0xFF151522),
          //                           fontSize:w/26.5,
          //                           fontWeight: FontWeight.w400),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ))
          //   ],
          //   onSelected: (value) {},
          // ),
        ],
      ),
    );
  }

  void handleActiveLength(data) {}
  Future<void> saveUnreadMessageCount(int count, String chatt) async {
    print("inside the funcion");
    pref = await SharedPreferences.getInstance();
    await pref!.setInt(chatt, 0);
    setState(() {
      print("my msg update counta $count $chatt");
    });
  }
}
