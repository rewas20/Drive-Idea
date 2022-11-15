import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expacto_patronam/Models/video.dart';
import 'package:expacto_patronam/Screens/Divide/video_gride.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../Models/storage_service.dart';

class VideosScreen extends StatefulWidget {
  static const routeName = "VIDEOS_SCREEN";
  const VideosScreen({Key? key}) : super(key: key);

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  var user = FirebaseAuth.instance.currentUser;
  CollectionReference videos = FirebaseFirestore.instance.collection("Videos");
  String formatDate  = DateFormat("dd-MM-yyyy h:mm a").format(DateTime.now());
  List<VideoModel> allVideos = [];
  List<VideoModel> videoUser = [];
  final Storage storage = Storage();
  List<File> videoList = [];
  late int counter = 0 ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Theme.of(context).primaryColorDark,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Videos"),
        actions: [
          IconButton(
            onPressed: (){
              upload();
            },
            icon: const Icon(Icons.cloud_upload,semanticLabel: "Upload"),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/background.jpg"),fit: BoxFit.fill)
        ),
        child: StreamBuilder(
          stream: videos.snapshots(),
          builder: (ctx,AsyncSnapshot<QuerySnapshot> snapShot){
            if(snapShot.data!=null){
              final data = snapShot.data!.docs ;

              for (var element in data) {
                final dataId = element.data() as Map<String,dynamic>;

                if(element.id==user!.uid){
                  videoUser.clear();
                  dataId.forEach((key, value) {
                    videoUser.add(VideoModel(videoID: key, videoPath: value["videoPath"], title: value["title"], time: value["time"], path: value["path"]));
                  });
                  allVideos = videoUser;
                }

              }}
            return VideoGrid(allVideo: allVideos);
          },
        ),
      ),
    );
  }
  void upload() async{
    final videoUpload = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.video,
    );
    if(videoUpload==null) {
      Fluttertoast.showToast(msg: "No file selected");
    }else{
      List<PlatformFile> files = videoUpload.files;
      counter = 0;
      alertDialog(files);
      for (PlatformFile element in files) {
        try {
          storage.uploadFile(element.path!, element.name, user!.uid,"videos").then((
              value) {
            setState(() {
              counter++;
            });
            videos.doc(user!.uid).get().then((videoUser) {
              if (videoUser.exists) {
                videos.doc(user!.uid).update(VideoModel(videoID: element.name.split(".").first,
                    videoPath: value,
                    title: element.name,
                    time: formatDate
                ,path: "videos/${user!.uid}/${element.name}"
                ).getMap());
              } else {
                videos.doc(user!.uid).set(VideoModel(videoID: element.name.split(".").first,
                    videoPath: value,
                    title: element.name,
                    time: formatDate
                ,path: "videos/${user!.uid}/${element.name}"
                ).getMap());
              }
            }).then((value) {
              Fluttertoast.showToast(msg: "uploaded $counter of ${files.length} ... ");
              if(counter==files.length){
                Navigator.of(context).pop();
              }
            });

          });
        }on FirebaseFirestore catch (e) {
          Navigator.of(context).pop();
          /*Fluttertoast.showToast(
              msg: "Failed upload");*/
        }
      }

    }



  }

  alertDialog(List<PlatformFile> files){
    showDialog(context: context, builder: (context) =>  const Center(
      child: Padding(
        padding: EdgeInsets.all(25),
        child: LinearProgressIndicator(
          minHeight: 5.0,
          valueColor: AlwaysStoppedAnimation(Colors.blue),

        ),
      ),
    ),
        barrierDismissible: false);
  }


}