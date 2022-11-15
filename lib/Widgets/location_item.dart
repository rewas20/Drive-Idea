import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationItem extends StatelessWidget {
  var user = FirebaseAuth.instance.currentUser;
  CollectionReference mapPlaces = FirebaseFirestore.instance.collection("Map");
  CollectionReference users = FirebaseFirestore.instance.collection("Users");
  Color? textColor = const Color(0xff8F7959);

  String locationID;
  String title;
  String description;
  String link;
  String time;

  LocationItem(
      this.description,
      this.locationID,
      {
        required this.title,
        required this.link,
        required this.time
      });
  @override
  Widget build(BuildContext context) {

    return  Card(
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color:  Colors.white,

      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
        horizontalTitleGap: 10,
        onLongPress: (){
          List<String> linkList = link.split("http");
          String copy = "title: $title\n$description\n=========\n${linkList[0]}\n${"http"+linkList[1]}\n========\ntime: $time";
          Clipboard.setData( ClipboardData(text: copy));

          Fluttertoast.showToast(msg: "Copied Card");
        },
        onTap: () async {
          List<String> linkList = link.split("http");
          await launch("http"+linkList[1]);
        },
        leading: const Icon(Icons.location_on),
        title: Text(title,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.grey),),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(description,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.grey ),),
            ),

            Text(time,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.grey ),),
          ],
        ),
        trailing: IconButton(
          onPressed: (){
            showDialog(context: context, builder: (context)=>alertDialog(context),barrierDismissible: false);
          },
          icon: Icon(Icons.delete),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

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
            child: Text("Do you want to delete?",style: TextStyle(fontSize: 20,color: textColor),),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: ()  {
                  mapPlaces.doc(user!.uid).update({locationID: FieldValue.delete()}).then((value) => Navigator.of(context).pop());
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
