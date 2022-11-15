import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NoteItem extends StatelessWidget {
  var user = FirebaseAuth.instance.currentUser;
  CollectionReference notes = FirebaseFirestore.instance.collection("Notes");
  CollectionReference users = FirebaseFirestore.instance.collection("Users");
  Color? textColor = Color.lerp(Color(0xff8F7959),Colors.blue, 0.2);
  String noteID;
  String title;
  String content;
  String time;

  NoteItem(
      this.noteID,
      {Key? key,
        required this.title,
        required this.content,
        required this.time
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color:  Theme.of(context).primaryColorDark.withOpacity(0.8),
        child: ListTile(
          contentPadding: const EdgeInsets.all(20),

          horizontalTitleGap: 5,
          onLongPress: (){
            String copy = "title: $title\n\=========\n$content\n========\ntime: $time";
            Clipboard.setData( ClipboardData(text: copy));

            Fluttertoast.showToast(msg: "Copied Card");
          },
          onTap: () {
  
          },
          title: Text(getheighTitle(title),style:  TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: textColor),),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                child: Text(getheighContent(content),style:  TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: textColor ),),
              ),
              Text(time,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: textColor),),
            ],
          ),
          trailing: IconButton(
            alignment: Alignment.topRight,
            onPressed: (){
              showDialog(context: context, builder: (context)=>alertDialog(context),barrierDismissible: false);
            },
            icon: const Icon(Icons.delete),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        ),
    );
  }
  String getheighContent(String note){
    if(note.length>40){
      return note.substring(0,40)+"\n...";
    }else{

      return note;
    }
  }
 String getheighTitle(String note){

   if(note.length>6){
     return note.substring(0,6)+"...";
   }else{

     return note;
   }
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
                  notes.doc(user!.uid).update({noteID: FieldValue.delete()}).then((value) => Navigator.of(context).pop());
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
