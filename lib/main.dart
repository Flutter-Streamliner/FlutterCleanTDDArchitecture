import 'package:flutter/material.dart';
import 'injection_container.dart' as di;

void main() async {
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}
      
class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container();
  }

}
