import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expacto_patronam/Models/map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class FormAddLocation extends StatefulWidget {
   const FormAddLocation({Key? key}) : super(key: key);

  @override
  State<FormAddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<FormAddLocation> {
  GlobalKey<FormState> formKeyAdd = GlobalKey<FormState>();
  var user = FirebaseAuth.instance.currentUser;
  CollectionReference mapPlaces = FirebaseFirestore.instance.collection("Map");
  Color? textColor = const Color(0xff8F7959);
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  String formatDate  = DateFormat("dd-MM-yyyy h:mm a").format(DateTime.now());

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    linkController.dispose();
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
            controller: descController,
            maxLength: 50,
            maxLines: 2,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: "Description(Optional)",
              prefixIcon: const Icon(Icons.description),
            ),
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: linkController,

            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              hintText: "url",
              prefixIcon: const Icon(Icons.link),
            ),
            keyboardType: TextInputType.url,
            validator: (value){
              if(value!.isEmpty){
                return "Url is Required";
              }if(!value.contains("/")){
                return "invalid URL";
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
                  addLocation();
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
  addLocation(){
    if(formKeyAdd.currentState!.validate()){
      formKeyAdd.currentState!.save();

      showDialog(context: context, builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      ),barrierDismissible: false);
      var checkValue = false;
      mapPlaces.doc(user!.uid).get().then((value) {
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
            mapPlaces.doc(user!.uid).update(LocationPlaces(descController.text.trim(),titleController.text.trim(), title: titleController.text.trim(), link: linkController.text.trim(), time: formatDate).getMap()).then((value){
              Fluttertoast.showToast(msg: "Added");
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
          }

        }else{
          mapPlaces.doc(user!.uid).set(LocationPlaces(descController.text.trim(),titleController.text.trim(), title: titleController.text.trim(), link: linkController.text.trim(), time: formatDate).getMap()).then((value){
            Fluttertoast.showToast(msg: "Added");
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        }

      } );
    }
  }
}
