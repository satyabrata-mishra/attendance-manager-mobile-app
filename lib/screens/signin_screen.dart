import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import './forgot_password_screen.dart';
import './signup_screen.dart';
import './switch_screen.dart';

import '../utils/colors_utils.dart';

import '../widgets/google_button.dart';
import '../widgets/snackbar_widget.dart';
import '../widgets/textfield_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/image_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);
  static const routeName = "/sign-in";

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  var isLoading = false, isLoading1 = false;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushNamed(context, SwitchScreen.routeName);
      }
    });
    // TODO: implement initState
    super.initState();
  }

  void handle_error(String msg) {
    Future.delayed(Duration.zero)
        .then((value) => snackbarWidget(context, msg, Colors.redAccent));
  }

  void _login() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailTextController.text,
              password: _passwordTextController.text)
          .then((value) {
        Navigator.pushNamed(context, SwitchScreen.routeName);
      });
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      final str = err.toString().substring(
          err.toString().indexOf("[") + 1, err.toString().indexOf("]"));
      if (str == "firebase_auth/unknown") {
        handle_error("Please enter a valid email or password.");
      } else if (str == "firebase_auth/network-request-failed") {
        handle_error("Please check your internet connection.");
      } else if (str == "firebase_auth/user-not-found") {
        handle_error("This email doesn't exists.");
      } else if (str == "firebase_auth/wrong-password") {
        handle_error("Wrong password.");
      } else {
        handle_error("Some unknown error occurred.");
      }
    }
  }

  void googleSignin() async {
    try {
      setState(() {
        isLoading1 = true;
      });
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(credentials);
      if (user.user != null) {
        Navigator.pushNamed(context, SwitchScreen.routeName);
      }
      setState(() {
        isLoading1 = false;
      });
    } catch (err) {
      setState(() {
        isLoading1 = false;
      });
      handle_error("Some internal error occurred. Please try again later.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61f4"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.1,
              20,
              0,
            ),
            child: Column(
              children: [
                imageWidget("lib/assets/login.png", context),
                const SizedBox(
                  height: 30,
                ),
                textfieldWidget("Enter Email", Icons.email_outlined, false,
                    _emailTextController),
                const SizedBox(
                  height: 10,
                ),
                textfieldWidget("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 5,
                ),
                buttonWidget(
                  context,
                  "LOGIN",
                  _login,
                  isLoading,
                  16,
                ),
                googleButton(
                  context,
                  googleSignin,
                  isLoading1,
                ),
                signUpOption(),
                forgotPassword(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have a account?",
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, SignUpScreen.routeName);
          },
          child: const Text(
            " Signup",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Padding forgotPassword() {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ForgotPasswordScreen.routeName);
          },
          child: const Text(
            "Forgot Password?",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          )),
    );
  }
}
