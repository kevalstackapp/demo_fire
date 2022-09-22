import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'resetpasword.dart';
import '../model/user_model.dart';

class firstlogin extends StatefulWidget {
  TabController tabController;

  firstlogin(this.tabController);

  @override
  State<firstlogin> createState() => _firstloginState();
}

class _firstloginState extends State<firstlogin> {
  bool staus = true;

  String admins = "User";
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              child: Lottie.asset("asset/107723-logindvdvd.json", width: 200),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: email,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter your secure Email'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: password,
                obscureText: staus,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        staus ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          staus = !staus;
                        });
                      },
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'password',
                    hintText: 'Enter your secure password'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: "Admin",
                  groupValue: admins,
                  onChanged: (value) {
                    setState(() {
                      admins = value.toString();
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                  width: 50,
                  child: Text("Admin", style: GoogleFonts.alice()),
                ),
                Radio(
                  value: "User",
                  groupValue: admins,
                  onChanged: (value) {
                    setState(() {
                      admins = value.toString();
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                  width: 30,
                  child: Text(
                    "User",
                    style: GoogleFonts.alice(),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return resetPasword();
                  },
                ));
              },
              child: Text(
                'Forget Password.',
                style: GoogleFonts.alice(textStyle: TextStyle(fontSize: 15)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                bool emailvalidate = RegExp(
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                    .hasMatch(email.text);

                if (emailvalidate == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 3),
                      content: const Text(
                        'Your Email are not validate',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                } else if (password.text == "") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 3),
                      content: const Text(
                        'Password not Enter',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                } else {
                  CircularProgressIndicator();
                }

                try {
                  final credential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email.text,
                    password: password.text,
                  );
                  print(credential);

                  UserModel userModel = UserModel(
                      email: email.text,
                      phone: password.text,
                      uId: credential.user!.uid,
                      name: admins);
                  createUsedata(userModel);

                  widget.tabController.animateTo(2);

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString("login", "Yes");
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 3),
                        content: const Text(
                          'weak-password',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');

                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email.text, password: password.text);

                      UserModel userModel = UserModel(
                          email: email.text,
                          phone: password.text,
                          uId: credential.user!.uid,
                          name: admins);

                      if (userModel.uId == credential.user!.uid) {
                        createUsedata(userModel);
                      }

                      widget.tabController.animateTo(2);

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString("login", "Yes");

                      print(credential);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 3),
                            content: const Text(
                              'wrong-password',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      }
                    }
                  }
                } catch (e) {
                  print(e);
                }
                email.clear();
                password.clear();
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Text(
                "Login",
                style:GoogleFonts.alice(textStyle: TextStyle(fontSize: 15)),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  UserCredential? logn = await signInWithGoogle();
                  if (logn.user != null) {
                    UserModel userModel = UserModel(
                      uId: logn.user!.uid,
                      name: logn.user!.displayName,
                      email: logn.user!.email,
                      phone: logn.user!.phoneNumber,
                      userImg: logn.user!.photoURL,
                    );
                    createUse(userModel);
                    widget.tabController.animateTo(2);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString("login", "Yes");
                  } else {
                    CircularProgressIndicator();
                  }
                },
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: Image.asset("asset/google (1).png"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 45, top: 17),
                      child: SizedBox(
                        height: 40,
                        width: 125,
                        child: Text("Sign in with Google", style: GoogleFonts.alice()),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future createUse(UserModel userModel) async {
    final firestore =
        FirebaseFirestore.instance.collection("user").doc("${userModel.uId}");

    await firestore.set(userModel.toJson());
  }

  Future createUsedata(UserModel userModel) async {
    final firestore =
        FirebaseFirestore.instance.collection("user").doc(userModel.uId);

    await firestore.set(userModel.toJson());
  }
}
