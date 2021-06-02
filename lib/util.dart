import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This class iis basically a HotRestartBypassMechanism. the firebaseSDK went through a bunch
/// of updates from the firebase team which fixed a few production bugs, in that process a dev bug
/// was discovered that basically doesn't allow StreamBuilder to work properly with Flutter Web on Hot Restart
/// hence, I had to come up with a custom solution to fix it.
class HotRestartBypassMechanism {
  ///The Standard SharedPreference instance
  static final Future<SharedPreferences> prefs =
      SharedPreferences.getInstance();

  ///Saves the Login State (true) for LoggedIn and (false) for LoggedOut
  static saveLoginState(bool isLoggedIn) async {
    //Ignore Operation if Not in DebugMode on Web
    if (!Foundation.kDebugMode && !Foundation.kIsWeb) return;

    SharedPreferences p = await prefs;
    p.setBool('is_logged_in', isLoggedIn);
    if (!isLoggedIn) {
      p.setString('user_info_json', ''); //Delete Associated UserInfo
    }
  }

  ///Saves the User as a JSONMapString into SharedPreferences
  static saveUserInformation(User u) async {
    //Ignore Operation if Not in DebugMode on Web
    if (!Foundation.kDebugMode && !Foundation.kIsWeb) return;
    SharedPreferences p = await prefs;
    Map userObj = {
      'displayName': u.displayName,
      'email': u.email,
      'uid': u.uid,
      'phoneNumber': u.phoneNumber,
      'photoURL': u.photoURL,
      'isAnonymous': u.isAnonymous,
    };
    p.setString('user_info_json', jsonEncode(userObj));
  }

  ///Gets the login status from SharedPreferences
  static Future<bool> getLoginStatus() async {
    SharedPreferences p = await prefs;
    return p.getBool('is_logged_in') ?? false;
  }

  ///Gets the UserInformation from SharedPreferences, JSONDecodes it and returns it.
  ///Not used very often only when FirebaseAuth.instance.currentUser fails even when user is logged in
  static Future<Map> getUserInformation() async {
    SharedPreferences p = await prefs;
    String json = p.getString('user_info_json');
    if (json != null && json != '') {
      return jsonDecode(json);
    } else {
      print("getUserInformation returned null");
      return null;
    }
  }
}

class HotRestartByPassBuilder extends StatelessWidget {
  final Widget destinationFragment;
  final Widget loginFragment;
  const HotRestartByPassBuilder({
    Key key,
    this.destinationFragment,
    this.loginFragment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: HotRestartBypassMechanism.getLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data) {
            return destinationFragment;
          } else {
            return loginFragment;
          }
        } else {
          return loginFragment;
        }
      },
    );
  }
}
