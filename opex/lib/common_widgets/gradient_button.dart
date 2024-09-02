// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:cluster/common_widgets/switch.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {

  final Widget child;
  final VoidCallback? onPressed;
  final Gradient gradient;
  final Color color;
  final double? border;

  const GradientButton({
    required this.onPressed,
    required this.child,
    required this.gradient,required this.color, this.border=4 });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      splashColor: Colors.black12,
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(38.0),
      ),
      child: Ink(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: gradient,
          border: Border.all(
            color: color
          ),
          borderRadius: BorderRadius.circular(border??4),
        ),
        child:
        Container(
            constraints: BoxConstraints(
                maxWidth: 200.0,
                minHeight: 40.0),
            alignment: Alignment.center,
            child: child
        ),
      ),
    );
  }
}


class AdminTableDotIcon extends StatefulWidget {
  final Function onTap;
  final Function? mouseHoverFunc;
  final Color? clr;
  final Color? iconClr;
  final IconData? icons;
  final double? iconSize;
  final double?  height;
  final List<customPopupmenuButton>valueList;
  AdminTableDotIcon({required this.onTap, required this.valueList, this.mouseHoverFunc, this.clr, this.icons, this.iconSize, this.iconClr, this.height});





  @override
  State<AdminTableDotIcon> createState() => _AdminTableDotIconState();
}

class _AdminTableDotIconState extends State<AdminTableDotIcon> {
  bool isHover=false;


  @override
  Widget build(BuildContext context) {
    return     PopupMenuButton(
      color:   Colors.white,
      offset: Offset(0,5),
      position: PopupMenuPosition.under,
      onCanceled : (){

      },
      onSelected: (val){
        print("aaaaaaaaaaaaaa");
        widget.onTap(val);
      },

      itemBuilder: (context) {
        final List<PopupMenuEntry<String>> popupItems = widget.valueList!.map((customPopupmenuButton item) {
          return PopupMenuItem<String>(
            padding: EdgeInsets.zero,
            value: item.value,
            child:Container(child: Center(  child: Text(item.label,style: TextStyle(color: Colors.black,),)),),
          );

        }).toList();

        return
          popupItems;

      },

      icon: Center(child: Icon(widget.icons??Icons.more_horiz,size:widget.iconSize??25,color: isHover?Colors.grey:widget.iconClr??Colors.grey.withOpacity(.6)),),
    );
  }
}