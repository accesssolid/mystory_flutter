import 'package:flutter/material.dart';

class NoNotificationsYet extends StatefulWidget {
  NoNotificationsYet({Key? key}) : super(key: key);

  @override
  _NoNotificationsYetState createState() => _NoNotificationsYetState();
}

class _NoNotificationsYetState extends State<NoNotificationsYet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back,color: Colors.black,)),
      //   centerTitle: true,
      //   title: Text("Notification",style: TextStyle(color: Colors.black),),
      //   actions: [
      //     Icon(Icons.more_horiz,color: Colors.black,),
      //     SizedBox(width: 15,),
      //   ],
      // ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

        Center(
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade100,
                radius: 60,
                child: Image(image: AssetImage("assets/images/Group 953.png")),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                " No Notification Yet",
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