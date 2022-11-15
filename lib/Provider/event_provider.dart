import 'package:expacto_patronam/Models/event.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  final List<EventModel> _events = [];
  List<EventModel> get events => _events;

  late DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<EventModel> get eventOfSelectedDate => _events;
  void setAllEvent(List<EventModel> allEvents){
    _events.clear();
    _events.addAll(allEvents);
    notifyListeners();
  }

  void addEvent(EventModel event){
    _events.add(event);

    notifyListeners();
  }
  void deleteEvent(EventModel event){

    _events.remove(event);

    notifyListeners();
  }
  void editEvent(EventModel newEvent,EventModel oldEvent){
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;

    notifyListeners();
  }
}