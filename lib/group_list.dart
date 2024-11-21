import 'package:flutter/material.dart';
import 'package:paymate/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'groupchat.dart';
import 'add_group_list.dart';
import 'package:paymate/main.dart';


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
      appBar: const Header(headerTitle: '모임 목록'),
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
                    onTap: () {                    },
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
                      groupId :groups[index]['id'],
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
  final String groupId;
  final Color? backgroundColor;

  const GroupCard({
    super.key,
    required this.groupName,
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
          final docSnapshot = await FirebaseFirestore.instance.collection('group').doc(groupId).get();
          if (docSnapshot.exists) {
            final data = docSnapshot.data();
            if (data != null) {
              List<Map<String, dynamic>> users = List<Map<String, dynamic>>.from(data['user'] ?? []);
              List<Map<String, dynamic>> schedule = List<Map<String, dynamic>>.from(data['schedule'] ?? []);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupChat(
                    meetingName: groupName,
                    schedule: schedule,
                    user: users,
                  ),
                ),
              );
            }
          } 
        }
        catch (e) {
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