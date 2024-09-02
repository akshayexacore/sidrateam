import 'package:cluster/presentation/authentication/authentication.dart';
import 'package:cluster/presentation/authentication/bloc/bloc/auth_bloc.dart';
import 'package:cluster/presentation/base/dashboard.dart';
import 'package:cluster/presentation/base/splash.dart';

import 'package:cluster/presentation/comunication_module/scoketconnection.dart';
import 'package:cluster/presentation/dashboard_screen/profile/profile_bloc/profile_bloc.dart';

import 'package:cluster/presentation/order_app/bloc/order_status_bloc/order_status_bloc.dart';
import 'package:cluster/presentation/seller_admin_app/seller_admin_bloc/seller_admin_bloc.dart';

import 'package:cluster/presentation/task_operation/create/task_bloc/task_bloc.dart';
import 'package:cluster/presentation/task_operation/employee_bloc/employee_bloc.dart';
import 'package:cluster/presentation/task_operation/home/bloc/job_bloc.dart';
import 'package:cluster/presentation/task_operation/organisation_pages/organisation_bloc_task/organisation_task_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'presentation/comunication_module/bloc/attachment_bloc.dart';
import 'presentation/comunication_module/bloc/chat_bloc.dart';
import 'presentation/comunication_module/bloc/communication_bloc.dart';
import 'presentation/comunication_module/bloc/paginatedchat_bloc.dart';
import 'presentation/comunication_module/dummy_design_forTesting/bloc/dummy_login_bloc.dart';
import 'presentation/comunication_module/group_bloc/bloc/group_bloc.dart';
import 'presentation/order_app/bloc/order_bloc/order_list_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  lifecycleEventHandler.init();

  // Set preferred orientations before running the app
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize authentication
  try {
    await authentication.init();
  } catch (e) {
    print('Error initializing authentication: $e');
    // Handle error appropriately
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firebase
  // try {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.web
  //
  //   );
  // } catch (e) {
  //   print('Error initializing Firebase: $e');
  //   // Handle error appropriately
  // }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // FlutterTts ftts = FlutterTts();
  void createChannel(AndroidNotificationChannel channel) async {
    final FlutterLocalNotificationsPlugin plugin =
        FlutterLocalNotificationsPlugin();
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    print("daaaaaaaaaaaaaaaaatttttttttttta");
    // if (notification != null && android != null && !kIsWeb) {
    //   // flutterLocalNotificationsPlugin.show(
    //   //   notification.hashCode,
    //   //   notification.title,
    //   //   notification.body,
    //   //   NotificationDetails(
    //   //     android: AndroidNotificationDetails(
    //   //       channel.id,
    //   //       channel.name,
    //   //       channelDescription: channel.description,
    //   //       // TODO add a proper drawable resource to android, for now using
    //   //       //      one that already exists in example app.
    //   //       icon: 'launch_background',
    //   //     ),
    //   //   ),
    //   // );
    // }
  }

  @override
  void initState() {
    // FirebaseMessaging.o.listen(showFlutterNotification);
    // data();
    // print("login init");
    // final FlutterLocalNotificationsPlugin flutterlocalnotificationplugins =
    // FlutterLocalNotificationsPlugin();
    // const AndroidInitializationSettings androidinitializationsettings =
    // AndroidInitializationSettings('@mipmap/ic_launcher');
    // const DarwinInitializationSettings darwinInitializationSettings =
    // DarwinInitializationSettings();
    // const InitializationSettings initializationSettings =
    // InitializationSettings(
    //     android: androidinitializationsettings,
    //     iOS: darwinInitializationSettings);
    // const AndroidNotificationChannel channel = AndroidNotificationChannel(
    //     'messages', 'Messages',
    //     description: "This is for flutter firebase",
    //     importance: Importance.max);
    // createChannel(channel);
    // flutterlocalnotificationplugins.initialize(initializationSettings);
    // FirebaseMessaging.onMessage.listen((event) async {
    //
    //   // await ftts.setLanguage("en-US");
    //   // await ftts.setSpeechRate(0.5);
    //   // await ftts.setVolume(1.0);
    //   // await ftts.setPitch(1);
    //   //
    //   // //play text to sp
    //   // var result = await ftts.speak(
    //   // "${event.notification?.title ?? ""} ${event.notification?.body}");
    //   // if (result == 1) {
    //   //
    //   // //speaking
    //   // } else {
    //   // //not speaking
    //   // }
    //   final notification = event.notification;
    //   final android = event.notification?.android;
    //   final data = event.data;
    //   if (notification != null && android != null) {
    //     flutterlocalnotificationplugins.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //             android: AndroidNotificationDetails(channel.id, channel.name,
    //                 channelDescription: channel.description,
    //                 icon: android.smallIcon)));
    //   }
    //
    // });
    //

    // // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // //   // Handle the incoming message when the app is in the foreground
    // //   print("onMessage: ${message}");
    // //   // _handleNotification(message.data);
    // // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("..........${authentication.authenticatedUser.token}");
    return StreamProvider<InternetConnectionStatus>(
        initialData: InternetConnectionStatus.connected,
        create: (_) {
          return InternetConnectionChecker().onStatusChange;
        },
        child: FlutterSizer(builder: (context, orientation, screenType) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: ((context) => scoketProvider())),
              ChangeNotifierProvider(
                  create: ((context) => scoketgrpProvider())),
              BlocProvider(
                create: (context) => JobBloc(),
              ),
              BlocProvider(
                create: (context) => TaskBloc(),
              ),
              BlocProvider(
                create: (context) => EmployeeBloc(),
              ),
              BlocProvider(
                create: (context) => OrderListBloc(),
              ),
              BlocProvider(
                create: (context) => OrderStatusBloc(),
              ),
              BlocProvider(
                create: (context) => AuthBloc(),
              ),
              BlocProvider(
                create: (context) => DummyLoginBloc(),
              ),
              BlocProvider(
                create: (context) => CommunicationBloc(),
              ),
              BlocProvider(
                create: (context) => SellerAdminBloc(),
              ),
              BlocProvider(
                create: (context) => ChatBloc(),
              ),
              BlocProvider(
                create: (context) => PaginatedchatBloc(),
              ),
              BlocProvider(
                create: (context) => GroupBloc(),
              ),
              BlocProvider(
                create: (context) => AttachmentBloc(),
              ),
              BlocProvider(
                create: (context) => ProfileBloc(),
              ),
              BlocProvider(
                create: (context) => OrganisationTaskBloc(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Sidrateams',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                // textSelectionTheme: TextSelectionThemeData(
                //   cursorColor: Colors.green, // Text cursor color
                //   selectionColor: Colors.yellow,
                //   // Text selection background color
                //   selectionHandleColor: Colors.blue, // Text selection handle color
                // ),
              ),

              home: SplashScreen(),
              // builder: EasyLoading.init(),
              // home:  HomeApp(),
            ),
          );
        }));
  }
}
