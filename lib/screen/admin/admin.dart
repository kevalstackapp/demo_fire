// 180 video compalet
// 181 then pening

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_fire/model/user_model.dart';
import 'package:demo_fire/screen/admin/admin_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:image_picker/image_picker.dart';

class admin extends StatefulWidget {
  TabController tabController;

  admin(this.tabController);

  @override
  State<admin> createState() => _adminState();
}

class _adminState extends State<admin> {
  String auth = FirebaseAuth.instance.currentUser!.uid;
  bool stsus = false;
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  ImagePicker picker = ImagePicker();
  String? immurl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: stsus
            ? StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("user")
              .doc(auth)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Text('Somthing is Laoding',
                      style: GoogleFonts.alice()));
            } else if (snapshot.hasData) {
              final user = snapshot.data!;
              UserModel userModel =
              UserModel.fromJson(user.data() as Map<String, dynamic>);

              return
                SingleChildScrollView(
                  child: Column(children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                title: Text("Choose your imgage",
                                    style: GoogleFonts.alice()),
                                actions: [
                                  IconButton(
                                    onPressed: () async {
                                      final XFile? photo =
                                      await picker.pickImage(
                                          source: ImageSource.camera);
                                      var file = File(photo!.path);

                                      if (photo != null) {
                                        var snapshot = await FirebaseStorage
                                            .instance
                                            .ref()
                                            .child('files/${photo.name}')
                                            .putFile(file);
                                        print("ok");
                                        var downloadUrl = await snapshot.ref
                                            .getDownloadURL();

                                        setState(() {
                                          immurl = downloadUrl;
                                        });
                                        Navigator.pop(context);
                                      }
                                    },
                                    icon: Icon(Icons.camera),
                                    iconSize: 40,
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final XFile? photo =
                                      await picker.pickImage(
                                          source: ImageSource.gallery);
                                      var file = File(photo!.path);

                                      if (photo != null) {
                                        var snapshot = await FirebaseStorage
                                            .instance
                                            .ref()
                                            .child('files/${photo.name}')
                                            .putFile(file);
                                        print("ok");
                                        var downloadUrl = await snapshot.ref
                                            .getDownloadURL();

                                        setState(() {
                                          immurl = downloadUrl;
                                        });
                                        Navigator.pop(context);
                                      }
                                    },
                                    icon: Icon(Icons.photo_album),
                                    iconSize: 40,
                                  ),
                                ]);
                          },
                        );
                      },
                      icon: immurl != null
                          ? Container(
                          height: 100,
                          child: Image.network(
                            "${immurl}",
                          ))
                          : Image.asset(
                        "asset/download.png",
                        height: 100,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        initialValue: userModel.email,
                        decoration: InputDecoration(
                          enabled: false,
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: name,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'name',
                            hintText: ''),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: phone,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'phone',
                            hintText: ''),
                      ),
                    ),
                    Center(
                        child: ElevatedButton(
                            onPressed: () async {
                              stsus = false;
                              setState(() {});
                              FirebaseFirestore.instance
                                  .collection("user")
                                  .doc(auth)
                                  .update({
                                'name': name.text,
                                'phone': phone.text,
                                'userImg': immurl
                              });
                            },
                            child: Text("Update")))
                  ]),
                );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
            : StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("user")
              .doc(auth)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Text('Somthing is Laoding',
                      style: GoogleFonts.alice()));
            } else if (snapshot.hasData) {
              final user = snapshot.data!;
              UserModel userModel =
              UserModel.fromJson(user.data() as Map<String, dynamic>);
              return ListView(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: (userModel.userImg != null)
                        ? Image.network("${userModel.userImg}")
                        : Icon(Icons.account_box, size: 100),
                  ),
                  ListTile(
                    leading: Text("Email:"),
                    title: Text("${userModel.email}",
                        style: GoogleFonts.alice()),
                  ),
                  ListTile(
                    leading: Text("Name:"),
                    title: (userModel.name != null)
                        ? Text("${userModel.name}",
                        style: GoogleFonts.alice())
                        : Text(""),
                  ),
                  ListTile(
                    leading: Text("Phone:"),
                    title: (userModel.name != null)
                        ? Text("${userModel.phone}",
                        style: GoogleFonts.alice())
                        : Text(""),
                  ),
                  Container(
                    height: 20,
                    width: 100,
                    child: (userModel.admin == "Admin")
                        ? Align(
                      heightFactor: 50,
                      widthFactor: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            if (userModel.admin == "Admin") {
                              widget.tabController.animateTo(1);
                            } else {
                              widget.tabController.animateTo(2);
                            }
                          },
                          child: Text("Admin",
                              style: GoogleFonts.alice())),
                    )
                        : Center(
                        child: Text("You Are not Admin",
                            style: GoogleFonts.alice())),
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
        floatingActionButton: stsus
            ? null
            : Container(
          height: 120,
          width: 100,
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      stsus = true;
                    });
                  },
                  child: Icon(Icons.edit)),
              FloatingActionButton(
                  onPressed: () async {
                    AdminViewModel().SignOutMethod(widget.tabController);
                  },
                  child: Icon(Icons.logout)),
            ],
          ),
        ));
  }
}
