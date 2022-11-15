import 'package:expacto_patronam/Widgets/note_item.dart';
import 'package:flutter/material.dart';

import '../../Models/note.dart';

class NotesItemsScreen extends StatelessWidget {
   List<NoteModel> allNotes = [];


   NotesItemsScreen({Key? key,
     required this.allNotes
   }) : super(key: key);

   @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.only(top: 10,left: 5,right: 5),
      children: allNotes.map((noteData) => NoteItem(noteData.noteID, title: noteData.title, content: noteData.content, time: noteData.time)).toList(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.5,
        childAspectRatio: 2.5/3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),

    );
  }
}
