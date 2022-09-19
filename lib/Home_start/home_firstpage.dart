import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/user_model.dart';

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
      body: StreamBuilder<List<UserModel>>(
        stream: readUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Somthing is wrong');
          } else if (snapshot.hasData) {
            final user = snapshot.data!;

            return ListView(
              children: user.map(buildUser).toList(),
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

  Widget buildUser(UserModel userModal) => InkWell(
        child: ListTile(
          title: Text(userModal.name!),
          subtitle: Text(userModal.email!),
          leading: Image.network("${userModal.userImg}"),
          trailing: InkWell(
            onTap: () {
              showModalBottomSheet<void>(
                  isDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                        child: new Wrap(children: <Widget>[
                      new ListTile(
                          leading: new Icon(Icons.delete),
                          title: new Text('Delete'),
                          onTap: () {
                            final docuser = FirebaseFirestore.instance
                                .collection('user')
                                .doc(userModal.uId);
                            docuser.delete();
                          }
                          // Remove the tapped document here - how?

                          ),
                    ]));
                  });
            },
            child: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ),
      );

  Stream<List<UserModel>> readUser() =>
      FirebaseFirestore.instance.collection('user').snapshots().map(
            (snapshot) => snapshot.docs
                .map((doc) => UserModel.fromJson(doc.data()))
                .toList(),
          );
}
