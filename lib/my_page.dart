import 'package:flutter/material.dart';
import 'package:paymate/header.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  // final String id;
  // final String name;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Header(
        headerTitle: "My Page",
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.person_pin, size: 300, color: Colors.pinkAccent),
            SizedBox(height: 10),
            /*Text(name, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 5),
            Text('ID : $id', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),*/
          ],
        ),
      ),
    );
  }
}
