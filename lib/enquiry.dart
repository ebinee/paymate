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
          headerTitle: "내 정보",
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(children: [
                  const Padding(padding: EdgeInsets.only(left: 35)),
                  const Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(userName, style: const TextStyle(fontSize: 40)),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 7.0),
                        child: Text('ID : $userId',
                            style: const TextStyle(fontSize: 18)),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ]),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  color: Color(0xFFF2E8DA),
                  thickness: 1, // 선 두께
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      "계정",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 25,
                    ),
                    const Text(
                      "아이디",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      userId,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 25,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(children: [
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    "비밀번호 변경",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 8,
                ),
                Row(children: [
                  const SizedBox(
                    width: 25,
                  ),
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const SignIn()),
                        (route) => false,
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      '로그아웃',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w100,
                        fontSize: 18,
                      ),
                    ),
                  )
                ]),
                const SizedBox(
                  height: 8,
                ),
                const Divider(
                  color: Color(0xFFF2E8DA),
                  thickness: 1, // 선 두께
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      "이용 안내",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      "앱 버전",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "demo",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(
                      width: 25,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(children: [
                  const SizedBox(
                    width: 25,
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      '문의하기',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w100,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 20,
                ),
                const Row(children: [
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    "회원탈퇴",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  color: Color(0xFFF2E8DA),
                  thickness: 1, // 선 두께
                  indent: 20,
                  endIndent: 20,
                ),
              ]),
        )));
  }
}
