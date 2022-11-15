
import 'package:flutter/material.dart';

import '../Models/icons.dart';

class IconItem extends StatelessWidget {
  int id;
  String title;
  String iconUrl;
  final String routName;

  IconItem({
    required this.id,
    required this.title,
    required this.iconUrl,
    required this.routName
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          Navigator.of(context).pushNamed(routName,arguments: IconsHome(id: id, title: title, iconUrl: iconUrl, routName: routName));
        },
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  boxShadow: const [
                    BoxShadow(color: Colors.black,blurRadius: 5)
                  ],
                  borderRadius: BorderRadius.circular(50),
                ),


                child: Image.asset(iconUrl,height: 95,width: 95,),
              ),
              Text(title,style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 20,)),
            ],
          ),
        )
    );
  }
}
