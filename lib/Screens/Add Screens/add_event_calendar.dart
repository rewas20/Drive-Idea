import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../Models/event.dart';
import '../../Models/utils.dart';
import '../../Provider/event_provider.dart';

class FormAddEventCa extends StatefulWidget {
  static const routeName = "FORM_ADD_EVENT";
  final EventModel? event;


  const FormAddEventCa({Key? key,  this.event}) : super(key: key);

  @override
  State<FormAddEventCa> createState() => _FormAddEventCaState();
}

class _FormAddEventCaState extends State<FormAddEventCa> {
  GlobalKey<FormState> formKeyAdd = GlobalKey<FormState>();
  var user = FirebaseAuth.instance.currentUser;
  CollectionReference calender = FirebaseFirestore.instance.collection("Calendar");
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;
  late String eventID ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.event==null){
      fromDate = DateTime.now();
      toDate = DateTime.now().add(const Duration(hours: 2));
    }else{
      eventID = widget.event!.eventID;
      titleController.text = widget.event!.title;
      fromDate = widget.event!.from;
      toDate = widget.event!.to;
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(),
            onPressed: saveForm,
            icon: const Icon(Icons.check),
            label: const Text("Save"),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKeyAdd,
          child:Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                style: const TextStyle(fontSize: 25),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: "Add Title",
                  labelText: "Title",
                ),
                onFieldSubmitted: (_)=>saveForm(),
                keyboardType: TextInputType.text,
                validator: (title)=> title!.isEmpty? 'Title is required': null ,
              ),
              const SizedBox(
                height: 15,
              ),
              buildDateTimePicker(),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: descController,
                maxLines: 10,
                style: const TextStyle(fontSize: 25),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  hintText: "description",
                  labelText: "Description(optional)",
                ),
                onFieldSubmitted: (_)=>saveForm(),
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
        ),
      ),
    );
  }



 Widget buildDateTimePicker() => Column(
      children: [
        buildForm(),
        buildTo(),
      ],
  );

Widget buildForm() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      const Text("from", style: TextStyle(fontWeight: FontWeight.bold),),
      Row(
        children: [
          Expanded(
            flex: 2,
            child:ListTile(
                title: Text(Utils.toDate(fromDate)),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: (){
                  pickFromDateTime(pickDate: true);
                },
                ) ,
          ),
          Expanded(
            child: ListTile(
              title: Text(Utils.toTime(fromDate)),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: (){
                pickFromDateTime(pickDate: false);
              },
            ) ,
          ),
        ],
      )
    ],
  );
}

  Widget buildTo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text("to", style: TextStyle(fontWeight: FontWeight.bold),),
        Row(
          children: [
            Expanded(
              flex: 2,
              child:ListTile(
                title: Text(Utils.toDate(toDate)),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: (){
                  pickToDateTime(pickDate: true);
                },
              ) ,
            ),
            Expanded(
              child: ListTile(
                title: Text(Utils.toTime(toDate)),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: (){
                  pickToDateTime(pickDate: false);
                },
              ) ,
            ),
          ],
        )
      ],
    );
  }


  Future pickFromDateTime({required bool pickDate}) async{
    final date = await pickDateTime(fromDate,pickDate: pickDate);
    if(date == null){
      return;
    }
    if(date.isAfter(toDate)){
      toDate = DateTime(date.year,date.month,date.day,toDate.hour,toDate.minute);
    }
    setState(() {
      fromDate = date;
    });
 }

  Future pickToDateTime({required bool pickDate}) async{
    final date = await pickDateTime(toDate,pickDate: pickDate,
    firstDate: pickDate ? fromDate : null,
    );
    if(date == null){
      return null;
    }
    setState(() {
      toDate = date;
    });
  }

 Future<DateTime?> pickDateTime(
    DateTime initialDate, {
      required bool pickDate,
       DateTime? firstDate
})async {
  if(pickDate){
    final date = await showDatePicker(
      context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2015,5),
      lastDate: DateTime(2101),
    );
    if(date == null){
      return null;
    }else {
      final time = Duration(hours: initialDate.hour,minutes: initialDate.minute);
      return date.add(time);
    }
  }else {
    final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
    );
    if(timeOfDay == null ){
      return null;
    }else{

      final date = DateTime(initialDate.year,initialDate.month,initialDate.day);
      final time = Duration(hours: timeOfDay.hour,minutes: timeOfDay.minute);
      return date.add(time);
    }
  }
 }

   saveForm(){
   final isValid = formKeyAdd.currentState!.validate();
   if(isValid) {
     formKeyAdd.currentState!.save();
       var event = EventModel(
           eventID: titleController.text,
           title: titleController.text,
           description: descController.text,
           from: fromDate,
           to: toDate
       );
     final isEditing = widget.event != null;
     final provider = Provider.of<EventProvider>(context,listen: false);
      if(isEditing){

        calender.doc(user!.uid).update({widget.event!.eventID: FieldValue.delete()}).then((value) {

        calender.doc(user!.uid).update(EventModel(eventID: event.eventID,title: event.title,description: event.description,from: event.from,to: event.to ).getMap()).then((value) => Navigator.of(context).pop());
        });
        provider.editEvent(event, widget.event!);

        Navigator.of(context).pop();
      }else{
        addEvent(event);
        provider.addEvent(event);
      }
  }
}
  void addEvent(EventModel event){

      showDialog(context: context, builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      ),barrierDismissible: false);
      var checkValue = false;
      calender.doc(user!.uid).get().then((value) {
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
            calender.doc(user!.uid).update(EventModel(eventID: event.title,title:event.title,description: event.description,from: event.from,to: event.to,backGroundColor: event.backGroundColor,isAllDay: false ).getMap()).then((value){
              Fluttertoast.showToast(msg: "saved");
              Navigator.of(context).pop();
              Navigator.of(context).pop();

            });
          }

        }else{
          calender.doc(user!.uid).set(EventModel(eventID: event.title,title:event.title,description: event.description,from: event.from,to: event.to,backGroundColor: event.backGroundColor,isAllDay: false ).getMap()).then((value){
            Fluttertoast.showToast(msg: "saved");

            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        }

      } );
    }

}
