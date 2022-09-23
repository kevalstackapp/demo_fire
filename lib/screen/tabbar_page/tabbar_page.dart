import 'package:demo_fire/api_demo/first_screen/first_screen.dart';
import 'package:demo_fire/common/method/shred_preferences.dart';
import 'package:demo_fire/screen/admin/admin.dart';
import 'package:demo_fire/screen/viewdata/home_firstpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../firstlogin/firstlogin.dart';

class TabbarPage extends StatefulWidget {
  const TabbarPage({Key? key}) : super(key: key);

  @override
  State<TabbarPage> createState() => _TabbarPageState();
}

class _TabbarPageState extends State<TabbarPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    shred();
    tabController = new TabController(vsync: this, length: 3);
  }

  Future shred() async {
    if (await chekPrefKey("Login")) {
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
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: Colors.blue),
            title: Text(
              "Login",
              style:
                  GoogleFonts.alice(textStyle: TextStyle(color: Colors.white)),
            ),
            actions: [
              IconButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FirstScrren();
                },));

              }, icon: Icon(Icons.videocam_outlined))
            ],
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
