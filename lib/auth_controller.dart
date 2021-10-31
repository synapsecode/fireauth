import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'fireauth.dart';

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
  ///[onError] a Callback for any Error that may occur
  ///
  ///[onSignInSuccessful] a Callback to perform any action after a successful SignIn
  static Future<User?> signInWithGoogle(
    BuildContext context, {
    bool? signInWithRedirect,
    Function(String)? onError,
    Function(User)? onSignInSuccessful,
  }) async {
    return await Provider.of<FireAuthProvider>(
      context,
      listen: false,
    ).signInWithGoogle(
      allowSignInWithRedirect: signInWithRedirect ?? false,
      onError: onError,
      onSignInSuccessful: onSignInSuccessful,
    );
  }

  ///Initiates and Anonymous SignIn and the AuthManager changes the screen to the destinationFragment
  ///
  ///Enable Anonymous Authentication in your Firebase Authentication Console for this to work
  ///[context] is neccessary
  ///
  ///[onSignInSuccessful] a Callback to perform any action after a successful SignIn
  static Future<User?> signInAnonymously(
    BuildContext context, {
    Function(User?)? onSignInSuccessful,
    Function(String)? onError,
  }) async {
    return await Provider.of<FireAuthProvider>(
      context,
      listen: false,
    ).signInAnonymously(
      onSignInSuccessful: onSignInSuccessful,
      onError: onError,
    );
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
  ///
  ///[onRegisterSuccessful] a Callback to perform any action after a successful SignIn
  static Future<User?> registerWithEmailAndPassword(
    BuildContext context, {
    required String email,
    required String password,
    Function(String)? onError,
    Function(User?)? onRegisterSuccessful,
  }) async {
    return await Provider.of<FireAuthProvider>(context, listen: false)
        .registerWithEmailAndPassword(
      email: email,
      password: password,
      onError: onError,
      onRegisterSuccessful: onRegisterSuccessful,
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
  ///
  ///[onSignInSuccessful] a Callback to perform any action after a successful SignIn
  static Future<User?> signInWithEmailAndPassword(
    BuildContext context, {
    required String email,
    required String password,
    Function(String)? onError,
    Function? onIncorrectCredentials,
    Function(User?)? onSignInSuccessful,
  }) async {
    return await Provider.of<FireAuthProvider>(context, listen: false)
        .signInWithEmailAndPassword(
      email: email,
      password: password,
      onError: onError,
      onIncorrectCredentials: onIncorrectCredentials,
      onSignInSuccessful: onSignInSuccessful,
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
  ///
  ///[onSignInSuccessful] a Callback to perform any action after a successful SignIn
  ///
  ///[closeVerificationPopupAfterSubmit] a boolean which when true, closes the OTP Verification Dialog after an attempt and if
  ///false leaves it open, basically if the User Wants to Retry
  static Future<User?> signInWithPhoneNumber(
    BuildContext context, {
    String? phoneNumber,
    Function(String)? onError,
    Function? onInvalidVerificationCode,
    Function(User?)? onSignInSuccessful,
    bool closeVerificationPopupAfterSubmit = false,
  }) async {
    final provider = Provider.of<FireAuthProvider>(context, listen: false);
    return await provider.signInWithPhoneNumber(
      context: context,
      phoneNumber: phoneNumber,
      onError: onError,
      onInvalidVerificationCode: onInvalidVerificationCode,
      onSignInSuccessful: onSignInSuccessful,
      closeVerificationPopupAfterSubmit: closeVerificationPopupAfterSubmit,
    );
  }

  ///Initiates a Twitter OAuth SignUp Flow based on the OAuthEngine Implementation
  ///
  ///[context] is necessary
  ///
  ///[onError] is a callback that is invoked when an error is encountered
  ///
  ///[onSignInSuccessful] is a callback that is invoked when the signIn is successful.
  ///It provides a User which you can use to perform other actions.
  static Future<User?> signInWithTwiter(
    BuildContext context, {
    Function(String)? onError,
    Function(User)? onSignInSuccessful,
  }) async {
    final provider = Provider.of<FireAuthProvider>(context, listen: false);
    return await provider.signInWithTwitter(
      onError: onError,
      onSignInSuccessful: onSignInSuccessful,
    );
  }

  ///Initiates a Github OAuth SignUp Flow based on the OAuthEngine Implementation
  ///
  ///[context] is necessary
  ///
  ///[onError] is a callback that is invoked when an error is encountered
  ///
  ///[onSignInSuccessful] is a callback that is invoked when the signIn is successful.
  ///It provides a User which you can use to perform other actions.
  static Future<User?> signInWithGithub(
    BuildContext context, {
    Function(String)? onError,
    Function(User)? onSignInSuccessful,
  }) async {
    final provider = Provider.of<FireAuthProvider>(context, listen: false);
    return await provider.signInWithGithub(
      onError: onError,
      onSignInSuccessful: onSignInSuccessful,
    );
  }

  ///Initiates a Microsoft OAuth SignUp Flow based on the OAuthEngine Implementation
  ///
  ///[context] is necessary
  ///
  ///[onError] is a callback that is invoked when an error is encountered
  ///
  ///[onSignInSuccessful] is a callback that is invoked when the signIn is successful.
  ///It provides a User which you can use to perform other actions.
  static Future<User?> signInWithMicrosoft(
    BuildContext context, {
    Function(String)? onError,
    Function(User)? onSignInSuccessful,
  }) async {
    final provider = Provider.of<FireAuthProvider>(context, listen: false);
    return await provider.signInWithMicrosoft(
      onError: onError,
      onSignInSuccessful: onSignInSuccessful,
    );
  }

  ///Initiates a Yahoo OAuth SignUp Flow based on the OAuthEngine Implementation
  ///
  ///[context] is necessary
  ///
  ///[onError] is a callback that is invoked when an error is encountered
  ///
  ///[onSignInSuccessful] is a callback that is invoked when the signIn is successful.
  ///It provides a User which you can use to perform other actions.
  static Future<User?> signInWithYahoo(
    BuildContext context, {
    Function(String)? onError,
    Function(User)? onSignInSuccessful,
  }) async {
    final provider = Provider.of<FireAuthProvider>(context, listen: false);
    return await provider.signInWithYahoo(
      onError: onError,
      onSignInSuccessful: onSignInSuccessful,
    );
  }

  ///Initiates a Apple OAuth SignUp Flow based on the OAuthEngine Implementation
  ///
  ///[context] is necessary
  ///
  ///[onError] is a callback that is invoked when an error is encountered
  ///
  ///[onSignInSuccessful] is a callback that is invoked when the signIn is successful.
  ///It provides a User which you can use to perform other actions.
  static Future<User?> signInWithApple(
    BuildContext context, {
    Function(String)? onError,
    Function(User)? onSignInSuccessful,
  }) async {
    final provider = Provider.of<FireAuthProvider>(context, listen: false);
    return await provider.signInWithApple(
      onError: onError,
      onSignInSuccessful: onSignInSuccessful,
    );
  }

  ///Initiates a Facebook Native/Web SignUp Flow
  ///
  ///[context] is necessary
  ///
  ///[onError] is a callback that is invoked when an error is encountered
  ///
  ///[onSignInSuccessful] is a callback that is invoked when the signIn is successful.
  ///It provides a User which you can use to perform other actions.
  static Future<User?> signInWithFacebook(
    BuildContext context, {
    Function(String)? onError,
    Function(User)? onSignInSuccessful,
  }) async {
    final provider = Provider.of<FireAuthProvider>(context, listen: false);
    return await provider.signInWithFacebook(
      onError: onError,
      onSignInSuccessful: onSignInSuccessful,
    );
  }

  /// Initiates a logout and the authManager redirects to the loginFragment
  ///
  /// [context] is necessary
  ///
  /// [onLogout] is a callback function that is called immediately after a logout
  static logout(BuildContext context, {Function? onLogout}) {
    Provider.of<FireAuthProvider>(context, listen: false).logout(
      onLogout: onLogout,
    );
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
  static User? getCurrentUser(
    BuildContext context, {
    Function(User?)? customMapping,
  }) {
    final provider = Provider.of<FireAuthProvider>(context, listen: false);
    User? cUser = provider.authInstance.currentUser;
    if (customMapping != null) return customMapping(cUser);
    return cUser;
  }
}
