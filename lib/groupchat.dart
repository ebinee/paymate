import 'package:flutter/material.dart';
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


  const GroupChat({
    super.key,
    required this.meetingName,
    required this.schedule,
    required this.user,
  });

  @override
  GroupChatState createState() => GroupChatState();
}

class GroupChatState extends State<GroupChat> {
  //final List<Map<String, dynamic>> _schedules = [];

  /*void _navigateToAddSchedule() async {
    final scheduleData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSchedule(
          groupuser: widget.user, // 선택된 친구 목록 전달
        ),
      ),
    );

    if (scheduleData != null) {
      setState(() {
        _schedules.add(scheduleData);
      });
    }
  }
  */

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
      {'name': '나',
        'id' : 'me',
      },
      ...widget.user,
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2E8DA),
        title: Text(widget.meetingName), // 모임 이름 표시
      ),
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
                            profile['name']!,
                            style: const TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            // 일정 목록 표시
            ...widget.schedule.map((schedule) {
              // 일정에 내 프로필을 추가한 프로필 목록
              final scheduleUser = [
                {'name': '나','id':'me'},
                ...schedule['schedule_user'],
              ];

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
                    // 일정 정보 표시
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              schedule['title'], // 일정 이름
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF646464),
                              ),
                            ),
                            const SizedBox(height: 5),
                            // 일정 친구들 프로필
                            Row(
                              children: scheduleUser.map<Widget>((friend) {
                              // `friend`가 Map 타입인지 확인하고 `name`이 문자열인지 확인
                                final name = /*friend is Map<String, dynamic> ?*/ friend['name'] ??'';
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
                                        name.isNotEmpty ? name[0] : ' ', // 이름의 첫 글자만 표시
                                        style: const TextStyle(
                                        color: Color(0xFF646464),
                                        fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '${schedule['money']}원',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF646464),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
      // 우측 하단에 동그란 + 버튼 추가
      floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSchedule(groupuser: groupuser),
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