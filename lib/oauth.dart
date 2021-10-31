import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'fireauth.dart';

///OAuthEngine
///This class is responsible for managing all the OAuthLoginFlows
///It internally uses the plugin: firebase_auth_oauth
///and Supports Github, Twitter, Microsoft, Yahoo, Apple (Basically SocialAuth)
class OAuthEngine {
  ///This function is responsible to conduct the OAuthLoginFlow and handle all the
  ///errors associated with it.
  static Future<User?> performOAuthLogin({
    required String provider,
    List<String>? scopes,
    Map<String, String>? parameters,
    Function(String)? onError,
  }) async {
    //Reduces Boilerplate! Basically Handles all the errors that occur in the OAuthFlow
    void handleError(String err) {
      if (err.contains(AuthErrors.operationCancelled)) {
        print("OPERATION CANCELLED OR INTERRUPTED");
        Fluttertoast.showToast(
          msg: "OPERATION CANCELLED OR INTERRUPTED",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      if (err.contains(AuthErrors.callbackNotApproved)) {
        err =
            "Firebase Twitter Auth callbackURL not added to your Twitter Developer Project's (3-legged OAuth) Authentication Settings";
        debugPrint(err);
        if (onError != null) onError(err);
      } else {
        debugPrint(err);
        if (onError != null) onError(err);
      }
    }

    User? usr;
    try {
      usr = await FirebaseAuthOAuth().openSignInFlow(
        provider,
        scopes ?? ["email"],
        parameters ?? {"locale": "en"},
      );
    } on PlatformException catch (error) {
      handleError("${error.code}: ${error.message}");
    } catch (e) {
      handleError(e.toString());
    }
    return usr;
  }

  ///This Function is Responsible for initiating the Twitter OAuthEngine.
  static Future<User?> twitterOAuthSignIn({
    Function(String)? onError,
  }) async {
    return await performOAuthLogin(
      provider: "twitter.com",
      onError: onError,
    );
  }

  ///This Function is Responsible for initiating the Github OAuthEngine
  static Future<User?> githubOAuthSignIn({
    Function(String)? onError,
  }) async {
    return await performOAuthLogin(
      provider: "github.com",
      onError: onError,
    );
  }

  ///This Function is Responsible for initiating the Github OAuthEngine
  static Future<User?> microsoftOAuthLogin({
    Function(String)? onError,
  }) async {
    return await performOAuthLogin(
      provider: "microsoft.com",
      onError: onError,
    );
  }

  ///This Function is Responsible for initiating the Github OAuthEngine
  static Future<User?> yahooOAuthLogin({
    Function(String)? onError,
  }) async {
    return await performOAuthLogin(
      provider: "yahoo.com",
      scopes: [],
      parameters: {"prompt": "login", "language": "en"},
      onError: onError,
    );
  }

  ///This Function is Responsible for initiating the Apple OAuthEngine
  static Future<User?> appleOAuthLogin({
    Function(String)? onError,
  }) async {
    return await performOAuthLogin(
      provider: "apple.com",
      onError: onError,
    );
  }
}
