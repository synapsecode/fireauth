library fireauth;

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

/// Initializes Firebase for Mobile Devices
///
/// Ensure you call this in your main method, ensure to use await before it
/// and convert your main method into an async main method.
initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp();
  }
}

/// This ChangeNotifier exposes the entire Authentication System
class FirebaseAuthenticationProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isWaitingForSignInCompletion = false;

  FirebaseAuth get authInstance => _auth;
  bool get isWaitingForSignInCompletion => _isWaitingForSignInCompletion;

  set isWaitingForSignInCompletion(bool x) {
    _isWaitingForSignInCompletion = x;
    notifyListeners();
  }

  //=============================<Google SignIn>=========================
  Future signInWithGoogle({
    bool allowSignInWithRedirect = false,
    bool enableWaitingScreen = true,
    Function(String) onError,
    Function onSignInSuccessful,
  }) async {
    User recievedUser;
    if (enableWaitingScreen) isWaitingForSignInCompletion = true;
    try {
      if (kIsWeb) {
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
      if (onSignInSuccessful != null) onSignInSuccessful();
      print("GoogleSignInUser -> ${recievedUser?.email}");
    } catch (e) {
      if (!e.toString().contains('isNewUser') && !allowSignInWithRedirect) {
        if (onError != null)
          onError(e.toString());
        else
          print("AuthenticationError(Google): $e");
      }
    }
    if (enableWaitingScreen) isWaitingForSignInCompletion = false;
    return recievedUser;
  }
  //============================</Google SignIn>=========================

  //=============================<Anonymous SignIN>=========================
  Future signInAnonymously({bool enableWaitingScreen}) async {
    try {
      if (enableWaitingScreen) isWaitingForSignInCompletion = true;
      UserCredential userCred = await _auth.signInAnonymously();
      isWaitingForSignInCompletion = false;
      return userCred.user;
    } catch (e) {
      print("AuthenticationError(Anonymous): $e");
      if (enableWaitingScreen) isWaitingForSignInCompletion = false;
      return null;
    }
  }
  //============================</Anonymous SignIN>=========================

  //=============================<EMAIL & PASSWORD SIGNIN>=========================
  Future registerWithEmailAndPassword({
    String email,
    String password,
    Function(String) onError,
  }) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCred.user;
    } catch (e) {
      print("RegisterError(Email&Password): $e");
      if (onError != null) onError(e.toString());

      return null;
    }
  }

  Future signInWithEmailAndPassword({
    String email,
    String password,
    Function onIncorrectCredentials,
    Function(String) onError,
  }) async {
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCred.user;
    } catch (e) {
      if (e.toString().contains('[firebase_auth/wrong-password]')) {
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
  Future signInWithPhoneNumber({
    BuildContext context,
    String phoneNumber,
    Function onInvalidVerificationCode,
    Function(String) onError,
  }) async {
    TextEditingController ctr = TextEditingController();
    UserCredential userCred;

    Widget generatePhoneVerificationDialog({
      Function(String) onSubmit,
      bool closeAfterSubmit = true,
    }) {
      return AlertDialog(
        title: Text('Verify Phone'),
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
                if (closeAfterSubmit) Navigator.pop(context);
                onSubmit(ctr.value.text);
              },
              child: Text("Verify"),
            ),
          ),
        ],
      );
    }

    if (kIsWeb) {
      Toast.show(
        "Initating SignIn...Please Wait",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
      );
      //The Web Flow
      try {
        ConfirmationResult confirmationResult =
            await _auth.signInWithPhoneNumber(phoneNumber);
        showDialog(
          context: context,
          builder: (context) {
            return generatePhoneVerificationDialog(
              onSubmit: (smsCode) async {
                print(smsCode);
                try {
                  userCred = await confirmationResult.confirm(smsCode);
                } catch (ex) {
                  String fx = ex.toString();
                  if (fx
                      .contains('[firebase_auth/invalid-verification-code]')) {
                    print("Invalid Verification Code");
                    if (onInvalidVerificationCode != null)
                      onInvalidVerificationCode();
                  }
                }
              },
            );
          },
        );
      } catch (e) {
        if (onError != null)
          onError(e.toString());
        else
          print("Web-AuthenticationError(Phone): $e");
      }
    } else {
      //The Native Flow
      print("Clicked");
      Toast.show(
        "Initating SignIn...Please Wait",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
      );
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            print(
                'Phone number verification failed. Code: ${e.code}. Message: ${e.message}');
          },
          codeSent: (String verificationId, int resendToken) {
            //Showing verification Screen
            showDialog(
              context: context,
              builder: (context) {
                return generatePhoneVerificationDialog(
                  onSubmit: (smsCode) async {
                    Navigator.pop(context);
                    try {
                      AuthCredential credential = PhoneAuthProvider.credential(
                          verificationId: verificationId, smsCode: smsCode);
                      userCred = await _auth.signInWithCredential(credential);
                    } catch (fx) {
                      if (fx.toString().contains(
                          '[firebase_auth/invalid-verification-code]')) {
                        if (onInvalidVerificationCode != null)
                          onInvalidVerificationCode();
                        else
                          print("Incorrect SMSCode or OTP");
                      } else {
                        print("InnerAuthenticationError(Phone): $fx");
                        if (onError != null) onError(fx.toString());
                      }
                    }
                  },
                  closeAfterSubmit: false,
                );
              },
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print("VerificationCode is $verificationId}");
          },
        );
      } catch (e) {
        if (onError != null) onError(e.toString());
        print("AuthenticationError(Phone): $e");
      }
    }
    return userCred?.user;
  }
  //============================</Phone Authentication>=========================

  logout() async {
    await FirebaseAuth.instance.signOut();
    isWaitingForSignInCompletion = false; //To Update ChangeNotifier
    print("Logged Out");
  }
}

///This class contains static methods that help you access the Authentication methods effectively
class AuthController {
  ///Initates a GoogleSignIn and the AuthManager changes the screen to the destinationFragment
  ///
  ///Shows a traditional OAuth Pop up window on the Web and a normal GoogleSignIn Modal on android
  ///
  ///Please ensure you have added your SHA-1 Key to Firebase to work on Mobile and ensure to have your
  ///GoogleSignInClientID in a meta tag in /web/index.html.
  ///
  ///Enable Google Authentication in your Firebase Authentication Console for this to work
  ///
  ///[context] is neccessary
  ///
  ///[signInWithRedirect] (default false) is a boolean that is Flutter Web only and basically allows you to chose if you want your
  ///OAuth Screen to be a popup or a redirect. Setting this to true, will use a redirect
  ///
  ///[enableWaitingScreen] (default false) is a boolean that enables or disables the AuthManager's Waiting Screen
  ///Until the signIn is complete, the AuthManager will show a default waitingScreen or a custom WaitingScreen depending
  ///on how you have setup your AuthManager.
  ///
  ///[onError] a Callback for any Error that may occur
  ///
  ///[onSignInSuccessful] a Callback to perform any action after a successful SignIn
  static signInWithGoogle(
    BuildContext context, {
    bool signInWithRedirect,
    bool enableWaitingScreen,
    Function(String) onError,
    Function onSignInSuccessful,
  }) {
    Provider.of<FirebaseAuthenticationProvider>(context, listen: false)
        .signInWithGoogle(
      allowSignInWithRedirect: signInWithRedirect ?? false,
      enableWaitingScreen: enableWaitingScreen ?? false,
      onError: onError,
      onSignInSuccessful: onSignInSuccessful,
    );
  }

  ///Initiates and Anonymous SignIn and the AuthManager changes the screen to the destinationFragment
  ///
  ///Enable Anonymous Authentication in your Firebase Authentication Console for this to work
  ///[context] is neccessary
  ///
  ///[enableWaitingScreen] (default false) is a boolean that enables or disables the AuthManager's Waiting Screen
  ///Until the signIn is complete, the AuthManager will show a default waitingScreen or a custom WaitingScreen depending
  ///on how you have setup your AuthManager.
  ///
  static signInAnonymously(BuildContext context, {bool enableWaitingScreen}) {
    Provider.of<FirebaseAuthenticationProvider>(context, listen: false)
        .signInAnonymously(enableWaitingScreen: enableWaitingScreen ?? true);
  }

  ///Registers the Email and Password Combination on Firebase
  ///initiates a login and the AuthManager changes the screen to the destinationFragment
  ///Call this to create a new User and instantly log them in
  ///
  ///Please enable Email and Password Authentication in your Firebase Authentication Console for this to work
  ///
  ///[context] is necessary
  ///
  ///[email] is required and is self-explanatory
  ///
  ///[password] is also required and is self-explanatory
  ///
  ///[onError] is a callback to handle any errors during the process
  static registerWithEmailAndPassword(
    BuildContext context, {
    @required String email,
    @required String password,
    Function(String) onError,
  }) {
    Provider.of<FirebaseAuthenticationProvider>(context, listen: false)
        .registerWithEmailAndPassword(
      email: email,
      password: password,
      onError: onError,
    );
  }

  ///Initates a Mail & Password SignIn and the AuthManager changes the screen to the destinationFragment
  ///
  ///Please enable Email and Password Authentication in your Firebase Authentication Console for this to work
  ///
  ///[context] is necessary
  ///
  ///[email] is required and is self-explanatory
  ///
  ///[password] is also required and is self-explanatory
  ///
  ///[onError] is a callback to handle any errors during the process
  ///
  ///[onIncorrectCredentials] is a callback to handle incorrect credentials
  static signInWithEmailAndPassword(
    BuildContext context, {
    @required String email,
    @required String password,
    Function(String) onError,
    Function onIncorrectCredentials,
  }) {
    Provider.of<FirebaseAuthenticationProvider>(context, listen: false)
        .signInWithEmailAndPassword(
      email: email,
      password: password,
      onError: onError,
      onIncorrectCredentials: onIncorrectCredentials,
    );
  }

  ///Initiates a PhoneNumber SignIn, brings up an OTPVerificationModal and then the AuthManager changes the screen to the destinationFragment
  ///
  ///Please enable Phone Authentication in your Firebase Authentication Console for this to work
  ///
  ///Please ensure you have added your SHA-1 and SHA-256 Keys to Firebase
  ///
  ///If you want to avoid ReCaptcha Redirect verification, Go to Google Cloud Console, Open your firebase
  ///project, search Android Device Verification and enable it
  ///
  ///The Phone Number must be in the format: +\<country code>\<phone number>
  ///
  ///[context] is necessary
  ///
  ///[phoneNumber] is the phoneNumber used to login
  ///
  ///[onError] is a callback to handle any errors in this process
  ///
  ///[onInvalidVerificationCode] is a callback to handle the situation where the OTP is incorrect
  static signInWithPhoneNumber(
    BuildContext context, {
    String phoneNumber,
    Function(String) onError,
    Function onInvalidVerificationCode,
  }) async {
    final provider =
        Provider.of<FirebaseAuthenticationProvider>(context, listen: false);
    await provider.signInWithPhoneNumber(
      context: context,
      phoneNumber: phoneNumber,
      onError: onError,
      onInvalidVerificationCode: onInvalidVerificationCode,
    );
  }

  /// Initiates a logout and the authManager redirects to the loginFragment
  ///
  /// [context] is necessary
  static logout(BuildContext context) {
    Provider.of<FirebaseAuthenticationProvider>(context, listen: false)
        .logout();
  }

  /// An easy way to get the Currently Logged in User
  ///
  /// [context] is necesssary
  /// [customMapping] is an optional Function accepting a User as its arguement and returns it in
  /// a format of your choice, for example creating a custom User Model.
  ///
  /// The recieved User will have all its data filled for GoogleSignIn only, for other forms of Auth
  /// Some of the User Data for example email, displayName etc will be empty.
  ///
  /// emailVerified is true only for GoogleSignIn
  ///
  /// Example:
  /// ```dart
  ///  AuthController.getCurrentUser(
  ///   context,
  ///   customMapping: (user) => {
  ///     'name': user.displayName,
  ///     'email': user.email,
  ///   },
  /// );
  /// ```
  static getCurrentUser(BuildContext context, {Function(User) customMapping}) {
    final provider =
        Provider.of<FirebaseAuthenticationProvider>(context, listen: false);
    if (customMapping != null)
      return customMapping(provider.authInstance.currentUser);
    return provider.authInstance.currentUser;
  }
}

class AuthenticationManager extends StatelessWidget {
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
  const AuthenticationManager({
    Key key,
    @required this.loginFragment,
    @required this.destinationFragment,
    this.customWaitingScreen,
    this.defaultWaitingScreenLoaderColor = Colors.white,
    this.defaultWaitingScreenBackgroundColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseAuthenticationProvider>(context);
    return StreamBuilder(
      stream: provider.authInstance.authStateChanges(),
      builder: (context, snapshot) {
        if (provider.isWaitingForSignInCompletion) {
          return customWaitingScreen ??
              Container(
                color: defaultWaitingScreenBackgroundColor,
                child: Stack(
                  children: [
                    Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          defaultWaitingScreenLoaderColor,
                        ),
                      ),
                    )
                  ],
                ),
              );
        } else {
          if (snapshot.hasData) {
            return destinationFragment;
          } else {
            return loginFragment;
          }
        }
      },
    );
  }
}

class GlobalFirebaseAuthenticationProvider extends StatelessWidget {
  final Widget child;

  ///Exposes the FirebaseAuthenticationProvider to the whole widget tree
  ///
  ///You MUST put this above the MaterialApp widget to ensure the whole widget tree
  ///has access to the AuthenticationProvider.
  ///
  ///This is a compulsary widget as the AuthController and AuthenticationManager depends on it.
  ///
  ///Although you won't need it, You can access the FirebaseAuthenticationProvider like this:
  ///
  ///```dart
  ///final provider = Provider.of<FirebaseAuthenticationProvider>(context, listen:false);
  ///```
  ///
  ///[child] is your MaterialApp
  const GlobalFirebaseAuthenticationProvider({Key key, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FirebaseAuthenticationProvider(),
      child: child,
    );
  }
}

class GenericSignInButton extends StatelessWidget {
  final String name;
  final String logoURL;
  final String customString;
  final Function(BuildContext) initiator;
  final Color foregroundColor;
  final Color backgroundColor;

  ///A Generic Tempalte to create Custom SignIn Buttons
  ///
  ///The Google SignIn Button and the Anonymous SignIn Button use this under the hood
  ///
  ///[customString] - If you want a custom text for your button
  ///
  ///[name] (required) - The Name of your SignIn Method, Example: Google, Snonymous, Github etc
  ///
  ///[logoURL] - The URL to an Image to be used in the button next to the text
  ///
  ///[initiator] (required) - A Function that accepts a BuildContext which initiates the SignIn Process
  ///
  ///[foregroundColor] - The Text Color
  ///
  ///[backgroundColor] - The Background Color
  const GenericSignInButton({
    Key key,
    this.foregroundColor = Colors.white,
    this.backgroundColor = Colors.black,
    @required this.name,
    @required this.initiator,
    this.logoURL,
    this.customString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => initiator(context),
      child: Container(
        color: backgroundColor,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (logoURL != null) ...[
                SizedBox(
                  height: 28,
                  width: 28,
                  child: Image.network(logoURL),
                ),
                SizedBox(width: 12),
              ],
              Text(
                customString ?? 'Sign in with $name',
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final Color foregroundColor;
  final Color backgroundColor;
  final bool enableWaitingScreen;
  final bool signInWithRedirect;
  final Function(String) onError;
  final Function onSignInSuccessful;

  ///A Ready-To-Use GoogleSignIn Button
  ///
  ///Just add this widget to your Widget tree and It will handle GoogleSignIn via the AuthManager and AuthController
  ///

  ///[signInWithRedirect] (default false) is a boolean that is Flutter Web only and basically allows you to chose if you want your
  ///OAuth Screen to be a popup or a redirect. Setting this to true, will use a redirect
  ///
  ///[enableWaitingScreen] (default false) is a boolean that enables or disables the AuthManager's Waiting Screen
  ///Until the signIn is complete, the AuthManager will show a default waitingScreen or a custom WaitingScreen depending
  ///on how you have setup your AuthManager.
  ///
  ///[onError] a Callback for any Error that may occur
  ///
  ///[onSignInSuccessful] a Callback to perform any action after a successful SignIn
  ///
  ///[foregroundColor] is the Text Color (default black)
  ///
  ///[backgroundColor] is the Background Color (default White)
  const GoogleSignInButton({
    Key key,
    this.foregroundColor = Colors.white,
    this.backgroundColor = Colors.black,
    this.enableWaitingScreen,
    this.signInWithRedirect,
    this.onError,
    this.onSignInSuccessful,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericSignInButton(
      name: "Google",
      initiator: (context) => AuthController.signInWithGoogle(
        context,
        signInWithRedirect: signInWithRedirect ?? false,
        enableWaitingScreen: enableWaitingScreen ?? true,
        onSignInSuccessful: onSignInSuccessful,
        onError: (String e) {
          if (onError != null) onError(e);
        },
      ),
      logoURL: 'https://i.ibb.co/P12Dmbw/googleicon.png',
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }
}

/// A Ready-To-Use Anonymous SignIn Button
///
///[enableWaitingScreen] (default false) is a boolean that enables or disables the AuthManager's Waiting Screen
///Until the signIn is complete, the AuthManager will show a default waitingScreen or a custom WaitingScreen depending
///on how you have setup your AuthManager.
///
///[foregroundColor] is the Text Color (default black)
///
///[backgroundColor] is the Background Color (default White)
class AnonymousSignInButton extends StatelessWidget {
  final Color foregroundColor;
  final Color backgroundColor;
  final bool enableWaitingSceeen;
  const AnonymousSignInButton({
    Key key,
    this.foregroundColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.enableWaitingSceeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericSignInButton(
      name: 'Anonymous',
      initiator: (context) => AuthController.signInAnonymously(
        context,
        enableWaitingScreen: enableWaitingSceeen ?? true,
      ),
      logoURL: 'https://i.ibb.co/jRSsZtN/36006-5-anonymous.png',
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      customString: 'Anonymous SignIn',
    );
  }
}
