import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_fire/Home_start/resetpasword.dart';
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
  bool staus = false;

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
                obscureText: staus,
                decoration: InputDecoration(
                    suffix: IconButton(
                      icon: Icon(
                        staus ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          staus = !staus;
                        });
                      },
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'password',
                    hintText: 'Enter your secure password'),
              ),
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

                  UserModel userModel = UserModel(
                    email: email.text,
                    phone: password.text,
                  );
                  createUsedata(userModel);
                  widget.tabController.animateTo(1);
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
                        action: SnackBarAction(
                          label: 'Action',
                          onPressed: () {},
                        ),
                      ),
                    );
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');

                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email.text, password: password.text)
                          .then((value) async {
                        widget.tabController.animateTo(1);

                        UserModel userModel = UserModel(
                          email: email.text,
                          phone: password.text,
                        );
                        if (userModel.uId == null) {
                          createUsedata(userModel);
                        }

                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString("login", "Yes");
                      });

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
                            action: SnackBarAction(
                              label: 'Action',
                              onPressed: () {},
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
                style: TextStyle(fontSize: 15),
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
    final firestore = FirebaseFirestore.instance.collection("user").doc();

    userModel.uId = firestore.id;
    final json = userModel.toJson();
    await firestore.set(json);
  }
}
