import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/constant/enum.dart';
import 'package:mystory_flutter/global.dart';
import 'package:mystory_flutter/models/appuser.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/notification_provider.dart';
import 'package:mystory_flutter/screens/create_story_screen.dart';
import 'package:mystory_flutter/screens/home_screen.dart';
import 'package:mystory_flutter/screens/search_screen_new.dart';
import 'package:mystory_flutter/screens/notification_screen.dart';
import 'package:mystory_flutter/screens/search_screen_old.dart';
import 'package:mystory_flutter/services/http_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/widgets/exit_alert_dialog.dart';
import 'package:mystory_flutter/widgets/main_drawer_widget.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';
import '.././services/navigation_service.dart';
import '.././utils/service_locator.dart';
import 'my_family_screen.dart';

class MainDashboardScreen extends StatefulWidget {
  final int pageIndex;
  MainDashboardScreen(this.pageIndex);
  @override
  _MainDashboardScreenState createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  TextEditingController controller = TextEditingController();
  int _selectedIndex = 0;
  var selectedData;
  HttpService? http = locator<HttpService>();

  var navigationService = locator<NavigationService>();
  var storageService;
  var newNotification;
  var user;

  @override
  void initState() {
    user = Provider.of<AuthProviderr>(context, listen: false).user;
    _selectedIndex = widget.pageIndex;
    Provider.of<InviteProvider>(context, listen: false)
        .fetchAllFamilyTree(id: user.id, count: 10, page: 1);

    super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  Future<bool> _onBackPressed() {
    print("CODE IS RUNNN RUNNNNNNNNNNN");
    return showDialog(
      context: context,
      builder: (context) => ExitAlertDialog(),
    ).then((value) => value as bool);
  }

  Widget build(BuildContext context) {
    newNotification =
        Provider.of<NotificationProvider>(context).newNotification;

    ScreenUtil.init(
      context,
      //BoxConstraints(
      //    maxWidth: MediaQuery.of(context).size.width,
      //    maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(360, 690),
      //orientation: Orientation.portrait
    );
    return RelativeBuilder(
      builder: (context, height, width, sy, sx) {
        return WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
              drawer: MainDrawerWidget(),
              appBar: _selectedIndex == 1
                  ? AppBar(
                      elevation: 0,
                      backgroundColor: _selectedIndex == 1
                          ? Colors.white
                          : Colors.transparent,
                      leading: _selectedIndex == 1
                          ? Builder(
                              builder: (context) => IconButton(
                                  icon: Image.asset(
                                    'assets/images/Left.png',
                                    scale: 1.0,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    Scaffold.of(context).openDrawer();
                                  }),
                            )
                          : null,
                      centerTitle: true,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _selectedIndex == 1 ? "Search" : "",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _selectedIndex == 1
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        // IconButton(onPressed: (){}, icon: Icon(Icons.search)),
                        _selectedIndex == 1
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () async {
                                    context.read<AuthProviderr>().tempRoute =
                                        "/maindeshboard-search-screen";
                                    var storageService =
                                        locator<StorageService>();
                                    await storageService.setData("route",
                                        "/maindeshboard-search-screen");
                                    navigationService
                                        .navigateTo(MyProfileScreenRoute);
                                  },
                                  child: user.profilePicture == ""
                                      ? CircleAvatar(
                                          radius: 20.r,
                                          backgroundImage: AssetImage(
                                              "assets/images/place_holder.png"),
                                        )
                                      : CircleAvatar(
                                          radius: 20.r,
                                          backgroundImage: NetworkImage(
                                              user.profilePicture.toString()),
                                        ),
                                ),
                              )
                            : Text(""),
                      ],
                    )
                  : _selectedIndex == 3
                      ? AppBar(
                          elevation: 0,
                          backgroundColor: _selectedIndex == 3
                              ? Colors.white
                              : Colors.transparent,
                          leading: _selectedIndex == 3
                              ? Builder(
                                  builder: (context) => IconButton(
                                      icon: Image.asset(
                                        'assets/images/Left.png',
                                        scale: 1.0,
                                        color: Colors.black,
                                      ),
                                      onPressed: () =>
                                          Scaffold.of(context).openDrawer()),
                                )
                              : null,
                          centerTitle: true,
                          title: Text(
                            _selectedIndex == 3 ? "My Family" : "",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _selectedIndex == 3
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          actions: <Widget>[
                            // IconButton(onPressed: (){}, icon: Icon(Icons.search)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () async {
                                  context.read<AuthProviderr>().tempRoute =
                                      "/familytree-screen";
                                  var storageService =
                                      locator<StorageService>();
                                  await storageService.setData(
                                      "route", "/familytree-screen");
                                  navigationService
                                      .navigateTo(MyProfileScreenRoute);
                                },
                                child: user.profilePicture == ""
                                    ? CircleAvatar(
                                        radius: 20.r,
                                        backgroundImage: AssetImage(
                                            "assets/images/place_holder.png"),
                                      )
                                    : CircleAvatar(
                                        radius: 20.r,
                                        backgroundImage: NetworkImage(
                                            user.profilePicture.toString()),
                                      ),
                              ),
                            )
                          ],
                        )
                      : _selectedIndex == 4
                          ? AppBar(
                              elevation: 0,
                              backgroundColor: _selectedIndex == 4
                                  ? Colors.white
                                  : Colors.transparent,
                              leading: _selectedIndex == 4
                                  ? Builder(
                                      builder: (context) => IconButton(
                                          icon: Image.asset(
                                            'assets/images/Left.png',
                                            scale: 1.0,
                                            color: Colors.black,
                                          ),
                                          onPressed: () => Scaffold.of(context)
                                              .openDrawer()),
                                    )
                                  : null,
                              centerTitle: true,
                              title: Text(
                                _selectedIndex == 4 ? "Notification" : "",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _selectedIndex == 4
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              actions: <Widget>[
                                // IconButton(onPressed: (){}, icon: Icon(Icons.search)),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () async {
                                      context.read<AuthProviderr>().tempRoute =
                                          "/notification-screen";
                                      var storageService =
                                          locator<StorageService>();
                                      await storageService.setData(
                                          "route", "/notification-screen");

                                      navigationService
                                          .navigateTo(MyProfileScreenRoute);
                                    },
                                    child: user.profilePicture == ""
                                        ? CircleAvatar(
                                            radius: 20.r,
                                            backgroundImage: AssetImage(
                                                "assets/images/place_holder.png"),
                                          )
                                        : CircleAvatar(
                                            radius: 20.r,
                                            backgroundImage: NetworkImage(
                                                user.profilePicture.toString()),
                                          ),
                                  ),
                                )
                              ],
                            )
                          : null,
              body: IndexedStack(
                index: _selectedIndex,
                children: <Widget>[
                  HomeScreen(),
                  SearchScreenOld(),
                  // SearchScreen(),
                  CreateStoryScreen(),
                  MyFamilyScreen(),
                  NotificationScreen()
                  // NotificationScreen(),
                ],
              ),
              bottomNavigationBar:
                  // Platform.isIOS
                  //     ? Theme(
                  //         data: Theme.of(context).copyWith(
                  //           // sets the background color of the `BottomNavigationBar`
                  //           canvasColor: Colors.white,
                  //         ),
                  //         child: Container(
                  //           height: sx(105),
                  //           decoration: BoxDecoration(
                  //             boxShadow: <BoxShadow>[
                  //               BoxShadow(
                  //                   color: Colors.grey.shade300,
                  //                   blurRadius: 8,
                  //                   spreadRadius: 2),
                  //             ],
                  //           ),
                  //           child: BottomNavigationBar(
                  //             showUnselectedLabels: true,
                  //             type: BottomNavigationBarType.fixed,

                  //             // elevation: 10,
                  //             backgroundColor: Colors.white,
                  //             items: <BottomNavigationBarItem>[
                  //               BottomNavigationBarItem(
                  //                 label: 'Home',
                  //                 icon: Image.asset(
                  //                   'assets/images/Home1.png',
                  //                   height: sx(25),
                  //                   // color: Theme.of(context).backgroundColor,
                  //                 ),
                  //                 activeIcon: Image.asset(
                  //                   'assets/images/Home.png',
                  //                   height: sx(25),
                  //                   // color: Colors.black,
                  //                 ),
                  //               ),
                  //               // BottomNavigationBarItem(
                  //               //   label: 'Cart',
                  //               //   icon: Image.asset(
                  //               //     'assets/images/CartBox.png',
                  //               //     scale: 3.0,
                  //               //   ),
                  //               //   activeIcon: Image.asset(
                  //               //     'assets/images/CartBox.png',
                  //               //     scale: 3,
                  //               //     color: Theme.of(context).backgroundColor,
                  //               //   ),
                  //               // ),
                  //               BottomNavigationBarItem(
                  //                 label: 'Search',
                  //                 icon: Image.asset(
                  //                   'assets/images/Search1.png',
                  //                   height: sx(25),
                  //                   // color: Theme.of(context).backgroundColor,
                  //                 ),
                  //                 activeIcon: Image.asset(
                  //                   'assets/images/Search.png',
                  //                   height: sx(25),
                  //                 ),
                  //               ),
                  //               BottomNavigationBarItem(
                  //                 label: '',
                  //                 icon: Container(
                  //                   margin: EdgeInsets.only(top: sx(0)),
                  //                   child: Image.asset(
                  //                     'assets/images/Group 932.png',
                  //                     height: sx(35),
                  //                     // scale: 1.15,
                  //                   ),
                  //                 ),
                  //               ),

                  //               BottomNavigationBarItem(
                  //                 label: 'Family Tree',
                  //                 icon: Image.asset(
                  //                   'assets/images/3 User1.png',
                  //                   height: sx(25),
                  //                   // color: Theme.of(context).backgroundColor,
                  //                 ),
                  //                 activeIcon: Image.asset(
                  //                   'assets/images/3 User.png',
                  //                   height: sx(25),
                  //                 ),
                  //               ),
                  //               BottomNavigationBarItem(
                  //                 label: 'Notifications',
                  //                 icon: Image.asset(
                  //                   'assets/images/Group 9531.png',
                  //                   height: sx(25),
                  //                   // color: Theme.of(context).backgroundColor,
                  //                 ),
                  //                 activeIcon: Image.asset(
                  //                   'assets/images/Group 953.png',
                  //                   height: sx(25),
                  //                 ),
                  //               ),
                  //             ],

                  //             // iconSize: 28,
                  //             // selectedFontSize: 0,

                  //             onTap: (int val) =>
                  //                 setState(() => _selectedIndex = val),
                  //             currentIndex: _selectedIndex,
                  //             selectedLabelStyle: TextStyle(
                  //                 fontSize: sx(11), color: Colors.grey.shade300),
                  //             unselectedLabelStyle: TextStyle(
                  //               fontSize: sx(11),
                  //             ),
                  //             selectedItemColor: Colors.grey.shade600,
                  //             unselectedItemColor: Colors.grey.shade300,
                  //           ),
                  //         ),
                  //       )
                  //     :
                  Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        spreadRadius: 2),
                  ],
                ),
                child: CupertinoTabBar(
                  activeColor: Colors.grey.shade600,
                  inactiveColor: Colors.grey.shade300,
                  onTap: (int val) async {
                    setState(() {
                      _selectedIndex = val;
                    });
                    if (val == 0 || val == 1) {
                      var response = await this.http!.getUserById(user.id);
                      var result = response.data;
                      AppUser _user = AppUser.fromJson(result['data']);
                      _user.notificationSettting = result['data']['notificationSettings'];


                      context.read<AuthProviderr>().setuser(_user);

                      this
                          .storageService
                          .setData(StorageKeys.user.toString(), _user);
                    }
                    if (val == 4) {
                      Provider.of<NotificationProvider>(context, listen: false)
                          .setClearNotificationIcon(false);
                      user = Provider.of<AuthProviderr>(context, listen: false)
                          .user;
                      Provider.of<NotificationProvider>(context, listen: false)
                          .setNewNotification(flag: false, userId: user.id);
                    }

                    if (val == 3) {
                      // showLoadingAnimation(context);
                      await Provider.of<InviteProvider>(context, listen: false).fetchAllFamilyTree(id: user.id, count: 10, page: 1);
                    }
                    // Navigator.pop(context);
                  },
                  currentIndex: _selectedIndex,
                  items: [
                    BottomNavigationBarItem(
                      label: 'Newsfeed',
                      icon: Image.asset(
                        'assets/images/Home1.png',
                        height: sx(25),
                        // color: Theme.of(context).backgroundColor,
                      ),
                      activeIcon: Image.asset(
                        'assets/images/Home.png',
                        height: sx(25),
                        // color: Colors.black,
                      ),
                    ),
                    // BottomNavigationBarItem(
                    //   label: 'Cart',
                    //   icon: Image.asset(
                    //     'assets/images/CartBox.png',
                    //     scale: 3.0,
                    //   ),
                    //   activeIcon: Image.asset(
                    //     'assets/images/CartBox.png',
                    //     scale: 3,
                    //     color: Theme.of(context).backgroundColor,
                    //   ),
                    // ),
                    BottomNavigationBarItem(
                      label: 'Search',
                      icon: Image.asset(
                        'assets/images/Search.png',
                        height: sx(25),
                        // color: Theme.of(context).backgroundColor,
                      ),
                      activeIcon: Image.asset(
                        'assets/images/Search1.png',
                        height: sx(25),
                      ),
                    ),
                    BottomNavigationBarItem(
                      icon: GestureDetector(
                        onTap: () {

                          _showModelSheets(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: sx(5)),
                          child: Image.asset(
                            'assets/images/Group 932.png',
                            height: sx(65),
                            // scale: 1.15,
                          ),
                        ),
                      ),
                    ),

                    BottomNavigationBarItem(
                      label: 'Family Tree',
                      icon: Image.asset(
                        'assets/images/3 User1.png',
                        height: sx(25),
                        // color: Theme.of(context).backgroundColor,
                      ),
                      activeIcon: Image.asset(
                        'assets/images/3 User1.png',
                        color: Colors.grey.shade800,
                        height: sx(25),
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: 'Notifications',
                      icon: newNotification
                          ? Image.asset(
                              'assets/images/Notification-Icon.png',
                              scale: 4,
                            )
                          : Image.asset(
                              'assets/images/Notification-Icon-(InActive).png',
                              scale: 4,
                            ),
                      activeIcon: Image.asset(
                        'assets/images/Group 953.png',
                        color: Colors.grey.shade800,
                        height: sx(25),
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  void _showModelSheets(BuildContext context) {
    showModalBottomSheet(
      // enableDrag: false,
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return SafeArea(
          child: Container(
            child: CreateStoryScreen(),
          ),
        );
      },
    );
  }
}
