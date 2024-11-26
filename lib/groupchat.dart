import 'package:flutter/material.dart';
import 'package:paymate/group_list.dart';
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
      if ((users
          .any((scheduleuser) => scheduleuser['Uid'] == widget.user?.uid))) {
        if (users.any((scheduleuser) => scheduleuser['Uid'] == userUid)) {
          final amount = schedule['money'] ?? 0;

          if (userUid == creatorUid) {
            totalAmount -= (amount / users.length);
          } else if (creatorUid == widget.user?.uid) {
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

//bool ? isAllCompleted;

  @override
  void initState() {
    super.initState();
    fetchGroupUsers(); 
    fetchSchedule();
//    fetchIsAllCompleted();
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

/*  Stream<bool> fetchIsAllCompleted() {
    // Firestore에서 해당 그룹 문서를 실시간으로 구독
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .snapshots()
        .map((groupSnapshot) {
      if (groupSnapshot.exists) {
        // 'User' 리스트 가져오기
        List users = groupSnapshot['User'];

        // 모든 사용자가 완료되었는지 확인
        return users.every((user) => user['isCompleted'] == true);
      }
      return false; // 그룹이 없으면 false
    });
  }
*/
  @override
  Widget build(BuildContext context) {

return Scaffold(
  appBar: AppBar(
    titleSpacing: -10.0,
    title: Text(widget.meetingName, style: const TextStyle(
            color: Color(0xFF646464),
            fontSize: 15,)),
    backgroundColor: Colors.white,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black,size:20,),
      onPressed: () {
        // 특정 페이지로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GroupList(user: _user)),
        );
      },
    ),
  ),
  backgroundColor: Colors.white,
  body: Container(
    color: Colors.white,
    padding: const EdgeInsets.all(10.0),
    child: Column(
      children: [
const SizedBox(height: 10),
Container(
  alignment: Alignment.topLeft, // 부모 컨테이너를 가운데 정렬
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal, // 가로 방향 스크롤 활성화
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center, // 가로 스크롤에서 아이템들을 가운데 정렬
      children: [
        if (groupuser.isEmpty)
          const SizedBox(height: 68) // 기본 공간 유지
        else
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
    )
  ),
const SizedBox(height: 20),

            // 일정 목록 표시
            Expanded(
              child: ListView.builder(
                itemCount: schedule.length,
                itemBuilder: (context, index) {
                  final scheduleItem = schedule[index];
                  return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                  children: [
                    // 분홍색 원형 아이콘
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB2A5).withOpacity(0.8),
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
          color: Colors.white,
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:
              Row(
          children: (() {
    List scheduleUsers = (scheduleItem['schedule_user'] ?? []);
    scheduleUsers.sort((a, b) {
      if (a['Uid'] == _user?.uid) return -1; // '나'를 첫 번째로
      if (b['Uid'] == _user?.uid) return 1;
      return 0;
    });

                                      return scheduleUsers
                                          .map<Widget>((friend) {
                                        final name = friend['name'] ?? '';
                                        return Container(
                                          margin:
                                              const EdgeInsets.only(right: 3.0),
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: (friend['Uid'] == _user?.uid)
                                                      ?const Color(0xFFFFB2A5) :const Color(0xFFC1C1C1),
                                          ),
                                          child: Center(
                                            child: Text(
                                              name.isNotEmpty
                                                  ? (friend['Uid'] == _user?.uid
                                                      ? '나'
                                                      : name[0])
                                                  : ' ',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                //fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList();
                                    })(),
              )
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
                    ]),
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
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('group').doc(widget.groupId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // 데이터 로딩 중일 때 표시
            }

            if (snapshot.hasError) {
              return Center(child: Text('오류가 발생했습니다.'));
            }

            // User 데이터 가져오기
            List users = snapshot.data!['members']??[];

            // isCompleted 상태에 따라 버튼 텍스트 및 색상 결정
            bool allCompleted = true;
            bool anyCompleted = false;

            for (var user in users) {
              if (user['isCompleted'] == false) {
                allCompleted = false;
              } else {
                anyCompleted = true;
              }
            }

            String buttonText ;//= '정산완료하기';
            Color buttonColor ;//= const Color(0xFFFFB2A5).withOpacity(0.2);
            Color textColor ;//= Colors.grey[600]!;

            if (allCompleted) {
              buttonText = '정산 완료';
              buttonColor = Colors.grey[600]!;
              textColor = Colors.white;
            } else if (anyCompleted) {
              buttonText = '정산 진행 중';
              buttonColor = Colors.grey.withOpacity(0.2);
              textColor = Colors.grey[600]!;
            }
            else{
              buttonText = '정산 시작하기';
              buttonColor = Color(0xFFFFB2A5) .withOpacity(0.6);
              textColor = Colors.grey[600]!;
            }

            return ElevatedButton(
              onPressed: () async {
                String userId = _user?.uid ?? ''; // 현재 사용자의 UID를 가져옵니다.
                if (userId.isNotEmpty) {
                  // 버튼 클릭 시 isCompleted 상태 반전
                  FirebaseFirestore.instance.collection('group').doc(widget.groupId).get().then((groupDoc) async {
                    List users = groupDoc['members'];

                    for (var i = 0; i < users.length; i++) {
                      if (users[i]['Uid'] == userId) {
                        bool currentStatus = users[i]['isCompleted'] == true;
                        users[i]['isCompleted'] = currentStatus ? false : true;
                        await FirebaseFirestore.instance.collection('group').doc(widget.groupId).update({
                          'members': users, // 수정된 배열로 업데이트
                        });
                        break;
                      }
                    }
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor, // 상태에 따른 색상
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                buttonText, // 상태에 따른 텍스트
                style: TextStyle(
                  fontSize: 16,
//                 fontWeight: FontWeight.bold,
                  color: textColor, // 상태에 따른 텍스트 색상
                ),
              ),
            );
          },
        ),
      )
    : null, // schedule이 비어있으면 버튼을 표시하지 않음
);


  }
  }
