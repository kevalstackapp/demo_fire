import 'dart:io';
import 'package:demo_fire/common/method/shred_preferences.dart';
import 'package:demo_fire/model/user_model.dart';
import 'package:demo_fire/screen/firstlogin/firstlogin.dart';
import 'package:demo_fire/screen/firstlogin/fist_login_view_model.dart';
import 'package:demo_fire/screen/tabbar_page/tabbar_page.dart';
import 'package:demo_fire/services/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class CreateUserAccount extends StatefulWidget {
  TabController tabController;

  CreateUserAccount(this.tabController);

  @override
  State<CreateUserAccount> createState() => _CreateUserAccountState();
}

class _CreateUserAccountState extends State<CreateUserAccount> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  ImagePicker picker = ImagePicker();
  String? immurl;
  bool staus = true;
  String admins = "User";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Account",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              controller: email,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              controller: name,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  hintText: ''),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              controller: phone,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone',
                  hintText: ''),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              controller: password,
              obscureText: staus,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      staus ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        staus = !staus;
                      });
                    },
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter your secure password'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(
                value: "Admin",
                groupValue: admins,
                onChanged: (value) {
                  setState(() {
                    admins = value.toString();
                  });
                },
              ),
              SizedBox(
                height: 20,
                width: 50,
                child: Text("Admin", style: GoogleFonts.alice()),
              ),
              Radio(
                value: "User",
                groupValue: admins,
                onChanged: (value) {
                  setState(() {
                    admins = value.toString();
                  });
                },
              ),
              SizedBox(
                height: 20,
                width: 30,
                child: Text(
                  "User",
                  style: GoogleFonts.alice(),
                ),
              ),
            ],
          ),
          Center(
              child: ElevatedButton(
                  onPressed: () async {
                    AuthService()
                        .CreateNewUserAccount(
                            context,
                            email.text,
                            password.text,
                            admins,
                            name.text,
                            phone.text,
                            widget.tabController)
                        .then((values) {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return TabbarPage();
                        },
                      ));
                    });
                  },
                  child: Text(
                    "Sign up",
                  )))
        ]),
      ),
    );
  }
}
