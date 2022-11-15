class NoteModel {
  String noteID;
  String title;
  String content;
  String time;

  NoteModel(
      this.noteID,
      {
        required this.title,
        required this.content,
        required this.time
      });

  Map<String,dynamic> getMap(){
    return {
      noteID: {
        "title" : title,
        "content" : content,
        "time" : time,
      }
    };
  }
}