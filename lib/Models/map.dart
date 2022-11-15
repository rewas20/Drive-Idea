class LocationPlaces {
  String locationID;
  String title;
  String description;
  String link;
  String time;

  LocationPlaces(
      this.description,
      this.locationID,
      {
    required this.title,
    required this.link,
    required this.time
  });

  Map<String,dynamic> getMap(){
    return {
      locationID: {
        "title" : title,
        "description" : description,
        "link" : link,
        "time" : time,
      }
    };
  }
}