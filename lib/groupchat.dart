import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:paymate/main.dart';
import 'package:paymate/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:intl/intl.dart';
//import 'group_list.dart';
import 'package:paymate/add_schedule.dart';
import 'package:firebase_auth/firebase_auth.dart';



class GroupChat extends StatefulWidget {
  final String meetingName; // 모임 이름
  final String groupId;
  final User? user;

  const GroupChat({
    super.key,
    required this.meetingName,
    required this.groupId,
    required this.user,
  });

  @override
  GroupChatState createState() => GroupChatState();
}

class GroupChatState extends State<GroupChat> {
  final Map<String, IconData> _categoryIcons = {
    '식비': Icons.fastfood,
    '카페/간식': Icons.local_cafe,
    '편의점/잡화': Icons.shopping_bag,
    '취미/여가': Icons.sports_esports,
    '의료/건강': Icons.local_hospital,
    '교통': Icons.directions_bus,
    '미용': Icons.brush,
    '여행': Icons.flight,
    '술/유흥': Icons.local_bar,
    '쇼핑': Icons.shopping_cart,
    '저축': Icons.savings,
    '교육': Icons.school,
    '공과금': Icons.receipt,
    '기타': Icons.category,
  };

double calculateTotalAmount(String userUid, List<Map<String,dynamic>> schedules) {
  double totalAmount = 0;

  for (var schedule in schedules) {

    // schedule_user에서 해당 userId가 포함된 경우만 계산
    final users = schedule['schedule_user'] ?? [];
    final creatorUid = schedule['Creator']?['Uid'];
        if((users.any((user) => user['Uid'] == user?.uid))){
    if (users.any((user) => user['Uid'] == userUid)) {
            final amount = schedule['money'] ?? 0;

      if(userUid==creatorUid){
        totalAmount -= (amount / users.length);
      }
      else if(creatorUid==user?.uid){
      totalAmount += (amount / users.length); // 금액을 사용자 수로 나눔
      }
    }
  }
}
  return totalAmount;
}

List<Map<String, dynamic>> groupuser=[];
List<Map<String, dynamic>> schedule=[];
User? user = FirebaseAuth.instance.currentUser;

bool isCompeleted = false; //정산이 완료되었는가? 버튼

  @override
  void initState() {
    super.initState();
    fetchGroupUsers(); 
    fetchSchedule();         
  }

// 특정 groupId에 해당하는 그룹의 user 필드를 실시간으로 가져오는 메서드
Future<void> fetchGroupUsers() async {
  try {
    String groupId = widget.groupId;
    
    FirebaseFirestore.instance
        .collection('group')
        .doc(groupId)
        .snapshots() // snapshots() 사용하여 실시간 데이터 수신
        .listen((groupDoc) {
      if (groupDoc.exists) {
        List<dynamic> users = groupDoc['members'];
        List<Map<String, dynamic>> fetchedGroupUsers = users.map((user) {
          return {
            'Uid': user['Uid'],
            'name': user['name'],
          };
        }).toList();

        // 상태 업데이트
        setState(() {
          groupuser = fetchedGroupUsers;
        });
      } else {
        print('Group not found');
      }
    });
  } catch (e) {
    print('그룹 데이터를 가져오는 중 오류 발생: $e');
  }
}


void fetchSchedule() {
  String groupId = widget.groupId;

  // Fetch the group document from Firestore
  var scheduleCollection = FirebaseFirestore.instance.collection('group').doc(groupId);

  scheduleCollection.snapshots().listen((snapshot) {
    if (snapshot.exists) {
      // Assuming the document contains a field named 'schedule' which is a list of maps
      List<Map<String, dynamic>> fetchedSchedule = List<Map<String, dynamic>>.from(snapshot.data()?['schedule'] ?? []);

      setState(() {
        schedule = fetchedSchedule;
      });
    } else {
      print("Group not found");
    }
  });
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: Header(headerTitle: widget.meetingName),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // 선택된 프로필 표시
if (groupuser.isNotEmpty)
  Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      children: [
        ...groupuser
            .where((profile) => profile['Uid'] == user?.uid) // "나"에 해당하는 프로필 먼저 필터링
            .map((profile) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Icon(
                  Icons.person, // 아이콘으로 대체
                  size: 40,
                  color: Colors.grey,
                ),
                SizedBox(height: 4),
                Text(
                  '나', // "나" 표시
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          );
        }),
        ...groupuser
            .where((profile) => profile['Uid'] != user?.uid) // 나머지 프로필
            .map((profile) {
            final userTotalAmount = calculateTotalAmount(profile['Uid'], schedule);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                const Icon(
                  Icons.person, // 아이콘으로 대체
                  size: 40,
                  color: Colors.grey,
                ),
                const SizedBox(height: 4),
                Text(
                  profile['name']!,
                  style: const TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userTotalAmount>0?
                  '+ ${userTotalAmount.toInt()}원' : '${userTotalAmount.toInt()}원',
                  style: const TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        }),
      ],
    ),
  ),
            // 일정 목록 표시
            Expanded(
              child:ListView.builder(
                itemCount: schedule.length,
                itemBuilder: (context,index){
                final scheduleItem=schedule[index];
                  return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                  children: [
                    // 분홍색 원형 아이콘
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFB2A5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _categoryIcons[scheduleItem['category']],
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),

                   Expanded(
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding
        child: Container(
        margin: const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: (scheduleItem['schedule_user'] ?? [])
              .any((friend) => friend['Uid'] == user?.uid) // Check if User1 is included
          ?const Color(0x00ffb2a5).withOpacity(0.2)//.withOpacity(0.2) // Highlight color if User1 is included
          : Colors.white,
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
            title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
          scheduleItem['title'], // Event title
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: Color(0xFF646464),
          ),
        ),
              const SizedBox(height: 8.0),
              Row(
          children: (() {
    List scheduleUsers = (scheduleItem['schedule_user'] ?? []);
    scheduleUsers.sort((a, b) {
      if (a['Uid'] == user?.uid) return -1; // '나'를 첫 번째로
      if (b['Uid'] == user?.uid) return 1;
      return 0;
    });

    return scheduleUsers.map<Widget>((friend) {
      final name = friend['name'] ?? '';
            return Container(
              margin: const EdgeInsets.only(right: 3.0),
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFC1C1C1), // Light grey background for avatar
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty
                      ? (friend['Uid'] == user?.uid ? '나' : name[0])
                      : ' ', // Display the first letter of the name or '나'
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList();})(),
        ),
            ],
          ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              scheduleItem['Creator']['Uid'] == user?.uid
                  ? '나'
                  : scheduleItem['Creator']['name'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF646464),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '₩ ${scheduleItem['money']}',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF646464),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
)

                  ]
                  ),
                );
                },
              ),
            )            
          ],
        ),
      ),

      // 우측 하단에 동그란 + 버튼 추가
      floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSchedule(
          groupId:widget.groupId,
          user:user,
          ),
      ),
    );
  },
  backgroundColor: const Color(0xFFFFB2A5),
  foregroundColor: Colors.white,
  shape: const CircleBorder(),
  child: const Icon(Icons.add),
),
    bottomNavigationBar: schedule.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: 16.0, left: 100.0, right: 100.0), // 아래쪽 여백만 조정하고 양옆 여백도 추가
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isCompeleted = !isCompeleted;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompeleted ? Colors.grey[600] : const Color(0xFFFFB2A5), // 상태에 따라 색 변경
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // 둥근 모서리
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                isCompeleted ? '정산 완료' : '정산완료하기', // 상태에 따라 텍스트 변경
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isCompeleted ? Colors.white : const Color(0xFF646464),
                ),
              ),
            ),
          )
        : null, // schedule이 비어있으면 버튼을 표시하지 않음
  );
}
  }
