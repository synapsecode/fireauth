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
  }

  ///Gets the login status from SharedPreferences
  static Future<bool> getLoginStatus() async {
    SharedPreferences p = await prefs;
    return p.getBool('is_logged_in') ?? false;
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
