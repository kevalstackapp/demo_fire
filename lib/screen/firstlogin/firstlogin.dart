import 'package:demo_fire/common/widget/snackbar_widget.dart';
import 'package:demo_fire/screen/firstlogin/fist_login_view_model.dart';
import 'package:demo_fire/services/authservice.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../resetpassword/resetpasword.dart';

class firstlogin extends StatefulWidget {
  TabController tabController;

  firstlogin(this.tabController);

  @override
  State<firstlogin> createState() => _firstloginState();
}

class _firstloginState extends State<firstlogin> {
  bool staus = true;

  String admins = "User";
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              child: Lottie.asset("asset/107723-logindvdvd.json", width: 200),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: email,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter your secure Email'),
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
                    labelText: 'password',
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
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return resetPasword();
                  },
                ));
              },
              child: Text(
                'Forget Password.',
                style: GoogleFonts.alice(textStyle: TextStyle(fontSize: 15)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (emailvalidat(context, text: email.text) == false) {
                  AppSnackBar(context, text: "Email Not Validate");
                } else if (emailvalidat(context, text: password.text) == "") {
                  AppSnackBar(context, text: "Password not Enter");
                } else if (password.text.length <= 8) {
                  AppSnackBar(context, text: "Your Password length not valid");
                } else {
                  CircularProgressIndicator();
                }

                AuthService().CreateEmailLogin(context, email.text,
                    password.text, admins, widget.tabController);
                email.clear();
                password.clear();
              },
              child: Text(
                "Login",
                style: GoogleFonts.alice(textStyle: TextStyle(fontSize: 15)),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  Googlesingmethod(widget.tabController);
                },
                child: Container(
                  height: 50,
                  width: 170,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset("asset/google (1).png"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 45, top: 17),
                        child: SizedBox(
                          height: 40,
                          width: 150,
                          child: Text("Sign in with Google",
                              style: GoogleFonts.alice()),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
