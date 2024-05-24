import 'dart:io';

class AdMobService{
  static String? get fullScreenAdUnitID {
    if (Platform.isAndroid){
      return 'ca-app-pub-2256050648476899/2464267144';
      // return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS){
      return 'ca-app-pub-2256050648476899/2172423416';
    }

    return null;
  }


}