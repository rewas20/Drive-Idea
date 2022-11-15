import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expacto_patronam/Models/note.dart';
import 'package:expacto_patronam/Screens/Add%20Screens/add_note_screen.dart';
import 'package:expacto_patronam/Screens/Divide/notes_items_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  static const routeName = "NOTES_SCREEN";
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  Color? textColor = const Color(0xff8F7959);
  var user = FirebaseAuth.instance.currentUser;
  CollectionReference notes = FirebaseFirestore.instance.collection("Notes");
  List<NoteModel> allNotes= [];
  List<NoteModel> noteUser = [];
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Theme.of(context).primaryColor,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Notes"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/background.jpg"),fit: BoxFit.fill)
        ),
        child: StreamBuilder(
          stream: notes.snapshots(),
          builder: (ctx,AsyncSnapshot<QuerySnapshot> snapShot){
            if(snapShot.data!=null){
              final data = snapShot.data!.docs ;

              for (var element in data) {
                final dataId = element.data() as Map<String,dynamic>;

                if(element.id==user!.uid){
                  noteUser.clear();
                  dataId.forEach((key, value) {
                    noteUser.add(NoteModel(key, title: value["title"], time: value["time"], content: value["content"]));
                  });
                  allNotes = noteUser;
                }

              }}


            /*data.forEach((key, value) {
              allMap.add(LocationPlaces(value["description"], value["locationID"], title: value["title"], link: value["link"], time: value["time"]));
            });*/
            return NotesItemsScreen(allNotes: allNotes);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: (){
          showDialog(context: context, builder: (context) => const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          ),barrierDismissible: false);
           Navigator.of(context).pushNamed(FormAddNote.routeName).then((value) => Navigator.of(context).pop());
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

}