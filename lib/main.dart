import 'package:expacto_patronam/Screens/Add%20Screens/add_event_calendar.dart';
import 'package:expacto_patronam/Screens/Add%20Screens/add_note_screen.dart';
import 'package:expacto_patronam/Screens/calender_screen.dart';
import 'package:expacto_patronam/Screens/home_screen.dart';
import 'package:expacto_patronam/Screens/login_screen.dart';
import 'package:expacto_patronam/Screens/map_screen.dart';
import 'package:expacto_patronam/Screens/messages_screen.dart';
import 'package:expacto_patronam/Screens/notes_screen.dart';
import 'package:expacto_patronam/Screens/photos_screen.dart';
import 'package:expacto_patronam/Screens/signup_screen.dart';
import 'package:expacto_patronam/Screens/videos_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Provider/event_provider.dart';
import 'Screens/splash_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
 MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expacto Patronam',
        theme: ThemeData(
          primaryColor: const Color(0xffefca95),
          primaryColorDark: const Color(0xffefd295),
          primarySwatch: Colors.grey,
          errorColor: Colors.redAccent,
        ),
        routes: {
          '/' : (context) => const SplashScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          PhotosScreen.routeName: (context) => const PhotosScreen(),
          NotesScreen.routeName: (context) => const NotesScreen(),
          VideosScreen.routeName: (context) => const VideosScreen(),
          CalenderScreen.routeName: (context) => const CalenderScreen(),
          MessagesScreen.routeName: (context) => const MessagesScreen(),
          MapScreen.routeName: (context) => const MapScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          SignUpScreen.routeName: (context) => const SignUpScreen(),
          FormAddNote.routeName: (context) => const FormAddNote(),
          FormAddEventCa.routeName: (context) => const FormAddEventCa(),
        },
      ),
    );
  }
}
