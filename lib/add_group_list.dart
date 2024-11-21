import 'package:flutter/material.dart';
import 'package:paymate/main.dart';
import 'package:paymate/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'groupchat.dart';


class AddGroupList extends StatefulWidget {
  const AddGroupList({super.key});

  @override
  State<AddGroupList> createState() => _AddGroupList();
}

class _AddGroupList extends State<AddGroupList> {
  List<Map<String, dynamic>> friends = [];

  @override
  void initState() {
    super.initState();
    fetchFriends();
  }

  Future<void> fetchFriends() async {
    try {
      // Firestore의 'group' 컬렉션 참조
      CollectionReference friendsCollection =
          FirebaseFirestore.instance.collection('user');

      // 데이터 가져오기
      QuerySnapshot snapshot = await friendsCollection.get();

      // 데이터를 List<Map<String, dynamic>>로 변환
      List<Map<String, dynamic>> fetchFriends = snapshot.docs.map((doc) {
        return {
          'id': doc['id'],
          'name': doc['name'],
        };
      }).toList();

      // 상태 업데이트
      setState(() {
        friends = fetchFriends;
      });
    } catch (e) {
      print("그룹 데이터를 가져오는 중 오류 발생: $e");
    }
  }

  String meetingName = ''; // 모임 이름
  Set<int> selectedFriends = {}; // 선택된 친구
  List<Map<String, dynamic>> selectedProfiles = []; // 선택된 친구 리스트

  bool _isCreateButtonEnabled() {
    return meetingName.isNotEmpty && selectedFriends.isNotEmpty;
  }

  void _toggleFriendSelection(int index) {
    setState(() {
      if (selectedFriends.contains(index)) {
        selectedFriends.remove(index);
        selectedProfiles.remove(friends[index]);
      } else {
        selectedFriends.add(index);
        selectedProfiles.add(friends[index]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2E8DA), // 상단바 배경색
        title: const Text(
          '모임 추가',
          style: TextStyle(color: Colors.black), // 상단바 텍스트
        ),
        iconTheme: const IconThemeData(color: Colors.black), // 상단바 아이콘
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.transparent, // 투명
                borderRadius: BorderRadius.circular(12.0), // 모서리
                border: Border.all(
                    color: const Color(0xFFFFB2A5), width: 1.0), // 테두리
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '모임 이름',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        meetingName = value; // 입력값 저장
                      });
                    },
                    style: const TextStyle(fontSize: 18.0),
                    decoration: const InputDecoration(
                      hintText: '모임 이름을 입력하세요',
                      border: InputBorder.none,
                    ),
                  ),
                  const Divider(color: Colors.black, thickness: 1.0), // 밑줄 추가
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (selectedProfiles.isEmpty)
                  const SizedBox(height: 68) // 기본 공간 유지
                else
                  ...selectedProfiles.map((friend) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                                'https://via.placeholder.com/150'), // 프로필 이미지 URL 아이콘으로 교체 가능
                          ),
                          const SizedBox(height: 8),
                          Text(
                            friend['name']!,
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final bool isSelected = selectedFriends.contains(index);
                  return GestureDetector(
                    onTap: () {
                      _toggleFriendSelection(index);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFFB2A5) // 선택된 경우 핑크색
                            : const Color(0xFF646464).withOpacity(0.2), // 기본 회색
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person, // 아이콘으로 대체
                            size: 40,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  friends[index]['name']!,
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  friends[index]['id']!,
                                  style: const TextStyle(
                                      fontSize: 14.0, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isCreateButtonEnabled()
                  ? () async {
                      try {
                        // Firestore 인스턴스 가져오기
                        final firestore = FirebaseFirestore.instance;
                        // 'group' 컬렉션에 새 문서 생성 및 데이터 저장
                        await firestore.collection('group').add({
                          
                          'date': FieldValue.serverTimestamp(), // 생성 시간 필드 추가
                          'meetingName': meetingName,
                          'schedule':[],
                          'user': selectedProfiles,
                          });

                        // 성공 시 화면 전환
                        if (mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupChat(
                                meetingName: meetingName,
                                schedule:[],
                                user:selectedProfiles,
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        // 에러 핸들링 (예: 스낵바로 에러 메시지 표시)
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('모임 생성 실패: $e')),
                          );
                        }
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: const Color(0xFF646464),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Center(
                child: Text(
                  '모임 생성',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
