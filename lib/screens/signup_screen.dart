import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import './switch_screen.dart';

import '../widgets/button_widget.dart';
import '../widgets/snackbar_widget.dart';
import '../widgets/google_button.dart';
import '../widgets/image_widget.dart';
import '../widgets/textfield_widget.dart';

import '../utils/colors_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const routeName = "/signup-screen";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

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
        .then((value) => snackbarWidget(context, msg, Colors.red));
  }

  void _signup() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (_username.text.isEmpty) {
        handle_error("Username cannot be empty.");
        setState(() {
          isLoading = false;
        });
        return;
      }
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _email.text, password: _password.text)
          .then((value) async {
        await FirebaseAuth.instance.currentUser
            ?.updateDisplayName(_username.text)
            .then((value) {
          Navigator.pushNamed(context, SwitchScreen.routeName);
        });
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
      if (_username.text.isEmpty) {
        handle_error("Please give a valid username.");
      } else if (str == "firebase_auth/unknown") {
        handle_error("Please enter a valid email or password.");
      } else if (str == "firebase_auth/network-request-failed") {
        handle_error("Please check your internet connection.");
      } else if (str == "firebase_auth/email-already-in-use") {
        handle_error("This email belongs to someone else.");
      } else if (str == "firebase_auth/weak-password") {
        handle_error("Please give a strong password.");
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // title: const Text(
        //   "Signup",
        //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        // ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
              MediaQuery.of(context).size.height * 0.10,
              20,
              0,
            ),
            child: Column(
              children: [
                imageWidget("lib/assets/signup.webp", context),
                textfieldWidget(
                    "Enter Username", Icons.person_outline, false, _username),
                const SizedBox(
                  height: 20,
                ),
                textfieldWidget(
                    "Enter Email", Icons.email_outlined, false, _email),
                const SizedBox(
                  height: 20,
                ),
                textfieldWidget(
                    "Enter Password", Icons.lock_outline, true, _password),
                buttonWidget(
                  context,
                  "SIGNUP",
                  _signup,
                  isLoading,
                  16,
                ),
                googleButton(
                  context,
                  googleSignin,
                  isLoading1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
