import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expacto_patronam/Screens/View%20Screens/view_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageItem extends StatelessWidget {
  var user = FirebaseAuth.instance.currentUser;
  CollectionReference photos = FirebaseFirestore.instance.collection("Photos");
  CollectionReference users = FirebaseFirestore.instance.collection("Users");
  Color? textColor = Color.lerp(Color(0xff8F7959),Colors.blue, 0.2);
  String imageID;
  String imagePath;
  String title;
  String path;
  String time;

  ImageItem({Key? key, required this.imageID,required this.imagePath,required this.title,required this.path,required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=> ViewImage(imagePath: imagePath,))
        );
      },
      onLongPress: (){
        showDialog(context: context, builder: (context)=> alertDialog(context));
      },
      child: Container(
        child: Image.network(imagePath),
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
                onPressed: ()  async {
                  String id = imageID;
                  await FirebaseStorage.instance.ref(path).delete().then((value) {
                    photos.doc(user!.uid).update({id: FieldValue.delete()}).then((value) => Navigator.of(context).pop());
                  });

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
