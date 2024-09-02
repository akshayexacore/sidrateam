import 'package:flutter/material.dart';

class InsightCard extends StatelessWidget {
  final EdgeInsets padding;
  Widget ?child;
   InsightCard({Key? key,this.padding= const EdgeInsets.all(16),this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w=MediaQuery.of(context).size.width;
    return Container(
      width: w,
     padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xffe6ecf0), width: 1, ),
        boxShadow: [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(1, 1),
          ),
        ],
        color: Colors.white,
      ),
      child: child,
    );
  }
}
