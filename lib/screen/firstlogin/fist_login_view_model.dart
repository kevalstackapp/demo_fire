import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_fire/common/method/shred_preferences.dart';
import 'package:demo_fire/model/user_model.dart';
import 'package:demo_fire/services/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirstLoginViewModel {}

bool emailvalidat(BuildContext context, {String? text}) {
  final emailvalidate = RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(text!);
  return emailvalidate;
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

Googlesingmethod(TabController tabController) async {
  UserCredential? logn = await AuthService().signInWithGoogle();
  if (logn.user != null) {
    UserModel userModel = UserModel(
      uId: logn.user!.uid,
      name: logn.user!.displayName,
      email: logn.user!.email,
      phone: logn.user!.phoneNumber,
      userImg: logn.user!.photoURL,
    );
    createUse(userModel);

    tabController.animateTo(2);
    await setPrefStringValue("Login", "yes");
  } else {
    CircularProgressIndicator();
  }
}
