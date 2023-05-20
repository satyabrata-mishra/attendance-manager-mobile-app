//The purpose of this screen is to switch between home and profile in BottomNavigationBar.
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../widgets/snackbar_widget.dart';

import './signin_screen.dart';
import './home_screen.dart';
import './profile_screen.dart';

class SwitchScreen extends StatefulWidget {
  const SwitchScreen({Key? key}) : super(key: key);
  static const routeName = "/switch-screen";

  @override
  State<SwitchScreen> createState() => _SwitchScreenState();
}

class _SwitchScreenState extends State<SwitchScreen> {
  var _index = 0;
  final user = FirebaseAuth.instance.currentUser;
  var attended = 0, total = 0;
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushNamed(context, SignInScreen.routeName);
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _index == 0 ? HomeScreen() : ProfileScreen(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        backgroundColor: const Color.fromRGBO(97, 53, 124, 1),
        currentIndex: _index,
        onTap: (val) {
          setState(() {
            _index = val;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Account",
          )
        ],
      ),
    );
  }
}
