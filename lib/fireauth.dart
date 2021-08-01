library fireauth;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'oauth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

//Exports
export 'auth_controller.dart';
export 'package:fireauth/SocialButtons/social_buttons.dart';
export 'package:fireauth/SocialButtons/mini_social_buttons.dart';
// Exporting Imported Plugins
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:provider/provider.dart';

/// Initializes Firebase for Mobile Devices
///
/// Ensure you call this in your main method, ensure to use await before it
/// and convert your main method into an async main method.
initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Foundation.kIsWeb) {
    await Firebase.initializeApp();
  }
  if (Foundation.kDebugMode && Foundation.kIsWeb)
    print("Using HotRestartBypassMechanism (debugOnly)");
}

class AuthErrors {
  //Mail&PasswordError
  static const String wrongPassword = '[firebase_auth/wrong-password]';
  //PhoneError
  static const String invalidOTP = '[firebase_auth/invalid-verification-code]';
  //TwitterOAuthErrors
  static const String operationCancelled =
      'FirebaseAuthError: The web operation was canceled by the user.';
  static const String callbackNotApproved =
      'Callback URL not approved for this client application';
}

/// This ChangeNotifier exposes the entire Authentication System
class FireAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth get authInstance => _auth;

  //=============================<Google SignIn>=========================
  Future<User> signInWithGoogle({
    bool allowSignInWithRedirect = false,
    Function(String) onError,
    Function(User) onSignInSuccessful,
  }) async {
    User recievedUser;
    try {
      if (Foundation.kIsWeb) {
        //Web Platform Only GoogleSignIn
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        UserCredential userCred;
        if (allowSignInWithRedirect) {
          FirebaseAuth.instance.signInWithRedirect(googleProvider);
          userCred = await _auth.getRedirectResult();
        } else {
          userCred = await _auth.signInWithPopup(googleProvider);
        }
        recievedUser = userCred.user;
      } else {
        //Mobile Platforms
        final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCred =
            await FirebaseAuth.instance.signInWithCredential(credential);
        recievedUser = userCred.user;
      }

      //======================HOT RESTART BUG BYPASS===========================
      await HotRestartBypassMechanism.saveLoginState(true);
      //======================HOT RESTART BUG BYPASS===========================

      if (onSignInSuccessful != null && recievedUser != null)
        onSignInSuccessful(recievedUser);
      // print("GoogleSignInUser -> ${recievedUser?.email}");
    } catch (e) {
      if (!e.toString().contains('isNewUser') && !allowSignInWithRedirect) {
        if (onError != null)
          onError(e.toString());
        else
          print("AuthenticationError(Google): $e");
      }
    }
    return recievedUser;
  }
  //============================</Google SignIn>=========================

  //=============================<Anonymous SignIN>=========================
  Future<User> signInAnonymously({
    Function(User) onSignInSuccessful,
    Function(String) onError,
  }) async {
    try {
      UserCredential userCred = await _auth.signInAnonymously();

      //======================HOT RESTART BUG BYPASS============================
      await HotRestartBypassMechanism.saveLoginState(true);
      //======================HOT RESTART BUG BYPASS============================

      if (onSignInSuccessful != null && userCred != null)
        onSignInSuccessful(userCred.user);
      return userCred.user;
    } catch (e) {
      print("AuthenticationError(Anonymous): $e");
      if (onError != null) onError(e);
      return null;
    }
  }
  //============================</Anonymous SignIN>=========================

  //=============================<EMAIL & PASSWORD SIGNIN>=========================
  Future<User> registerWithEmailAndPassword({
    String email,
    String password,
    Function(String) onError,
    Function(User) onRegisterSuccessful,
  }) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //======================HOT RESTART BUG BYPASS============================
      await HotRestartBypassMechanism.saveLoginState(true);
      //======================HOT RESTART BUG BYPASS============================

      if (onRegisterSuccessful != null && userCred != null)
        onRegisterSuccessful(userCred.user);
      return userCred.user;
    } catch (e) {
      print("RegisterError(Email&Password): $e");
      if (onError != null) onError(e.toString());

      return null;
    }
  }

  Future<User> signInWithEmailAndPassword({
    String email,
    String password,
    Function onIncorrectCredentials,
    Function(String) onError,
    Function(User) onSignInSuccessful,
  }) async {
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //======================HOT RESTART BUG BYPASS============================
      await HotRestartBypassMechanism.saveLoginState(true);
      //======================HOT RESTART BUG BYPASS============================

      if (onSignInSuccessful != null && userCred != null)
        onSignInSuccessful(userCred.user);
      return userCred.user;
    } catch (e) {
      if (e.toString().contains(AuthErrors.wrongPassword)) {
        print("Incorrect Email Or Password");
        if (onIncorrectCredentials != null) onIncorrectCredentials();
      } else {
        print("AuthenticationError(Email&Password): $e");
        if (onError != null) onError(e.toString());
      }
      return null;
    }
  }
  //============================</EMAIL & PASSWORD SIGNIN>=========================

  //============================<Phone Authentication>=========================-
  Future<User> signInWithPhoneNumber({
    BuildContext context,
    String phoneNumber,
    Function onInvalidVerificationCode,
    Function(String) onError,
    Function(User) onSignInSuccessful,
    bool closeVerificationPopupAfterSubmit,
    bool enableDebugLog = true,
    bool showInitiationToast = true,
  }) async {
    TextEditingController ctr = TextEditingController();
    UserCredential userCred;

    final log = (String x) => enableDebugLog ? print(x) : null;

    Widget generatePhoneVerificationDialog({
      Future<bool> Function(String) onSubmit,
      bool closeVerificationPopupAfterSubmit = true,
    }) {
      return AlertDialog(
        title: Text('OTP Verification'),
        content: Container(
          child: TextField(
            controller: ctr,
            decoration: InputDecoration(hintText: 'SMS Code (OTP)'),
          ),
        ),
        actions: [
          Container(
            width: 100,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.black),
              onPressed: () async {
                if (closeVerificationPopupAfterSubmit) Navigator.pop(context);
                bool isDone = await onSubmit(ctr.value.text);
                if (isDone) {
                  //======================HOT RESTART BUG BYPASS===============
                  await HotRestartBypassMechanism.saveLoginState(true);
                  //======================HOT RESTART BUG BYPASS===============
                  if (!closeVerificationPopupAfterSubmit)
                    Navigator.pop(context);
                }
              },
              child: Text("Verify"),
            ),
          ),
        ],
      );
    }

    if (showInitiationToast)
      Fluttertoast.showToast(
        msg: "Initiating SignIn...Please Wait",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );

    if (Foundation.kIsWeb) {
      //The Web Flow
      try {
        ConfirmationResult confirmationResult =
            await _auth.signInWithPhoneNumber(phoneNumber);
        showDialog(
          context: context,
          builder: (context) {
            return generatePhoneVerificationDialog(
              closeVerificationPopupAfterSubmit:
                  closeVerificationPopupAfterSubmit ?? true,
              onSubmit: (smsCode) async {
                bool isDone = false; //FutureReturnValue
                try {
                  userCred = await confirmationResult.confirm(smsCode);
                  isDone = true;
                } catch (ex) {
                  String fx = ex.toString();
                  if (fx.contains(AuthErrors.invalidOTP)) {
                    log("Invalid Verification Code");

                    //Invalid Verification Code Callback
                    if (onInvalidVerificationCode != null) {
                      onInvalidVerificationCode();
                    }
                  }
                }

                //Successful SignIn Callback
                if (onSignInSuccessful != null && userCred != null) {
                  onSignInSuccessful(userCred.user);
                }

                return isDone;
              },
            );
          },
        );
      } catch (e) {
        if (onError != null) {
          onError(e.toString());
        } else {
          log("Web-AuthenticationError(Phone): $e");
        }
      }
    } else {
      //The Native Flow
      log("Clicked on Phone Authentication");

      try {
        final autoRetrieve = (String vID) {
          log("autoRetrieve :: VerificationCode is $vID}");
        };

        final verificationCompleted = (PhoneAuthCredential credential) async {
          log("VerificationCompleted");
          Navigator.pop(context); //To Remove Dialog when AutoSMS Verified
          try {
            await _auth.signInWithCredential(credential);
          } catch (e) {
            if (onError != null) onError(e.toString());
            log('Error at func: verificationCompleted ::=> ${e.toString()}');
          }
        };

        final verificationFailed = (FirebaseAuthException e) {
          if (onError != null) onError(e.toString());
          log(
            'Phone number verification failed. Code: ${e.code}. Message: ${e.message}',
          );
        };

        final onCodeSent = (String verificationId, int resendToken) {
          log("onCodeSent :: OTP Has been sent");
          showDialog(
            context: context,
            builder: (context) {
              return generatePhoneVerificationDialog(
                closeVerificationPopupAfterSubmit:
                    closeVerificationPopupAfterSubmit ?? true,
                onSubmit: (smsCode) async {
                  bool isDone = false; //FutureReturnValue
                  try {
                    AuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: smsCode,
                    );
                    userCred = await _auth.signInWithCredential(credential);
                    isDone = true; //To Show that Login Was Successful

                    //Successful SignIn Callback
                    if (onSignInSuccessful != null && userCred != null) {
                      onSignInSuccessful(userCred.user);
                    }
                  } catch (e) {
                    String error = e.toString();

                    if (error.contains(AuthErrors.invalidOTP)) {
                      if (onInvalidVerificationCode != null)
                        onInvalidVerificationCode();
                      else
                        log("Incorrect OTP");
                    } else {
                      log("InnerAuthenticationError(Phone): $error");
                      if (onError != null) onError(error.toString());
                    }
                  }
                  return isDone;
                },
              );
            },
          );
        };

        //Calling the Verify Phone Number Method & Catching Async Errors
        FirebaseAuth.instance
            .verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: onCodeSent,
          codeAutoRetrievalTimeout: autoRetrieve,
        )
            .then(
          (_) {
            log("Future<VerifyPhoneNumber> complete");
          },
        ).onError(
          (error, stackTrace) {
            log("Error at func: Future<VerifyPhoneNumber> ::=> " +
                error.toString());
            if (onError != null) onError(error.toString());
          },
        );
      } catch (e) {
        if (onError != null) onError(e.toString());
        log("AuthenticationError(Phone): $e");
      }
    }

    return userCred?.user;
  }
  //============================</Phone Authentication>=========================

  //============================<Facebook Authentication>=======================
  Future<User> signInWithFacebook({
    Function(String) onError,
    Function(User) onSignInSuccessful,
  }) async {
    if (Foundation.kIsWeb) {
      //The WebFlow
      FacebookAuthProvider facebookProvider = FacebookAuthProvider();
      facebookProvider.addScope('email');
      facebookProvider.setCustomParameters({
        'display': 'popup',
      });

      // Once signed in, return the UserCredential
      User user;
      try {
        UserCredential userCred =
            await FirebaseAuth.instance.signInWithPopup(facebookProvider);
        user = userCred?.user;
      } catch (e) {
        if (onError != null) onError(e.toString());
        print("FBError: $e");
      }
      if (user != null) {
        if (onSignInSuccessful != null) onSignInSuccessful(user);
        //======================HOT RESTART BUG BYPASS============================
        await HotRestartBypassMechanism.saveLoginState(true);
        //======================HOT RESTART BUG BYPASS============================
      }
      return user;
    } else {
      //The NativeFlow
      User user;
      try {
        final LoginResult result = await FacebookAuth.instance.login();
        final facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken.token);
        UserCredential userCred = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
        user = userCred?.user;

        if (user != null) {
          if (onSignInSuccessful != null) onSignInSuccessful(user);
        }
      } catch (e) {
        if (onError != null) onError(e.toString());
        print("FBError: $e");
      }

      return user;
    }
  }
  //============================</Facebook Authentication>======================

  //-----------------------------------OAUTH------------------------------------

  //Twitter
  Future<User> signInWithTwitter({
    Function(String) onError,
    Function(User) onSignInSuccessful,
  }) async {
    User user = await OAuthEngine.twitterOAuthSignIn(
      onError: onError,
    );
    if (user != null) {
      if (onSignInSuccessful != null) onSignInSuccessful(user);
      //======================HOT RESTART BUG BYPASS============================
      await HotRestartBypassMechanism.saveLoginState(true);
      //======================HOT RESTART BUG BYPASS============================
    }
    return user;
  }

  //Github
  Future<User> signInWithGithub({
    Function(String) onError,
    Function(User) onSignInSuccessful,
  }) async {
    User user = await OAuthEngine.githubOAuthSignIn(
      onError: onError,
    );
    if (user != null) {
      if (onSignInSuccessful != null) onSignInSuccessful(user);
      //======================HOT RESTART BUG BYPASS============================
      await HotRestartBypassMechanism.saveLoginState(true);
      //======================HOT RESTART BUG BYPASS============================
    }
    return user;
  }

  //Microsoft
  Future<User> signInWithMicrosoft({
    Function(String) onError,
    Function(User) onSignInSuccessful,
  }) async {
    User user = await OAuthEngine.microsoftOAuthLogin(
      onError: onError,
    );
    if (user != null) {
      if (onSignInSuccessful != null) onSignInSuccessful(user);
      //======================HOT RESTART BUG BYPASS============================
      await HotRestartBypassMechanism.saveLoginState(true);
      //======================HOT RESTART BUG BYPASS============================
    }
    return user;
  }

  //Yahoo
  Future<User> signInWithYahoo({
    Function(String) onError,
    Function(User) onSignInSuccessful,
  }) async {
    User user = await OAuthEngine.yahooOAuthLogin(
      onError: onError,
    );
    if (user != null) {
      if (onSignInSuccessful != null) onSignInSuccessful(user);
      //======================HOT RESTART BUG BYPASS============================
      await HotRestartBypassMechanism.saveLoginState(true);
      //======================HOT RESTART BUG BYPASS============================
    }
    return user;
  }
  //-----------------------------------OAUTH------------------------------------

  logout({Function onLogout}) async {
    await FirebaseAuth.instance.signOut();
    if (onLogout != null) onLogout();
    await HotRestartBypassMechanism.saveLoginState(false);
    print("Logged Out");
  }
}

class AuthManager extends StatelessWidget {
  final Widget loginFragment;
  final Widget destinationFragment;
  final Widget customWaitingScreen;
  final Color defaultWaitingScreenLoaderColor;
  final Color defaultWaitingScreenBackgroundColor;

  ///An Authentication Gateway for your application
  ///
  ///If the User is logged in, it automatically redirects to the destinationFragment
  ///and if the user is not logged in, it redirects to the loginFragment
  ///can also accomodate a customWaitingScreen or a default one if needed.
  ///
  ///[loginFragment] (required) - The Login View
  ///
  ///[destinationFragment] (required) - The Destination View
  ///
  ///[customWaitingScreen] if your signIn method allows a waiting screen, you can customize the waiting
  ///screen using this arguement
  ///
  ///[defaultWaitingScreenLoaderColor] if you use the default waiting screen, this arguement changes the
  ///color of the CircularLoader
  ///
  ///[defaultWaitingScreenBackgroundColor] if you use the default waiting screen, this arguement changes the
  ///background color
  const AuthManager({
    Key key,
    @required this.loginFragment,
    @required this.destinationFragment,
    this.customWaitingScreen,
    this.defaultWaitingScreenLoaderColor = Colors.white,
    this.defaultWaitingScreenBackgroundColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FireAuthProvider>(context);
    return StreamBuilder(
      stream: provider.authInstance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return destinationFragment;
        } else {
          //Only in Debug Mode & in Web
          if (Foundation.kDebugMode && Foundation.kIsWeb) {
            //---------------------HOT RESTART BYPASS--------------------------
            return HotRestartByPassBuilder(
              destinationFragment: destinationFragment,
              loginFragment: loginFragment,
            );
            //-----------------------------------------------------------------
          } else {
            return loginFragment;
          }
        }
      },
    );
  }
}

class FireAuth extends StatelessWidget {
  final Widget child;

  ///Exposes the FireAuthProvider to the whole widget tree
  ///
  ///You MUST put this above the MaterialApp widget to ensure the whole widget tree
  ///has access to the AuthenticationProvider.
  ///
  ///This is a compulsary widget as the AuthController and AuthManager depends on it.
  ///
  ///Although you won't need it, You can access the FireAuthProvider like this:
  ///
  ///```dart
  ///final provider = Provider.of<FireAuthProvider>(context, listen:false);
  ///```
  ///
  ///[child] is your MaterialApp
  const FireAuth({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FireAuthProvider(),
      child: child,
    );
  }
}

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
