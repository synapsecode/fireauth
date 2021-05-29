<img src="https://i.ibb.co/Xz42VyG/ddf.png" align="right">


# Fireauth

FireAuth is a Flutter Package that aims to simplify Flutter Firebase Authentication and streamline app development. It provides a intuitive way to access Parts of the Firebase Authentication Suite and reduces the amount of time you have to spend on it.
Works for both Flutter Native and Flutter Web!

## Install

Add this line to your **pubspec.yaml**:
```yaml
dependencies:
  fireauth: ^0.0.5
  #fireauth: 0.0.5-legacy if you rely on the older firebase dependencies
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
<img src="https://img.icons8.com/color/48/000000/ios-logo.png"/>
</span>

## Currently Supported Authentication Methods:
<span>
<img src="https://img.icons8.com/color/48/000000/google-logo.png"/>
<img src="https://img.icons8.com/color/48/000000/anonymous-mask.png"/>
<img src="https://img.icons8.com/color/48/000000/new-post.png"/>
<img src="https://img.icons8.com/color/48/000000/phone.png"/>
</span>

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
     
## Step 2: Wrap your Material App with GlobalFirebaseAuthenticationProvider
```dart
//Allows the Authentication Methods to be accessible from anywhere in the widget tree
return GlobalFirebaseAuthenticationProvider(
 child: MaterialApp(
   home: AppOrigin(),
 ),
);
```

## Step 3: Use the AuthenticationManager
```dart
//This basically acts like a Gateway, If youre logged in, it shows the destinationFragment
//else it shows the loginFragment (It Remembers the Authentication State too!)

return AuthenticationManager(
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
  onError: (String e) {
    print(e);
  },
),
```

### Anonymous SignIn
```dart
AuthController.signInAnonymously(context),
```

### Phone SignIn
```dart
AuthController.signInWithPhoneNumber(
    context,
    phoneNumber: phoneNumberController.value.text,
    onError: (e) {
      ...
    },
    onInvalidVerificationCode: () {
      ...
    },
  );
},
```

### Register & Login With Email & Password
```dart
AuthController.registerWithEmailAndPassword(
  context,
  email: "example@email.com",
  password: "abc123",
  onError: (String e) {
    ...
  },
);
```

### SignIn With Email & Password
```dart
AuthController.signInWithEmailAndPassword(
  context,
  email: "example@email.com",
  password: "abc123",
  onError: (String e) {
    ...
  },
  onIncorrectCredentials: () {
    ...
  },
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

## Other Widgets

### GoogleSignIn Button
If you just want a ready to use button that enables Google SignIn, This is the Widget you're looking for!

```dart
//has some additional arguements that you can see from your IDE, as it is very well documented
GoogleSignInButton()
```

### Anonymous SignIn Button
If you just want a ready to use button that enables Anonymous SignIn, This is the Widget you're looking for!

```dart
//has some additional arguements that you can see from your IDE, as it is very well documented
AnonymousSignInButton()
```

# Future Plans

- Test FireAuth on iOS
- Implement Twitter, Github, Microsoft, Apple, Facebook and other such AuthenticationMethods
- Move FireAuth to sound null safety

# [FireAuth ChangeLogs](https://pub.dev/packages/fireauth/changelog)
