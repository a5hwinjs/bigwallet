import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';




class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences preferences;
  bool loading = false;
  bool isLoggedin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSignedin();
    
  }
  void isSignedin() async{
    setState(() {
      loading=true;
    });
    preferences=await SharedPreferences.getInstance();
    
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}