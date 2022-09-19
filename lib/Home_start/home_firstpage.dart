import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_fire/service/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class home_firstpage extends StatefulWidget {
  TabController tabController;

  home_firstpage(this.tabController);

  @override
  State<home_firstpage> createState() => _home_firstpageState();
}

class _home_firstpageState extends State<home_firstpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<UserModel>>(
          stream: usersStream(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            } else if (snapshot.hasData) {
              final user = snapshot.data;
              return ListView(children: user!.map(userBulid).toList());
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: InkWell(
        onTap: () async {
          await GoogleSignIn().signOut().then((value) {
            widget.tabController.animateTo(0);
          });
        },
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(Icons.logout),
        ),
      ),
    );
  }

  Stream<List<UserModel>> usersStream() =>
      FirebaseFirestore.instance.collection('user').snapshots().map((event) =>
          event.docs.map((e) => UserModel.fromJson(e.data())).toList());

  Widget userBulid(UserModel userModel) => ListTile(
        title: Text(userModel.name!),
        subtitle: Text(userModel.email!),
        leading: Image.network(userModel.userImg!),
      );
}
