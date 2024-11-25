import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paymate/header.dart';
import 'package:paymate/sign_in.dart';

class enquiry extends StatefulWidget {
  const enquiry({super.key});

  @override
  State<enquiry> createState() => _enquiryState();
}

class _enquiryState extends State<enquiry> {
  String userId = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentSnapshot snapshot1 =
        await firestore.collection('user').doc(user?.email).get();
    if (snapshot1.exists) {
      final data = snapshot1.data() as Map<String, dynamic>;
      setState(() {
        userId = data['id'] ?? 'Unknown ID';
        userName = data['name'] ?? 'Unknown Name';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Header(
          headerTitle: "문의하기",
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Column(children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    children: [
                      Text("이름"),
                      SizedBox(width: 39),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    children: [
                      Text("이메일"),
                      SizedBox(width: 26),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    children: [
                      Text("문의제목"),
                      SizedBox(width: 13),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft, // 왼쪽 정렬
                    child: Text(
                      "문의내용",
                      textAlign: TextAlign.left, // 텍스트 내부 정렬
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 300, // TextField의 높이
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 180, // 내부 여백 (위, 아래)
                                horizontal: 10, // 내부 여백 (양옆)
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // 버튼을 화면 중앙에 배치
                    children: [
                      // '취소' 버튼
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                          backgroundColor: Colors.white, // 버튼 배경색
                          side: const BorderSide(color: Colors.red), // 테두리 색
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15), // 글씨 색
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // 버튼 모서리 둥글게
                          ),
                        ),
                        child: const Text(
                          "취소",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 20), // 버튼 사이 간격
                      // '접수' 버튼
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('접수가 완료되었습니다.'),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red, // 버튼 배경색
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15), // 글씨 색
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // 버튼 모서리 둥글게
                          ),
                        ),
                        child: const Text(
                          "접수",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  )
                ]))));
  }
}
