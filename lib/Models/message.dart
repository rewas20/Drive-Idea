class MessageModel{
  String messageID;
  String title;
  String message;
  String time;

  MessageModel(
      this.messageID,
      {
        required this.title,
        required this.message,
        required this.time
      });

  Map<String,dynamic> getMap(){
    return {
      messageID: {
        "title" : title,
        "message" : message,
        "time" : time,
      }
    };
  }
}