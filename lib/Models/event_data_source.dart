import 'package:expacto_patronam/Models/event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<EventModel> appointments){
    this.appointments = appointments;
  }
  EventModel getEvent(int index )=>appointments![index] as EventModel;

  @override
  DateTime getStartTime(int index) => getEvent(index).from;

  @override
  DateTime getEndTime(int index) => getEvent(index).to;

  @override
  String getSubject(int index) => getEvent(index).title;

  @override
  Color getColor(int index) => getEvent(index).backGroundColor;

  @override
  bool isAllDay(int index) => getEvent(index).isAllDay;

}