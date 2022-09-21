import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_fire/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class showDataFire {
  Stream<List<UserModel>> readUser() =>
      FirebaseFirestore.instance.collection('user').snapshots().map(
            (snapshot) => snapshot.docs
                .map((doc) => UserModel.fromJson(doc.data()))
                .toList(),
          );




}
