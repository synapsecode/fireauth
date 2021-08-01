import 'package:fireauth/SocialButtons/util.dart';
import 'package:fireauth/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GenericMiniSocialButton extends StatefulWidget {
  final String logoURL;
  final Function(BuildContext) initiator;
  final Color backgroundColor;
  final bool useBorder;
  final Color borderColor;
  const GenericMiniSocialButton({
    Key key,
    this.logoURL,
    this.initiator,
    this.backgroundColor,
    this.useBorder = false,
    this.borderColor,
  }) : super(key: key);

  @override
  _GenericMiniSocialButtonState createState() =>
      _GenericMiniSocialButtonState();
}

class _GenericMiniSocialButtonState extends State<GenericMiniSocialButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.initiator(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          border:
              widget.useBorder ? Border.all(color: widget.borderColor) : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Image.network(widget.logoURL),
        ),
      ),
    );
  }
}

class MiniGoogleSocialButton extends StatelessWidget {
  final SocialButtonConfiguration config;
  const MiniGoogleSocialButton({Key key, this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericMiniSocialButton(
      initiator: (context) => AuthController.signInWithGoogle(
        context,
        signInWithRedirect: (config?.signInWithRedirect) ?? false,
        onSignInSuccessful: (config?.onSignInSuccessful) ?? (User u) {},
        onError: (config?.onError) ?? (String e) {},
      ),
      backgroundColor: (config?.backgroundColor) ?? Colors.black,
      logoURL: SocialLogos.googleLogo,
    );
  }
}

class MiniTwitterSocialButton extends StatelessWidget {
  final SocialButtonConfiguration config;
  const MiniTwitterSocialButton({Key key, this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericMiniSocialButton(
      initiator: (context) => AuthController.signInWithTwiter(
        context,
        onSignInSuccessful: (config?.onSignInSuccessful) ?? (User u) {},
        onError: (config?.onError) ?? (String e) {},
      ),
      backgroundColor: (config?.backgroundColor) ?? Colors.blue,
      logoURL: SocialLogos.twitterLogo,
    );
  }
}

class MiniGithubSocialButton extends StatelessWidget {
  final SocialButtonConfiguration config;
  const MiniGithubSocialButton({Key key, this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericMiniSocialButton(
      initiator: (context) => AuthController.signInWithGithub(
        context,
        onSignInSuccessful: (config?.onSignInSuccessful) ?? (User u) {},
        onError: (config?.onError) ?? (String e) {},
      ),
      backgroundColor: (config?.backgroundColor) ?? Colors.black,
      logoURL: SocialLogos.githubLogo,
    );
  }
}

class MiniAnonymousSocialButton extends StatelessWidget {
  final SocialButtonConfiguration config;
  const MiniAnonymousSocialButton({Key key, this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericMiniSocialButton(
      initiator: (context) => AuthController.signInAnonymously(
        context,
        onSignInSuccessful: (config?.onSignInSuccessful) ?? (User u) {},
        onError: (config?.onError) ?? (String e) {},
      ),
      backgroundColor: (config?.backgroundColor) ?? Color(0xFF101010),
      logoURL: SocialLogos.anonymousLogo,
    );
  }
}

class MiniMicrosoftSocialButton extends StatelessWidget {
  final SocialButtonConfiguration config;
  const MiniMicrosoftSocialButton({Key key, this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericMiniSocialButton(
      initiator: (context) => AuthController.signInWithMicrosoft(
        context,
        onSignInSuccessful: (config?.onSignInSuccessful) ?? (User u) {},
        onError: (config?.onError) ?? (String e) {},
      ),
      backgroundColor: (config?.backgroundColor) ?? Colors.grey[200],
      logoURL: SocialLogos.msftLogo,
    );
  }
}

class MiniFacebookSocialButton extends StatelessWidget {
  final SocialButtonConfiguration config;
  const MiniFacebookSocialButton({Key key, this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericMiniSocialButton(
      initiator: (context) => AuthController.signInWithFacebook(
        context,
        onSignInSuccessful: (config?.onSignInSuccessful) ?? (User u) {},
        onError: (config?.onError) ?? (String e) {},
      ),
      backgroundColor: (config?.backgroundColor) ?? Color(0xFF415DAE),
      logoURL: SocialLogos.facebookLogo,
    );
  }
}

class MiniNewFacebookSocialButton extends StatelessWidget {
  final SocialButtonConfiguration config;
  const MiniNewFacebookSocialButton({Key key, this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericMiniSocialButton(
      initiator: (context) => AuthController.signInWithFacebook(
        context,
        onSignInSuccessful: (config?.onSignInSuccessful) ?? (User u) {},
        onError: (config?.onError) ?? (String e) {},
      ),
      backgroundColor: (config?.backgroundColor) ?? Colors.white,
      logoURL: SocialLogos.newFacebookLogo,
    );
  }
}

class MiniYahooSocialButton extends StatelessWidget {
  final SocialButtonConfiguration config;
  const MiniYahooSocialButton({Key key, this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericMiniSocialButton(
      initiator: (context) => AuthController.signInWithYahoo(
        context,
        onSignInSuccessful: (config?.onSignInSuccessful) ?? (User u) {},
        onError: (config?.onError) ?? (String e) {},
      ),
      backgroundColor: (config?.backgroundColor) ?? Color(0xFF400090),
      logoURL: SocialLogos.yahooLogo,
    );
  }
}
