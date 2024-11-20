import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paymate/header.dart';

class FriendList extends StatefulWidget {
  const FriendList({super.key});

  @override
  State<FriendList> createState() => FriendListState();
}

class FriendListState extends State<FriendList> {
  final TextEditingController _idController = TextEditingController();
  final List<Map<String, dynamic>> _friends = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('myuser').get();

    final List<Map<String, dynamic>> friends = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': data['id'] ?? 'Unknown',
        'name': data['name'] ?? 'Unknown',
      };
    }).toList();

    setState(() {
      _friends.addAll(friends);
    });
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmationDialog(String name, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xffffffff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: EdgeInsets.zero,
          title: const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              '친구삭제',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff646464),
                fontSize: 20,
              ),
            ),
          ),
          content: Text(
            '$name 을 (를) 삭제하시겠습니까?',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xff646464),
              fontSize: 20,
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xffffffff),
                backgroundColor: const Color(0xff646464),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w100,
                ),
              ),
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xffffffff),
                backgroundColor: const Color(0xff646464),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w100,
                ),
              ),
              child: const Text('삭제'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteFriend(name, id);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteFriend(String name, String id) {
    setState(() {
      _friends.removeWhere(
          (friend) => friend['name'] == name && friend['id'] == id);
    });
  }

  void _addFriend(BuildContext context, String id) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final QuerySnapshot querySnapshot =
          await firestore.collection('user').where('id', isEqualTo: id).get();

      if (querySnapshot.docs.isNotEmpty) {
        final Map<String, dynamic> data =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        final String name = data['name'] ?? 'Unknown';

        setState(() {
          _friends.add({'name': name, 'id': id});
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('해당하는 아이디가 없습니다.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('친구 추가 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Header(
        headerTitle: "친구 목록",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                _navigateToNewPage(context);
              },
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        )
                      ],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(width: 10),
                          Icon(Icons.person_outline_outlined,
                              size: 50, color: Color(0xFF646464)),
                          SizedBox(width: 15),
                          Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Text(
                              '이수현',
                              style: TextStyle(
                                color: Color(0xFF646464),
                                fontSize: 30,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Padding(
                            padding: EdgeInsets.only(bottom: 2),
                            child: Text(
                              'TNGUSDL',
                              style: TextStyle(
                                color: Color(0xFF646464),
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: const Color(0xffffffff),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      titlePadding: EdgeInsets.zero,
                      title: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          '친구추가',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff646464),
                            fontSize: 20,
                          ),
                        ),
                      ),
                      content: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 3.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              controller: _idController,
                              decoration: const InputDecoration(
                                hintText: '아이디 ID',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2.0, vertical: 8.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xffffffff),
                            backgroundColor: const Color(0xff646464),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 12),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          child: const Text('추가',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15)),
                          onPressed: () {
                            String enteredId = _idController.text;
                            Navigator.of(context).pop();
                            _addFriend(context, enteredId);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '친구추가',
                    style: TextStyle(
                      color: Color(0xFF646464),
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.add,
                    size: 15,
                    color: Color(0xFF646464),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: _friends.length,
                itemBuilder: (context, index) {
                  final friend = _friends[index];
                  return Column(children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 222, 216),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.2),
                            spreadRadius: 0,
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 0,
                          bottom: 10,
                          top: 5,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(Icons.person_outline_outlined,
                                size: 40, color: Color(0xFF646464)),
                            const SizedBox(width: 15),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                friend['name']!,
                                style: const TextStyle(
                                  color: Color(0xFF646464),
                                  fontSize: 23,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                friend['id']!,
                                style: const TextStyle(
                                  color: Color(0xFF646464),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.centerRight, // 오른쪽 정렬
                              child: IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.grey),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                      friend['name']!, friend['id']!);
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToNewPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const NewPage(id: "TNGUSDL", name: "이수현")),
    );
  }
}

class NewPage extends StatelessWidget {
  final String id;
  final String name;

  const NewPage({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(
        headerTitle: "내 정보",
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.person_pin, size: 300, color: Colors.pinkAccent),
            const SizedBox(height: 10),
            Text(name, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 5),
            Text('ID : $id', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
