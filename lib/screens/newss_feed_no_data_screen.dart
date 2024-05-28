import 'package:flutter/material.dart';

class NewsFeedNoDataScreen extends StatefulWidget {
  NewsFeedNoDataScreen({Key? key}) : super(key: key);

  @override
  _NewsFeedNoDataScreenState createState() => _NewsFeedNoDataScreenState();
}

class _NewsFeedNoDataScreenState extends State<NewsFeedNoDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

        Center(
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade100,
                radius: 60,
                child: Image(image: AssetImage("assets/images/Vector.png")),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                " No Newsfeed Yet",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: 300,
              child: Text(
                "its been a very woderful time on the west beach today.Best day ever,Thanks",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12, color: Colors.grey.shade500, height: 1.5),
              ),
            )

      ],),
    );
  }
}