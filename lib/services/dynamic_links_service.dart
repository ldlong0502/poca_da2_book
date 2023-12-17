import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class DynamicLinksService {
  DynamicLinksService._privateConstructor();

  static final DynamicLinksService _instance = DynamicLinksService._privateConstructor();

  static DynamicLinksService get instance => _instance;

  Future<String> createLink(String ref) async {
    final url = "https://pocasedemo.page.link/$ref";
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(url),
      uriPrefix: "https://pocasedemo.page.link",
      androidParameters: const AndroidParameters(packageName: "com.example.poca" , minimumVersion: 20),
      iosParameters: const IOSParameters(bundleId: "com.example.poca"),
    );
    final dynamicLink =
    await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    return dynamicLink.shortUrl.toString();
  }
  
  
  void initDynamicLink() async {
    final instanceLink = await FirebaseDynamicLinks.instance.getInitialLink();
    
    if(instanceLink != null) {
      final refLink = instanceLink.link;
      print(refLink.data);
    }
  }
}
