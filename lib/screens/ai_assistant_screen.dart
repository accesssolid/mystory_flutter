import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'package:http/http.dart' as http;

class AiAssistantPage extends StatefulWidget {
  @override
  _MyStoryPageState createState() => _MyStoryPageState();
}

class _MyStoryPageState extends State<AiAssistantPage> {
  final _formKey = GlobalKey<FormState>();
  String _storySummary = '';
  var getUserData;
  final _textController1 = TextEditingController();
  final _textController2 = TextEditingController();
  final _textController3 = TextEditingController();
  final _textController4 = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    getUserData = Provider.of<AuthProviderr>(context, listen: false).user;
    print("getUserData");
    print(getUserData);
    super.initState();
    // _textController1.text="Travel image";
    // _textController2.text="No";
    // _textController3.text="Mountain view";
    // _textController4.text="No";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          children: [
            Text("AI Assistant", // changed by chetu
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                      color: Colors.red.shade100,
                      blurRadius: 5,
                      spreadRadius: 0,
                      offset: Offset(0, 6))
                ]),
            child: CircleAvatar(
              backgroundColor: Colors.orange.shade900,
              radius: 20,
              child: getUserData.profilePicture == ""
                  ? CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          AssetImage("assets/images/place_holder.png"))
                  : CircleAvatar(
                      backgroundColor: Theme.of(context).backgroundColor,
                      radius: 25,
                      backgroundImage:
                          NetworkImage(getUserData.profilePicture.toString())),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: isLoading == true
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "To use the MyStory AI Assistant:",
                    style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  BulletListItem(text: 'Answer questions.'),
                  BulletListItem(text: 'Type or use Voice to Text for answers'),
                  BulletListItem(text: 'Click submit.'),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      "The AI Assistant will capture your stated details of the story and produce a perfectly worded summary inserted into your story description.",
                      style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      "1. What do you want to share about this story and the pictures/videos you are adding?",
                      style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Container(
                    // height: 45.h,
                    child: TextField(
                      controller: _textController1,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
                      ),
                      //controller: ,
                      maxLength: 500,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        isDense: true,
                        counter: SizedBox(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).indicatorColor)),
                        disabledBorder: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor)),
                        errorBorder: InputBorder.none,
                        filled: true,
                        hintStyle: TextStyle(
                          letterSpacing: 1,
                          color: Color.fromRGBO(
                            218,
                            219,
                            221,
                            1,
                          ),
                        ),
                        hintText: "Text..",
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      "2. Is there anyone with you in this story and what part did they play in this story?",
                      style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Container(
                    // height: 45.h,
                    child: TextField(
                      controller: _textController2,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
                      ),
                      //controller: ,
                      maxLength: 500,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        isDense: true,
                        counter: SizedBox(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).indicatorColor)),
                        disabledBorder: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor)),
                        errorBorder: InputBorder.none,
                        filled: true,
                        hintStyle: TextStyle(
                          letterSpacing: 1,
                          color: Color.fromRGBO(
                            218,
                            219,
                            221,
                            1,
                          ),
                        ),
                        hintText: "Text..",
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "3. What was the most memorable part of this story to you?",
                    style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Container(
                    // height: 45.h,
                    child: TextField(
                      controller: _textController3,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
                      ),
                      //controller: ,
                      maxLength: 500,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        isDense: true,
                        counter: SizedBox(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).indicatorColor)),
                        disabledBorder: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor)),
                        errorBorder: InputBorder.none,
                        filled: true,
                        hintStyle: TextStyle(
                          letterSpacing: 1,
                          color: Color.fromRGBO(
                            218,
                            219,
                            221,
                            1,
                          ),
                        ),
                        hintText: "Text..",
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "4. Is there anything else you want to capture about this story?",
                    style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Container(
                    // height: 45.h,
                    child: TextField(
                      controller: _textController4,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
                      ),
                      //controller: ,
                      maxLength: 500,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        isDense: true,
                        counter: SizedBox(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).indicatorColor)),
                        disabledBorder: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor)),
                        errorBorder: InputBorder.none,
                        filled: true,
                        hintStyle: TextStyle(
                          letterSpacing: 1,
                          color: Color.fromRGBO(
                            218,
                            219,
                            221,
                            1,
                          ),
                        ),
                        hintText: "Text..",
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(91, 121, 229, 1),
                                Color.fromRGBO(129, 109, 224, 1)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.0, 0.99]),
                        ),
                        height: MediaQuery.of(context).size.height * 0.053,
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.resolveWith(
                                  (states) => 0),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.transparent)),
                          onPressed: () async {
                            /*here wirte validation code for all text field */
                            if (_textController1.text.isEmpty ||
                                _textController2.text.isEmpty ||
                                _textController3.text.isEmpty ||
                                _textController4.text.isEmpty) {
                              // If any text field is empty, show Snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('All fields are mandatory.'),
                                ),
                              );
                            } else {
//                               sendMessage('''
// Question: What do you want to share about this story and the pictures/videos you are adding?
// User: "${_textController1.text}"
//
// Question: Is there anyone with you in this story and what part did they play in this story?
// User: "${_textController2.text}"
//
// Question: What was the most memorable part of this story to you?
// User: "${_textController3.text}"
//
// Question: Is there anything else you want to capture about this story?
// User: "${_textController4.text}",
//
// give me answer in one paragraph and maximum text limit will be 10000.
// ''');
//                             Write me a first-person story summary no more than 1000 words in common everyday language about my experience considering the following information:
                              sendMessage(
                                  '''Write me a first-person story summary no more than 1000 words in common everyday language about my experience considering the following information:
${_textController1.text}
${_textController2.text}
${_textController3.text}
${_textController4.text}''');
                            }
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          textStyle: TextStyle(fontWeight: FontWeight.w600),
                          fixedSize: Size(
                            MediaQuery.of(context).size.width / 2.5,
                            MediaQuery.of(context).size.height * 0.055,
                          ),
                          backgroundColor: Colors.white,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(50),
                            side: BorderSide(
                                color: Theme.of(context).indicatorColor),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
      ),
    );
  }



  Future<void> sendMessage(String message) async {
    print(message);
    String api = '********';
    //String endpoint = 'https://api.openai.com/v1/chat/completions';
    String endpoint = 'https://api.openai.com/v1/chat/completions';
    setState(() {
      isLoading = true;
    });
    var response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $api',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo-1106',
        //'max_tokens': 150,
         'messages': [
           {'role': 'user', 'content': message}
         ]
      }),
    );

print(response);
    if (response.statusCode == 200) {
      var data = await jsonDecode(response.body);
      setState(() {
        isLoading = false;
        print("\n\n\n");
        LogPrint(data['choices'][0]['message']['content']);
        Navigator.pop(context, data['choices'][0]['message']['content']);
        print("\n\n\n");
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Request failed with status: ${response.body} ${response.statusCode}.');
    }
  }

  static void LogPrint(Object object) async {
    int defaultPrintLength = 1020;
    if (object == null || object.toString().length <= defaultPrintLength) {
      print(object);
    } else {
      String log = object.toString();
      int start = 0;
      int endIndex = defaultPrintLength;
      int logLength = log.length;
      int tmpLogLength = log.length;
      while (endIndex < logLength) {
        String message = log.substring(start, endIndex);
        // Remove the "I/flutter (30018): " prefix
        message = message.replaceFirst(RegExp(r'I/flutter \(\d+\): '), '');
        print(message);


        endIndex += defaultPrintLength;
        start += defaultPrintLength;
        tmpLogLength -= defaultPrintLength;
      }
      if (tmpLogLength > 0) {
        String message = log.substring(start, logLength);
        // Remove the "I/flutter (30018): " prefix
        message = message.replaceFirst(RegExp(r'I/flutter \(\d+\): '), '');
        print(message);
      }
    }
  }
}

class BulletListItem extends StatelessWidget {
  final String text;

  const BulletListItem({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 6.0),
              width: 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 14.0),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 12.sp, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
