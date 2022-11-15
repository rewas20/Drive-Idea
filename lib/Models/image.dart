class ImageModel {
  String imageID;
  String imagePath;
  String title;
  String path;
  String time;

  ImageModel({required this.imageID,required this.imagePath,required this.title,required this.path,required this.time});

  Map<String,dynamic> getMap(){
    return {imageID:{
      "imagePath": imagePath,
      "title": title,
      "path": path,
      "time": time,
    }};

  }
}