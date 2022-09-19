import 'package:demo_fire/Home_start/home_firstpage.dart';
import 'package:demo_fire/tab_page/firstlogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class firstpage extends StatefulWidget {
  const firstpage({Key? key}) : super(key: key);

  @override
  State<firstpage> createState() => _firstpageState();
}

class _firstpageState extends State<firstpage>
    with SingleTickerProviderStateMixin {


  late TabController tabController;



  @override
  void initState() {
    super.initState();
    tabController = new TabController(vsync: this, length: 2);
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
            title: Text("Login"),
            centerTitle: true,
            bottom: TabBar(
              controller: tabController,
              tabs: [
                Tab(
                  child: ListTile(
                    leading: Icon(
                      Icons.login,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Tab(
                  child: ListTile(
                    leading: Icon(
                      Icons.supervised_user_circle,
                      color: Colors.white,
                    ),
                    title: Text(
                      "User's",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller:tabController ,
            children: [firstlogin(tabController),
             home_firstpage(tabController)],
          ),
        ));
  }
}
