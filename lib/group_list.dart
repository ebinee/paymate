import 'package:flutter/material.dart';
import 'package:paymate/main.dart';
import 'package:paymate/add_schedule.dart';
import 'package:paymate/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GroupList extends StatefulWidget {
  const GroupList({super.key});

  @override
  State<GroupList> createState() => GroupListState();
}

class GroupListState extends State<GroupList> {
  List<Map<String, dynamic>> groups = [];

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    try {
      CollectionReference groupCollection =
          FirebaseFirestore.instance.collection('group');
      QuerySnapshot snapshot = await groupCollection.get();

      List<Map<String, dynamic>> fetchedGroups = snapshot.docs.map((doc) {
        return {
          'id': doc.id, // 이게 문서의 고유ID를 가져오는 코드!! 현비언니 참고 >_<
          'data': doc.data(),
        };
      }).toList();

      setState(() {
        groups = fetchedGroups;
      });
    } catch (e) {
      print("그룹 데이터를 가져오는 중 오류 발생: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(headerTitle: '모임 목록'), // header.dart의 Header 사용
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  // 새로운 모임 추가 기능
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const AddGroupList()), // AddGroupList
                  );
                },
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFFFB2A5)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: IconButton(
                      icon: Icon(Icons.add, color: Color(0xFF646464)),
                      onPressed: null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                groups[index]['page']), // 채팅창(?) 같은 곳으로 이동
                      );*/
                    },
                    child: GroupCard(
                      groupName:
                          groups[index]['data']['meetingName'] ?? 'Unknown',
                      date: groups[index]['data']['date'] is Timestamp
                          ? groups[index]['data']['date'] as Timestamp
                          : Timestamp.now(),
                      friends: (groups[index]['data']['user'] != null)
                          ? (groups[index]['data']['user'] as List<dynamic>)
                              .map<String>((user) =>
                                  user['name'] ??
                                  'Unknown') // 명시적으로 List<String>으로 변환
                              .toList()
                          : <String>[],
                    ),
                  );
                },
              ),
            ],
          )),
    );
  }
}

class GroupCard extends StatelessWidget {
  final String groupName;
  final Timestamp date;
  final List<String> friends;
  final Color? backgroundColor;

  const GroupCard({
    super.key,
    required this.groupName,
    required this.date,
    required this.friends,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MM/dd').format(date.toDate());
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const App()), // 원하는 페이지로 이동
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0x00ffb2a5).withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/iceBear.jpg'),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                groupName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                ' ${friends.join(', ')}',
                //"User",
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF646464),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
          trailing: Text(formattedDate),
        ),
      ),
    );
  }
}

/* 여기서부터 현비 Time~ */
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
                          'meetingName': meetingName,
                          'user': selectedProfiles,
                          'date': FieldValue.serverTimestamp(), // 생성 시간 필드 추가
                        });

                        // 성공 시 화면 전환
                        if (mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupChat(
                                meetingName: meetingName,
                                selectedProfiles: selectedProfiles,
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

class GroupChat extends StatelessWidget {
  final String meetingName; // 모임 이름
  final List<Map<String, dynamic>> selectedProfiles; // 선택된 프로필

  const GroupChat({
    super.key,
    required this.meetingName,
    required this.selectedProfiles,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2E8DA), // 상단바 배경색
        title: Text(
          meetingName,
          style: const TextStyle(color: Colors.black), // 상단바 텍스트
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
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8, // 한 행에 8개
            childAspectRatio: 1,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          itemCount: selectedProfiles.length,
          itemBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(selectedProfiles[index]
                          ['imageUrl'] ??
                      'https://via.placeholder.com/150'), // 프로필 이미지 URL
                ),
                const SizedBox(height: 4),
                Text(
                  selectedProfiles[index]['name']!,
                  style: const TextStyle(fontSize: 8.0),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSchedule()),
          );
        },
        backgroundColor: const Color(0xFFFFB2A5),
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// class AddSchedule extends StatelessWidget {
//   const AddSchedule({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(' '),
//       ),
//       body: const Center(
//         child: Text(' '),
//       ),
//     );
//   }
// }
