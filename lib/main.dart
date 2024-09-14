import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locate/view/map_view.dart';

void main() {
  WidgetsFlutterBinding();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Map App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapView(), // Initial view
    );
  }
}
