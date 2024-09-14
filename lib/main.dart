import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'view/map_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor:
        Colors.transparent, // Makes the status bar background color transparent
    statusBarIconBrightness: Brightness.dark, // Controls the icon brightness
    statusBarBrightness: Brightness.light, // Controls the status bar brightness
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Location Distance App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LocationDistanceView(),
    );
  }
}
