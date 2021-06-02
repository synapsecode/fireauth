## 0.1.0

- **(Stable Version)**
- **FEAT**: Laid the Foundations of OAuthEngine
- **FEAT**: Implemented TwitterOAuth SignIn & Its SocialButton
- **DOCS**: Updated Documentation
- **FIX**: Added GuavaListenableImplementation to Example build.gradle to Resolve Build Errors after implementing OAuthEngine
- **FEAT**: Made sure all AuthMethods return a User
- **RENAME**: GlobalFirebaseAuthenticationProvider is now FireAuth and its child arguement is now the materialApp arguement.
- **RENAME**: AuthenticationManager is now AuthManager
- **RENAME**: FirebaseAuthenticationProvider is now FireAuthProvider
- **NOTE**: Use the Latest Version of FireSetup for this version.

- **(v0.1.0-dev)**: A Pre-Release Test of the OAuthEngine & TwitterSignIn

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