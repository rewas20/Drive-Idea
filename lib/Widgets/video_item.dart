import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class VideoItem extends StatelessWidget {
  var user = FirebaseAuth.instance.currentUser;
  CollectionReference videos = FirebaseFirestore.instance.collection("Videos");
  CollectionReference users = FirebaseFirestore.instance.collection("Users");
  Color? textColor = Color.lerp(Color(0xff8F7959),Colors.blue, 0.2);
  String videoID;
  String videoPath = "";
  String title;
  String path;
  String time;
  

  VideoItem({Key? key, required this.videoID,required this.videoPath,required this.title,required this.path, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
       /* Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=> ViewImage(imagePath: videoPath,))
        );*/
      },
      onLongPress: (){
        showDialog(context: context, builder: (context)=> alertDialog(context));
      },
      child: Container(
        child: Image.asset("assets/icons/video_icon_screen.png"),
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
                  String id = videoID;
                  await FirebaseStorage.instance.ref(path).delete().then((value){
                    videos.doc(user!.uid).update({id: FieldValue.delete()}).then((value) => Navigator.of(context).pop());
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
  generateThumbnail(String file) async {
    /*final thumbnailByts = await VideoCompress.getByteThumbnail(file);
    return thumbnailByts;*/
  }
}
