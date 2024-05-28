import 'package:flutter/material.dart';
import 'package:mystory_flutter/global.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/widgets/news_feed_widget.dart';
import 'package:mystory_flutter/widgets/no_data_yet.dart';
import 'package:provider/provider.dart';

class NewsFeedTabbarWidget extends StatefulWidget {
  final TextEditingController? searchController;
  const NewsFeedTabbarWidget({this.searchController, Key? key})
      : super(key: key);

  @override
  _NewsFeedTabbarWidgetState createState() => _NewsFeedTabbarWidgetState();
}

class _NewsFeedTabbarWidgetState extends State<NewsFeedTabbarWidget> {
  bool isLoading = false;
  callback(bool data) {
    setState(() {
      isLoading = data;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(builder: (context, post, child) {
      return widget.searchController!.text.isEmpty
          ? NoDataYet(title: "Search", image: "Group 947.png")
          : post.searchMessage == "No Stories"
              ? NoDataYet(title: "No Search Found", image: "Group 947.png")
              : post.searchNewsFeedPost.length == 0
                  ? LoadingWidget()
                  : Container(
                      padding: EdgeInsets.all(20),
                      child: ListView.builder(
                        // controller: _scroll,
                        itemCount: post.searchNewsFeedPost.length,
                        itemBuilder: (BuildContext context, int i) {
                          return NewsFeedWidget(
                            route:"Search",
                            data: post.searchNewsFeedPost[i],
                            callback: callback,
                          );
                        },
                      ));
    });
  }
}
