import 'package:fireauth/SocialButtons/util.dart';
import 'package:fireauth/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GenericSocialButton extends StatelessWidget {
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
  ///The Social and Anonymous Buttons on use this under the hood
  ///
  ///[configuration] - If you want a custom text for your button
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
  const GenericSocialButton({
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

class GoogleSocialButton extends StatelessWidget {
  final SocialButtonConfiguration config;

  ///A Ready-To-Use GoogleSignIn Button
  ///
  ///[config] This parameter accepts a SocialButtonConfiguration object and is used to change properties of the button

  const GoogleSocialButton({
    Key key,
    this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericSocialButton(
      name: "Google",
      initiator: (context) => AuthController.signInWithGoogle(
        context,
        signInWithRedirect: (config?.signInWithRedirect) ?? false,
        onSignInSuccessful: (config?.onSignInSuccessful) ?? (User u) {},
        onError: (config?.onError) ?? (String e) {},
      ),
      logoURL: SocialLogos.googleLogo,
      backgroundColor: (config?.backgroundColor) ?? Colors.black,
      foregroundColor: (config?.foregroundColor) ?? Colors.white,
    );
  }
}

class AnonymousSocialButton extends StatelessWidget {
  final SocialButtonConfiguration config;

  /// A Ready-To-Use Anonymous SignIn Button
  ///
  ///[config] This parameter accepts a SocialButtonConfiguration object and is used to change properties of the button
  const AnonymousSocialButton({
    Key key,
    this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericSocialButton(
      name: 'Anonymous',
      initiator: (context) => AuthController.signInAnonymously(
        context,
        onSignInSuccessful: (config?.onSignInSuccessful) ?? (u) {},
        onError: (config?.onError) ?? (e) {},
      ),
      logoURL: SocialLogos.anonymousLogo,
      backgroundColor: (config?.backgroundColor) ?? Color(0xFF101010),
      foregroundColor: (config?.foregroundColor) ?? Colors.white,
      customString: 'Anonymous SignIn',
      useBorder: true,
    );
  }
}

class TwitterSocialButton extends StatelessWidget {
  final SocialButtonConfiguration config;

  /// A Ready-To-Use Twitter SignIn Button
  ///
  /// [config] This parameter accepts a SocialButtonConfiguration object and is used to change properties of the button
  const TwitterSocialButton({
    Key key,
    this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericSocialButton(
      name: 'Twitter',
      initiator: (context) => AuthController.signInWithTwiter(
        context,
        onSignInSuccessful: (config?.onSignInSuccessful) ?? (u) {},
        onError: (config?.onError) ?? (e) {},
      ),
      logoURL: SocialLogos.twitterLogo,
      backgroundColor: (config?.backgroundColor) ?? Colors.blue,
      foregroundColor: (config?.foregroundColor) ?? Colors.white,
    );
  }
}

class GithubSocialButton extends StatelessWidget {
  final SocialButtonConfiguration config;

  /// A Ready-To-Use Github SignIn Button
  ///
  /// [config] This parameter accepts a SocialButtonConfiguration object and is used to change properties of the button
  const GithubSocialButton({
    Key key,
    this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericSocialButton(
      name: 'Github',
      initiator: (context) => AuthController.signInWithGithub(
        context,
        onSignInSuccessful: (config?.onSignInSuccessful) ?? (u) {},
        onError: (config?.onError) ?? (e) {},
      ),
      logoURL: SocialLogos.githubLogo,
      backgroundColor: (config?.backgroundColor) ?? Colors.black,
      foregroundColor: (config?.foregroundColor) ?? Colors.white,
    );
  }
}

class MicrosoftSocialButton extends StatelessWidget {
  final SocialButtonConfiguration config;

  /// A Ready-To-Use Microsoft SignIn Button
  ///
  /// [config] This parameter accepts a SocialButtonConfiguration object and is used to change properties of the button
  const MicrosoftSocialButton({
    Key key,
    this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericSocialButton(
      name: 'Microsoft',
      initiator: (context) => AuthController.signInWithMicrosoft(
        context,
        onSignInSuccessful: (config?.onSignInSuccessful) ?? (u) {},
        onError: (config?.onError) ?? (e) {},
      ),
      logoURL: SocialLogos.msftLogo,
      backgroundColor: (config?.backgroundColor) ?? Colors.grey[200],
      foregroundColor: (config?.foregroundColor) ?? Colors.black,
      useBorder: true,
    );
  }
}

class FacebookSocialButton extends StatelessWidget {
  final SocialButtonConfiguration config;

  /// A Ready-To-Use Facebook SignIn Button using the Old Facebook Design Language
  ///
  /// [config] This parameter accepts a SocialButtonConfiguration object and is used to change properties of the button
  const FacebookSocialButton({
    Key key,
    this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericSocialButton(
      name: 'Facebook',
      initiator: (context) => AuthController.signInWithFacebook(
        context,
        onSignInSuccessful: (config?.onSignInSuccessful) ?? (u) {},
        onError: (config?.onError) ?? (e) {},
      ),
      logoURL: SocialLogos.facebookLogo,
      backgroundColor: (config?.backgroundColor) ?? Color(0xFF415DAE),
      foregroundColor: (config?.foregroundColor) ?? Colors.white,
    );
  }
}

class NewFacebookSocialButton extends StatelessWidget {
  final SocialButtonConfiguration config;

  /// A Ready-To-Use Facebook SignIn Button aligned with the new Facebook Design Language
  ///
  /// [config] This parameter accepts a SocialButtonConfiguration object and is used to change properties of the button
  const NewFacebookSocialButton({
    Key key,
    this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericSocialButton(
      name: 'Facebook',
      initiator: (context) => AuthController.signInWithFacebook(
        context,
        onSignInSuccessful: (config?.onSignInSuccessful) ?? (u) {},
        onError: (config?.onError) ?? (e) {},
      ),
      logoURL: SocialLogos.newFacebookLogo,
      backgroundColor: (config?.backgroundColor) ?? Colors.white,
      foregroundColor: (config?.foregroundColor) ?? Colors.black,
      useBorder: true,
      borderColor: Color(0xFF1A77F2),
    );
  }
}

class YahooSocialButton extends StatelessWidget {
  final SocialButtonConfiguration config;

  /// A Ready-To-Use Facebook SignIn Button aligned with the new Facebook Design Language
  ///
  /// [config] This parameter accepts a SocialButtonConfiguration object and is used to change properties of the button
  const YahooSocialButton({
    Key key,
    this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericSocialButton(
      name: 'Yahoo',
      initiator: (context) => AuthController.signInWithYahoo(
        context,
        onSignInSuccessful: (config?.onSignInSuccessful) ?? (u) {},
        onError: (config?.onError) ?? (e) {},
      ),
      logoURL: SocialLogos.yahooLogo,
      backgroundColor: (config?.backgroundColor) ?? Color(0xFF400090),
      foregroundColor: (config?.foregroundColor) ?? Colors.white,
      useBorder: true,
      borderColor: Colors.white10,
    );
  }
}
