import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SocialLogos {
  static String twitterLogo =
      "https://img.icons8.com/android/24/ffffff/twitter.png";
  static String githubLogo =
      "https://img.icons8.com/ios-glyphs/30/ffffff/github.png";
  static String msftLogo =
      "https://img.icons8.com/color/48/000000/microsoft.png";
  static String googleLogo = "https://i.ibb.co/P12Dmbw/googleicon.png";
  static String facebookLogo =
      "https://img.icons8.com/fluent-systems-filled/48/FFFFFF/facebook.png";
  static String newFacebookLogo =
      "https://img.icons8.com/fluency/96/FFFFFF/facebook-new.png";
  static String anonymousLogo =
      "https://img.icons8.com/color/48/000000/lock.png";
  static String yahooLogo =
      "https://img.icons8.com/windows/32/FFFFFF/yahoo.png";
}

class SocialButtonConfiguration {
  final Color? foregroundColor;
  final Color? backgroundColor;
  final bool? signInWithRedirect;
  final Function(String)? onError;
  final Function(User?)? onSignInSuccessful;

  /// An Object thats used to provide Configuration settings to a SocialButton
  ///
  ///[signInWithRedirect] (default false) is a boolean that is Flutter Web only and basically allows you to chose if you want your
  ///OAuth Screen to be a popup or a redirect. Setting this to true, will use a redirect. Currenly only useful in Google SignIn.
  ///
  ///[onError] a Callback for any Error that may occur
  ///
  ///[onSignInSuccessful] a Callback to perform any action after a successful SignIn
  ///
  ///[foregroundColor] is the Text Color
  ///
  ///[backgroundColor] is the Background Color
  SocialButtonConfiguration({
    this.foregroundColor,
    this.backgroundColor,
    this.signInWithRedirect,
    this.onError,
    this.onSignInSuccessful,
  });
}
