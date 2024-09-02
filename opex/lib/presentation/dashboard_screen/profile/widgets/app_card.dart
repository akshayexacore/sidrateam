import 'package:cluster/core/utils/platform_check.dart';
import 'package:cluster/presentation/dashboard_screen/home_screen/homescreen_widget/apps_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AppHomeCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String? svgIcon;
  final String? appTitle;
  final String? appDescription;
  final Color? clr;
  const AppHomeCard(
      {super.key,
      this.onTap,
      this.svgIcon,
      this.clr,
      this.appTitle,
      this.appDescription});

  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width ;
    double w = w1> 700
        ? 400
        : w1;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: w1*.01,vertical: 5),
        color: clr??Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.string(svgIcon ?? "",
            height: w*.11,width:  w1*.11,),
            SizedBox(
              width:isMobile? w*.05:w1*.01,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appTitle ?? "",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize:isMobile? w/24:w1*.011,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  width: isMobile?w/1.45 :w1/6.8,
                  // color: Colors.red,
                  child: Text(
                    appDescription ?? "",
                    style: GoogleFonts.roboto(
                        color: Color(0xFF555555),
                        fontSize: isMobile?w/28:w1*.0087,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
