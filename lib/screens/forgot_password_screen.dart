import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/snackbar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/image_widget.dart';
import '../widgets/textfield_widget.dart';

import '../utils/colors_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  static const routeName="/forgot-password-screen";

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();

  var isLoading = false;

  void sendPasswordResetLink() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _email.text)
          .then((value) {
        snackbarWidget(context, "Link sent to ${_email.text}", Colors.green);
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
      if (str == "firebase_auth/user-not-found") {
        snackbarWidget(context, "No such email registered.", Colors.red);
      } else if (str == "firebase_auth/invalid-email") {
        snackbarWidget(context, "Invalid email.", Colors.red);
      } else if (str == "firebase_auth/unknown") {
        snackbarWidget(context, "Please enter a valid email.", Colors.red);
      } else {
        snackbarWidget(context, "Some unknown error occurred.", Colors.red);
      }
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
        //   "Forgot password",
        //   style: TextStyle(
        //     fontSize: 24,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
      ),
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
              MediaQuery.of(context).size.height * 0.15,
              20,
              0,
            ),
            child: Column(
              children: [
                imageWidget("lib/assets/forgot-password.png", context),
                const SizedBox(height: 20),
                textfieldWidget(
                    "Enter Email", Icons.email_outlined, false, _email),
                buttonWidget(
                  context,
                  "SEND PASSWORD RESET LINK",
                  sendPasswordResetLink,
                  isLoading,
                  14.5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}