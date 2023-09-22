import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

import './screens/opening_screen.dart';
import './screens/switch_screen.dart';
import './screens/forgot_password_screen.dart';
import './screens/profile_screen.dart';
import './screens/home_screen.dart';
import './screens/signup_screen.dart';
import './screens/signin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Manager App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: HomeScreen(),
      routes: {
        OpeningScreen.routeName:(context) => OpeningScreen(),
        SignInScreen.routeName: (context) => SignInScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
        SwitchScreen.routeName: (context) => SwitchScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        ProfileScreen.routeName: (context) => ProfileScreen(),
      },
    );
  }
}
