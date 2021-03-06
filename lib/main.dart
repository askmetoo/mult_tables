import 'package:flutter/material.dart';
import 'package:mult_tables/pages/homePageWidget.dart';
import 'package:mult_tables/pages/quizPageWidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: HomePageWidget()),
    );
  }
}
