import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paymate/header.dart';
import 'package:paymate/sign_in.dart';
import 'package:paymate/enquiry.dart';

class MyInfo extends StatefulWidget {
  const MyInfo({super.key});

  @override
  State<MyInfo> createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {
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
        appBar: const Header(headerTitle: "내 정보"),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(width: 10),
                                const Icon(Icons.person_outline_outlined,
                                    size: 50, color: Color(0xFF646464)),
                                const SizedBox(width: 15),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    userName,
                                    style: const TextStyle(
                                      color: Color(0xFF646464),
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    userId,
                                    style: const TextStyle(
                                      color: Color(0xFF646464),
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(
                          color: Color(0xFFF2E8DA),
                          thickness: 1.5, // 선 두께
                          indent: 0,
                          endIndent: 0,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Row(
                          children: [
                            SizedBox(
                              width: 25,
                            ),
                            Text(
                              "계정",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.grey),
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
                                MaterialPageRoute(
                                    builder: (context) => const SignIn()),
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
                          thickness: 1.5, // 선 두께
                          indent: 0,
                          endIndent: 0,
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
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            SizedBox(
                              width: 25,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(children: [
                          const SizedBox(
                            width: 25,
                          ),
                          TextButton(
                            onPressed: () {
                              //Navigator.push(context,
                              //  MaterialPageRoute(builder: context)=>const enquiry)
                            },
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
                          height: 8,
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
                ),
              ),
            ],
          ),
        ));
  }
}
