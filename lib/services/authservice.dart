import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_fire/common/method/shred_preferences.dart';
import 'package:demo_fire/common/widget/snackbar_widget.dart';
import 'package:demo_fire/model/user_model.dart';
import 'package:demo_fire/screen/firstlogin/fist_login_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/tab_controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService {


  //     ======================= SignUp =======================     //
  Future<UserCredential?> CreateEmailLogin(BuildContext context,
      String email,
      String password,
      String admins,
      TabController tabController,) async {
    try {
      UserCredential credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(credential);

      UserModel userModel = UserModel(
          email: email,
          password: password,
          uId: credential.user!.uid,
          admin: admins);
      createUsedata(userModel);

      tabController.animateTo(2);

      await setPrefStringValue("Login", "yes");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');

        try {
          UserCredential credential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);

          UserModel userModel = UserModel(
              email: email,
              password: password,
              uId: credential.user!.uid,
              admin: admins);

          QuerySnapshot users =
          await FirebaseFirestore.instance.collection('user').get();
          List<UserModel> userModelList = <UserModel>[];
          for (QueryDocumentSnapshot element in users.docs) {
            UserModel userModal =
            UserModel.fromJson(element.data() as Map<String, dynamic>);
            userModelList.add(userModal);
          }
          UserModel currentUSerModel = userModelList.firstWhere(
                  (element) => element.uId == credential.user!.uid,
              orElse: () => UserModel());
          log('createUsers --->  ${currentUSerModel.toJson()}');
          if (currentUSerModel.uId == null || currentUSerModel.uId!.isEmpty) {
            createUsedata(userModel);

            tabController.animateTo(2);
          } else {
            tabController.animateTo(2);
          }

          await setPrefStringValue("Login", "yes");

          print(credential);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
            AppSnackBar(context, text: "Your Password length not valid");
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<UserCredential?>  CreateNewUserAccount(BuildContext context,
      String email,
      String password,
      String admins,

      String name,
      String phone,
      TabController tabController) async {
    try {
      UserCredential credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(credential);

      UserModel userModel = UserModel(
        email: email,
        password: password,
        uId: credential.user!.uid,
        admin: admins,

        name: name,
        phone: phone,
      );
      createUsedata(userModel);

      tabController.animateTo(2);

      await setPrefStringValue("Login", "yes");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');

        try {
          UserCredential credential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);

          UserModel userModel = UserModel(
            email: email,
            password: password,
            uId: credential.user!.uid,
            admin: admins,

            name: name,
            phone: phone,
          );

          QuerySnapshot users =
          await FirebaseFirestore.instance.collection('user').get();
          List<UserModel> userModelList = <UserModel>[];
          for (QueryDocumentSnapshot element in users.docs) {
            UserModel userModal =
            UserModel.fromJson(element.data() as Map<String, dynamic>);
            userModelList.add(userModal);
          }
          UserModel currentUSerModel = userModelList.firstWhere(
                  (element) => element.uId == credential.user!.uid,
              orElse: () => UserModel());
          log('createUsers --->  ${currentUSerModel.toJson()}');
          if (currentUSerModel.uId == null || currentUSerModel.uId!.isEmpty) {
            createUsedata(userModel);

            tabController.animateTo(2);
          } else {
            tabController.animateTo(2);
          }

          await setPrefStringValue("Login", "yes");

          print(credential);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
           // AppSnackBar(context, text: "Your Password length not valid");
          }
        }
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

    //     ======================= Google Sign In =======================     //
    Future<UserCredential> signInWithGoogle() async {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }
