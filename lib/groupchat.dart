import 'package:flutter/material.dart';
import 'package:paymate/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paymate/add_schedule.dart';
import 'package:firebase_auth/firebase_auth.dart';



class GroupChat extends StatefulWidget {
  final String meetingName; 
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
        if((users.any((scheduleuser) => scheduleuser['Uid'] == widget.user?.uid))){
    if (users.any((scheduleuser) => scheduleuser['Uid'] == userUid)) {
            final amount = schedule['money'] ?? 0;

      if(userUid==creatorUid){
        totalAmount -= (amount / users.length);
      }
      else if(creatorUid==widget.user?.uid){
      totalAmount += (amount / users.length); 
      }
    }
  }
}
  return totalAmount;
}

List<Map<String, dynamic>> groupuser=[];
List<Map<String, dynamic>> schedule=[];
User? _user;

bool ? isCompeleted;

  @override
  void initState() {
    super.initState();
    fetchGroupUsers(); 
    fetchSchedule();
    fetchIsCompleted();
    _user = widget.user;
         
  }

Future<void> fetchGroupUsers() async {
  try {
    String groupId = widget.groupId;
    
    FirebaseFirestore.instance
        .collection('group')
        .doc(groupId)
        .snapshots() 
        .listen((groupDoc) {
      if (groupDoc.exists) {
        List<dynamic> users = groupDoc['members'];
        List<Map<String, dynamic>> fetchedGroupUsers = users.map((_groupuser) {
          return {
            'Uid': _groupuser['Uid'],
            'name': _groupuser['name'],
          };
        }).toList();

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

  var scheduleCollection = FirebaseFirestore.instance.collection('group').doc(groupId);

  scheduleCollection.snapshots().listen((snapshot) {
    if (snapshot.exists) {
      List<Map<String, dynamic>> fetchedSchedule = List<Map<String, dynamic>>.from(snapshot.data()?['schedule'] ?? []);

      setState(() {
        schedule = fetchedSchedule;
      });
    } else {
      print("Group not found");
    }
  });
}

Future<void> fetchIsCompleted() async {
  try {
    String groupId = widget.groupId;

    FirebaseFirestore.instance
        .collection('group')
        .doc(groupId)
        .snapshots()
        .listen((groupDoc) {
      if (groupDoc.exists) {
        setState(() {
          isCompeleted = groupDoc.data()?['isCompeleted'] ?? false;
        });
      } else {
        print('Group document not found');
      }
    });
  } catch (e) {
    print('Error fetching isCompeleted: $e');
  }
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
            .where((profile) => profile['Uid'] == _user?.uid) // "나"에 해당하는 프로필 먼저 필터링
            .map((profile) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Icon(
                  Icons.person, 
                  size: 40,
                  color: Colors.grey,
                ),
                SizedBox(height: 4),
                Text(
                  '나', 
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
                SizedBox(height: 15),
              ],
            ),
          );
        }),
        ...groupuser
            .where((profile) => profile['Uid'] != _user?.uid) 
            .map((profile) {
            final userTotalAmount = calculateTotalAmount(profile['Uid'], schedule);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                const Icon(
                  Icons.person, 
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
                const SizedBox(height: 15),
              ],
            ),
          );
        }),
      ],
    ),
  ),
            // 일정 목록 표시
            Expanded(
              child: ListView.builder(
                itemCount: schedule.length,
                itemBuilder: (context, index) {
                  final scheduleItem = schedule[index];
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
    padding: const EdgeInsets.only(bottom: 1.0), 
        child: Container(
        margin: const EdgeInsets.only(right: 40),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: (scheduleItem['schedule_user'] ?? [])
              .any((friend) => friend['Uid'] == _user?.uid) 
          ?const Color(0xFFFFB2A5).withOpacity(0.2)
          : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
      child: ListTile(
            title: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
          scheduleItem['title'], 
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF646464),
          ),
        ),
              const SizedBox(height: 12.0),
              Row(
          children: (() {
    List scheduleUsers = (scheduleItem['schedule_user'] ?? []);
    scheduleUsers.sort((a, b) {
      if (a['Uid'] == _user?.uid) return -1; // '나'를 첫 번째로
      if (b['Uid'] == _user?.uid) return 1;
      return 0;
    });

    return scheduleUsers.map<Widget>((friend) {
      final name = friend['name'] ?? '';
            return Container(
              margin: const EdgeInsets.only(right: 3.0),
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFC1C1C1),
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty
                      ? (friend['Uid'] == _user?.uid ? '나' : name[0])
                      : ' ', 
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
              scheduleItem['Creator']['Uid'] == _user?.uid
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
//                fontWeight: FontWeight.bold,
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
          user:_user,
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
            String groupId = widget.groupId;
            FirebaseFirestore.instance.collection('group').doc(groupId).update({
              'isCompeleted': !(isCompeleted ?? false), // 현재 상태 반전
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: (isCompeleted ?? false) ? Colors.grey[600] : const Color(0xFFFFB2A5).withOpacity(0.2), // 상태에 따라 색 변경
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), 
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                (isCompeleted ?? false) ? '정산 완료' : '정산완료하기', // 상태에 따라 텍스트 변경
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: (isCompeleted ?? false) ?  Colors.white : Colors.grey[600] ,
                ),
              ),
            ),
          )
        : null, // schedule이 비어있으면 버튼을 표시하지 않음
  );
}
  }
