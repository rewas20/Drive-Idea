import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expacto_patronam/Models/event.dart';
import 'package:expacto_patronam/Provider/event_provider.dart';
import 'package:expacto_patronam/Screens/Add%20Screens/add_event_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventViewScreen extends StatelessWidget {
  var user = FirebaseAuth.instance.currentUser;
  CollectionReference calender = FirebaseFirestore.instance.collection("Calendar");
  final EventModel event;

   EventViewScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: [
         IconButton(
              onPressed: (){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context)=>FormAddEventCa(event: event))
                );
              },
              icon: const Icon(Icons.edit)
          ),
          IconButton(
              onPressed: (){
                showDialog(context: context, builder: (context) => const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),barrierDismissible: false);
                final provider = Provider.of<EventProvider>(context,listen: false);
                calender.doc(user!.uid).update({event.eventID: FieldValue.delete()}).then((value) => Navigator.of(context).pop());
                provider.deleteEvent(event);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.delete)
          ),

        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(32),
        children: [

          Text("Title",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
          Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 2),
            ),
            child: Text(event.title,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
          ),

          const SizedBox(height: 32,),

          Text("Description",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
          Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 2),
            ),
            child: Text(event.description,style: TextStyle(color: Colors.black,fontSize: 15,),),
          ),

          const SizedBox(height: 24,),
          Text("Duration",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
          Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 2),
            ),
            child: Column(
              children: [

                SizedBox(
                  height: 5,
                ),
                Text("from: ${event.from}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                SizedBox(
                  height: 5,
                ),
                Text("to: ${event.to}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
