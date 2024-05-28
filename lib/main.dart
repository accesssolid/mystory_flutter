import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/mention_pack/flutter_mentions.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/category_provider.dart';
import 'package:mystory_flutter/providers/chatProvider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/linkStories_familytree&storybook_provider.dart';
import 'package:mystory_flutter/providers/media_gallery_provider.dart';
import 'package:mystory_flutter/providers/message_provider.dart';
import 'package:mystory_flutter/providers/notification_provider.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/services/handle_navigations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/widgets/news_feed_widget_dynamic.dart';
import 'package:provider/provider.dart';
import './services/navigation_service.dart';
import './utils/service_locator.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
    print("I AM HERE FIREBAE");
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: '******************',
          appId: '*************',
          messagingSenderId: '***********',
          projectId: '*************',
          storageBucket: "**********************",
        ),
      );
    } else if (Platform.isIOS) {
      await Firebase.initializeApp();
    }

  await flutterLocalNotificationsPlugin.cancelAll();
   setupLocator();
  // final PendingDynamicLinkData? initialLink =
  //     await FirebaseDynamicLinks.instance.getInitialLink();
  //
  // if (initialLink != null) {
  //   final Uri deepLink = initialLink.link;
  //   String postId = deepLink.path;
  //   String userId = deepLink.queryParameters["userId"]!;
  //   HandleLinkNavigation().handleNavigation(postId,userId);
  // }

// try{
//   FirebaseDynamicLinks.instance.onLink.listen(
//         (pendingDynamicLinkData) {
//       // Set up the `onLink` event listener next as it may be received here
//       if (pendingDynamicLinkData != null) {
//         final Uri deepLink = pendingDynamicLinkData.link;
//         print("deepLink2");
//         print(deepLink);
//         print(deepLink.path);
//         String postId = deepLink.path;
//         String userId = deepLink.queryParameters["userId"]!;
//         print(deepLink.queryParameters["userId"]);
//         HandleLinkNavigation().handleNavigation(postId,userId);
//         // locator<NavigationService>()
//         //     .navigatorKey
//         //     .currentState
//         //     ?.push(MaterialPageRoute(
//         //         builder: (builder) => NewsFeedWidgetDynamic(
//         //               postID: deepLink.path.substring(1),
//         //             )));
//       }
//     },
//   );
// }catch(err){}

  runApp(
    // DevicePreview(
    //     enabled: !kReleaseMode,
    //     builder: (context) =>
    MyApp(),
    // YourApp()
    // ),
  );
}


// class YourApp extends StatefulWidget {
//   const YourApp({Key? key}) : super(key: key);

//   @override
//   State<YourApp> createState() => _YourAppState();
// }

// class _YourAppState extends State<YourApp> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('NewChat').snapshots(),

//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

//           return ListView(
//           children: snapshot.data!.docs.map((DocumentSnapshot document) {
//           Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
//             return ListTile(
//               title: Text(data['message']),
//               // subtitle: Text(data['company']),
//             );
//           }).toList(),
//         );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(onPressed: () {
//         FirebaseFirestore.instance
//             .collection('NewChat')
//             .add({'message': ' world'});
//       }),
//     );
//   }
// }

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProviderr()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => InviteProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => MediaGalleryProvider()),
        ChangeNotifierProvider(create: (_) => LinkFamilyStoryProvider()),
      ],
      child: ScreenUtilInit(
          designSize: Size(360, 690),
          builder: (context, widget)  => Portal(
                child: MaterialApp(
                  // builder: DevicePreview.appBuilder,
                  title: 'MyStory',
                  // code chnage by chetu
                  // .backgroundColor was depricated , change it with .colorsceme.background
                   color: Theme.of(context).backgroundColor,
                 //color: Theme.of(context).colorScheme.background,
                  debugShowCheckedModeBanner: false,
                  // locale: DevicePreview.locale(context),
                  navigatorKey: locator<NavigationService>().navigatorKey,
                  theme: ThemeData(
                   // backgroundColor: Color.fromRGBO(31, 106, 247, 1),
                    primaryColor: Color.fromRGBO(
                      110,
                      115,
                      232,
                      1,
                    ),
                    indicatorColor: Color.fromRGBO(222, 221, 224, 1),
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    highlightColor: Color.fromRGBO(
                      110,
                      115,
                      232,
                      1,
                    ),
                    // Define the default font family.
                    fontFamily: 'Rubik',
                  ),
                  // home: VideoThumb(),
                  onGenerateRoute: onGenerateRoute,
                  initialRoute: SplashScreenRoute,
                ),
              )),
    );
  }




}
