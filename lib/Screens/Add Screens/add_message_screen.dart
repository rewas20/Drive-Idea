import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../Models/message.dart';

class FormAddMessage extends StatefulWidget {
  const FormAddMessage({Key? key}) : super(key: key);

  @override
  State<FormAddMessage> createState() => _FormAddMessageState();
}

class _FormAddMessageState extends State<FormAddMessage> {
  GlobalKey<FormState> formKeyAdd = GlobalKey<FormState>();
  var user = FirebaseAuth.instance.currentUser;
  CollectionReference messages = FirebaseFirestore.instance.collection("Messages");
  Color? textColor = const Color(0xff8F7959);
  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  String formatDate  = DateFormat("dd-MM-yyyy h:mm a").format(DateTime.now());

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKeyAdd,
      child: Column(
        children: [
          TextFormField(
            controller: titleController,
            maxLength: 15,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              hintText: "Add Title",
              labelText: "Title",
              prefixIcon: const Icon(Icons.title),

            ),
            keyboardType: TextInputType.text,
            validator: (value){
              if(value!.isEmpty){
                return "Title is Required";
              }else if(value.length >15){
                return "Title must be at most less than '15' characters ";
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: messageController,
            maxLines: 15,
            minLines: 15,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              hintText: "Copy Message here",
              labelText: "Message",
              prefixIcon: const Icon(Icons.message),
            ),
            keyboardType: TextInputType.multiline,
            validator: (value){
              if(value!.isEmpty){
                return "Message is Required";
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: ()  {
                  addMessage();
                },
                child:  Text("Add",style: TextStyle(fontSize: 20,color: textColor)),
              ),
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text("Cancel",style: TextStyle(fontSize: 20,color: textColor)),
              ),
            ],
          )
        ],
      ),
    );
  }
  addMessage(){
    if(formKeyAdd.currentState!.validate()){
      formKeyAdd.currentState!.save();

      showDialog(context: context, builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      ),barrierDismissible: false);
      var checkValue = false;
      messages.doc(user!.uid).get().then((value) {
        if(value.exists){
          Map<String,dynamic> locations = value.data() as Map<String,dynamic>;
          locations.forEach((key, data) {
            if(key==titleController.text.trim()){
              checkValue = true;
            }
          });
          if(checkValue){
            Fluttertoast.showToast(msg: "try another title");
            Navigator.of(context).pop();
          }else{
            messages.doc(user!.uid).update(MessageModel(titleController.text.trim(), title: titleController.text.trim(), time: formatDate, message:  messageController.text.trim()).getMap()).then((value){
              Fluttertoast.showToast(msg: "Added");
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
          }

        }else{
          messages.doc(user!.uid).set(MessageModel(titleController.text.trim(), title: titleController.text.trim(), time: formatDate, message:  messageController.text.trim()).getMap()).then((value){
            Fluttertoast.showToast(msg: "Added");
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        }

      } );
    }
  }
}
