import 'package:cluster/core/common_snackBar.dart';
import 'package:cluster/core/utils/platform_check.dart';
import 'package:cluster/firebase_options.dart';
import 'package:cluster/presentation/authentication/authentication.dart';
import 'package:cluster/presentation/base/onboarding.dart';
import 'package:cluster/presentation/comunication_module/dummy_design_forTesting/bloc/dummy_login_bloc.dart';
import 'package:cluster/presentation/comunication_module/scoketconnection.dart';
import 'package:cluster/presentation/task_operation/task_title.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../task_operation/employee_bloc/employee_bloc.dart';
import 'dashboard.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {

SharedPreferences? pref;
String token="";
  data() async {

    // await Firebase.initializeApp(name: "webteamcom",options: DefaultFirebaseOptions.currentPlatform);
    print("log data");
    final _firebaseMessaging=FirebaseMessaging.instance;
    await _firebaseMessaging.requestPermission( alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    final fcmToken=await _firebaseMessaging.getToken(vapidKey:  "BFPsZ_p4MERknOu2s1KUw_2RDHS95Q7mlX3E_l8WtXfzOjJXzoOyOYnkoevdf9V0FAoVj7ha8IiI5rgzjgTbGqU");
    print("FCM TOKEN.....$fcmToken");
    SharedPreferences pre = await SharedPreferences.getInstance();
    // pre.setString("fcm", fcmToken.toString());

    // context.read<EmployeeBloc>().add( FcmTokenRegisterEvent(fcmToken.toString()??""));
    print("after fcm");

  }
  @override
  void initState() {
    data();
    super.initState();
    Timer(
        const Duration(seconds: 2),
        () {
          print("init timer${authentication.isAuthenticated}");
          authentication.isAuthenticated
              ?
          context.read<DummyLoginBloc>()
              .add(TokenCreationCommunicationEvent()):
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                  // HomePage()
                  const OnBoarding())
          );
        }
    );

  }
  void socketconnnect() async {
    final socketProvider = context.read<scoketProvider>();

    final socketgrpProvider = context.read<scoketgrpProvider>();

    pref = await SharedPreferences.getInstance();

    token = pref!.getString("token")!;


    print("socket token $token");

    setState(() {});

    socketProvider.connect(token.toString());

    socketgrpProvider.connect(token.toString());
  }
  // void socketconnnect() async {
  //   final socketProvider = context.read<scoketProvider>();

  //   final socketgrpProvider = context.read<scoketgrpProvider>();

  //   pref = await SharedPreferences.getInstance();

  //   token = pref!.getString("token")!;

  //   print("socket token $token");

  //   setState(() {});

  //   socketProvider.connect(token.toString());

  //   socketgrpProvider.connect(token.toString());
  // }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.width;
    debugPrint("${authentication.authenticatedUser.token}customer_CODE");
    return
    BlocListener<DummyLoginBloc, DummyLoginState>(
    listener: (context, state) async {

    if (state is TokenCreationCommunicationSuccess) {
    final socketProvider = context.read<scoketProvider>();

    final socketgrpProvider = context.read<scoketgrpProvider>();
    pref = await SharedPreferences.getInstance();

    await pref!.setString("token", state.token);


    print("socket token ${state.token}");
    socketProvider.connect(state.token.toString());

    socketgrpProvider.connect(state.token.toString());
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(
    builder: (context) =>
    // HomePage()
    // authentication.isAuthenticated
    //     ?
    const DashBoard()
    // : const OnBoarding()
    )
    );

    setState(() {});
    } else if (state is TokenCreationCommunicationFailed) {
    showSnackBar(context,
    message: "Token creation failed",
    color: Colors.red,
    // icon: HomeSvg().SnackbarIcon,
    autoDismiss: true);
    setState(() {});
    }
    },

  child: Scaffold(
      backgroundColor:isMobile? Colors.white:Colors.grey,
      body:isMobile? Center(
        child: PageView(children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: h / 2,
                  alignment: Alignment.center,
                  child: Lottie.asset('asset/Logo.json'),
                  // Image.asset('asset/Logo'),
                  //child: SvgPicture.string(IconConstants().SplashIcon),
                )
              ]),
        ]),
      ):Container(color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/4.5),
      child: Center(child:  PageView(children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: h / 4,
                alignment: Alignment.center,
                child: Lottie.asset('asset/Logo.json'),
                // Image.asset('asset/Logo'),
                //child: SvgPicture.string(IconConstants().SplashIcon),
              )
            ]),
      ]),),),
    ),
);
  }

}