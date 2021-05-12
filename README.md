# Fireauth

FireAuth is a Flutter Package that aims to simplify Flutter Firebase Authentication and streamline app development. It provides a intuitive way to access Parts of the Firebase Authentication Suite and reduces the amount of time you have to spend on it.
Works for both Flutter Native and Flutter Web!

## Install

Add this line to your **pubspec.yaml**:
```yaml
dependencies:
  fireauth: ^0.0.1
```

Then run this command:
```bash
$ flutter packages get
```

Then add this import:
```dart
import 'package:fireauth/fireauth.dart';
```

## Platform Support
* Android
* iOS (Not Tested & Probably has bugs)
* Web

## Currently Supported Authentication Methods:
* Google
* Anonymous
* Email and Password
* Phone

## Prerequisites:
* Create a new flutter project
* Create a new Firebase Project and Add it to your project or use [My FireSetup Python Utility](https://github.com/synapsecode/FireSetup) to do it easily.
* Add your SHA-1 & SHA-256 Key to Firebase in your App Settings on the Firebase Console. Here is how you do it:

    Go to your /android folder in the flutter project, open terminal and type this:
    
    ```batch
    gradlew signingReport
    ```
    
    now, copy the SHA1 and SHA-256 Keys, store it for later use and add it to your Firebase Project
    **(This is required for GoogleSignIn and PhoneSignIn)**
* Enable all the Authentication Methods needed in the Firebase Authentication Console (example: Phone, Google, etc)

## Optional Prerequisites (Not Needed if you used [FireSetup](https://github.com/synapsecode/FireSetup)):
* **(For Google SignIn on Flutter Web)**
    * Go to [Google Cloud Platform Console](https://console.cloud.google.com/) and Open your Google Account Associated with Firebase
    * Open your GCP project with the same name as your firebase project and search for Credentials
    * copy the OAuth2 ClientID for Web
    * Go to your flutter project > web > index.html and paste this in the head section:
    
        ```html
        <meta name="google-signin-client_id" content="<REPLACE WITH CLIENTID>">
        ```
* **(To Remove ReCaptcha Verification for Phone Authentication)**
     * **(Android)** Go to [Google Cloud Platform Console](https://console.cloud.google.com/) open the correct GCP Project, search for Android Device Verification API and enable it. **(NOTE: This needs to be done even if you have used FireSetup)**
     
    * **(Web)** Go the flutter project > web > index.html and add this in the head section:
    
      ```html
      <style>
        .grecaptcha-badge { visibility: hidden; }
      </style>
      ```

   
    
# Usage

## Step 1: Initializing Firebase (main.dart)
```dart
void main() async {
  //This initializes Firebase Accordingly (Important)
  await initializeFirebase();  //This method is from the fireauth package
  runApp(YourApp());
}
```
     
## Step 2: Wrapping your Material App with GlobalFirebaseAuthenticationProvider
```dart
//Allows the Authentication Methods to be accessible from anywhere in the widget tree
return GlobalFirebaseAuthenticationProvider(
 child: MaterialApp(
   home: AppOrigin(),
 ),
);
```

## Step 3: Using the AuthenticationManager
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
