import 'package:cluster/common_widgets/loading.dart';
import 'package:cluster/common_widgets/no_glow.dart';
import 'package:cluster/common_widgets/string_extensions.dart';
import 'package:cluster/core/common_snackBar.dart';
import 'package:cluster/presentation/authentication/authentication.dart';
import 'package:cluster/presentation/comunication_module/bloc/chat_bloc.dart';
import 'package:cluster/presentation/comunication_module/bloc/communication_bloc.dart';
import 'package:cluster/presentation/comunication_module/chat_profile_screen.dart';
import 'package:cluster/presentation/comunication_module/chat_screen.dart';
import 'package:cluster/presentation/comunication_module/com_svg.dart';
import 'package:cluster/presentation/comunication_module/create_chatgroup.dart';
import 'package:cluster/presentation/comunication_module/dummy_design_forTesting/dummy_user_list_model.dart';
import 'package:cluster/presentation/comunication_module/group_bloc/bloc/group_bloc.dart';
import 'package:cluster/presentation/comunication_module/models/communicationuser_model.dart';
import 'package:cluster/presentation/comunication_module/newgroup.dart';
import 'package:cluster/presentation/task_operation/task_svg.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:socket_io_client/socket_io_client.dart';
import  'package:cluster/presentation/task_operation/employee_card.dart';
import 'package:xid/xid.dart';
import '../../core/color_palatte.dart';
import '../dashboard_screen/home_screen/home_svg.dart';

class AddGroupMembers extends StatefulWidget {
  final String? token;
  final String? chatid;
  bool isGroup;
  final UserDummyList? communicationUserModel;
  final Socket? socket;
  final String redirectchatid;
  final String redirectchatname;
  final bool chat;
  final GroupList? communicationuser;
  AddGroupMembers({Key? key,
    this.token,
    this.chatid,
    this.isGroup = false,
    this.communicationUserModel,
    this.socket,
    this.redirectchatid="",
    this.redirectchatname="",
    this.chat = false,
    this.communicationuser
  })
      : super(key: key);

  @override
  State<AddGroupMembers> createState() => _AddGroupMembersState();
}

class _AddGroupMembersState extends State<AddGroupMembers> {
  bool changeUi = false;
  List<CommunicationUserModel> chatlist=[];
  String email1='';
  String? uid='';
  bool val=true;
  List<GroupUserList> grpmember=[];
  bool isM=true;
  bool issMount= true;
  String? addusername="";
  bool isSelect = false;
  // var _listGenderText = ["Users", "Groups"];
  // var _tabTextIconIndexSelected = 0;
  @override
  void initState() {
    print("redirection id ${widget.redirectchatid}");
    BlocProvider.of<CommunicationBloc>(context).add(
        GetFilterdChatListEvent(
            token: widget.token ?? "",
            chatFilter: "chats"
        ));
    print("room pofilr ${widget.communicationuser?.description} ${widget.redirectchatid} ${widget.redirectchatname}");
    widget.socket!.emit("group.members",
        widget.chat==false?widget.redirectchatid!=""?widget.redirectchatid:widget.communicationUserModel?.chatid : widget.communicationuser?.chatid);

    widget.socket!.on("groupmembers.result", (data){
      print("group members: $data");
      grpmember.clear();
      (data as List).forEach((element) {
        grpmember.add(GroupUserList.fromJson(element));

      });
      if(issMount){
        setState(() {
          isM=false;
          print(grpmember.length);
        });
      }
      print("room pofilr ${widget.communicationuser?.description}  ${widget.redirectchatid}");

    });

    //  widget.socket!.on("userAddedToGroup", (data) {

    //     print("user $data");
    //       showSnackBar(context,
    //     message: "User Add To Group Successfully", color: ColorPalette.primary);
    //   }

    // );
    // TODO: implement initState
    super.initState();
  }

  void dispose() {
    // Remove the socket listener when the widget is disposed
    widget.socket?.off("userAddedToGroup");
    widget.socket?.off("userAlreadyInGroup");
    issMount=false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return
      MultiBlocListener(
        listeners: [

          BlocListener<GroupBloc,GroupState>(
              listener: (context, state){
                if(state is GroupMemberAddLoading){
                  print("loading");
                }
                else if(state is GroupMemberAddSuccess){
                  BlocProvider.of<GroupBloc>(context)
                      .add(GetAllRegisteredUsersEvent(""));
                  print("success");
                  var xid = Xid();
                  print("xid uniw $xid");
                  widget.socket!.emit("group.members",{widget.chat==false?widget.redirectchatid!=""?widget.redirectchatid: widget.communicationUserModel?.chatid:widget.communicationuser?.chatid,uid});
                  widget.socket?.on("update.chat.list", (data) => print("fxgf  $data"));
                  widget.socket!.emit("group.message",{
                    "type": "notify", "chatid": widget.redirectchatid==""?widget.chatid:widget.redirectchatid, "content": "$addusername is added to group","xid":"$xid"
                  });
                  showSnackBar(context,
                      message: state.successmsg, color: Colors.green);
                }
                else if(state is GroupMemberAddFailed){
                  BlocProvider.of<GroupBloc>(context)
                      .add(GetAllRegisteredUsersEvent(""));
                  showSnackBar(context,
                      message: state.error, color: Colors.red);

                }
              }

          )

        ],

        child: AlertDialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(20.0),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: w/2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
              // Add border to see if it's being applied

            ),

            child: Column(
              children: [
                AppBar(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          )),
                  leading: BackButton(
                    onPressed: () {
                      print("hello");

                      setState(() {
                        widget.socket!.emit("group.members",{widget.redirectchatid==""?widget.chatid:widget.redirectchatid,uid});
                        widget.socket!.on("groupmembers.result", (data) => print("update"));
                        widget.socket!.emit("update.list",{
                          widget.socket!.on("friends.update", (data) => print(data)),
                          print("update")
                        });
                        Navigator.pop(context);
                      });
                      // BlocProvider.of<CommunicationBloc>(context)
                      //     .add(GetChatListEvent(token: widget.token ?? ""));
                    },
                    color: Colors.black,
                  ),

                  iconTheme: IconThemeData(
                    color: Colors.black, //change your color here
                  ),
                  surfaceTintColor: Colors.white,
                  elevation: 0,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    systemNavigationBarColor: Colors.white, // Navigation bar
                    statusBarColor: Colors.white, // Status bar
                  ),
                  backgroundColor: Colors.white,
                  title: Text("Add Member", style:  TextStyle(color: Colors.black,fontSize: w*.01),),
                  titleSpacing: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height/1.24,
                  padding: const EdgeInsets.all(20),
                  child: ScrollConfiguration(
                    behavior: NoGlow(),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<GroupBloc, GroupState>(
                            builder: (context, state) {
                              if (state is GetAllRegisteredUsersLoading) {
                                return customCupertinoLoading();
                              } else if (state is GetAllRegisteredUsersSuccess) {
                                print("sjsd ${authentication.authenticatedUser.code}");
                                for(int j=0;j<grpmember.length;){
                                  for(int i=0;i<state.registeresUsers.length;){
                                    // print();
                                    if(grpmember[j].usercode==state.registeresUsers[i].userCode){
                                      state.registeresUsers.removeAt(i);
                                    }
                                    i++;
                                  }
                                  j++;
                                }

                                return Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      // child: Container(
                                      //   padding: const EdgeInsets.only(
                                      //       left: 16, top: 10, bottom: 16),
                                      //   child: Text(
                                      //     "${state.registeresUsers.length} Contacts",
                                      //     style: GoogleFonts.roboto(
                                      //       color: const Color(0xff151522),
                                      //       fontSize: w / 22,
                                      //       fontWeight: FontWeight.w600,
                                      //     ),
                                      //   ),
                                      // ),
                                    ),
                                    state.registeresUsers.length ==0?Padding(
                                      padding: const EdgeInsets.only(top:150),
                                      child: Container(child: Column(
                                        children: [
                                          SvgPicture.string(CommunicationSvg().nolistSvg),
                                          Text("All contacts are already in group")

                                        ],
                                      )),
                                    ) :ListView.separated(
                                        padding:EdgeInsets.only(left: 16,right: 16) ,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) => GestureDetector(
                                            onTap: () {
                                              addusername= "${state.registeresUsers[index].fname.toString().toTitleCase()} ${state.registeresUsers[index].lname.toString().toTitleCase()}";
                                              showDialog(
                                                context: context, builder: (BuildContext context) {
                                                return
                                                  Padding(
                                                  padding: const EdgeInsets.only(top: 20,left:30,right: 30),
                                                  child: AlertDialog(

                                                    insetPadding: EdgeInsets.symmetric(vertical:5),
                                                    content: Container(


                                                      height: MediaQuery.of(context).size.height/2,
                                                      child: Column(

                                                        children: [
                                                          SizedBox(height:35,),
                                                          SvgPicture.string(CommunicationSvg().msghistory),
                                                          SizedBox(height:20,),
                                                          Text(
                                                            'Include chat history?',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: Color(0xFF151522),
                                                              fontSize: 24,
                                                              fontFamily: 'Roboto',
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          SizedBox(height:10,),
                                                          Text(
                                                            'Would you like to provide the chat\nhistory for him?',
                                                            textAlign: TextAlign.center,
                                                            softWrap: true,
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 15,
                                                              fontFamily: 'Roboto',
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      Row( mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          GestureDetector(onTap: (){
                                                            isSelect=true;
                                                            BlocProvider.of<GroupBloc>(context).add(
                                                                GroupMemberAddEvent(token: widget.token??"",
                                                                    chatId: widget.redirectchatid==""?widget.chatid.toString():widget.redirectchatid.toString(),
                                                                    userId: "${state.registeresUsers[index].userCode}",
                                                                    emailid: state
                                                                        .registeresUsers[index]
                                                                        .email ??
                                                                        "",
                                                                    fname: state
                                                                        .registeresUsers[index]
                                                                        .fname ??
                                                                        "",
                                                                    photo: state
                                                                        .registeresUsers[index].userMete
                                                                        ?.profile ??
                                                                        "",
                                                                    lname: state
                                                                        .registeresUsers[index]
                                                                        .lname ??
                                                                        "",
                                                                    ishistory: false
                                                                )
                                                            );
                                                            Navigator.pop(context);
                                                          }, child: Container(
                                                            width: w/3,
                                                            height: 55,
                                                            decoration: ShapeDecoration(
                                                              color: isSelect==false? Colors.transparent:Color(0xFF2871AF),
                                                              shape: RoundedRectangleBorder(
                                                                side: BorderSide(width: 1, color: Color(0xFF2871AF)),
                                                                borderRadius: BorderRadius.circular(4),
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                'Yes, Include',
                                                                style: TextStyle(
                                                                  color:isSelect==false? Color(0xFF2871AF):Colors.white,
                                                                  fontSize: 16,
                                                                  fontFamily: 'Inter',
                                                                  fontWeight: FontWeight.w500,
                                                                  height: 0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          ),
                                                          SizedBox(width: 5,),
                                                          GestureDetector(onTap: (){
                                                            isSelect=false;
                                                            setState(() {
                                                              BlocProvider.of<GroupBloc>(context).add(
                                                                  GroupMemberAddEvent(token: widget.token??"",
                                                                      chatId: widget.redirectchatid==""?widget.chatid.toString():widget.redirectchatid.toString(),
                                                                      userId: "${state.registeresUsers[index].userCode}",
                                                                      emailid: state
                                                                          .registeresUsers[index]
                                                                          .email ??
                                                                          "",
                                                                      fname: state
                                                                          .registeresUsers[index]
                                                                          .fname ??
                                                                          "",
                                                                      photo: state
                                                                          .registeresUsers[index].userMete
                                                                          ?.profile ??
                                                                          "",
                                                                      lname: state
                                                                          .registeresUsers[index]
                                                                          .lname ??
                                                                          "",
                                                                      ishistory: true
                                                                  )
                                                              );

                                                              Navigator.pop(context);


                                                            });

                                                          }, child: Container(
                                                            width: w/3,
                                                            height: 55,
                                                            decoration: ShapeDecoration(
                                                              color: isSelect==false? Color(0xFF2871AF):Colors.transparent,
                                                              shape: RoundedRectangleBorder(
                                                                  side: BorderSide(width: 1, color: Color(0xFF2871AF)),
                                                                  borderRadius: BorderRadius.circular(4)),
                                                            ),
                                                            child:  Center(
                                                              child: Text(
                                                                'Not include',
                                                                style: TextStyle(
                                                                  color:isSelect==false? Colors.white:Color(0xFF2871AF),
                                                                  fontSize: 16,
                                                                  fontFamily: 'Inter',
                                                                  fontWeight: FontWeight.w500,
                                                                  height: 0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                              );

                                              //          BlocProvider.of<GroupBloc>(context).add(
                                              //           GroupMemberAddEvent(token: widget.token??"",
                                              //           chatId: widget.redirectchatid==""?widget.chatid.toString():widget.redirectchatid.toString(),
                                              //           userId: "${state.registeresUsers[index].userCode}",
                                              //           emailid: state
                                              //         .registeresUsers[index]
                                              //         .email ??
                                              //     "",
                                              // fname: state
                                              //         .registeresUsers[index]
                                              //         .fname ??
                                              //     "",
                                              // photo: state
                                              //         .registeresUsers[index].userMete
                                              //         ?.profile ??
                                              //     "",
                                              // lname: state
                                              //         .registeresUsers[index]
                                              //         .lname ??
                                              //     "",
                                              //           )
                                              //                                   );





                                              //       widget.socket!.emit("userAddToGroup",{
                                              //         "userCode": "${state.registeresUsers[index].userCode}",
                                              //        "chatId": widget.redirectchatid==""?widget.chatid.toString():widget.redirectchatid.toString() });

                                              //      print("hjkl");
                                              //      print("hjkluser1");
                                              //    widget.socket!.on("userAddedToGroup", (data) {
                                              //     print("hjkluser $data");

                                              //      showSnackBar(context,
                                              //     message: "User Add To Group Successfully", color: ColorPalette.primary);
                                              //      widget.socket!.emit("group.message",{
                                              //       "type": "notify", "chatid": widget.redirectchatid==""?widget.chatid:widget.redirectchatid, "content": "${state.registeresUsers[index].fname.toString().toTitleCase()} ${state.registeresUsers[index].lname.toString().toTitleCase()} is added to group"
                                              //     });
                                              //      widget.socket!.emit("group.members",{widget.chat==false?widget.redirectchatid!=""?widget.redirectchatid: widget.communicationUserModel?.chatid:widget.communicationuser?.chatid,uid});
                                              //     widget.socket?.on("update.chat.list", (data) => print("fxgf  $data"));

                                              //   }

                                              // );
                                              //   widget.socket!.on("userAlreadyInGroup", (data) {
                                              //     print("hjkluser2 $data");

                                              //     showSnackBar(context,
                                              //     message: "Already in Group", color: ColorPalette.primary);
                                              //     setState(() {

                                              //     });

                                              //   });

                                            },
                                            child: EmployeeCard(employeeList: state.registeresUsers[index],isCommunicate:true,)
                                          // Container(
                                          //   padding:
                                          //       const EdgeInsets.symmetric(
                                          //           horizontal: 10),
                                          //   child: Row(
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment
                                          //             .spaceBetween,
                                          //     children: [
                                          //       Row(
                                          //         children: [
                                          //           const CircleAvatar(),
                                          //           const SizedBox(
                                          //             width: 10,
                                          //           ),
                                          //           Column(
                                          //             mainAxisAlignment:
                                          //                 MainAxisAlignment
                                          //                     .start,
                                          //             crossAxisAlignment:
                                          //                 CrossAxisAlignment
                                          //                     .start,
                                          //             children: [
                                          //               Text(
                                          //                 state
                                          //                         .registeresUsers[
                                          //                             index]
                                          //                         .name ??
                                          //                     "",
                                          //                 style: GoogleFonts
                                          //                     .roboto(
                                          //                   color: const Color(
                                          //                       0xff151522),
                                          //                   fontSize: 18,
                                          //                   fontWeight:
                                          //                       FontWeight
                                          //                           .w500,
                                          //                 ),
                                          //               ),
                                          //               Text(
                                          //                 state
                                          //                         .registeresUsers[
                                          //                             index]
                                          //                         .mail ??
                                          //                     "",
                                          //                 style:
                                          //                     const TextStyle(
                                          //                   color: Color(
                                          //                       0xff6d6d6d),
                                          //                   fontSize: 14,
                                          //                 ),
                                          //               )
                                          //             ],
                                          //           )
                                          //         ],
                                          //       ),
                                          //       index < 0
                                          //           ? Container(
                                          //               width: 28,
                                          //               height: 28,
                                          //               decoration:
                                          //                   BoxDecoration(
                                          //                 borderRadius:
                                          //                     BorderRadius
                                          //                         .circular(
                                          //                             30),
                                          //                 color: const Color(
                                          //                     0xfffe5762),
                                          //               ),
                                          //               child: Center(
                                          //                 child: Text(
                                          //                   "15",
                                          //                   style: GoogleFonts
                                          //                       .outfit(
                                          //                     color: Colors
                                          //                         .white,
                                          //                     fontSize: 14,
                                          //                     fontWeight:
                                          //                         FontWeight
                                          //                             .w600,
                                          //                   ),
                                          //                 ),
                                          //               ),
                                          //             )
                                          //           : Container()
                                          //     ],
                                          //   ),
                                          // ),
                                        ),
                                        separatorBuilder: (context, index) =>
                                        const SizedBox(
                                          height:5,
                                        ),
                                        itemCount: state.registeresUsers.length),
                                    SizedBox(
                                      height: 50,
                                    )
                                  ],
                                );
                              } else if (state is GetAllRegisteredUsersFailed) {}
                              return Container();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Scaffold(
                //   backgroundColor: Colors.white,
                //   appBar:
                //   AppBar(
                //
                //     leading: BackButton(
                //       onPressed: () {
                //         print("hello");
                //
                //         setState(() {
                //           widget.socket!.emit("group.members",{widget.redirectchatid==""?widget.chatid:widget.redirectchatid,uid});
                //           widget.socket!.on("groupmembers.result", (data) => print("update"));
                //           widget.socket!.emit("update.list",{
                //             widget.socket!.on("friends.update", (data) => print(data)),
                //             print("update")
                //           });
                //           Navigator.pop(context);
                //         });
                //         // BlocProvider.of<CommunicationBloc>(context)
                //         //     .add(GetChatListEvent(token: widget.token ?? ""));
                //       },
                //       color: Colors.black,
                //     ),
                //
                //     iconTheme: IconThemeData(
                //       color: Colors.black, //change your color here
                //     ),
                //     surfaceTintColor: Colors.white,
                //     elevation: 0,
                //     systemOverlayStyle: const SystemUiOverlayStyle(
                //       systemNavigationBarColor: Colors.white, // Navigation bar
                //       statusBarColor: Colors.white, // Status bar
                //     ),
                //     backgroundColor: Colors.white,
                //     title: Text("Add Member", style:  TextStyle(color: Colors.black,fontSize: w/22),),
                //     titleSpacing: 10,
                //   ),
                //
                //   body:
                //   Padding(
                //     padding: const EdgeInsets.all(20),
                //     child: ScrollConfiguration(
                //       behavior: NoGlow(),
                //       child: SingleChildScrollView(
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             BlocBuilder<GroupBloc, GroupState>(
                //               builder: (context, state) {
                //                 if (state is GetAllRegisteredUsersLoading) {
                //                   return customCupertinoLoading();
                //                 } else if (state is GetAllRegisteredUsersSuccess) {
                //                   print("sjsd ${authentication.authenticatedUser.code}");
                //                   for(int j=0;j<grpmember.length;){
                //                     for(int i=0;i<state.registeresUsers.length;){
                //                       // print();
                //                       if(grpmember[j].usercode==state.registeresUsers[i].userCode){
                //                         state.registeresUsers.removeAt(i);
                //                       }
                //                       i++;
                //                     }
                //                     j++;
                //                   }
                //
                //                   return Column(
                //                     children: [
                //                       Align(
                //                         alignment: Alignment.centerLeft,
                //                         // child: Container(
                //                         //   padding: const EdgeInsets.only(
                //                         //       left: 16, top: 10, bottom: 16),
                //                         //   child: Text(
                //                         //     "${state.registeresUsers.length} Contacts",
                //                         //     style: GoogleFonts.roboto(
                //                         //       color: const Color(0xff151522),
                //                         //       fontSize: w / 22,
                //                         //       fontWeight: FontWeight.w600,
                //                         //     ),
                //                         //   ),
                //                         // ),
                //                       ),
                //                       state.registeresUsers.length ==0?Padding(
                //                         padding: const EdgeInsets.only(top:150),
                //                         child: Container(child: Column(
                //                           children: [
                //                             SvgPicture.string(CommunicationSvg().nolistSvg),
                //                             Text("All contacts are already in group")
                //
                //                           ],
                //                         )),
                //                       ) :ListView.separated(
                //                           padding:EdgeInsets.only(left: 16,right: 16) ,
                //                           physics: NeverScrollableScrollPhysics(),
                //                           shrinkWrap: true,
                //                           itemBuilder: (context, index) => GestureDetector(
                //                               onTap: () {
                //                                 addusername= "${state.registeresUsers[index].fname.toString().toTitleCase()} ${state.registeresUsers[index].lname.toString().toTitleCase()}";
                //                                 showDialog(
                //                                   context: context, builder: (BuildContext context) {
                //                                   return Padding(
                //                                     padding: const EdgeInsets.only(top: 20,left:30,right: 30),
                //                                     child: AlertDialog(
                //
                //                                       insetPadding: EdgeInsets.symmetric(vertical:5),
                //                                       content: Container(
                //                                         height: MediaQuery.of(context).size.height/2.5,
                //                                         child: Column(
                //
                //                                           children: [
                //                                             SizedBox(height:35,),
                //                                             SvgPicture.string(CommunicationSvg().msghistory),
                //                                             SizedBox(height:20,),
                //                                             Text(
                //                                               'Include chat history?',
                //                                               textAlign: TextAlign.center,
                //                                               style: TextStyle(
                //                                                 color: Color(0xFF151522),
                //                                                 fontSize: 24,
                //                                                 fontFamily: 'Roboto',
                //                                                 fontWeight: FontWeight.w600,
                //                                               ),
                //                                             ),
                //                                             SizedBox(height:10,),
                //                                             Text(
                //                                               'Would you like to provide the chat\nhistory for him?',
                //                                               textAlign: TextAlign.center,
                //                                               softWrap: true,
                //                                               style: TextStyle(
                //                                                 color: Colors.black,
                //                                                 fontSize: 15,
                //                                                 fontFamily: 'Roboto',
                //                                                 fontWeight: FontWeight.w400,
                //                                               ),
                //                                             )
                //                                           ],
                //                                         ),
                //                                       ),
                //                                       actions: [
                //                                         Row( mainAxisAlignment: MainAxisAlignment.end,
                //                                           children: [
                //                                             GestureDetector(onTap: (){
                //                                               isSelect=true;
                //                                               BlocProvider.of<GroupBloc>(context).add(
                //                                                   GroupMemberAddEvent(token: widget.token??"",
                //                                                       chatId: widget.redirectchatid==""?widget.chatid.toString():widget.redirectchatid.toString(),
                //                                                       userId: "${state.registeresUsers[index].userCode}",
                //                                                       emailid: state
                //                                                           .registeresUsers[index]
                //                                                           .email ??
                //                                                           "",
                //                                                       fname: state
                //                                                           .registeresUsers[index]
                //                                                           .fname ??
                //                                                           "",
                //                                                       photo: state
                //                                                           .registeresUsers[index].userMete
                //                                                           ?.profile ??
                //                                                           "",
                //                                                       lname: state
                //                                                           .registeresUsers[index]
                //                                                           .lname ??
                //                                                           "",
                //                                                       ishistory: false
                //                                                   )
                //                                               );
                //                                               Navigator.pop(context);
                //                                             }, child: Container(
                //                                               width: w/3,
                //                                               height: 55,
                //                                               decoration: ShapeDecoration(
                //                                                 color: isSelect==false? Colors.transparent:Color(0xFF2871AF),
                //                                                 shape: RoundedRectangleBorder(
                //                                                   side: BorderSide(width: 1, color: Color(0xFF2871AF)),
                //                                                   borderRadius: BorderRadius.circular(4),
                //                                                 ),
                //                                               ),
                //                                               child: Center(
                //                                                 child: Text(
                //                                                   'Yes, Include',
                //                                                   style: TextStyle(
                //                                                     color:isSelect==false? Color(0xFF2871AF):Colors.white,
                //                                                     fontSize: 16,
                //                                                     fontFamily: 'Inter',
                //                                                     fontWeight: FontWeight.w500,
                //                                                     height: 0,
                //                                                   ),
                //                                                 ),
                //                                               ),
                //                                             ),
                //                                             ),
                //                                             SizedBox(width: 5,),
                //                                             GestureDetector(onTap: (){
                //                                               isSelect=false;
                //                                               setState(() {
                //                                                 BlocProvider.of<GroupBloc>(context).add(
                //                                                     GroupMemberAddEvent(token: widget.token??"",
                //                                                         chatId: widget.redirectchatid==""?widget.chatid.toString():widget.redirectchatid.toString(),
                //                                                         userId: "${state.registeresUsers[index].userCode}",
                //                                                         emailid: state
                //                                                             .registeresUsers[index]
                //                                                             .email ??
                //                                                             "",
                //                                                         fname: state
                //                                                             .registeresUsers[index]
                //                                                             .fname ??
                //                                                             "",
                //                                                         photo: state
                //                                                             .registeresUsers[index].userMete
                //                                                             ?.profile ??
                //                                                             "",
                //                                                         lname: state
                //                                                             .registeresUsers[index]
                //                                                             .lname ??
                //                                                             "",
                //                                                         ishistory: true
                //                                                     )
                //                                                 );
                //
                //                                                 Navigator.pop(context);
                //
                //
                //                                               });
                //
                //                                             }, child: Container(
                //                                               width: w/3,
                //                                               height: 55,
                //                                               decoration: ShapeDecoration(
                //                                                 color: isSelect==false? Color(0xFF2871AF):Colors.transparent,
                //                                                 shape: RoundedRectangleBorder(
                //                                                     side: BorderSide(width: 1, color: Color(0xFF2871AF)),
                //                                                     borderRadius: BorderRadius.circular(4)),
                //                                               ),
                //                                               child:  Center(
                //                                                 child: Text(
                //                                                   'Not include',
                //                                                   style: TextStyle(
                //                                                     color:isSelect==false? Colors.white:Color(0xFF2871AF),
                //                                                     fontSize: 16,
                //                                                     fontFamily: 'Inter',
                //                                                     fontWeight: FontWeight.w500,
                //                                                     height: 0,
                //                                                   ),
                //                                                 ),
                //                                               ),
                //                                             ),
                //
                //                                             )
                //                                           ],
                //                                         )
                //                                       ],
                //                                     ),
                //                                   );
                //                                 },
                //                                 );
                //
                //                                 //          BlocProvider.of<GroupBloc>(context).add(
                //                                 //           GroupMemberAddEvent(token: widget.token??"",
                //                                 //           chatId: widget.redirectchatid==""?widget.chatid.toString():widget.redirectchatid.toString(),
                //                                 //           userId: "${state.registeresUsers[index].userCode}",
                //                                 //           emailid: state
                //                                 //         .registeresUsers[index]
                //                                 //         .email ??
                //                                 //     "",
                //                                 // fname: state
                //                                 //         .registeresUsers[index]
                //                                 //         .fname ??
                //                                 //     "",
                //                                 // photo: state
                //                                 //         .registeresUsers[index].userMete
                //                                 //         ?.profile ??
                //                                 //     "",
                //                                 // lname: state
                //                                 //         .registeresUsers[index]
                //                                 //         .lname ??
                //                                 //     "",
                //                                 //           )
                //                                 //                                   );
                //
                //
                //
                //
                //
                //                                 //       widget.socket!.emit("userAddToGroup",{
                //                                 //         "userCode": "${state.registeresUsers[index].userCode}",
                //                                 //        "chatId": widget.redirectchatid==""?widget.chatid.toString():widget.redirectchatid.toString() });
                //
                //                                 //      print("hjkl");
                //                                 //      print("hjkluser1");
                //                                 //    widget.socket!.on("userAddedToGroup", (data) {
                //                                 //     print("hjkluser $data");
                //
                //                                 //      showSnackBar(context,
                //                                 //     message: "User Add To Group Successfully", color: ColorPalette.primary);
                //                                 //      widget.socket!.emit("group.message",{
                //                                 //       "type": "notify", "chatid": widget.redirectchatid==""?widget.chatid:widget.redirectchatid, "content": "${state.registeresUsers[index].fname.toString().toTitleCase()} ${state.registeresUsers[index].lname.toString().toTitleCase()} is added to group"
                //                                 //     });
                //                                 //      widget.socket!.emit("group.members",{widget.chat==false?widget.redirectchatid!=""?widget.redirectchatid: widget.communicationUserModel?.chatid:widget.communicationuser?.chatid,uid});
                //                                 //     widget.socket?.on("update.chat.list", (data) => print("fxgf  $data"));
                //
                //                                 //   }
                //
                //                                 // );
                //                                 //   widget.socket!.on("userAlreadyInGroup", (data) {
                //                                 //     print("hjkluser2 $data");
                //
                //                                 //     showSnackBar(context,
                //                                 //     message: "Already in Group", color: ColorPalette.primary);
                //                                 //     setState(() {
                //
                //                                 //     });
                //
                //                                 //   });
                //
                //                               },
                //                               child: EmployeeCard(employeeList: state.registeresUsers[index],isCommunicate:true,)
                //                             // Container(
                //                             //   padding:
                //                             //       const EdgeInsets.symmetric(
                //                             //           horizontal: 10),
                //                             //   child: Row(
                //                             //     mainAxisAlignment:
                //                             //         MainAxisAlignment
                //                             //             .spaceBetween,
                //                             //     children: [
                //                             //       Row(
                //                             //         children: [
                //                             //           const CircleAvatar(),
                //                             //           const SizedBox(
                //                             //             width: 10,
                //                             //           ),
                //                             //           Column(
                //                             //             mainAxisAlignment:
                //                             //                 MainAxisAlignment
                //                             //                     .start,
                //                             //             crossAxisAlignment:
                //                             //                 CrossAxisAlignment
                //                             //                     .start,
                //                             //             children: [
                //                             //               Text(
                //                             //                 state
                //                             //                         .registeresUsers[
                //                             //                             index]
                //                             //                         .name ??
                //                             //                     "",
                //                             //                 style: GoogleFonts
                //                             //                     .roboto(
                //                             //                   color: const Color(
                //                             //                       0xff151522),
                //                             //                   fontSize: 18,
                //                             //                   fontWeight:
                //                             //                       FontWeight
                //                             //                           .w500,
                //                             //                 ),
                //                             //               ),
                //                             //               Text(
                //                             //                 state
                //                             //                         .registeresUsers[
                //                             //                             index]
                //                             //                         .mail ??
                //                             //                     "",
                //                             //                 style:
                //                             //                     const TextStyle(
                //                             //                   color: Color(
                //                             //                       0xff6d6d6d),
                //                             //                   fontSize: 14,
                //                             //                 ),
                //                             //               )
                //                             //             ],
                //                             //           )
                //                             //         ],
                //                             //       ),
                //                             //       index < 0
                //                             //           ? Container(
                //                             //               width: 28,
                //                             //               height: 28,
                //                             //               decoration:
                //                             //                   BoxDecoration(
                //                             //                 borderRadius:
                //                             //                     BorderRadius
                //                             //                         .circular(
                //                             //                             30),
                //                             //                 color: const Color(
                //                             //                     0xfffe5762),
                //                             //               ),
                //                             //               child: Center(
                //                             //                 child: Text(
                //                             //                   "15",
                //                             //                   style: GoogleFonts
                //                             //                       .outfit(
                //                             //                     color: Colors
                //                             //                         .white,
                //                             //                     fontSize: 14,
                //                             //                     fontWeight:
                //                             //                         FontWeight
                //                             //                             .w600,
                //                             //                   ),
                //                             //                 ),
                //                             //               ),
                //                             //             )
                //                             //           : Container()
                //                             //     ],
                //                             //   ),
                //                             // ),
                //                           ),
                //                           separatorBuilder: (context, index) =>
                //                           const SizedBox(
                //                             height:5,
                //                           ),
                //                           itemCount: state.registeresUsers.length),
                //                       SizedBox(
                //                         height: 50,
                //                       )
                //                     ],
                //                   );
                //                 } else if (state is GetAllRegisteredUsersFailed) {}
                //                 return Container();
                //               },
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      );
  }



}