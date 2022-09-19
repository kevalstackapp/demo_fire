import 'package:flutter/material.dart';

class userLogin extends StatefulWidget {
  const userLogin({Key? key}) : super(key: key);

  @override
  State<userLogin> createState() => _userLoginState();
}

class _userLoginState extends State<userLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Container(
          height: 100,
          width: 100,
          color: Colors.blue,
          child: Text("Welcome"),
        ),
      )
    );
  }
}
