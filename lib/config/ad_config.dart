import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdConfig {


  //Enable or Disable Ads
  static const bool isAdsEnabled = false;

  //Set user clicks to show ads in the content description screen
  final int userClicksAmountsToShowEachAd = 3;

  static const String appIdAndroid = 'ca-app-pub-3940256099942544~3347511713';
  static const String appIdiOS = 'ca-app-pub-3940256099942544~1458002511';

  static const String interstitialAdUnitIdAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String interstitialAdUnitIdiOS = 'ca-app-pub-3940256099942544/4411468910';

  static const String rewardedVideoAdUnitIdAndroid = 'ca-app-pub-3940256099942544/5224354917';
  static const String rewardedVideoAdUnitIdiOS = 'ca-app-pub-3940256099942544/1712485313';

  static const String bannerAdUnitIdAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String bannerAdUnitIdiOS = 'ca-app-pub-3940256099942544/2934735716';








  // -- Don't edit these --
  
  Future initAdmob ()async {
    await MobileAds.instance.initialize();
  }


  String getAdmobAppId () {
    if(Platform.isAndroid){
      return appIdAndroid;
    } 
    else{
      return appIdiOS;
    }
  }

  String getBannerAdUnitId (){
    if(Platform.isAndroid){
      return bannerAdUnitIdAndroid;
    }
    else{
      return bannerAdUnitIdiOS;
    }
  }

  String getInterstitialAdUnitId (){
    if(Platform.isAndroid){
      return interstitialAdUnitIdAndroid;
    }
    else{
      return interstitialAdUnitIdiOS;
    }
  }

  String getRewardedVideoAdUnitId (){
    if(Platform.isAndroid){
      return rewardedVideoAdUnitIdAndroid;
    }
    else{
      return rewardedVideoAdUnitIdiOS;
    }
  }

  
}