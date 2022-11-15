import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expacto_patronam/Models/map.dart';
import 'package:expacto_patronam/Models/message.dart';
import 'package:expacto_patronam/Screens/Add%20Screens/add_message_screen.dart';
import 'package:expacto_patronam/Widgets/message_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/location_item.dart';

class MessagesScreen extends StatefulWidget {
  static const routeName = "MESSAGES_SCREEN";
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  Color? textColor = const Color(0xff8F7959);
  var user = FirebaseAuth.instance.currentUser;
  CollectionReference messages = FirebaseFirestore.instance.collection("Messages");
  List<MessageModel> allMessages = [];
  List<MessageModel> messageUser = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Theme.of(context).primaryColor,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Messages"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/background.jpg"),fit: BoxFit.fill)
        ),
        child: StreamBuilder(
          stream: messages.snapshots(),
          builder: (ctx,AsyncSnapshot<QuerySnapshot> snapShot){
            if(snapShot.data!=null){
              final data = snapShot.data!.docs ;

              for (var element in data) {
                final dataId = element.data() as Map<String,dynamic>;

                if(element.id==user!.uid){
                  messageUser.clear();
                  dataId.forEach((key, value) {
                    messageUser.add(MessageModel(key, title: value["title"], time: value["time"], message: value["message"]));
                  });
                  allMessages = messageUser;
                }

              }}


            /*data.forEach((key, value) {
              allMap.add(LocationPlaces(value["description"], value["locationID"], title: value["title"], link: value["link"], time: value["time"]));
            });*/
            return ListView.builder(
              itemCount: allMessages.length,
              itemBuilder: (ctx,index){
                return MessageItem(allMessages[index].messageID, title: allMessages[index].title, time: allMessages[index].time, message: allMessages[index].message);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: (){
          showDialog(context: context, builder: (context)=>alertDialog(context));
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }



  Widget alertDialog(context){
    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Center(
          child: AlertDialog(
              alignment: Alignment.center,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              actionsPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Container(
                  alignment: Alignment.center,
                  child:  Text("Add Message",style: TextStyle(fontSize: 20,color: textColor,fontWeight: FontWeight.w800,),),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: textColor,
                ),
                const SizedBox(
                  height: 20,
                ),
                const FormAddMessage(),
              ]),
        ),
      ),
    );
  }
}
