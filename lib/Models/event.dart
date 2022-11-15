import 'package:flutter/material.dart';

class EventModel {
  String eventID;
  String title;
  String description;
  DateTime from;
  DateTime to;
  Color backGroundColor;
  bool isAllDay;

  EventModel({required this.eventID,required this.title,required this.description,required this.from,required this.to,
      this.backGroundColor = Colors.lightGreen,
    this.isAllDay = false
  });

  Map<String,dynamic> getMap(){
    return {
      eventID: {
        "title" : title,
        "description" :  description,
        "from" : "$from",
        "to" : "$to",
      }
    };
  }
}