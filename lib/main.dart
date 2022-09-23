import 'package:demo_fire/screen/tabbar_page/tabbar_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GestureDetector(
    onTap: () {
      FocusManager.instance.primaryFocus!.unfocus();
    },
    child: MaterialApp(
      home:TabbarPage(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}
