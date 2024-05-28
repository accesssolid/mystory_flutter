import 'package:flutter/material.dart';

class NoDataYet extends StatefulWidget {
  final title;
  final image;
  NoDataYet({this.image, this.title});

  @override
  _NoDataYetState createState() => _NoDataYetState();
}

class _NoDataYetState extends State<NoDataYet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, children: [
      Center(
        child: CircleAvatar(
          backgroundColor: Colors.grey.shade100,
          radius: 60,
          child: Image(
            
            image: AssetImage(
              "assets/images/${widget.image}",
            ),
            color: Colors.grey,
            
            fit: BoxFit.fill,
            // height: MediaQuery.of(context).size.height * 0.5,
          ),
        ),
      ),
      SizedBox(
        height: 15,
      ),
      Center(
        child: Text(
          " ${widget.title}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      // SizedBox(
      //   height: 5,
      // ),
      // Container(
      //   width: 300,
      //   child: Text(
      //     "its been a very woderful time on the west beach today.Best day ever,Thanks",
      //     textAlign: TextAlign.center,
      //     style:
      //         TextStyle(fontSize: 12, color: Colors.grey.shade500, height: 1.5),
      //   ),
      // )
    ]);
  }
}
