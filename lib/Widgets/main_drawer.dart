
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Screens/login_screen.dart';

class MainDrawer extends  StatelessWidget{

  var user = FirebaseAuth.instance.currentUser;
  String userName = "";
  CollectionReference users = FirebaseFirestore.instance.collection("Users");
  MainDrawer({Key? key}) : super(key: key){

      users.doc(user!.uid).get().then((value) {
      userName = value["userName"];
    } );
  }
  //users.map((event) {user = event['userName'];});

  Color? backgroundColorTheme = Color.lerp(const Color(0xff4b4032), Colors.blueAccent,0.2);
  Color? textColor = const Color(0xff8F7959);
  Color? focusColor = Color.lerp(const Color(0xff4b4032), Colors.blueAccent,0.2);


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            height: 150,
            width: double.infinity,
            color: backgroundColorTheme,
            padding: const EdgeInsets.all(20),
            child: Text(userName, style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
         /* ListTile(
              focusColor: focusColor,
              onTap: () {


              },
              leading: const Icon(Icons.settings,size: 30),
              title: Text("Settings",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700,color:textColor),)
          ),
          const SizedBox(
            height: 20,
          ),*/
          ListTile(
              focusColor: focusColor,
              onTap: () {
               showDialog(context: context, builder: (context)=>alertDialog(context));
              },
              title: Text("Logout",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700,color:textColor),),
              leading: const Icon(Icons.logout,size: 30)
          ),
        ],
      ),
    );
  }
  Widget alertDialog(context){
    return AlertDialog(
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actionsPadding: const EdgeInsets.all(20),
        actionsAlignment: MainAxisAlignment.start,
        actions: [
          Container(
            alignment: Alignment.center,
            child: Text("Do you want to logout?",style: TextStyle(fontSize: 20,color: textColor),),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: ()  async {
                  try {
                      await FirebaseAuth.instance.signOut().then((_) =>
                      Navigator.of(context).pushReplacementNamed(
                          LoginScreen.routeName));
                    }catch(e){
                      Fluttertoast.showToast(msg: "failed Add");
                    }
                },
                child:  Text("Yes",style: TextStyle(fontSize: 20,color: textColor)),
              ),
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text("No",style: TextStyle(fontSize: 20,color: textColor)),
              ),
            ],
          )

        ]);
  }
}
