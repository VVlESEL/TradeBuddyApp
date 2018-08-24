import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';

String getAdMobAppId(){
  return defaultTargetPlatform == TargetPlatform.android
      ? "ca-app-pub-4539817448561450~4872351601"
      : "ca-app-pub-4539817448561450~5357838273";
}

String getAdMobBannerAdUnitId(){
  return defaultTargetPlatform == TargetPlatform.android
      ? "ca-app-pub-4539817448561450/7055661814"
      : "ca-app-pub-4539817448561450/9651063230";
}

String getAdMobInterstitialAdUnitId(){
  return defaultTargetPlatform == TargetPlatform.android
      ? "ca-app-pub-4539817448561450/5669679522"
      : "ca-app-pub-4539817448561450/1899623776";
}

final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['trading', 'forex', 'cfd'],
  contentUrl: 'https://bmtrading.de',
  //birthday: DateTime.now(),
  childDirected: false,
  designedForFamilies: false,
  gender: MobileAdGender.male,
  testDevices: <String>["356736175D9CA7F508ED08337745F7B6"],
);

BannerAd createBannerAd() {
  return BannerAd(
    adUnitId: getAdMobBannerAdUnitId(),
    size: AdSize.banner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event $event");
    },
  );
}

InterstitialAd createInterstitialAd() {
  return InterstitialAd(
    adUnitId: getAdMobInterstitialAdUnitId(),
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event $event");
    },
  );
}