import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:paymate/main.dart';
import 'package:paymate/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:intl/intl.dart';
//import 'group_list.dart';
import 'package:paymate/add_schedule.dart';


class GroupChat extends StatefulWidget {
  final String meetingName; // 모임 이름
  final String groupId;

  const GroupChat({
    super.key,
    required this.meetingName,
    required this.groupId,
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

List<Map<String, dynamic>> groupuser=[];
List<Map<String, dynamic>> schedule=[];

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
        List<dynamic> users = groupDoc['user'];
        List<Map<String, dynamic>> fetchedGroupUsers = users.map((user) {
          return {
            'id': user['id'],
            'name': user['name'],
            'amount':(!user.containsKey('amount'))?0:user['amount'],
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
 /*   for (var user in groupuser) {
      if (!user.containsKey('amount')) {
        user['amount'] = 0;  // amount 필드가 없으면 추가하고 0으로 초기화
      }
    }
*/

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
                  children: groupuser.map((profile) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          // 프로필 이미지
                          const CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                                'https://via.placeholder.com/150'), // 프로필 이미지 URL
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile['id']=='User1'?'나':profile['name']!,
                            style: const TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
profile['amount'] <= 0
    ? (profile['id'] == 'User1' ? '' : '${profile['amount']}원')
    : '+ ${profile['amount']}원',                            
    style: const TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    );
                  }).toList(),
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
                    Container(
                    width: 2, // 선 두께
                    color: Colors.grey.shade300, // 선 색상
                  ),
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
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners for the card
      ),
      color: (scheduleItem['schedule_user'] ?? [])
              .any((friend) => friend['id'] == 'User1') // Check if User1 is included
          ? Color(0xFFFFB2A5).withOpacity(0.2) // Highlight color if User1 is included
          : Colors.white, // Default color
      elevation: 5, // Shadow effect for elevation
      shadowColor: Colors.grey.withOpacity(0.5), // Light shadow
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0), // Add padding inside ListTile
        title: Text(
          scheduleItem['title'], // Event title
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF646464),
          ),
        ),
        subtitle: Row(
          children: (scheduleItem['schedule_user'] ?? []).map<Widget>((friend) {
            final name = friend['name'] ?? '';
            return Container(
              margin: const EdgeInsets.only(right: 5.0),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade300, // Light grey background for avatar
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty
                      ? (friend['id'] == 'User1' ? '나' : name[0])
                      : ' ', // Display the first letter of the name or '나'
                  style: const TextStyle(
                    color: Color(0xFF646464),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              scheduleItem['scheduleCreator']['id'] == 'User1'
                  ? '나'
                  : scheduleItem['scheduleCreator']['name'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF646464),
              ),
            ),
            const SizedBox(height: 8),
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
            padding: const EdgeInsets.only(bottom: 16.0, left: 40.0, right: 40.0), // 아래쪽 여백만 조정하고 양옆 여백도 추가
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
                  color: isCompeleted ? Colors.white : Color(0xFF646464),
                ),
              ),
            ),
          )
        : null, // schedule이 비어있으면 버튼을 표시하지 않음
  );
}
  }
