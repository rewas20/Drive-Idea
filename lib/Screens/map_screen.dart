import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expacto_patronam/Models/map.dart';
import 'package:expacto_patronam/Screens/Add%20Screens/add_location_screen.dart';
import 'package:expacto_patronam/Widgets/location_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  static const routeName = "MAP_SCREEN";
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Color? textColor = const Color(0xff8F7959);
  var user = FirebaseAuth.instance.currentUser;
  CollectionReference locations = FirebaseFirestore.instance.collection("Map");
  List<LocationPlaces> allMap = [];
  List<LocationPlaces> places = [];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F3DA),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Map"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/background.jpg"),fit: BoxFit.fill)
        ),
        child: StreamBuilder(
          stream: locations.snapshots(),
          builder: (ctx,AsyncSnapshot<QuerySnapshot> snapShot){
            if(snapShot.data!=null){
            final data = snapShot.data!.docs ;

            for (var element in data) {
              final dataId = element.data() as Map<String,dynamic>;

              if(element.id==user!.uid){
                places.clear();
                dataId.forEach((key, value) {
                  places.add(LocationPlaces(value["description"], key, title: value["title"], link: value["link"], time: value["time"]));
                  });
                allMap = places;
              }

            }}


            /*data.forEach((key, value) {
              allMap.add(LocationPlaces(value["description"], value["locationID"], title: value["title"], link: value["link"], time: value["time"]));
            });*/
            return ListView.builder(
              itemCount: allMap.length,
              itemBuilder: (ctx,index){
                return LocationItem(allMap[index].description, allMap[index].locationID, title: allMap[index].title, link: allMap[index].link, time: allMap[index].time);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: (){
          showDialog(context: context, builder: (context)=>alertDialog(context));
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }



  Widget alertDialog(context){
    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
          child: Center(
            child: AlertDialog(
                alignment: Alignment.center,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                actionsPadding: const EdgeInsets.all(20),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  Container(
                    alignment: Alignment.center,
                    child:  Text("Add Location",style: TextStyle(fontSize: 20,color: textColor,fontWeight: FontWeight.w800,),),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: textColor,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const FormAddLocation(),
                ]),
          )
      ),
    );
  }
}
