import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class resetPasword extends StatefulWidget {
  const resetPasword({Key? key}) : super(key: key);

  @override
  State<resetPasword> createState() => _resetPaswordState();
}

class _resetPaswordState extends State<resetPasword> {
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reser Password"),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: email,
              //obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter your secure Email'),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance
                    .sendPasswordResetEmail(email: email.text)
                    .then((value) => Navigator.pop(context));
              },
              child: Text("Reset Your Password"))
        ],
      )),
    );
  }
}
