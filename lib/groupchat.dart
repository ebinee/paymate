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
  final List<Map<String,dynamic>> schedule;
  final List<Map<String, dynamic>> user; // 선택된 프로필
  final String groupId;

  


  const GroupChat({
    super.key,
    required this.meetingName,
    required this.schedule,
    required this.user,
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

  @override
  Widget build(BuildContext context) {
    // 내 프로필을 포함한 프로필 목록
    final groupuser = [
      ...widget.user,
    ];
    for (var user in groupuser) {
      if (!user.containsKey('amount')) {
        user['amount'] = 0;  // amount 필드가 없으면 추가하고 0으로 초기화
      }
    }
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
                                profile['id']=='User1'?'' :'${profile['amount']}원',                                  
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
                itemCount: widget.schedule.length,
                itemBuilder: (context,index){
                final schedule=widget.schedule[index];
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
                        _categoryIcons[schedule['category']],
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),

                    Expanded(
                      child: ListTile(
                        
                      title: Text(
                        schedule['title'], // 일정 이름
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF646464),

                      ),
                      
                      //textAlign: TextAlign.start,
                      ),
                      subtitle:Row(
          children: (schedule['schedule_user']??[]).map<Widget>((friend) {
          final name = friend['name'] ?? '';

          return Container(
            margin: const EdgeInsets.only(right: 5.0),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
            ),
            child: Center(
              child: Text(
                name.isNotEmpty
                    ? (friend['id'] == 'User1' ? '나' : name[0])
                    : ' ', // 이름의 첫 글자만 표시
                style: const TextStyle(
                  color: Color(0xFF646464),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
                      trailing: 
                        Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                               Text(
                          schedule['scheduleCreator']['id']=='User1'?'나':schedule['scheduleCreator']['name'],
                          ),
                          const SizedBox(height:10),
                                    Text(
                                '${schedule['money']}원',                                  
                                textAlign:TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF646464),
                                ),),

                                  ],

                        )
                      ),
                    ),
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
          groupuser: groupuser,
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
    );
  }
}