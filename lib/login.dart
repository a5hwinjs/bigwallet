import 'dart:html';
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
    isLoggedin= await googleSignIn.isSignedIn();

    if(isLoggedin){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Homepage()));
    }

    setState(() {
      loading=false;
    });

    Future handleSignIn() async{
      preferences = await SharedPreferences.getInstance();

      setState(() {
        loading=true;
      });
      GoogleSignInAccount googleUser = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication= await googleUser.authentication;
      FirebaseUser firebaseUser = await firebaseAuth.signInWithGoogle(
        idToken:googleSignInAuthentication.idToken,accessToken:googleSignInAuthentication.accessToken
      );
      if (firebaseUser !=null){

        final QuerySnapshot result =await Firestore.instance.collection("users").where("id", isEqualTo: firebaseUser.uid).getDocuments();
        final List<DocumentSnapshot> documents= result.documents;

        if (documents.length== 0){
           Firestore.instance.collection("users").document(firebaseUser.uid).setData({
             "id":firebaseUser.uid,
             "username":firebaseUser.displayName,
             "profilePicture":firebaseUser.photoUrl

           });

           await preferences.setString("id", firebaseUser.uid);
           await preferences.setString("username",firebaseUser.displayName);
           await preferences.setString("photourl",firebaseUser.photoUrl);
        }
        else{
           await preferences.setString("id", documents[0]["id"]);
           await preferences.setString("username",documents[0]["username"]);
           await preferences.setString("photourl",documents[0]["profilepicture"]);
        }

        Fluttertoast.showToast(msg:"Logged in");
        setState(() {
          loading=false;
        });

        Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context)=>Homepage()));
      }else{
            Fluttertoast.showToast(msg: "Login failed");

      }
      
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: new Text("Login",style: TextStyle(color: Colors.amber),),
        elevation: 0.1,
      ),
      body: Stack(
        children<Widget>[
          Center(child: FlatButton(
            color: Colors.red.shade900,
            onPressed: (){
              handleSignIn();
            }
          ),)
        ]
      )
      
    );
  }
}