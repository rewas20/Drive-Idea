import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expacto_patronam/Models/storage_service.dart';
import 'package:expacto_patronam/Screens/Divide/image_grid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../Models/image.dart';

class PhotosScreen extends StatefulWidget {
  static const routeName = "PHOTOS_SCREEN";
  const PhotosScreen({Key? key}) : super(key: key);

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  var user = FirebaseAuth.instance.currentUser;
  Reference ref = FirebaseStorage.instance.ref("photos");
  CollectionReference photos = FirebaseFirestore.instance.collection("Photos");
  String formatDate  = DateFormat("dd-MM-yyyy h:mm a").format(DateTime.now());
  List<ImageModel> allImages = [];
  List<ImageModel> imageUser = [];
  final Storage storage = Storage();
  List<File> imagesList = [];
  late int counter = 0 ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Theme.of(context).primaryColorDark,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Photos"),
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
          stream: photos.snapshots(),
          builder: (ctx,AsyncSnapshot<QuerySnapshot> snapShot){
            if(snapShot.data!=null){
              final data = snapShot.data!.docs ;

              for (var element in data) {
                final dataId = element.data() as Map<String,dynamic>;

                if(element.id==user!.uid){
                  imageUser.clear();
                  dataId.forEach((key, value) {
                    imageUser.add(ImageModel(imageID: key, imagePath: value["imagePath"], title: value["title"], time: value["time"], path: value["path"]));
                  });
                    allImages = imageUser;
                }

              }}
            return ImageGrid(allImages: allImages,);
          },
        ),

      ),
    );
  }

  void upload() async{
    final images = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if(images==null) {
      Fluttertoast.showToast(msg: "No file selected");
    }else{
      List<PlatformFile> files = images.files;
      counter = 0;
      alertDialog(files);
      for (PlatformFile element in files) {
        try {
          storage.uploadFile(element.path!, element.name, user!.uid,"photos",).then((value) {
            setState(() {
              counter++;
            });
            photos.doc(user!.uid).get().then((photoItem) {
              if (photoItem.exists) {
                photos.doc(user!.uid).update(ImageModel(imageID: element.name.split(".").first,
                    imagePath:  value,
                    title: element.name,
                    time: formatDate, path: "photos/${user!.uid}/${element.name}").getMap());
              } else {
                photos.doc(user!.uid).set(ImageModel(imageID: element.name.split(".").first,
                    imagePath: value,
                    title: element.name,
                    time: formatDate, path: "photos/${user!.uid}/${element.name}").getMap());
              }
            }).then((successful) {
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
