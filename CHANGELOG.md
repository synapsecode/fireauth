## 0.0.5-legacy (STABLE)

- **(Stable Version)**
- **(Note)**: fireauth will continue to support -legacy versions in future releases. This version is basically a pure version and doesn't suffer from the DartWebSDK + FirebaseAuth + StreamBuilder Hot Restart Bug as the firebase version is older.
- If you are getting dependency clashes because of the older version of firebase plugins used here, then consider upgrading to v0.0.5 or the frozen version of the same.

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