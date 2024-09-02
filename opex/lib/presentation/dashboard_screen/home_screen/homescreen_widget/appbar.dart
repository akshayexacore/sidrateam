import 'package:cluster/core/color_palatte.dart';
import 'package:cluster/core/common_snackBar.dart';
import 'package:cluster/core/utils/platform_check.dart';
import 'package:cluster/core/utils/variables.dart';
import 'package:cluster/presentation/authentication/bloc/bloc/auth_bloc.dart';
import 'package:cluster/presentation/base/login_page.dart';
import 'package:cluster/presentation/base/splash.dart';
import 'package:cluster/presentation/comunication_module/chat-profile_screengrp.dart';
import 'package:cluster/presentation/task_operation/badge_icon.dart';
import 'package:cluster/presentation/task_operation/create/task_bloc/task_bloc.dart';
import 'package:cluster/presentation/task_operation/employee_bloc/employee_bloc.dart';
import 'package:cluster/presentation/task_operation/notification_sidra_teams.dart';
import 'package:cluster/presentation/task_operation/task_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../authentication/authentication.dart';
import '../../../task_operation/create/create_job.dart';
import '../../../task_operation/create/model/task_models.dart';
import '../../../task_operation/create_group.dart';
import '../../profile/profile_bloc/profile_bloc.dart';
import '../home_svg.dart';

class AppBarScreen extends StatefulWidget {
  var scaffoldKey;
  final String label;
  final VoidCallback ontap;
  AppBarScreen({Key? key, this.scaffoldKey, required this.label, required this.ontap}) : super(key: key);

  @override
  State<AppBarScreen> createState() => _AppBarState();
}

class _AppBarState extends State<AppBarScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(const GetNotificationListEvent("", "", ""));
    if(isMobile) context.read<ProfileBloc>().add(const GetProfilePicEvent());
    // Transparent status bar
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.white,
    // ));
  }
  List<NotificationList>? notification=[];
  int countNoti=0;
  String fcm='';

  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width ;
    double w = w1> 700
        ? 400
        : w1;
    return MultiBlocListener(
      listeners:[
        BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
    if (state is SwitchUserAuthGetSuccess) {
    Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
    builder: (context) => SplashScreen()),
    (Route<dynamic> route) => false);

    Fluttertoast.showToast(
    msg: 'Account Switched Successfully',
    backgroundColor: Colors.white,
    textColor: Colors.black);
    } else if (state is SwitchUserAuthGetFailed) {
    showSnackBar(context,
    message: state.error ?? "", color: Colors.red);
    }
    },),
        BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {

      if(state is GetNotificationListSuccess){
        notification=state.notificationList;
        // countNoti=notification?[0].count??0;
        print("SDFG${notification?.length}");
        setState(() {

        });
      }
      // TODO: implement listener
      },),
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileSuccess) {
              Variable.profilePic = state.user.userMete?.profile ?? '';

              setState(() {});
            }
          },
        ),
      ],
      child: Column(
        children: [
          AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.white, // Navigation bar
              statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark,statusBarBrightness: Brightness.light// Status bar
            ),
            elevation: 0,
            backgroundColor:    Color(0xff0F2F5),
            surfaceTintColor: Colors.white,
            leading: Container(
              padding: const EdgeInsets.only(left: 16),
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  widget.scaffoldKey.currentState.openDrawer();

                },
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.transparent,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 5,
                        child:
                     CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(Variable.profilePic),
                            ),

                      ),
                      // Positioned(
                      //     bottom: 0,
                      //     right: 0,
                      //     child: Container(
                      //         width: 24,
                      //         height: 24,
                      //         padding: const EdgeInsets.all(8),
                      //         decoration: const BoxDecoration(
                      //           shape: BoxShape.circle,
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: Color(0x3f000000),
                      //               blurRadius: 1,
                      //               offset: Offset(0, 0),
                      //             ),
                      //           ],
                      //           color: Color(0xfff9f9f9),
                      //         ),
                      //         child: SvgPicture.string(HomeSvg().drawerIcon)))
                    ],
                  ),
                ),
              ),
            ),
            titleSpacing: 10,
            centerTitle: false,

            title: Row(
              children: [
                Text(
                  widget.label??"Sidra Teams",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: w / 22,
                    fontWeight: FontWeight.w500,
                  ),

                ),
                SizedBox(width: w*.01,),
                GestureDetector(onTap: (){
                  widget.ontap();





                }, child: Icon(Icons.keyboard_arrow_down_outlined,size:w*.07,))
              ],
            ),
            actions: [
              Center(
                child: GestureDetector(
                  onTap: (){
                    context.read<TaskBloc>().add(const NotificationIconEvent());
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen:  NotificationInSidraTeams(notification: notification??[]),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                    );
                  },
                  child:SizedBox(
                    // color: Colors.yellow,
                    width: 25,
                    child: BadgeIcon(
                      badgeCount:countNoti??0,
                      // int.tryParse(snapshot.data.toString()) ?? 0,
                      icon: SvgPicture.string(
                        HomeSvg().notificationHomeIcon,
                        // color: Colors.black,
                        // width: 17,
                      ),
                    ),
                  ),
                  // BadgeIcon(
                  //   child: SvgPicture.string(
                  //     HomeSvg().notificationHomeIcon,
                  //     height: 22,
                  //     width: 22,
                  //   ),
                  // ),
                ),
              ),
               SizedBox(
                width:authentication.isAdmin? 30:0,
              ),
              // authentication.isAdmin
              //     ? GestureDetector(
              //         onTap: () {
              //           _showModalBottomSheet();
              //         },
              //         child: SvgPicture.string(
              //
              //           HomeSvg().addIcon,
              //           height: 19,
              //           width: 19,color: ColorPalette.primary,
              //         ))
              //     : Container(),
              const SizedBox(
                width: 16,
              )
            ],
          ),
          // Container(
          //   // color: Colors.green,
          //   padding: const EdgeInsets.only(right: 16,left: 16,bottom: 8),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Row(
          //         children: [
          //
          //           const SizedBox(
          //             width: 16,
          //           ),
          //
          //         ],
          //       ),
          //       Row(
          //         children: [
          //
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            width: w1,
            height: .01,
            decoration: BoxDecoration(
              color:Color(0xff0F2F5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: Offset(0, 4), // Adjust the vertical offset to control shadow position
                ),
              ],
              // border: Border.all(
              //   color: const Color(0xb2e6e6e6),
              //   width: 0.50,
              // ),
            ),
          ),
        ],
      ),
    );
  }

  _showModalBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18)),
        ),
        context: context,
        useRootNavigator: true,
        builder: (context) {
          var h = MediaQuery.of(context).size.height;
          var w = MediaQuery.of(context).size.width;
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                // height: 350,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    )),
                // alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "Create ",
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 20,),
                      const Divider(
                        thickness: 1,
                        color: Color(0xfff8f7f5),
                      ),
                      SizedBox(height: 5,),
                      GestureDetector(
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: const CreateJob(),
                            withNavBar: true,
                            // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation:
                                PageTransitionAnimation.fade,
                          );
                        },
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 16),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:  ColorPalette.black,
                                ),
                                child: SvgPicture.string(HomeSvg().jobIcon,
                                  height: 15,width: 15,),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: w / 1.5,
                                child: Text(
                                  "New Job",
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: w/24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      const Divider(
                        indent: 70,
                        color: Color(0xffE6ECF0),
                      ),
                      SizedBox(height: 5,),
                      InkWell(
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen:  CreateGroup(),
                            withNavBar: false,
                            // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation:
                            PageTransitionAnimation.fade,
                          );
                        },
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 16),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:  ColorPalette.black,
                                ),
                                child: SvgPicture.string(HomeSvg().groupIcon,
                                height: 12,width: 12,),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: w / 1.5,
                                child: Text(
                                  "New Group",
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: w/24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 50,)
                      // Row(
                      //   children: [
                      //     Container(
                      //       margin: const EdgeInsets.only(left: 16),
                      //       padding: const EdgeInsets.all(10),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10),
                      //         color: const Color(0xfffd5762),
                      //       ),
                      //       child: SvgPicture.string(HomeSvg().imgFeedIcon),
                      //     ),
                      //     const SizedBox(
                      //       width: 10,
                      //     ),
                      //     Text(
                      //       "Video / Image Feed ",
                      //       style: GoogleFonts.roboto(
                      //         color: Colors.black,
                      //         fontSize: 18,
                      //         fontWeight: FontWeight.w500,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const Divider(
                      //   indent: 70,
                      //   color: Color(0xffE6ECF0),
                      // ),
                      // Row(
                      //   children: [
                      //     Container(
                      //       margin: const EdgeInsets.only(left: 16),
                      //       padding: const EdgeInsets.all(10),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10),
                      //         color: const Color(0xfffd5762),
                      //       ),
                      //       child: SvgPicture.string(HomeSvg().analyticIcon),
                      //     ),
                      //     const SizedBox(
                      //       width: 10,
                      //     ),
                      //     Text(
                      //       "Updation / Analytics",
                      //       style: GoogleFonts.roboto(
                      //         color: Colors.black,
                      //         fontSize: 18,
                      //         fontWeight: FontWeight.w500,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const Divider(
                      //   indent: 70,
                      //   color: Color(0xffE6ECF0),
                      // ),
                      // Row(
                      //   children: [
                      //     Container(
                      //       margin: const EdgeInsets.only(left: 16),
                      //       padding: const EdgeInsets.all(10),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10),
                      //         color: const Color(0xfffd5762),
                      //       ),
                      //       child: SvgPicture.string(HomeSvg().chatGroupIcon),
                      //     ),
                      //     const SizedBox(
                      //       width: 10,
                      //     ),
                      //     Text(
                      //       "Chat or Group",
                      //       style: GoogleFonts.roboto(
                      //         color: Colors.black,
                      //         fontSize: 18,
                      //         fontWeight: FontWeight.w500,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 50,
                      // )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}

class BackAppBar extends StatefulWidget {
  String label;
  final VoidCallback? onTap;
  bool isAction, isBack,isLeading;
  Widget? action;

  BackAppBar(
      {Key? key,
      required this.label,
      this.isAction = true,
      this.action,
        this.isLeading=true,
      this.isBack = true,
      this.onTap})
      : super(key: key);

  @override
  State<BackAppBar> createState() => _BackAppBarState();
}

class _BackAppBarState extends State<BackAppBar> {
  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width ;
    double w = w1> 700
        ? 400
        : w1;
    return Container(

      child: Column(
        children: [
          AppBar( automaticallyImplyLeading: widget.isLeading,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0),
              ),
            ),


            systemOverlayStyle: const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.white, // Navigation bar
              statusBarColor: Colors.white, // Status bar
            ),
            elevation: 0,
            backgroundColor: Color(0xffF0F2F5),
            centerTitle: false,

            title: Container(
              padding:widget.isLeading!=true? EdgeInsets.only(left: 12):null,
              child: Text(
                widget.label,
                style:  TextStyle(color: Colors.black,fontSize: w/22),
              ),
            ),
            titleSpacing: 0,
            leading:widget.isLeading? GestureDetector(
                onTap: widget.isBack
                    ? () {
                        widget.isBack ? Navigator.pop(context) : print("hello");
                      }
                    : widget.onTap,
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )):null,
            actions: [
              widget.isLeading==false? GestureDetector(
                  onTap: widget.isBack
                      ? () {
                    widget.isBack ? Navigator.pop(context) : print("hello");
                  }
                      : widget.onTap,
                  child:  Icon(
                    Icons.close,
                    color: Colors.black.withOpacity(.5),
                  )):Container(),
              widget.isAction
                  ? SvgPicture.string(
                      HomeSvg().msgIcon,
                      height: 25,
                      width: 25,
                    )
                  : Container(),
              widget.isAction
                  ? const SizedBox(
                      width: 30,
                    )
                  : Container(),
              widget.isAction
                  ? GestureDetector(
                      onTap: () {
                        // _showModalBottomSheet();
                      },
                      child: SvgPicture.string(
                        HomeSvg().addIcon,
                        height: 19,
                        width: 19,
                      ))
                  : widget.action ?? Container(),

              // SvgPicture.string(HomeSvg().msgIcon),
              //         const SizedBox(
              //           width: 16,
              //         ),
              //         GestureDetector(
              //           onTap: widget.onTap,
              //             child: SvgPicture.string(HomeSvg().addIcon)),

              const SizedBox(
                width: 16,
              )
            ],
          ),
          Container(
            width: w1,
            height: 1.50,
            decoration: const BoxDecoration(
              color: Color(0xb2e6e6e6),
            ),
          ),
        ],
      ),
    );
  }
}
