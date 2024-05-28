import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinksService {
  int a = 1;

  Future<String> createDynamicLink(
      {String? parameter, String? imageUrl, String? title, String? userId}) async {
    String uriPrefix = "https://mystoryapp.page.link";
    String param = parameter ?? "";
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
        uriPrefix: uriPrefix,
        link: Uri.parse('https://example.com/$param?userId=$userId'),
        androidParameters: AndroidParameters(
          packageName: "com.appstirr.mystory",
          minimumVersion: 0,
        ),
        iosParameters: const IOSParameters(bundleId: "com.appstirr.mystoryapp"),
        socialMetaTagParameters: SocialMetaTagParameters(
            title: title!, imageUrl: Uri.parse(imageUrl!))
        // iosParameters: const IOSParameters(bundleId: "com.appstirr.mystory"),
        );

    // final Uri dynamicUrl = await parameters.buildUrl();
    final shortLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    return shortLink.shortUrl.toString();
  }

  Future<void> initDynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDynamicLink(data!);

    FirebaseDynamicLinks.instance.onLink.listen(
      (dynamicLinkData) async {
        _handleDynamicLink(dynamicLinkData);
      },
    ).onError((e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  _handleDynamicLink(PendingDynamicLinkData data) async {
    final Uri? deepLink = data.link;

    if (deepLink == null) {
      print('No Data in dynamic link');
      return;
    } else {
      print('Deep link data: ${deepLink.data}');
      print('Deep link path segment: ${deepLink.pathSegments.toString()}');
      print('Deep link path: ${deepLink.path}');
    }
  }
}
