import 'package:cluster/core/utils/platform_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../common_widgets/dialogur_box.dart';
import '../../profile/help_screen.dart';
import '../home_svg.dart';

class SearchBarDashboard extends StatelessWidget {
  const SearchBarDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width ;
    double w = w1> 700
        ? 400
        : w1;
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.only(left: 18, right: 18),
      width:isMobile? w:w,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(49),
        border: Border.all(
          color: Color(0x11000000),
          width: 0.30,
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Color(0x14000000).withOpacity(0.08),
        //     blurRadius: 30,
        //     offset: Offset(1, 1),
        //   ),
        // ],
        color: Color(0xffF7F7F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: w / 2.6,

            child: TextFormField(
              onTap: (){
                showDailogPopUp(
                    context,
                    //     AdminCreationUser()
                    HelpScreen(autoFocus: false));
                // PersistentNavBarNavigator.pushNewScreen(
                //   context,
                //   screen: HelpScreen(autoFocus: true),
                //   withNavBar: false,
                //   // OPTIONAL VALUE. True by default.
                //   pageTransitionAnimation: PageTransitionAnimation.slideUp,
                // );
              },
              cursorColor: Colors.black,readOnly: true,
              decoration: InputDecoration(
                hintText: "Search..",
                hintStyle: GoogleFonts.roboto(
                  color: Color(0xffbdbdbd),
                  fontSize:isMobile? w / 28:w/24,
                  fontWeight: FontWeight.w400,
                ),

                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 1,
                height: 30,
                color: Color(0xffE7E7E7),
              ),
              SizedBox(
                width: 13,
              ),
              SvgPicture.string(
                HomeSvg().searchIcon,
                color: Color(0xff222222),
                height: 17,
                width: 17,
              ),
              SizedBox(
                width: 2,
              )
            ],
          ),
        ],
      ),
    );
  }
}
