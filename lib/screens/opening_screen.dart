import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/loading_widget.dart';

import 'switch_screen.dart';
import 'signin_screen.dart';

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({Key? key}) : super(key: key);
  static const routeName = "/";

  @override
  State<OpeningScreen> createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> {
  final user = FirebaseAuth.instance.currentUser;
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
        () => user == null
            ? Navigator.pushNamed(context, SignInScreen.routeName)
            : Navigator.pushNamed(context, SwitchScreen.routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.blueGrey,
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.04, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "lib/assets/attendance-logo.png",
              height: MediaQuery.of(context).size.height * 0.5,
              fit: BoxFit.contain,
            ),
            loadingWidget(MediaQuery.of(context).size.height * 0.08),
          ],
        ),
      ),
    );
  }
}
