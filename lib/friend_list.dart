import 'package:flutter/material.dart';
import 'package:paymate/header.dart';

class FriendList extends StatefulWidget {
  const FriendList({super.key});

  @override
  State<FriendList> createState() => FriendListState();
}

class FriendListState extends State<FriendList> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Header(
        headerTitle: '친구 목록',
      ),
    );
  }
}
