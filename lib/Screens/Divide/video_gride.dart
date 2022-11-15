import 'package:expacto_patronam/Models/video.dart';
import 'package:expacto_patronam/Widgets/video_item.dart';
import 'package:flutter/material.dart';

class VideoGrid extends StatelessWidget {
  List<VideoModel> allVideo= [];


  VideoGrid({Key? key, required this.allVideo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GridView(
      padding: const EdgeInsets.only(top: 10,left: 5,right: 5),
      children: allVideo.map((videoData) => VideoItem(videoID: videoData.videoID, videoPath: videoData.videoPath, title: videoData.title, time: videoData.time, path: videoData.path,)).toList(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:  4,
        mainAxisExtent: MediaQuery.of(context).size.width * 0.25,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),

    );
  }
}
