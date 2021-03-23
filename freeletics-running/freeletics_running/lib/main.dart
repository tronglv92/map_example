import 'package:flutter/material.dart';

import 'package:freeletics_running/pages/freeletics/freeletics_running_page.dart';
import 'package:freeletics_running/pages/menu/menu_page.dart';
import 'package:freeletics_running/pages/route_map/search_location/search_location_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'pages/route_map/map/map_page.dart';
import 'pages/route_map/search_location/search_location_page.dart';
import 'services/cache/cache_preferences.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>SearchLocationProvider(sessionToken: Uuid().v4())),
        Provider(create: (_)=>CachePreferences()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MenuPage(),
      ),
    );
  }
}


