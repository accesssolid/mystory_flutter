import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/models/email_invite.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class DeleteAccountRequestScreen extends StatefulWidget {
  const DeleteAccountRequestScreen({Key? key}) : super(key: key);

  @override
  State<DeleteAccountRequestScreen> createState() =>
      _DeleteAccountRequestScreenState();
}

class _DeleteAccountRequestScreenState
    extends State<DeleteAccountRequestScreen> {
  var userId;
  var userEmail;
  bool isLoading = false;

  @override
  void initState() {
    var user = Provider.of<AuthProviderr>(context, listen: false).user;
    userId = user.id;
    userEmail = user.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              "Delete Account",
              style: TextStyle(color: Colors.black),
            )),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "You can delete your account by requesting the admin to delete your account.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.h),
           Container(child:  isLoading?  CircularProgressIndicator():
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(252, 0, 6, 1.0),
                         Color.fromRGBO(236, 63, 63, 1.0)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.99]),
                ),
                height: MediaQuery.of(context).size.height * 0.053,
                // width: MediaQuery.of(context).size.width * 0.43,
                child: ElevatedButton(
                  style: ButtonStyle(
                      elevation:
                          MaterialStateProperty.resolveWith((states) => 0),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.transparent)),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text(
                                'Are you sure you want to permanently delete your account?',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14)),
                            actions: [
                              ElevatedButton(
                                  onPressed: () async {
                                    setState((){
                                      isLoading = true;
                                    });
                                    Navigator.pop(context);
                                    EmailInvite  emailDelete = EmailInvite(
                                        to: "contact@mystoryforlife.com",
                                        message: Message(
                                            subject: "MyStory Deletion Request",
                                            text:
                                            "$userEmail requested you to delete account."));
                                    Provider.of<AuthProviderr>(context,
                                            listen: false)
                                        .deleteUser(emailInvite:
                                        emailDelete, context: context);
                                   await Future.delayed(Duration(seconds: 1));
                                    setState((){
                                        isLoading = false;
                                        });
                                  },
                                  child: Text('Yes')),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('No'))
                            ],
                          );
                        });
                  },
                  child: Text(
                    'Request to delete account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),))
              ),
              SizedBox(
                height: 40.h,
              )
            ],
          ),
        ));
  }
}
