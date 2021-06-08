<img src="https://i.ibb.co/Xz42VyG/ddf.png" align="right">


# Fireauth

FireAuth is a Flutter Package that aims to simplify Flutter Firebase Authentication and streamline app development. It provides a intuitive way to access Parts of the Firebase Authentication Suite and reduces the amount of time you have to spend on it.
Works for both Flutter Native and Flutter Web!

## Install

Add this line to your **pubspec.yaml**:
```yaml
dependencies:
  fireauth: ^0.4.0
  
#If you want the latest Major Stable Version use Version 0.0.5
#If you rely on the older firebase dependencies (pre-1.0) Use Version 0.0.5-legacy
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
### Use [My FireSetup Utility](https://github.com/synapsecode/FireSetup)

Setting up Firebase correctly to work with all the Authentication Methods provided by FireAuth can sometimes be difficult and tedious!  Hence, I have come up with a python script that will do most of the hardwork for you! It also contains well documented instructions so that the entire process is very smooth. It's better than the official documentation! 
> 🔴 If you do not use FireSetup there could be some issues due to incorrect manual setup.

## Platform Support
<span>
<img src="https://img.icons8.com/fluent/48/000000/android-tablet.png"/>
<img src="https://img.icons8.com/fluent/48/000000/chrome.png"/>
</span>

## Currently Supported Authentication Methods:
>🟡 The status for iOS is currently unknown as It has not been tested yet.

| Auth Methods  | Platforms    | Auth Methods  | Platforms    |
|---------------|--------------|---------------|--------------|
| Anonymous     | <img src="https://img.icons8.com/fluent/24/000000/chrome.png"/>  <img src="https://img.icons8.com/fluent/26/000000/android-tablet.png"/> | Github  | <img src="https://img.icons8.com/fluent/24/000000/chrome.png"/>  <img src="https://img.icons8.com/fluent/26/000000/android-tablet.png"/> |
| Email & Password | <img src="https://img.icons8.com/fluent/24/000000/chrome.png"/>  <img src="https://img.icons8.com/fluent/26/000000/android-tablet.png"/> | Microsoft | <img src="https://img.icons8.com/fluent/24/000000/chrome.png"/>  <img src="https://img.icons8.com/fluent/26/000000/android-tablet.png"/> |
| Phone | <img src="https://img.icons8.com/fluent/24/000000/chrome.png"/>  <img src="https://img.icons8.com/fluent/26/000000/android-tablet.png"/> | Facebook| <img src="https://img.icons8.com/fluent/24/000000/chrome.png"/>  <img src="https://img.icons8.com/fluent/26/000000/android-tablet.png"/> |
| Google | <img src="https://img.icons8.com/fluent/24/000000/chrome.png"/>  <img src="https://img.icons8.com/fluent/26/000000/android-tablet.png"/>
| Twitter | <img src="https://img.icons8.com/fluent/24/000000/chrome.png"/>  <img src="https://img.icons8.com/fluent/26/000000/android-tablet.png"/>



>🔵 Most of these Authentication Methods need extra setup! Everything is documented very well in the [FireSetup README](https://github.com/synapsecode/FireSetup/blob/main/README.md#additional-setup-instructions)
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
   child: MaterialApp(
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
);
```

## Using the AuthController
The AuthController is a Dart class that contains several static methods that exposes useful functions!

For more information on these methods, take a look at them using the IDE, they are very well documented, but this is all you need for it to work in the default way

### Sign In With Google
>🟡 GoogleSignIn Needs [Additional Setup](https://github.com/synapsecode/FireSetup#additional-setup-instructions)
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
>🟡 PhoneSignIn Needs [Additional Setup](https://github.com/synapsecode/FireSetup#additional-setup-instructions)
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

### SignIn With Facebook
>🟡 FacebookSignIn Needs [Additional Setup](https://github.com/synapsecode/FireSetup#additional-setup-instructions)
```dart
AuthController.signInWithFacebook(
  context,
  onSignInSuccessful: (User u) {},
  onError: (String e) {},
);
```

### SignIn Using OAuth Methods
>🟡 OAuthSignIn Needs [Additional Setup](https://github.com/synapsecode/FireSetup#additional-setup-instructions)
```dart
//Twitter OAuth SignIn
AuthController.signInWithTwiter(
  context,
  onSignInSuccessful: (User u) {},
  onError: (String e) {},
);

//Github OAuth SignIn
AuthController.signInWithGithub(
  context,
  onSignInSuccessful: (User u) {},
  onError: (String e) {},
);

//Microsoft OAuth SignIn
AuthController.signInWithMicrosoft(
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

<span>
<img src="https://i.ibb.co/sySnBp3/sib.jpg" align="right">  
  
```dart
//To Use SocialButtons you need this import!
import 'package:fireauth/social.dart';

TwitterSignInButton(),
GithubSignInButton(),
MicrosoftSignInButton(),
GoogleSignInButton(),
FacebookSignInButton(),
AnonymousSignInButton(),
```
  
  
</span>
<br><br><br>
  
# Future Plans

- Test FireAuth on iOS
- Move FireAuth to sound null safety
- Declare Production Ready Status

# [FireAuth ChangeLogs](https://pub.dev/packages/fireauth/changelog)

# [Live Example (FlutterWeb)](https://fauthweb-example.surge.sh/#/)
