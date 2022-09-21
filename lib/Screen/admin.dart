import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_fire/model/showDataFire.dart';
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
  User? user;
  bool staus = false;
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loaddata();
  }

  loaddata() {
    FirebaseAuth load = FirebaseAuth.instance;
    user = load.currentUser;
    if (user == null) {
      user!.reload();
    }
    setState(() {
      staus = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  StreamBuilder(
        stream: FirebaseFirestore.instance.collection("user").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Somthing is Laoding'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;

            return ListView.builder(
              itemCount: user.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot = user.docs[index];

                UserModel userModel = UserModel.fromJson(
                    documentSnapshot.data() as Map<String, dynamic>);
                return ListTile(
                  trailing: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                title: Text("Delet Your Acount"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        final docuser = FirebaseFirestore
                                            .instance
                                            .collection('user')
                                            .doc(documentSnapshot.id);
                                        docuser.delete();
                                        Navigator.pop(context);
                                      },
                                      child: Text("Yes")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("No")),
                                ]);
                          },
                        );
                      },
                      icon: Icon(Icons.delete)),
                  leading: userModel.userImg != null
                      ? Image.network("${userModel.userImg}")
                      : Icon(
                    Icons.manage_accounts_outlined,
                    size: 50,
                  ),
                  title: (userModel.email.toString().isNotEmpty)
                      ? Text("")
                      : const Text("No Email"),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      // (staus)
      //     ? ListView(
      //         children: [
      //           ListTile(
      //             title: Text("${user!.email}"),
      //           ),
      //           ElevatedButton(
      //               onPressed: () {
      //                 if () {
      //                   widget.tabController.animateTo(1);
      //                 } else {
      //                   widget.tabController.animateTo(2);
      //                 }
      //               },
      //               child: Text("Admin"))
      //         ],
      //       )
      //     : Center(child: CircularProgressIndicator()),
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
