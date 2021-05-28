## 0.0.5

- **(Stable Version)**
- **FIX**: Contains a Hot Restart Bypass for the AuthManager for the Web Platform only - This was to bypass the DartWebSDK bug where Hot Restart doesn't work as expected with StreamBuilder and FirebaseAuth

- **(v0.0.5-legacy)**: Contains the older versions of the firebase plugins (^0.7.0 for core and ^0.20.1 for auth)
- **(v0.0.5-frozen)**: Contains version 1.1.0 for auth and 1.0.3 for core
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