import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_fire/service/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

class firstlogin extends StatefulWidget {
  TabController tabController;

  firstlogin(this.tabController);

  @override
  State<firstlogin> createState() => _firstloginState();
}

class _firstloginState extends State<firstlogin> {
  TextEditingController User_name = TextEditingController();
  TextEditingController phone = TextEditingController();
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
                controller: User_name,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                    hintText: 'Enter valid mail id as abc@gmail.com'),
              ),
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
                controller: phone,
                //obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone',
                    hintText: 'Enter your secure phone'),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Forgot Password.',
                style: TextStyle(fontSize: 15),
              ),
            ),
            ElevatedButton(onPressed: () {}, child: Text("Sumbit")),
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
