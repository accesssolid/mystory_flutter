import 'package:flutter/material.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';

Future<void> showLoadingAnimation(BuildContext context,{bool showPercentage = false}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    barrierColor: Colors.transparent,
    builder: (context) {
      return Center(child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if(showPercentage)
            Consumer<AuthProviderr>(
              builder: (context, authProvider, _) {
                if (authProvider.loadingprogress > 0) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [

                            Padding(
                              padding: const EdgeInsets.only(left:8.0,right: 8.0),
                              child: Text(authProvider.loadingprogress.toString()+" %"),
                            ),
                            // if (authProvider.loadingprogress == 100) // Show "Uploading is in progress" when loadingprogress is 100
                            //   Text("Uploading is in progress"),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return SizedBox(); // Return an empty SizedBox if loadingprogress is not greater than 0
                }
              },
            ),

            // Consumer<AuthProviderr>(
            //   builder: (context, authProvider, _) {
            //     return
            //       Container(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10), // Adjust the value as needed for the desired roundness
            //         color: Colors.white, // Change the color as needed
            //       ),
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Text(authProvider.loadingprogress.toString()),
            //       ),
            //     );
            //   },
            // ),
        CircularProgressIndicator()
      ],));
    },
  );
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}


Future<void> showLoadingAnimationwithPercentage(BuildContext context,percentage) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    barrierColor: Colors.transparent,
    builder: (context) {
      return Center(child: Column(
        children: <Widget>[
          Text(percentage),
          CircularProgressIndicator()
        ],
      ));
    },
  );
}