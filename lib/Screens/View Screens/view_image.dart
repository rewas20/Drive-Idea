import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewImage extends StatefulWidget {
  String imagePath;

  ViewImage({Key? key, required this.imagePath}) : super(key: key) ;



  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Image.network(widget.imagePath),
      ),
    );
  }
}
