import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';

class Userpage extends StatefulWidget {
  TabController tabController;

  Userpage(this.tabController);

  @override
  State<Userpage> createState() => _UserpageState();
}

class _UserpageState extends State<Userpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("user").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Text('Somthing is Laoding', style: GoogleFonts.alice()));
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
                                title: Text("Delete Your Acount",
                                    style: GoogleFonts.alice()),
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
                                      child: Text("Yes",
                                          style: GoogleFonts.alice())),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("No",
                                          style: GoogleFonts.alice())),
                                ]);
                          },
                        );
                      },
                      icon: Icon(Icons.delete)),
                  leading: userModel.userImg != null
                      ? Image.network("${userModel.userImg}")
                      : Icon(
                          Icons.account_box,
                          size: 50,
                        ),
                  title: (userModel.email.toString().isNotEmpty)
                      ? Text("${userModel.email}", style: GoogleFonts.alice())
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
