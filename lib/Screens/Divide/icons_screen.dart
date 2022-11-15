import 'package:flutter/material.dart';

import '../../Data/data.dart';
import '../../Widgets/icons_item.dart';

class ViewIconsHome extends StatelessWidget {
  const ViewIconsHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.only(top: 50),
      children: ICONS_HOME.map((icData) => IconItem(id: icData.id, title: icData.title, iconUrl: icData.iconUrl,routName: icData.routName), ).toList(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.5,
        childAspectRatio: 2.5/2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),

    );
  }
}
