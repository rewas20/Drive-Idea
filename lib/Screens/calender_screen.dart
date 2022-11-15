import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expacto_patronam/Models/event.dart';
import 'package:expacto_patronam/Screens/Add%20Screens/add_event_calendar.dart';
import 'package:expacto_patronam/Widgets/calendar_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/event_provider.dart';

class CalenderScreen extends StatefulWidget {
  static const routeName = "CALENDER_SCREEN";
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  var user = FirebaseAuth.instance.currentUser;
  CollectionReference calender = FirebaseFirestore.instance.collection("Calendar");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    List<EventModel> allEvents = [] ;
    calender.doc(user!.uid).get().then((value) {
      if(value.exists) {
        Map<String, dynamic> events = value.data() as Map<String, dynamic>;
        events.forEach((key, data) {
          allEvents.add(EventModel(eventID: key, title: data["title"], description: data["description"], from: DateTime.parse(data["from"]), to: DateTime.parse(data["to"]),));
        });
        final provider = Provider.of<EventProvider>(context,listen: false);
        provider.setAllEvent(allEvents);

        allEvents.clear();
        }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Calendar"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/background.jpg"),fit: BoxFit.fill,opacity: 0.3)
        ),
        child: const CalendarItem(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pushNamed(FormAddEventCa.routeName);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add,),

      ),
    );
  }
}
