import 'package:flutter/material.dart';
import 'package:paymate/header.dart';

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
                    Text(name, style: const TextStyle(fontSize: 40)),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 7.0),
                      child: Text('ID : $id',
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    id,
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
                height: 20,
              ),
              const Row(children: [
                SizedBox(
                  width: 25,
                ),
                Text(
                  "로그아웃",
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              const Row(children: [
                SizedBox(
                  width: 25,
                ),
                Text(
                  "문의하기",
                  style: TextStyle(
                    fontSize: 18,
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
      ),
    );
  }
}
