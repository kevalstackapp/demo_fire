import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_fire/common/method/shred_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class AdminViewModel {
  UserUpdateMethod(BuildContext context, String name, String phone,
      String immurl, String auth) {
    FirebaseFirestore.instance
        .collection("user")
        .doc(auth)
        .update({'name': name, 'phone': phone, 'userImg': immurl});
  }

  UserGallryImgMethod(
      BuildContext context, ImagePicker picker, String immurl) async {
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    var file = File(photo!.path);

    if (photo != null) {
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('files/${photo.name}')
          .putFile(file);
      print("ok");
      var downloadUrl = await snapshot.ref.getDownloadURL();

      immurl = downloadUrl;
    }
    Navigator.pop(context);
  }

  UserCamaraImgMethod(
      BuildContext context, ImagePicker picker, String immurl) async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    var file = File(photo!.path);

    if (photo != null) {
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('files/${photo.name}')
          .putFile(file);
      print("ok");
      var downloadUrl = await snapshot.ref.getDownloadURL();

      immurl = downloadUrl;

      Navigator.pop(context);
    }
  }

  void SignOutMethod(TabController tabController) async {
    await GoogleSignIn().signOut();
    tabController.animateTo(0);
    removePrefValue();
  }
}
