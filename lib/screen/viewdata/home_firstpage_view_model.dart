import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_fire/common/method/shred_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/tab_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeFirstpageViewModel {
  void SignOutMethod(TabController tabController) async {
    await GoogleSignIn().signOut();
    tabController.animateTo(0);
    removePrefValue();
  }

  void UserDataDalete(BuildContext context, String id) {
    DocumentReference docuser =
        FirebaseFirestore.instance.collection('user').doc(id);
    docuser.delete();
    Navigator.pop(context);
  }
}
