import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_fire/common/method/shred_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class AdminViewModel {
  UserUpdateMethod(BuildContext context, String name, String phone, String immurl, String auth) {
    FirebaseFirestore.instance
        .collection("user")
        .doc(auth)
        .update({'name': name, 'phone': phone, 'userImg': immurl});
  }



  void SignOutMethod(TabController tabController) async {
    await GoogleSignIn().signOut();
    tabController.animateTo(0);
    removePrefValue();
  }
}
