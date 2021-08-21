import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/screens/landing_screen.dart';
import 'package:untitled/screens/welcome_screen.dart';
import 'package:untitled/services/user_services.dart';

import '../constants.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id ='splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User ? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    Timer(
        Duration(seconds: 3,
        ),(){
      FirebaseAuth.instance.authStateChanges().listen((user){
        if (user==null){
          Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        }
        else {
          getUserData();
        }
      });
    }
    );
    super.initState();
  }
  getUserData()async{
    final UserServices _userServices = UserServices();
    if (user != null ) {
      _userServices.getUserById(user!.uid).then((result) {
      if(result['address']!=null){
        updatePrefs(result);
      }
      Navigator.pushReplacementNamed(context, LandingScreen.id);
    });
    }
  }

  Future<void>updatePrefs(result)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', result['latitude']);
    prefs.setDouble('longitude', result['longitude']);
    prefs.setString('address', result['address']);
    prefs.setString('location', result['location']);
    Navigator.pushReplacementNamed(context, MainScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('images/logo.png'),
              Text('Aggricus',style: kPageViewTextStyle2,)
            ],


          )
      ),
    );
  }
}