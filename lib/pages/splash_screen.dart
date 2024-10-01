import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn1/pages/login_page.dart';

import 'home_page.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 3),(){

      if(FirebaseAuth.instance.currentUser!=null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
      }

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueGrey[900],
        child: Center(
          child: Text(
            'CryptoCrew',
            style: TextStyle(
              color: const Color(0xFF10A37F),
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
