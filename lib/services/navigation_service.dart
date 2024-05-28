import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {Object? args}) {
    print(args);
    return navigatorKey.currentState!
        .pushNamed(routeName,arguments: args);  //* added arguments by chetu
  }

  closeScreen() {
    return navigatorKey.currentState!.pop();
  }
}
