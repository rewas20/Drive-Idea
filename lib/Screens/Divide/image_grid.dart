import 'package:flutter/material.dart';

import '../../Models/image.dart';
import '../../Widgets/image_item.dart';

class ImageGrid extends StatelessWidget {
  List<ImageModel> allImages = [];


  ImageGrid({Key? key, required this.allImages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GridView(
      padding: const EdgeInsets.only(top: 10,left: 5,right: 5),
      children: allImages.map((imageData) => ImageItem(imageID: imageData.imageID, imagePath: imageData.imagePath, title: imageData.title, time: imageData.time, path: imageData.path,)).toList(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:  4,
        mainAxisExtent: MediaQuery.of(context).size.width * 0.25,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),

    );
  }
}
