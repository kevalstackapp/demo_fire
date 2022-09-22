import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_fire/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class admin extends StatefulWidget {
  TabController tabController;

  admin(this.tabController);

  @override
  State<admin> createState() => _adminState();
}

class _adminState extends State<admin> {
  bool staus = false;
  UserModel? userModel;

  String auth = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("user").doc(auth).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Somthing is Laoding'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            UserModel userModel =
                UserModel.fromJson(user.data() as Map<String, dynamic>);
            return ListView(
              children: [
                ListTile(
                  title: Text("${userModel.email}"),
                ),
                Container(
                  height: 100,
                  width: 100,
                  child: (userModel.name == "Admin")
                      ? Align(heightFactor: 50,
                        widthFactor: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              if (userModel.name == "Admin") {
                                widget.tabController.animateTo(1);
                              } else {
                                widget.tabController.animateTo(2);
                              }
                            },
                            child: Text("Admin")),
                      )
                      : Text("You Are not Admin"),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await GoogleSignIn().signOut();
            widget.tabController.animateTo(0);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();
          },
          child: Icon(Icons.logout)),
    );
  }
}
