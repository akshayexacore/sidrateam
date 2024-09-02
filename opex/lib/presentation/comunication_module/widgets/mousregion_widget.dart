import 'package:flutter/cupertino.dart';

class CustomMouseRegion extends StatelessWidget {
  final Widget child;
  final Function onEnter;
  final Function onExist;
  const CustomMouseRegion({super.key, required this.child, required this.onEnter, required this.onExist});

  @override
  Widget build(BuildContext context) {
    return  MouseRegion(
onEnter: (event){onEnter();},
      onExit: (event){onExist();},
      child: child,
    );
  }
}
