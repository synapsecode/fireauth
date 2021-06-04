import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'fireauth.dart';

// ============================SOCIAL BUTTONS=================================
class GenericSignInButton extends StatelessWidget {
  final String name;
  final String logoURL;
  final String customString;
  final Function(BuildContext) initiator;
  final Color foregroundColor;
  final Color backgroundColor;
  final bool useBorder;
  final Color borderColor;

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
    this.useBorder = false,
    this.borderColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => initiator(context),
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: useBorder ? Border.all(color: borderColor) : null,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
  final Function(User) onSignInSuccessful;

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
    this.enableWaitingScreen = false,
    this.signInWithRedirect = false,
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
        enableWaitingScreen: enableWaitingScreen ?? false,
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

class AnonymousSignInButton extends StatelessWidget {
  final Color foregroundColor;
  final Color backgroundColor;
  final bool enableWaitingSceeen;
  final Function(User) onSignInSuccessful;
  final Function(String) onError;

  /// A Ready-To-Use Anonymous SignIn Button
  ///
  ///[enableWaitingScreen] (default false) is a boolean that enables or disables the AuthManager's Waiting Screen
  ///Until the signIn is complete, the AuthManager will show a default waitingScreen or a custom WaitingScreen depending
  ///on how you have setup your AuthManager.
  ///
  ///[foregroundColor] is the Text Color (default black)
  ///
  ///[backgroundColor] is the Background Color (default White)

  ///[onSignInSuccessful] a Callback to perform any action after a successful SignIn
  ///
  ///[onError] A Callback which is invoked during an error
  const AnonymousSignInButton({
    Key key,
    this.foregroundColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.enableWaitingSceeen,
    this.onError,
    this.onSignInSuccessful,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericSignInButton(
      name: 'Anonymous',
      initiator: (context) => AuthController.signInAnonymously(
        context,
        enableWaitingScreen: enableWaitingSceeen ?? true,
        onSignInSuccessful: onSignInSuccessful,
        onError: onError,
      ),
      logoURL: 'https://i.ibb.co/jRSsZtN/36006-5-anonymous.png',
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      customString: 'Anonymous SignIn',
      useBorder: true,
    );
  }
}

class TwitterSignInButton extends StatelessWidget {
  final Color foregroundColor;
  final Color backgroundColor;
  final bool enableWaitingSceeen;
  final Function(User) onSignInSuccessful;
  final Function(String) onError;

  /// A Ready-To-Use Twitter SignIn Button
  ///
  ///[enableWaitingScreen] (default false) is a boolean that enables or disables the AuthManager's Waiting Screen
  ///Until the signIn is complete, the AuthManager will show a default waitingScreen or a custom WaitingScreen depending
  ///on how you have setup your AuthManager.
  ///
  ///[foregroundColor] is the Text Color (default black)
  ///
  ///[backgroundColor] is the Background Color (default White)
  ///
  ///[onError] a Callback for any Error that may occur
  ///
  ///[onSignInSuccessful] a Callback to perform any action after a successful SignIn
  const TwitterSignInButton({
    Key key,
    this.foregroundColor = Colors.white,
    this.backgroundColor = Colors.white,
    this.enableWaitingSceeen,
    this.onSignInSuccessful,
    this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericSignInButton(
      name: 'Twitter',
      initiator: (context) => AuthController.signInWithTwiter(
        context,
        onSignInSuccessful: onSignInSuccessful,
        enableWaitingScreen: enableWaitingSceeen ?? false,
        onError: onError,
      ),
      logoURL: 'https://img.icons8.com/android/24/ffffff/twitter.png',
      backgroundColor: Colors.blue,
      foregroundColor: foregroundColor,
    );
  }
}

class GithubSignInButton extends StatelessWidget {
  final Color foregroundColor;
  final Color backgroundColor;
  final bool enableWaitingSceeen;
  final Function(User) onSignInSuccessful;
  final Function(String) onError;

  /// A Ready-To-Use Github SignIn Button
  ///
  ///[enableWaitingScreen] (default false) is a boolean that enables or disables the AuthManager's Waiting Screen
  ///Until the signIn is complete, the AuthManager will show a default waitingScreen or a custom WaitingScreen depending
  ///on how you have setup your AuthManager.
  ///
  ///[foregroundColor] is the Text Color (default black)
  ///
  ///[backgroundColor] is the Background Color (default White)
  ///
  ///[onError] a Callback for any Error that may occur
  ///
  ///[onSignInSuccessful] a Callback to perform any action after a successful SignIn
  const GithubSignInButton({
    Key key,
    this.foregroundColor = Colors.white,
    this.backgroundColor = Colors.black,
    this.enableWaitingSceeen,
    this.onSignInSuccessful,
    this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericSignInButton(
      name: 'Github',
      initiator: (context) => AuthController.signInWithGithub(
        context,
        onSignInSuccessful: onSignInSuccessful,
        enableWaitingScreen: enableWaitingSceeen ?? false,
        onError: onError,
      ),
      logoURL: 'https://img.icons8.com/ios-glyphs/30/ffffff/github.png',
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
    );
  }
}

class MicrosoftSignInButton extends StatelessWidget {
  final Color foregroundColor;
  final Color backgroundColor;
  final bool enableWaitingSceeen;
  final Function(User) onSignInSuccessful;
  final Function(String) onError;

  /// A Ready-To-Use Microsoft SignIn Button
  ///
  ///[enableWaitingScreen] (default false) is a boolean that enables or disables the AuthManager's Waiting Screen
  ///Until the signIn is complete, the AuthManager will show a default waitingScreen or a custom WaitingScreen depending
  ///on how you have setup your AuthManager.
  ///
  ///[foregroundColor] is the Text Color (default black)
  ///
  ///[backgroundColor] is the Background Color (default White)
  ///
  ///[onError] a Callback for any Error that may occur
  ///
  ///[onSignInSuccessful] a Callback to perform any action after a successful SignIn
  const MicrosoftSignInButton({
    Key key,
    this.foregroundColor,
    this.backgroundColor,
    this.enableWaitingSceeen,
    this.onSignInSuccessful,
    this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericSignInButton(
      name: 'Microsoft',
      initiator: (context) => AuthController.signInWithMicrosoft(
        context,
        onSignInSuccessful: onSignInSuccessful,
        enableWaitingScreen: enableWaitingSceeen ?? false,
        onError: onError,
      ),
      logoURL: 'https://img.icons8.com/color/48/000000/microsoft.png',
      foregroundColor: foregroundColor ?? Colors.black,
      backgroundColor: backgroundColor ?? Colors.grey[200],
      useBorder: true,
    );
  }
}

// ============================SOCIAL BUTTONS=================================