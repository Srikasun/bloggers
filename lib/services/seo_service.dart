// seo_service.dart
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class SeoService {
  Future<Uri> createDynamicLinkForPost(String postId) async {
    final parameters = DynamicLinkParameters(
      uriPrefix:
          'https://bloggers.page.link', // Replace with your dynamic link prefix
      link: Uri.parse(
          'https://bloggers.com/post?postId=$postId'), // Replace with your deep link URL
      androidParameters: AndroidParameters(
        packageName:
            'com.bloggy.bloggers', // Replace with your Android package name
        minimumVersion: 1,
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.yourcompany.yourapp', // Replace with your iOS bundle ID
        minimumVersion: '1.0.1',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Check out this post on Inkhaven!',
        description: 'Discover and share amazing posts on Inkhaven.',
        imageUrl: Uri.parse('https://yourapp.com/assets/inkhavenlogo.png'),
      ),
    );

    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    return dynamicLink.shortUrl;
  }
}
