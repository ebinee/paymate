import 'package:flutter/material.dart';
import 'package:paymate/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'groupchat.dart';
import 'add_group_list.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupList extends StatefulWidget {
  final User? user;
  const GroupList({
    super.key,
    required this.user,
  });

  @override
  State<GroupList> createState() => GroupListState();
}

class GroupListState extends State<GroupList> {
  List<Map<String, dynamic>> groups = []; // 찐또배기 group의 doc.id/data
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    fetchGroups();
  }

  // Firestore에서 실시간 데이터를 가져오는 메서드
  Future<void> fetchGroups() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('group').get();
      final userGroup = snapshot.docs.where((doc) {
        final members = doc['members'] as List<dynamic>?;
        if (members == null) return false;

        return members.any((member) {
          if (member is Map<String, dynamic>) {
            return member['Uid'] == _user?.uid;
          } else if (member is String) {
            return member == _user?.uid;
          }
          return false;
        });
      });

      setState(() {
        groups = userGroup.map((doc) {
          return {
            'id': doc.id,
            'data': doc.data() as Map<String, dynamic>,
          };
        }).toList();
      });
    } catch (e) {
      // print("그룹 데이터를 가져오는 중 오류 발생: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(headerTitle: '모임 목록'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  // 새로운 모임 추가 기능
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddGroupList(
                                user: _user,
                              )) // AddGroupList
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
                    onTap: () {},
                    child: GroupCard(
                      meetingName:
                          groups[index]['data']['meetingName'] ?? 'Unknown',
                      date: groups[index]['data']['date'] is Timestamp
                          ? groups[index]['data']['date'] as Timestamp
                          : Timestamp.now(),
                      friends: (groups[index]['data']['members'] != null)
                          ? (groups[index]['data']['members'] as List<dynamic>)
                              .map<String>((user) {
                              if (user is Map<String, dynamic>) {
                                // Map 형태라면 'name' 필드 반환
                                return user['name'] ?? 'Unknown';
                              } else if (user is String) {
                                // 요소가 문자열(String)이라면 그대로 반환
                                return user;
                              }
                              return 'Unknown'; // 예상하지 못한 타입일 경우 기본값 반환
                            }).toList()
                          : <String>[],
                      groupId: groups[index]['id'],
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
  final String meetingName;
  final Timestamp date;
  final List<String> friends;
  final String groupId;
  final Color? backgroundColor;

  const GroupCard({
    super.key,
    required this.meetingName,
    required this.date,
    required this.friends,
    required this.groupId,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MM/dd').format(date.toDate());
    return GestureDetector(
      onTap: () async {
        try {
          final docSnapshot = await FirebaseFirestore.instance
              .collection('group')
              .doc(groupId)
              .get();
          if (docSnapshot.exists) {
            final data = docSnapshot.data();
            if (data != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupChat(
                    meetingName: meetingName,
                    groupId: groupId,
                  ),
                ),
              );
            }
          }
        } catch (e) {
          print('Error fetching group data: $e');
        }
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
                meetingName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                ' ${friends.join(', ')}',
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
