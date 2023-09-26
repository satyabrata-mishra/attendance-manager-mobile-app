import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './snackbar_widget.dart';

void _logout(BuildContext context) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.question,
    animType: AnimType.scale,
    title: 'Confirm Logout?',
    btnCancelOnPress: () {},
    btnOkOnPress: () async {
      try {
        await FirebaseAuth.instance.signOut();
      } catch (err) {
        snackbarWidget(context, "Some unknown error occurred. ", Colors.red);
      }
    },
    btnCancelText: "CANCEL",
    btnOkText: "OK",
  ).show();
}

Drawer drawer_widget(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;
  return Drawer(
    width: MediaQuery.of(context).size.width * 0.65,
    backgroundColor: const Color.fromRGBO(140, 38, 204, 0.6),
    child: ListView(
      children: [
        DrawerHeader(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 40,
                  backgroundImage: user?.photoURL == null
                      ? const AssetImage("lib/assets/image-not-avaliable.png")
                      : NetworkImage(user?.photoURL as String)
                          as ImageProvider<Object>?,
                ),
              ),
              Text(
                user?.displayName as String,
                style: const TextStyle(
                    fontSize: 22,
                    letterSpacing: 0.6,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                user?.email as String,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.white,
          indent: 20,
          endIndent: 20,
        ),
        ListTile(
          iconColor: Colors.white,
          leading: const Icon(Icons.logout),
          title: const Text(
            "LOGOUT",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 0.8,
            ),
          ),
          onTap: () {
            _logout(context);
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.50,
        ),
        ListTile(
          leading: const Icon(
            Icons.verified_outlined,
            color: Colors.white,
          ),
          title: const Text(
            "Version 1.0.2",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 0.8,
            ),
          ),
          enabled: false,
        ),
      ],
    ),
  );
}
