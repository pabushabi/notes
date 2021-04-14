import 'package:flutter/material.dart';
import 'HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Заметки',
      theme: ThemeData(
          fontFamily: "Roboto",
          iconTheme: IconThemeData(color: Color.fromARGB(255, 59, 73, 73)),
          primaryColor: Color.fromARGB(255, 59, 73, 73),
          accentColor: Color.fromARGB(255, 246, 85, 85),
          canvasColor: Color.fromARGB(255, 255, 255, 255),
          textSelectionColor: Color.fromARGB(50, 59, 73, 73)),
      home: HomePage(),
    );
  }
}
