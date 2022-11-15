import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' /*as firebase_storage*/;

class Storage{
  final FirebaseStorage storage = FirebaseStorage.instance ;
  Future<String> uploadFile(
  String filePath,
      String fileName,
      String userName,
      String type,
      )
  async {
    File file = File(filePath);
    try {
      Reference ref =  storage.ref("$type/$userName/$fileName");
      ref.putFile(file);
      Future<String> url = ref.getDownloadURL();
      return url;

    }on FirebaseException catch(e){
      return "";
    }
  }

 /* Future<firebase_storage.ListResult> listFiles(String userName) async {
    firebase_storage.ListResult result = await  storage.ref("photos/$userName").listAll();
    result.items.forEach((firebase_storage.Reference ref) {
      print("Found file: $ref");

    });
    return result;
  }*/
}