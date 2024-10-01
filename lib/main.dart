import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn1/pages/home_page.dart';
import 'package:learn1/pages/login_page.dart';
import 'package:learn1/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(); // Use await to initialize Firebase
  } catch (e) {
    print("Firebase initialization error: $e"); // Handle error if necessary
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      routes: <String, WidgetBuilder>{
        "/": (context) => SplashScreen(),
        "/home": (context) => HomePage(), // Add HomePage route
        "/login": (context) => LoginPage(), // Add LoginPage route
      },
    );
  }
}
