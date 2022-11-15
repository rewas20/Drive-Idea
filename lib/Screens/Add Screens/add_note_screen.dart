import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../Models/note.dart';

class FormAddNote extends StatefulWidget {
  static const routeName = "FORM_ADD_NOTE";
  const FormAddNote({Key? key}) : super(key: key);

  @override
  State<FormAddNote> createState() => _FormAddNoteState();
}

class _FormAddNoteState extends State<FormAddNote> {
  GlobalKey<FormState> formKeyAdd = GlobalKey<FormState>();
  var user = FirebaseAuth.instance.currentUser;
  CollectionReference notes = FirebaseFirestore.instance.collection("Notes");
  Color? textColor = const Color(0xff8F7959);
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String formatDate  = DateFormat("dd-MM-yyyy h:mm a").format(DateTime.now());


  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        shadowColor: Theme.of(context).primaryColor,
        elevation: 0,
        toolbarHeight: 70,
        actions: [
          IconButton(
              onPressed: (){
                addNote();
              },
              icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
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

                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: contentController,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Theme.of(context).primaryColor,
                      hintText: "Typ anything",
                      prefixIcon: const Icon(Icons.message),
                    ),
                    keyboardType: TextInputType.multiline,

                  ),
                  const SizedBox(
                    height: 20,
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  addNote(){

      formKeyAdd.currentState!.save();

      showDialog(context: context, builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      ),barrierDismissible: false);
      var checkValue = false;
      notes.doc(user!.uid).get().then((value) {
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
            notes.doc(user!.uid).update(NoteModel(titleController.text.trim(), title: titleController.text.trim(), time: formatDate, content:  contentController.text.trim()).getMap()).then((value){
              Fluttertoast.showToast(msg: "Added");
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
          }

        }else{
          notes.doc(user!.uid).set(NoteModel(titleController.text.trim(), title: titleController.text.trim(), time: formatDate, content:  contentController.text.trim()).getMap()).then((value){
            Fluttertoast.showToast(msg: "Added");
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        }

      } );

  }
}
