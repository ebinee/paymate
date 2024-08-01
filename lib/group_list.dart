import 'package:flutter/material.dart';
import 'package:paymate/header.dart';

class GroupList extends StatefulWidget {
  const GroupList({super.key});

  @override
  State<GroupList> createState() => GroupListState();
}

class GroupListState extends State<GroupList> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Header(
        headerTitle: '모임 목록',
      ),
    );
  }
}
