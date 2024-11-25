import 'package:flutter/material.dart';
import 'package:paymate/header.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
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
          ],
        ),
      ),
    );
  }
}
