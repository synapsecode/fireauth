## 0.5.0
- **(Major Stable Version)**
- **FEAT**: Implemented Yahoo OAuth Sign In
- **REFACTOR**: SocialButtons are now exported to fireauth.dart
- **FEAT**: NewFacebookSocialButton & MiniSocialButtons
- **FEAT**: SocialButtonConfiguration added to all SocialButtons instead of Constructor fields
- **FEAT**: Removed WaitingScreen Feature as it was a useless and incomplete feature idea
- **CHORE**: Updated Example Project and README
- **DEPENDENCY**: Updated firebase_auth -> ^2.0.0, google_sign_in -> ^5.0.5, firebase_core -> ^1.4.0, firebase_auth_oauth -> ^1.0.2
- **FEAT**: FireAuth now exports the firebase_auth, provider and firebase_core packages

## 0.4.0
- **(Stable Version)**
- **FEAT**: Implemented FacebookNative & FacebookWeb SignIn & Its SocialButton.
- **FIX**: enableWaitingScreen argument is now by default false for all AuthProviders
- **CHORE**: Updated Example Project

## 0.3.0

- **(Stable Version)**
- **FEAT**: Implemented MicrosoftOAuth SignIn & Its SocialButton
- **REFACTOR**: Moved the AuthController class into a new file and exported it in fireauth.dart
- **DOCS**: Updated Documentation
- **FEAT**: Removed getUserInformation and saveUserInformation from HotRestartBypassMechanism as it was not useful.
- **CHORE**: Updated Example Project

## 0.2.0

- **(Stable Version)**
- **FEAT**: Implemented GithubOAuth SignIn & Its SocialButton
- **DOCS**: Fixed & Updated Documentation
- **BREAKING**: Social Buttons are now placed in fireauth/social.dart
- **CHORE**: Updated Example Project

## 0.1.0

- **(Stable Version)**
- **FEAT**: Laid the Foundations of OAuthEngine
- **FEAT**: Implemented TwitterOAuth SignIn & Its SocialButton
- **DOCS**: Updated Documentation
- **FIX**: Added GuavaListenableImplementation to Example build.gradle to Resolve Build Errors after implementing OAuthEngine
- **FEAT**: Made sure all AuthMethods return a User
- **RENAME**: GlobalFirebaseAuthenticationProvider is now FireAuth
- **RENAME**: AuthenticationManager is now AuthManager
- **RENAME**: FirebaseAuthenticationProvider is now FireAuthProvider

## 0.0.5

- **(Major Stable Version)**
- **FIX**: Implemented HotRestartBypassMechanism to solve the DartWebSDKBug [#6247](https://github.com/FirebaseExtended/flutterfire/issues/6247) which basically solves the issue of AuthenticationManager not working on Flutter Web Hot Restart.
- **DOCS**: Updated Documentation
- **DEPENDENCY**: Updated google_sign_in to ^5.0.4

- **(v0.0.5-legacy)**: Contains the older versions of the firebase plugins (^0.7.0 for core and ^0.20.1 for auth)
- **(v0.0.5-frozen)**: Contains specific version 1.1.0 for auth and 1.0.3 for core
- **(v0.0.5-dev)**: A Pre-Release Test of the HotRestartByPassMechanism for the DartWebSDKBug

## 0.0.4

- **(Stable Version)**
- **FIX**: Upon Learning that there is a Dart SDK Bug regarding Hot Reload in Flutter Web,
I have gone back to firebase_core version ^0.7.0 and firebase_auth version ^0.20.1
- **Update**: (+2) Tested Single Version combination for firebase plugins. Will be implemented in next build (v0.0.5-frozen)
- Same as v0.0.1 with all the improvements of v0.0.2 but without its Hot Restart bug

## 0.0.2

- **(Deprecated Version)**
- **FLAW**: Updated firebase dependencies to stable pair
- **FIX**: PhoneAuth: Mobile onError Callback now Works
- **FEAT**: PhoneAuth: VerificationDialog closes on verificationCompleted
- **FEAT**: Added a success callback for AuthController static methods
- **DOCS**: Added success callback examples in example app
- **WARNING**: This version has a specific DartWebSDK bug that prevents AuthenticationManager
from working correctly during Hot restart on Web. Doesn't exist in Release Mode or on Mobile.

## 0.0.1

- **(Stable Version)**
- **FEAT**: Enabled Mail, Anonymous, Google & Phone Authentication
- **DOCS**: Added Exhaustive Documentation