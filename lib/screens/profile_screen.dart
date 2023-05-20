import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../utils/colors_utils.dart';
import '../utils/constants.dart';

import '../widgets/snackbar_widget.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profile-screen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? user = FirebaseAuth.instance.currentUser;
  var isLoading = false;
  var attended = 0, total = 0;

  @override
  void initState() {
    fetchAllSubjects();
    super.initState();
  }

  void fetchAllSubjects() async {
    try {
      var url = Uri.https(host, '/attendance/get/${user?.email}');
      await http.get(url).then((value) {
        List response = json.decode(value.body);
        int a = 0, b = 0;
        for (int i = 0; i < response.length; i++) {
          a += int.parse(response[i]["attended"].toString());
          b += int.parse(response[i]["classes"].toString());
        }
        setState(() {
          attended = a;
          total = b;
        });
      });
    } catch (err) {
      snackbarWidget(
          context, "Some internal error occurred.Try again later.", Colors.red);
    }
  }

  void sendEmailVerificationLink() async {
    try {
      setState(() {
        isLoading = true;
      });
      FirebaseAuth.instance.currentUser?.sendEmailVerification().then((value) {
        setState(() {
          isLoading = false;
        });
        snackbarWidget(context,
            "Email verification link sent to ${user?.email}", Colors.green);
      });
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      snackbarWidget(context, err.toString(), Colors.red);
    }
  }

  Color darkColor = const Color(0xFF49535C);

  @override
  Widget build(BuildContext context) {
    const montserrat = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
    return Scaffold(
      body: Material(
        child: Container(
          height: double.infinity,
          width: double.infinity,
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150,
                      child: Stack(
                        children: [
                          ClipPath(
                            clipper: AvatarClipper(),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: darkColor,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 11,
                            top: 50,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: darkColor,
                                  backgroundImage: user?.photoURL == null
                                      ? const AssetImage(
                                          "lib/assets/image-not-avaliable.png")
                                      : NetworkImage(user?.photoURL as String)
                                          as ImageProvider<Object>?,
                                ),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user?.displayName as String,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      user?.email as String,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: darkColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 30,
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Account Created : \n Last Signin : ",
                                style: montserrat,
                              ),
                              const SizedBox(height: 16),
                              user?.emailVerified as bool
                                  ? const Text(
                                      "Email verified:",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : const Text(
                                      "Email verified:",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('yyyy-MM-dd – kk:mm').format(
                                    user?.metadata.creationTime as DateTime),
                                style: montserrat,
                              ),
                              Text(
                                DateFormat('yyyy-MM-dd – kk:mm').format(
                                    user?.metadata.lastSignInTime as DateTime),
                                style: montserrat,
                              ),
                              const SizedBox(height: 16),
                              user?.emailVerified as bool
                                  ? const Text(
                                      "Yes",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : const Text(
                                      "No",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                attended.toString(),
                                style: buildMontserrat(
                                  const Color(0xFF000000),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Attended",
                                style: buildMontserrat(darkColor),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                            child: VerticalDivider(
                              thickness: 3,
                              color: Color(0xFF9A9A9A),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                total.toString(),
                                style: buildMontserrat(
                                  const Color(0xFF000000),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Classes",
                                style: buildMontserrat(darkColor),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: user?.emailVerified as bool
          ? Container()
          : CircleAvatar(
              radius: 30,
              backgroundColor: Colors.black54,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : IconButton(
                      onPressed: () {
                        sendEmailVerificationLink();
                      },
                      icon: const Icon(
                        Icons.send_to_mobile,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  TextStyle buildMontserrat(
    Color color, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: 18,
      color: color,
      fontWeight: fontWeight,
    );
  }
}

class AvatarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height)
      ..lineTo(8, size.height)
      ..arcToPoint(Offset(114, size.height), radius: Radius.circular(1))
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
