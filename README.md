<img src="https://i.ibb.co/Xz42VyG/ddf.png" align="right">


# Fireauth

FireAuth is a Flutter Package that aims to simplify Flutter Firebase Authentication and streamline app development. It provides a intuitive way to access Parts of the Firebase Authentication Suite and reduces the amount of time you have to spend on it.
Works for both Flutter Native and Flutter Web!

## Install

Add this line to your **pubspec.yaml**:
```yaml
dependencies:
  fireauth: ^0.1.0-dev
  
# If you want the latest Major Stable Version use Version 0.0.5
# If you rely on the older firebase dependencies (pre-1.0) Use Version 0.0.5-legacy
```

Then run this command:
```bash
$ flutter packages get
```

Then add this import:
```dart
import 'package:fireauth/fireauth.dart';
```

## Project Firebase Setup
Setting up Firebase correctly can sometimes be a tedious process. Hence, I have come up with a python script that will do most of the hardwork for you! It also contains well documented instructions so that the entire process is very smooth!
Use [My FireSetup Utility](https://github.com/synapsecode/FireSetup) to Properly add Firebase to your Flutter App

## Platform Support
<span>
<img src="https://img.icons8.com/color/48/000000/android-os.png"/>
<img src="https://img.icons8.com/fluent/48/000000/chrome.png"/>
</span>

## Currently Supported Authentication Methods:
| Auth Methods  | Android | iOS (Untested) | Web |
|---------------|---------|-----|-----|
| Anonymous     |   ✔️    |  ❓   |  ✔️   |
| Email         |   ✔️      |  ❓   |  ✔️   |
| Phone         |   ✔️      |   ❓  |  ✔️   |
| Google        |   ✔️      |  ❓   |  ✔️   |
| Twitter OAuth |   ✔️      |   ❓  | ✔️    |

---

# Usage

## Step 1: Initializing Firebase (main.dart)
```dart
void main() async {
  //This initializes Firebase Accordingly (Important)
  await initializeFirebase();  //This method is from the fireauth package
  runApp(YourApp());
}
```
     
## Step 2: Wrap your Material App with FireAuth
```dart
//Allows the Authentication Methods to be accessible from anywhere in the widget tree
return FireAuth(
   materialApp: MaterialApp(
     home: MyAppHome(),
   ),
);
```

## Step 3: Use the AuthManager
```dart
//This basically acts like a Gateway, If youre logged in, it shows the destinationFragment
//else it shows the loginFragment (It Remembers the Authentication State too!)

return AuthManager(
  loginFragment: LoginPage(),
  destinationFragment: HomePage(),
  
  //Other Arguements can be explored in the IDE, documentation has been provided
);
```

## Using the AuthController
The AuthController is a Dart class that contains several static methods that exposes useful functions!

For more information on these methods, take a look at them using the IDE, they are very well documented, but this is all you need for it to work in the default way

### Sign In With Google
```dart
AuthController.signInWithGoogle(
  context,
  onError: (String e) {},
  onSignInSuccessful: (User u) {},
);
```

### Anonymous SignIn
```dart
AuthController.signInAnonymously(
  context,
  onSignInSuccessful: (User u) {},
  onError: (String e) {},
);
```

### Phone SignIn
```dart
AuthController.signInWithPhoneNumber(
    context,
    phoneNumber: phoneNumberController.value.text,
    onError: (e) {},
    onInvalidVerificationCode: () {},
    onSignInSuccessful: (User u) {},
  );
};
```

### Register & Login With Email & Password
```dart
AuthController.registerWithEmailAndPassword(
  context,
  email: "example@email.com",
  password: "abc123",
  onError: (String e) {},
  onRegisterSuccessful: (User u) {},
);
```

### SignIn With Email & Password
```dart
AuthController.signInWithEmailAndPassword(
  context,
  email: "example@email.com",
  password: "abc123",
  onError: (String e) {},
  onIncorrectCredentials: () {},
  onSignInSuccessful: (User u) {},
);
```

### Twitter OAuth SignIn
```dart
AuthController.signInWithTwiter(
  context,
  onSignInSuccessful: (User u) {},
  onError: (String e) {},
);
```

### Logout
```dart
AuthController.logout(context);
```

### Get Current User
```dart
AuthController.getCurrentUser(
  context,
  //Optional Arguement, if not provided, It just returns a Firebase User
  customMapping: (user) => {
    'name': user.displayName,
    'email': user.email,
  },
);
```

## Social SignIn Buttons

If you just want a ready to use button that enables a particular Social SignIn, This is these are the Widgets that you're looking for!

```dart
GoogleSignInButton()
AnonymousSignInButton()
TwitterSignInButton()
```

# Future Plans

- Test FireAuth on iOS
- Implement other OAuth Login Methods along With Facebook Login
- Move FireAuth to sound null safety
- Declare Production Ready Status

# [FireAuth ChangeLogs](https://pub.dev/packages/fireauth/changelog)

# [Live Example (FlutterWeb)](https://fauthweb-example.surge.sh/#/)
