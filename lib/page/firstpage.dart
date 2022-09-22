import 'package:demo_fire/Screen/admin.dart';
import 'package:demo_fire/Screen/home_firstpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screen/firstlogin.dart';

class firstpage extends StatefulWidget {
  const firstpage({Key? key}) : super(key: key);

  @override
  State<firstpage> createState() => _firstpageState();
}

class _firstpageState extends State<firstpage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  var islogin;

  @override
  void initState() {
    super.initState();
    shred();
    tabController = new TabController(vsync: this, length: 3);
  }

  Future shred() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("login")) {
      tabController.animateTo(2);
    } else {
      tabController.animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
                // Status bar color
                statusBarColor: Colors.blue),
            title: Text(
              "Login",
              style:
                  GoogleFonts.alice(textStyle: TextStyle(color: Colors.white)),
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: Size(50, 50),
              child: IgnorePointer(
                ignoring: false,
                child: TabBar(
                  controller: tabController,
                  tabs: [
                    Tab(
                        child: Row(
                      children: [
                        SizedBox(
                          height: 20,
                          width: 30,
                          child: Icon(
                            Icons.login,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: SizedBox(
                              height: 20,
                              width: 40,
                              child: Text("Login",
                                  style: GoogleFonts.alice(
                                      textStyle:
                                          TextStyle(color: Colors.white)))),
                        ),
                      ],
                    )),
                    Tab(
                        child: Row(
                      children: [
                        SizedBox(
                          height: 20,
                          width: 30,
                          child: Icon(
                            Icons.supervised_user_circle,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: SizedBox(
                              height: 20,
                              width: 50,
                              child: Text("User's",
                                  style: GoogleFonts.alice(
                                      textStyle:
                                          TextStyle(color: Colors.white)))),
                        ),
                      ],
                    )),
                    Tab(
                        child: Row(
                      children: [
                        SizedBox(
                          height: 20,
                          width: 30,
                          child: Icon(
                            Icons.admin_panel_settings,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: SizedBox(
                              height: 20,
                              width: 30,
                              child: Text(
                                "User",
                                style: GoogleFonts.alice(
                                    textStyle: TextStyle(color: Colors.white)),
                              )),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: tabController,
            children: [
              firstlogin(tabController),
              Userpage(tabController),
              admin(tabController)
            ],
          ),
        ));
  }
}
