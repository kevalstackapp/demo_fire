import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_fire/model/user_model.dart';
import 'package:flutter/foundation.dart';


class UserService {
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');




  Future<void> createUser(UserModel userModel) async {
    try {
      await userCollection.doc(userModel.uId).set(userModel.toJson());
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Catch Exception in createUser : ${e.message}");
      }
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await userCollection.doc(id).delete();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Catch Exception in deleteUser : ${e.message}");
      }
    }
  }
}