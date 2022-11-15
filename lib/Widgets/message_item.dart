import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MessageItem extends StatelessWidget {

  var user = FirebaseAuth.instance.currentUser;
  CollectionReference messages = FirebaseFirestore.instance.collection("Messages");
  CollectionReference users = FirebaseFirestore.instance.collection("Users");
  Color? textColor = const Color(0xff8F7959);
  String messageID;
  String title;
  String message;
  String time;

  MessageItem(
      this.messageID,
      {Key? key,
        required this.title,
        required this.message,
        required this.time
      }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  Card(
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color:  Colors.white,

      child: Container(
        child: ListTile(
          contentPadding: EdgeInsets.only(top: 10,bottom: 20,left: 15,right: 15),

          horizontalTitleGap: 10,
          onLongPress: (){
            String copy = "title: $title\n\=========\n$message\n========\ntime: $time";
            Clipboard.setData( ClipboardData(text: copy));

            Fluttertoast.showToast(msg: "Copied Card");
          },
          onTap: () {

          },
          leading: const Icon(Icons.message),
          title: Text(title,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.grey),),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 25),
                child: Text(message,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.grey ),),
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
      )
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
                  messages.doc(user!.uid).update({messageID: FieldValue.delete()}).then((value) => Navigator.of(context).pop());
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
