import '../Models/icons.dart';
import '../Screens/calender_screen.dart';
import '../Screens/map_screen.dart';
import '../Screens/messages_screen.dart';
import '../Screens/notes_screen.dart';
import '../Screens/photos_screen.dart';
import '../Screens/videos_screen.dart';

var ICONS_HOME = [
  IconsHome(id: 1, title: "Photos", iconUrl: "assets/icons/photos.png",routName: PhotosScreen.routeName),
  IconsHome(id: 2, title: "Notes", iconUrl: "assets/icons/notes.png",routName: NotesScreen.routeName),
  IconsHome(id: 3, title: "Videos", iconUrl: "assets/icons/videos.png",routName: VideosScreen.routeName),
  IconsHome(id: 4, title: "Calender", iconUrl: "assets/icons/calender.png",routName: CalenderScreen.routeName),
  IconsHome(id: 5, title: "Messages", iconUrl: "assets/icons/messages.png",routName: MessagesScreen.routeName),
  IconsHome(id: 6, title: "Map", iconUrl: "assets/icons/map.png",routName: MapScreen.routeName),
];