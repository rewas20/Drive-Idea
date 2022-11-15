class VideoModel {
  String videoID;
  String videoPath;
  String title;
  String path;
  String time;

  VideoModel({required this.videoID,required this.videoPath,required this.title,required this.path,required this.time});

  Map<String,dynamic> getMap(){
    return {videoID:{
      "videoPath": videoPath,
      "title": title,
      "path": path,
      "time": time,
    }};

  }
}