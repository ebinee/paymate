import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paymate/header.dart';

class HowToUse extends StatefulWidget {
  const HowToUse({super.key});

  @override
  State<HowToUse> createState() => _HowToUseState();
}

class _HowToUseState extends State<HowToUse> {
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

    // Firebase에서 사용자 데이터 가져오기
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
        headerTitle: "어플리케이션 사용법",
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: ListView(
          children: [
            const ListTile(
              title: Text('홈 화면 사용법'),
              subtitle: Text(
                  '앱을 실행하여 로그인하면 첫 번째 화면에서 가계부, 친구목록, 모임목록을 선택할 수 있습니다. 또, 그래프를 통해 월별 지출내역을 한눈으로 볼 수 있습니다. 원하는 메뉴를 클릭하여 원하는 기능을 이용하세요.'),
            ),
            const ListTile(
              title: Text('프로필'),
              subtitle: Text(
                  '내 정보를 확인하려면 화면 상단의 사람 아이콘이나 친구목록에서 내 프로필을 클릭하여 프로필을 확인할 수 있습니다.'),
            ),
            const ListTile(
              title: Text('MY 가계부'),
              subtitle: Text(
                  '이번달에 지출한 내역을 카테고리별로 볼 수 있습니다. 달력의 날짜를 선택하면 해당 날짜의 총 지출과 지출내역을 볼 수 있습니다.'),
            ),
            const ListTile(
              title: Text('MY 친구목록'),
              subtitle:
                  Text('나의 친구를 확인할 수 있는 페이지로, 아이디로 친구추가가 가능하고 친구삭제도 가능합니다.'),
            ),
            const ListTile(
              title: Text('MY 모임목록'),
              subtitle: Text(
                  '모임을 새로 추가할 수 있으며, 기존에 있던 모임이 확인 가능합니다. 목록에서는 모임명, 구성원, 모임날짜가 확인 가능합니다. 원하는 모임을 누르면 모임 구성원들끼리 각자 정산할 금액을 올립니다. 그러면 모임 구성원들 간 최종으로 주고받을 금액이 나타납니다. 모두 정산을 하고 정산완료하기를 누르면 해당 모임은 비활성화됩니다.'),
            ),
            const ListTile(
              title: Text('고객 지원'),
              subtitle: Text('앱 사용 중 문제가 발생하면 "문의하기" 메뉴를 클릭하여 문의하세요.'),
            ),
            ListTile(
              title: const Text('사용자 ID'),
              subtitle: Text(userId),
            ),
            ListTile(
              title: const Text('사용자 이름'),
              subtitle: Text(userName),
            ),
          ],
        ),
      ),
    );
  }
}
