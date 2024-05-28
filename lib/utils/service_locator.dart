import 'package:get_it/get_it.dart';
import 'package:mystory_flutter/services/dynamic_link_service.dart';
import 'package:mystory_flutter/services/firebase_service.dart';
import 'package:mystory_flutter/services/http_service.dart';
import 'package:mystory_flutter/services/sound_services.dart';

import '../services/navigation_service.dart';
import '../services/util_service.dart';
// import '../services/firebase_service.dart';
import '../services/storage_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  print("SDF SDF DSF SDF DSF SDF DSF DSF ");
  try {
    locator.registerSingleton(StorageService());
    locator.registerSingleton(NavigationService());
    locator.registerSingleton(UtilService());
    locator.registerSingleton(FirebaseService());
    locator.registerSingleton(HttpService());
    locator.registerSingleton(DynamicLinksService());
    // locator.registerSingleton(SoundService());
  } catch (err) {
    print("in error setupLocator $err");
    print(err);
  }
}
