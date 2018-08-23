import 'package:firebase_admob/firebase_admob.dart';

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
  return new BannerAd(
    adUnitId: /*BannerAd.testAdUnitId,*/ "ca-app-pub-4539817448561450/7055661814",// Replace the testAdUnitId with an ad unit id from the AdMob dash.
    size: AdSize.banner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event $event");
    },
  );
}

InterstitialAd createInterstitialAd() {
  return new InterstitialAd(
    adUnitId: InterstitialAd.testAdUnitId, // Replace the testAdUnitId with an ad unit id from the AdMob dash.
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event $event");
    },
  );
}