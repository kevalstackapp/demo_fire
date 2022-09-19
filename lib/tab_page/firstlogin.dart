import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_fire/Home_start/resetpasword.dart';
import 'package:demo_fire/Home_start/userLogin.dart';
import 'package:demo_fire/service/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class firstlogin extends StatefulWidget {
  TabController tabController;

  firstlogin(this.tabController);

  @override
  State<firstlogin> createState() => _firstloginState();
}

class _firstloginState extends State<firstlogin> {

  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: email,
                //obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter your secure Email'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: password,
                //obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone',
                    hintText: 'Enter your secure phone'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return resetPasword();
                },));

              },
              child: Text(
                'Forget Password.',
                style: TextStyle(fontSize: 15),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final credential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email.text, password: password.text).then((value) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return userLogin();
                      },
                    ));
                  });

                  print(credential);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided for that user.');
                  }
                }
              },
              child: Text(
                "Login",
                style: TextStyle(fontSize: 15),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );
                    print(credential);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text("Sumbit")),
            ElevatedButton(
                onPressed: () async {
                  UserCredential? logn = await signInWithGoogle();
                  if (logn.user != null) {
                    UserModel userModel = UserModel(
                        uId: logn.user!.uid,
                        name: logn.user!.displayName,
                        email: logn.user!.email,
                        phone: logn.user!.phoneNumber,
                        userImg: logn.user!.photoURL);
                    createUse(userModel);
                    widget.tabController.animateTo(1);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString("login", "Yes");
                  }
                },
                child: Text("Google to Login.."))
          ],
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    print(credential);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future createUse(UserModel userModel) async {
    final firestore =
        FirebaseFirestore.instance.collection("user").doc("${userModel.uId}");

    await firestore.set(userModel.toJson());
  }
}
