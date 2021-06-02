import 'package:fireauth/social.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//Import FireAuth
import 'package:fireauth/fireauth.dart';

void main() async {
  //This initializes Firebase Accordingly (Important)
  await initializeFirebase();
  runApp(FireAuthExampleApp());
}

class FireAuthExampleApp extends StatelessWidget {
  const FireAuthExampleApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Always add this above the MaterialApp, it Exposes a Provider Internally
    //That can be used to access the AuthInformation from Anywhere
    return FireAuth(
      child: MaterialApp(
        home: AppOrigin(),
      ),
    );
  }
}

class AppOrigin extends StatelessWidget {
  const AppOrigin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //This basically acts like a Gateway, If youre logged in, it shows destination
    //If youre not logged in, it shows login (Remembers the Authentication State too!)
    return AuthManager(
      loginFragment: LoginPage(),
      destinationFragment: HomePage(),
      //Other Arguements are for Setting up WaitingScreen during login and are optional
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController regEmailController = TextEditingController();
  TextEditingController regPassController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF333333),
        constraints: BoxConstraints.expand(),
        padding: EdgeInsets.symmetric(
            vertical: kIsWeb ? 10 : 20, horizontal: kIsWeb ? 10 : 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                "FireAuth Example",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Social Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 20),
              //FireAuth Provided TwitterSignInButton
              TwitterSignInButton(
                onError: (e) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("TwitterOAuth Error Occured"),
                      content: Text(e),
                    ),
                  );
                },
              ),
              //Incase you want to make a new Button for TwitterSignInButton, you can use this method:
              /*
              AuthController.signInWithTwiter(
                context,
                signInWithRedirect: false,
                enableWaitingScreen: false,
                onError: (String e) {
                  print(e);
                },
              ),
              */
              SizedBox(height: 8),
              GithubSignInButton(
                onError: (e) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("GithubOAuth Error Occured"),
                      content: Text(e),
                    ),
                  );
                },
              ),
              //Incase you want to make a new Button for GithubSignInButton, you can use this method:
              /*
              AuthController.signInWithGithub(
                context,
                signInWithRedirect: false,
                enableWaitingScreen: false,
                onError: (String e) {
                  print(e);
                },
              ),
              */
              SizedBox(height: 8),
              //FireAuth Provided GoogleSignInButton
              GoogleSignInButton(
                //If you want a waiting screen when GoogleSignIn is ongoing
                //Set this to true, you can customize it or add a new waitingScreen in the AuthenticationManager
                //You can also customize the colors of this button
                enableWaitingScreen: false,
                onError: (e) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("GoogleOAuth Error Occured"),
                      content: Text(e),
                    ),
                  );
                },
                //Callback for a Successful SignIn
                onSignInSuccessful: (user) {
                  print(
                    "Google SignIn Successful!!! Name: ${user.displayName}",
                  );
                },
              ),
              //Incase you want to make a new Button for GoogleSignIn, you can use this method:
              /*
              AuthController.signInWithGoogle(
                context,
                signInWithRedirect: false,
                enableWaitingScreen: false,
                onError: (String e) {
                  print(e);
                },
              ),
              */
              SizedBox(height: 8),
              //FireAuth Provided AnonymousSignInButton you can customize the colors if needed
              AnonymousSignInButton(
                enableWaitingSceeen: false,
                //Callback for a Successful SignIn
                onSignInSuccessful: (user) {
                  print(
                    "Anonymous SignIn Successful!!! UID: ${user.uid}",
                  );
                },
              ),
              //Incase you want your own AnonymousSignInButton then use this method:
              /*
                AuthController.signInAnonymously(
                  context,
                  enableWaitingScreen: false,
                ),
              */
              SizedBox(height: 30),
              Text(
                "Phone Authentication",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.white,
                width: 400,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: phoneNumberController,
                        decoration:
                            InputDecoration(hintText: '+CC Phone Number'),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    //Use this Widget to create a SignInButton if needed, for example,
                    //we used it to create the Phone SignIn button
                    GenericSignInButton(
                      name: 'Phone SignIn',
                      initiator: (context) {
                        //This is how you initiate a PhoneNumberSignIn
                        AuthController.signInWithPhoneNumber(
                          context,
                          phoneNumber: phoneNumberController.value.text,
                          onError: (e) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("PhoneAuth Error Occured"),
                                content: Text(e),
                              ),
                            );
                          },
                          onInvalidVerificationCode: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Invalid OTP"),
                                content: Text(
                                  "The SMSCode or OTP that you provided is Wrong, please try again",
                                ),
                              ),
                            );
                          },
                          closeVerificationPopupAfterSubmit: false,
                          //Callback for a Successful SignIn
                          onSignInSuccessful: (user) {
                            print(
                              "PhoneSignIn Successful!!! Phone: ${user.phoneNumber}",
                            );
                          },
                        );
                      },
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green[500],
                      customString: 'Phone SignIn',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Register With Email & Password",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: kIsWeb ? 100 : 0),
                child: Column(
                  children: [
                    TextField(
                      controller: regEmailController,
                      decoration: InputDecoration(hintText: 'Register Email'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: regPassController,
                      decoration:
                          InputDecoration(hintText: 'Register Password'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        //This is how you register with Email&Password
                        AuthController.registerWithEmailAndPassword(
                          context,
                          email: regEmailController.value.text,
                          password: regPassController.value.text,
                          onError: (String e) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Error Occured"),
                                content: Text(e),
                              ),
                            );
                          },
                          onRegisterSuccessful: (user) {
                            print(
                                "Successfully Registered Email: ${user.email}");
                          },
                        );
                      },
                      child: Text("Register & Login"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Login With Email & Password",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: kIsWeb ? 100 : 0),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(hintText: 'SignIn Email'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: passController,
                      decoration: InputDecoration(hintText: 'SignIn Password'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        //This is how you signIn with Email & Password
                        AuthController.signInWithEmailAndPassword(
                          context,
                          email: emailController.value.text,
                          password: passController.value.text,
                          onIncorrectCredentials: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Incorrect Credentials"),
                                content: Text(
                                  "Either the Email, password is incorrect or this combination does not exist. Please try again",
                                ),
                              ),
                            );
                          },
                          onError: (String e) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Error Occured"),
                                content: Text(e),
                              ),
                            );
                          },
                          //Callback for a Successful SignIn
                          onSignInSuccessful: (user) {
                            print(
                              "Email SignIn Successful!!! Email: ${user.email}",
                            );
                          },
                        );
                      },
                      child: Text("Login"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Use AuthController.logout(context) to logout from anywhere
              GenericSignInButton(
                name: 'Logout',
                initiator: (context) => AuthController.logout(
                  context,
                ),
                foregroundColor: Colors.white,
                backgroundColor: Colors.red[700],
                customString: 'Logout',
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          //Logout
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthController.logout(
                context,
                onLogout: () {
                  print("Logout Successful");
                },
              );
            },
          ),

          IconButton(
            icon: Icon(Icons.person),
            onPressed: () async {
              print(
                AuthController.getCurrentUser(
                  context,
                  //Use the customMapping arguement to create your own User Representation from Firebase User
                  // customMapping: (user) => {
                  //   'email': user.email,
                  //   'name': user.displayName,
                  // },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
