import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FriendList(),
    );
  }
}

class FriendList extends StatefulWidget {
  const FriendList({super.key});

  @override
  State<FriendList> createState() => FriendListState();
}

class FriendListState extends State<FriendList> {
  final TextEditingController _idController = TextEditingController();
  Map<String, String> _idToNameMap = {};
  List<Map<String, String>> _friends = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot snapshot = await firestore.collection('myuser').get();

      Map<String, String> idToNameMap = {};
      List<Map<String, String>> friends = [];

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String id = data['id'] ?? 'Unknown';
        String name = data['name'] ?? 'Unknown';
        idToNameMap[id] = name;
        friends.add({'name': name, 'id': id});
      }

      setState(() {
        _idToNameMap = idToNameMap;
        _friends = friends;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
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

  void _addFriend(String id) async {
    // Firestore 인스턴스 생성
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // 'user' 컬렉션에서 해당 id를 가진 문서 검색
      final QuerySnapshot querySnapshot =
          await firestore.collection('user').where('id', isEqualTo: id).get();

      // 검색 결과가 있는지 확인
      if (querySnapshot.docs.isNotEmpty) {
        final Map<String, dynamic> data =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        final String name = data['name'] ?? 'Unknown';

        // 상태 업데이트 및 Firestore에 친구 추가
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
      appBar: AppBar(
        title: const Text('친구 목록'),
        backgroundColor: const Color(0xFFf2e8da),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 30),
            Row(
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
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
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
                            _addFriend(enteredId);
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(Icons.person_outline_outlined,
                                size: 40, color: Color(0xFF646464)),
                            const SizedBox(width: 15),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
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
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(
                                friend['id']!,
                                style: const TextStyle(
                                  color: Color(0xFF646464),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmationDialog(
                                    friend['name']!, friend['id']!);
                              },
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
}
