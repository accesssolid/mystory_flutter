// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:mystory_flutter/providers/auth_provider.dart';
// import 'package:mystory_flutter/providers/post_provider.dart';
// import 'package:mystory_flutter/screens/newss_feed_no_data_screen.dart';
// import 'package:mystory_flutter/widgets/news_feed_widget.dart';
// import 'package:mystory_flutter/widgets/no_data_yet.dart';
// import 'package:provider/provider.dart';

// class NewsFeedScreen extends StatefulWidget {
//   const NewsFeedScreen({Key? key}) : super(key: key);

//   @override
//   _NewsFeedScreenState createState() => _NewsFeedScreenState();
// }

// class _NewsFeedScreenState extends State<NewsFeedScreen> {
//   // bool like = false;
//   // var formatted;
//   // List<Map<String, dynamic>> groupList = [
//   //   {
//   //     "id": "1",
//   //     "name": "Mande Portman",
//   //     "group": "Friends",
//   //     "relation": "Bro",
//   //     "video": "assets/images/play.png",
//   //     "time": "25 Mins ago",
//   //     "title": "it's been a very wonderful",
//   //     "subtitle": "",
//   //     "description":
//   //         "Its been a wonderful on the west beach today.Best Day ever #maryane #summertime #beachlife",
//   //     "image": "assets/images/dummy01.jpg",
//   //     "post":
//   //         "https://cdn.pixabay.com/photo/2016/02/19/11/20/jump-1209647_960_720.jpg",
//   //   },
//   //   {
//   //     "id": "2",
//   //     "name": "Mande Portman",
//   //     "group": "Friends",
//   //     "relation": "Bro",
//   //     "video": "",
//   //     "time": "1 Hours ago",
//   //     "title": "Mandypo it's been a very wonderful",
//   //     "subtitle": "@maryjane",
//   //     "description":
//   //         "#caption #love #quotes #books #photography #likeBooks #bookLover #follow #captions #instagood ",
//   //     "image": "assets/images/dummy01.jpg",
//   //     "post":
//   //         "https://cdn.pixabay.com/photo/2021/09/08/09/03/book-6606414_960_720.jpg",
//   //   },
//   //   {
//   //     "id": "3",
//   //     "name": "Hehenryhehe",
//   //     "relation": "Friends",
//   //     "video": "",
//   //     "group": "Office",
//   //     "time": "10 Hours ago",
//   //     "title": "",
//   //     "subtitle": "",
//   //     "description":
//   //         "#caption #love #quotes #TreesAreLife #photography #likeTree #TreeLover #coffe #forest #jangal ",
//   //     "image": "assets/images/6.jpg",
//   //     "post":
//   //         "https://cdn.pixabay.com/photo/2021/10/03/04/21/woman-6676901__340.jpg",
//   //   },
//   // ];
// //
//   // String text = '';
//   // String subject = '';
//   // List<String> imagePaths = [];
//   // List gallary = [];
//   var getAllUserPost;
//   var user;
//   bool? isLoadingProgress = false;
//   void post() async {
//     user = Provider.of<AuthProviderr>(context, listen: false).user;
//     getAllUserPost =
//         Provider.of<PostProvider>(context, listen: false).getAllUserPost;
//     // await Provider.of<PostProvider>(context, listen: false)
//     //     .fetchAllUserPost(user.id);
//   }

//   @override
//   void initState() {
//     post();
//     super.initState();
//   }

//   callback(bool data) {
//     setState(() {
//       isLoadingProgress = data;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(
//         BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width,
//             maxHeight: MediaQuery.of(context).size.height),
//         designSize: Size(360, 690),
//         orientation: Orientation.portrait);
//     return Stack(children: [
//       Scaffold(
//         body: getAllUserPost.isEmpty
//             ? NoDataYet(title: "No newsfeed yet", image: "add.png")
//             : Container(
//                 padding: EdgeInsets.all(20),
//                 child: Consumer<PostProvider>(builder: (context, post, child) {
//                   return ListView.builder(
//                     itemCount: post.fetchUserPost.length,
//                     itemBuilder: (BuildContext context, int i) {
//                       return NewsFeedWidget(
//                         data: post.fetchUserPost[i],
//                         callback: callback,
//                       );
//                     },
//                   );
//                 })),
//       ),
//       if (isLoadingProgress!)
//         Positioned.fill(
//           child: Align(
//             alignment: Alignment.center,
//             child: CircularProgressIndicator(),
//           ),
//         )
//     ]);
//   }
// }
