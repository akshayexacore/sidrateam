import 'package:cluster/presentation/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../common_widgets/dialogur_box.dart';
import '../../common_widgets/no_glow.dart';
import '../../core/color_palatte.dart';
import '../dashboard_screen/home_screen/homescreen_widget/appbar.dart';
import 'create/create_svg.dart';
import 'create_group.dart';
import 'groups_card.dart';
import 'home/bloc/job_bloc.dart';
import 'lottieLoader.dart';

class ProfileGroupList extends StatefulWidget {
  const ProfileGroupList({super.key});

  @override
  State<ProfileGroupList> createState() => _ProfileGroupListState();
}

class _ProfileGroupListState extends State<ProfileGroupList> {
  @override
  void initState() {
    context.read<JobBloc>().add(GetGroupListEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    double w1 = MediaQuery.of(context).size.width;
    double w = w1 > 700 ? 400 : w1;
    return AlertDialog(

      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      content: Container(
        // padding: EdgeInsets.all(10),
        width: w1/2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
          // Add border to see if it's being applied

        ),
        child: Column(
          children: [
            BackAppBar(
              label:"Groups",
              isAction: false,
              action: authentication.isAssociateAdmin?Container():Padding(
                padding: const EdgeInsets.only(top: 0,left: 16),
                child:
                InkWell(
                  onTap: (){
                    showDailogPopUp(
                        context,
                        //     AdminCreationUser()
                        CreateGroup());
                    // PersistentNavBarNavigator.pushNewScreen(
                    //   context,
                    //   screen: CreateGroup(),
                    //   withNavBar: true,
                    //   // OPTIONAL VALUE. True by default.
                    //   pageTransitionAnimation: PageTransitionAnimation.fade,
                    // );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.group,color: ColorPalette.primary,
                        size: 20,),
                      SizedBox(width: 2,),
                      Text(
                        "Create",
                        style: GoogleFonts.roboto(
                          color: Color(0xFF2871AF),
                          fontSize: w/24,
                          fontWeight: FontWeight.w500,
                          // height: 1.56,
                        ),
                      ),
                    ],
                  ),
                ),
              ),),
            SizedBox(
              height: MediaQuery.of(context).size.height/1.2,
              child: ScrollConfiguration(
                behavior: NoGlow(),
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        BlocBuilder<JobBloc, JobState>(
                          builder: (context, state) {
                            if (state is GetGroupListLoading) {
                              return LottieLoader();
                            }
                            if (state is GetGroupListSuccess) {
                              return state.groupList.isEmpty?
                              Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: 25,),
                                    SvgPicture.string(CreateSvg().groupEmpty,height: 250,width: 250,),
                                  ],
                                ),
                              ):Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${state.groupList.length} Groups",
                                    style: GoogleFonts.roboto(
                                      color: Color(0xff151522),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    //color: Colors.yellow,
                                    padding: const EdgeInsets.only(
                                      bottom: 20,
                                    ),
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        separatorBuilder: (BuildContext cxt, int i) {
                                          return const SizedBox(
                                            height: 5,
                                          );
                                        },
                                        itemBuilder: (BuildContext context, int i) {
                                          return InkWell(
                                            onTap: () {

                                              print("tapped grou");
                                            },
                                            child: GroupCard(groupList:state.groupList[i] ),
                                          );
                                        },
                                        itemCount: state.groupList.length),
                                  ),
                                ],
                              );
                            }
                            return Container();
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Scaffold(
            //   backgroundColor: Colors.white,
            //   appBar: PreferredSize(
            //     preferredSize: Size.fromHeight(60),
            //     child:
            //     BackAppBar(
            //       label:"Groups",
            //       isAction: false,
            //       action: authentication.isAssociateAdmin?Container():Padding(
            //         padding: const EdgeInsets.only(top: 0,left: 16),
            //         child:
            //         InkWell(
            //           onTap: (){
            //             PersistentNavBarNavigator.pushNewScreen(
            //               context,
            //               screen: CreateGroup(),
            //               withNavBar: true,
            //               // OPTIONAL VALUE. True by default.
            //               pageTransitionAnimation: PageTransitionAnimation.fade,
            //             );
            //           },
            //           child: Row(
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               Icon(Icons.group,color: ColorPalette.primary,
            //                 size: 20,),
            //               SizedBox(width: 2,),
            //               Text(
            //                 "Create",
            //                 style: GoogleFonts.roboto(
            //                   color: Color(0xFF2871AF),
            //                   fontSize: w/24,
            //                   fontWeight: FontWeight.w500,
            //                   // height: 1.56,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),),
            //   ),
            //   body:
            //   ScrollConfiguration(
            //     behavior: NoGlow(),
            //     child: SingleChildScrollView(
            //       child: Container(
            //         padding: EdgeInsets.all(16),
            //         child: Column(
            //           children: [
            //             BlocBuilder<JobBloc, JobState>(
            //               builder: (context, state) {
            //                 if (state is GetGroupListLoading) {
            //                   return LottieLoader();
            //                 }
            //                 if (state is GetGroupListSuccess) {
            //                   return state.groupList.isEmpty?
            //                   Center(
            //                     child: Column(
            //                       children: [
            //                         SizedBox(height: 25,),
            //                         SvgPicture.string(CreateSvg().groupEmpty,height: 250,width: 250,),
            //                       ],
            //                     ),
            //                   ):Column(
            //                     mainAxisAlignment: MainAxisAlignment.start,
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       Text(
            //                         "${state.groupList.length} Groups",
            //                         style: GoogleFonts.roboto(
            //                           color: Color(0xff151522),
            //                           fontSize: 18,
            //                           fontWeight: FontWeight.w500,
            //                         ),
            //                       ),
            //                       SizedBox(height: 10,),
            //                       Container(
            //                         //color: Colors.yellow,
            //                         padding: const EdgeInsets.only(
            //                           bottom: 20,
            //                         ),
            //                         child: ListView.separated(
            //                             shrinkWrap: true,
            //                             physics: const ScrollPhysics(),
            //                             separatorBuilder: (BuildContext cxt, int i) {
            //                               return const SizedBox(
            //                                 height: 5,
            //                               );
            //                             },
            //                             itemBuilder: (BuildContext context, int i) {
            //                               return InkWell(
            //                                 onTap: () {
            //
            //                                   print("tapped grou");
            //                                 },
            //                                 child: GroupCard(groupList:state.groupList[i] ),
            //                               );
            //                             },
            //                             itemCount: state.groupList.length),
            //                       ),
            //                     ],
            //                   );
            //                 }
            //                 return Container();
            //               },
            //             )
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
