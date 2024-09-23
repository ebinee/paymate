import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
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
=======
import 'package:cloud_firestore/cloud_firestore.dart';
>>>>>>> 8d1961a2f3848ab06eeda10299efc0366312545d

class FriendList extends StatefulWidget {
  const FriendList({super.key});

  @override
  State<FriendList> createState() => FriendListState();
}

class FriendListState extends State<FriendList> {
  final TextEditingController _idController = TextEditingController();
<<<<<<< HEAD
  Map<String, String> _idToNameMap = {};
  List<Map<String, String>> _friends = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }
=======

  Map<String, String> _idToNameMap = {};

  final List<Widget> _containers = [];
>>>>>>> 8d1961a2f3848ab06eeda10299efc0366312545d

  Future<void> _fetchData() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
<<<<<<< HEAD
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
=======
      // Firestore 컬렉션에서 데이터를 읽어옵니다.
      QuerySnapshot snapshot = await firestore.collection('user').get();

      // 데이터를 Map으로 변환합니다.
      Map<String, String> idToNameMap = {};
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String id = doc.id;
        String name =
            data['name'] ?? 'Unknown'; // 필드 이름은 Firestore에서의 필드 이름과 일치해야 합니다.
        idToNameMap[id] = name;
        setState(() {
          _addContainer(name, id);
        });
      }

      // 상태를 업데이트하여 UI를 새로 고칩니다.
      setState(() {
        _idToNameMap = idToNameMap;
>>>>>>> 8d1961a2f3848ab06eeda10299efc0366312545d
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
<<<<<<< HEAD
                Navigator.of(context).pop();
=======
                Navigator.of(context).pop(); // 대화상자 닫기
>>>>>>> 8d1961a2f3848ab06eeda10299efc0366312545d
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
<<<<<<< HEAD
                Navigator.of(context).pop();
                _deleteFriend(name, id);
=======
                Navigator.of(context).pop(); // 대화상자 닫기
                _deleteContainer(name, id);
>>>>>>> 8d1961a2f3848ab06eeda10299efc0366312545d
              },
            ),
          ],
        );
      },
    );
  }

<<<<<<< HEAD
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
=======
  void _deleteContainer(String name, String id) {
    setState(() {
      _containers.removeWhere((container) {
        if (container is Container) {
          final child = container.child as Padding;
          final row = child.child as Row;
          final textWidgets = row.children.whereType<Text>().toList();
          final textName = textWidgets[0].data;
          final textId = textWidgets[1].data;
          return textName == name && textId == id;
        }
        return false;
      });
    });
  }

  void _addContainer(String name, String id) {
    setState(() {
      _containers.add(
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(Icons.person_outline_outlined,
                    size: 40, color: Color(0xFF646464)),
                const SizedBox(
                  width: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Color(0xFF646464),
                      fontSize: 23,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    id,
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
                      _showDeleteConfirmationDialog(name, id);
                    }),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        ),
      );
      _containers.add(const SizedBox(height: 15));
    });
>>>>>>> 8d1961a2f3848ab06eeda10299efc0366312545d
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
<<<<<<< HEAD
                              style: TextStyle(fontSize: 15)),
                          onPressed: () {
                            String enteredId = _idController.text;
                            Navigator.of(context).pop();
                            _addFriend(enteredId);
=======
                              style: TextStyle(
                                fontSize: 15,
                              )),
                          onPressed: () {
                            String enteredId = _idController.text;
                            Navigator.of(context).pop();

                            String? name = _idToNameMap[enteredId];

                            if (name != null) {
                              _addContainer(name, enteredId);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('해당 아이디에 맞는 이름이 없습니다.')));
                            }
>>>>>>> 8d1961a2f3848ab06eeda10299efc0366312545d
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
<<<<<<< HEAD
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
=======
              child: ListView(
                children: _containers,
>>>>>>> 8d1961a2f3848ab06eeda10299efc0366312545d
              ),
            ),
          ],
        ),
      ),
    );
  }
}
