
import 'package:expacto_patronam/Screens/Divide/icons_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/main_drawer.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "HOME_SCREEN";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  // Size for all content on AppBar
  double sizeAppBar = 25;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F3DA),
      drawerScrimColor: Colors.black.withOpacity(0.3),
      drawer: MainDrawer(),

      //AppBar
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text("Expacto Patronam" ,style: TextStyle(fontSize: sizeAppBar)),
        backgroundColor: Theme.of(context).primaryColor,

      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/background.jpg"),fit: BoxFit.fill)
        ),
        child: const ViewIconsHome(),
      ),

    );
  }
}
/*
* Stack(
        children: [

          Image.asset("images/background.jpg",fit: BoxFit.fill,width: double.infinity,height: double.infinity,),
          ViewIconsHome(),
        ],
      ),
*
* */