import 'package:firebase_core/firebase_core.dart';
import 'shared/firebase_authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _message = '';
  bool _isLogin = true;

  final TextEditingController txtUserName = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  FirebaseAuthentication auth = FirebaseAuthentication();

  @override
  void initState() {
    // Creates an instance of a Firebase app
    Firebase.initializeApp().whenComplete(() {
      // When the method completes, it'll set auth FirebaseAuthenticatio so that
      // it takes a new instance of Fireabse Authentication
      auth = FirebaseAuthentication();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout().then((value) {
                if (value) {
                  setState(() {
                    _message = 'Logged Out';
                  });
                } else {
                  _message = 'Unable to Log Out';
                }
              });
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(36),
        child: ListView(
          children: [
            userInput(),
            passwordInput(),
            btnMain(),
            btnSecondary(),
            txtMessage(),
            btnGoogle(),
          ],
        ),
      ),
    );
  }

// Username widget
  Widget userInput() {
    return Padding(
        padding: const EdgeInsets.only(top: 150),
        child: TextFormField(
          controller: txtUserName,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
              hintText: 'Email Address', icon: Icon(Icons.verified_user)),
          validator: (String? text) => text!.isEmpty ? 'Email is required' : '',
        ));
  }

// Password widget
  Widget passwordInput() {
    return Padding(
        padding: const EdgeInsets.only(top: 24),
        child: TextFormField(
          controller: txtPassword,
          keyboardType: TextInputType.emailAddress,
          obscureText: true,
          decoration: const InputDecoration(
              hintText: 'Password', icon: Icon(Icons.enhanced_encryption)),
          validator: (text) => text!.isEmpty ? 'Password is required' : '',
        ));
  }

// Main button widget
  Widget btnMain() {
    String btnText = _isLogin ? 'Log in' : 'Sign up';
    return Padding(
        padding: const EdgeInsets.only(top: 128),
        child: SizedBox(
            height: 60,
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                child: Text(
                  btnText,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () {
                  String userId = '';
                  if (_isLogin) {
                    auth
                        .login(txtUserName.text, txtPassword.text)
                        .then((value) {
                      if (value == null) {
                        setState(() {
                          _message = 'Login Error';
                        });
                      } else {
                        userId = value;
                        setState(() {
                          _message = 'User $userId successfully logged in';
                        });
                      }
                    });
                  } else {
                    auth
                        .createUser(txtUserName.text, txtPassword.text)
                        .then((value) {
                      if (value == null) {
                        setState(() {
                          _message = 'Registration Error';
                        });
                      } else {
                        userId = value;
                        setState(() {
                          _message = 'User $userId successfully signed in';
                        });
                      }
                    });
                  }
                })));
  }

// Secondary button widget
  Widget btnSecondary() {
    String buttonText = _isLogin ? 'Sign up' : 'Log In';
    return TextButton(
      child: Text(buttonText),
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
        });
      },
    );
  }

// Google Sign-in button widget
  Widget btnGoogle() {
    return Padding(
        padding: const EdgeInsets.only(top: 24),
        child: SizedBox(
            height: 60,
            child: Container(
                color: Colors.white,
                child: SignInButton(
                  Buttons.Google,
                  onPressed: () {
                    auth.loginWithGoogle().then((value) {
                      if (value == null) {
                        setState(() {
                          _message = 'Google login Error';
                        });
                      } else {
                        setState(() {
                          _message = 'Successfully logged in with Google';
                        });
                      }
                    });
                  },
                ))));
  }

// Validation message widget
  Widget txtMessage() {
    return Text(
      _message,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).errorColor,
          fontWeight: FontWeight.bold),
    );
  }
}
