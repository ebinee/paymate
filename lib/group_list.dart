import 'package:flutter/material.dart';
import 'package:paymate/main.dart';
import 'package:paymate/add_schedule.dart';

class GroupList extends StatefulWidget {
  const GroupList({super.key});

  @override
  State<GroupList> createState() => GroupListState();
}

class GroupListState extends State<GroupList> {
  // Example list of group data with additional properties
  final List<Map<String, dynamic>> groups = [
    {
      'name': '엽떡팟',
      'date': '07/22',
      'friends': '김두콩, 이뚜현, 네넨이, 인지 23 이강훈',
      'color': const Color(0xFFFFB2A5).withOpacity(0.2),
      'image': 'assets/images/iceBear.jpg',
      'page': const App(),
    },
    {
      'name': '갓생스터디',
      'date': '07/22',
      'friends': '김두콩, 이뚜현, 네넨이, 이숨',
      'color': const Color(0xFFFFB2A5).withOpacity(0.2),
      'image': 'assets/images/pinkBear.jpg',
      'page': const App(),
    },
    {
      'name': '계절총회',
      'date': '06/25',
      'friends': '컴공 23 박우진, 인지 23 이강훈, 인지 23 신은준',
      'color': const Color(0xFFB0B0B0),
      'image': 'assets/images/iceBear.jpg',
      'page': const App(),
    },
    {
      'name': '군바',
      'date': '06/22',
      'friends': '컴공 23 하성준, 이뚜현, 최지뇽',
      'color': const Color(0xFFB0B0B0),
      'image': 'assets/images/pinkBear.jpg',
      'page': const App(),
    },
    {
      'name': '종강총회',
      'date': '06/21',
      'friends': '강지현, 강민서, 김효정, 박우진, 신은준',
      'color': const Color(0xFFB0B0B0),
      'image': 'assets/images/pinkBear.jpg',
      'page': const App(),
    },
    {
      'name': '밥약',
      'date': '06/10',
      'friends': '컴공 23 하성준, 이숨, 박건형, 이서준',
      'color': const Color(0xFFB0B0B0),
      'image': 'assets/images/pinkBear.jpg',
      'page': const App(),
    },
    // 추가 모임 데이터...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0), // 원하는 높이로 설정 (단위: 픽셀)
        child: AppBar(
          backgroundColor: const Color(0xFFF2E8DA),
          elevation: 0,
          title: const Text(
            '모임 목록',
            style: TextStyle(color: Color(0xFF646464)),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: Color(0xFF646464)),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const App()));
            },
          ),
        ),
      ),
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
                      builder: (context) => const AddSchedule()), // 원하는 화면으로 전환
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              groups[index]['page']), // 원하는 화면으로 전환
                    );
                  },
                  child: GroupCard(
                    groupName: groups[index]['name'],
                    date: groups[index]['date'],
                    friends: groups[index]['friends'],
                    backgroundColor: groups[index]['color'],
                    imagePath: groups[index]['image'],
                    // imagePath2: groups[index]['image2'],
                    //imagePath3: groups[index]['image3'],
                    //imagePath4: groups[index]['image4'],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  final String groupName;
  final String date;
  final String friends;
  final Color? backgroundColor;
  final String imagePath;
  //final String imagePath2;
  //final String imagePath3;
  //final String imagePath4;

  const GroupCard({
    super.key,
    required this.groupName,
    required this.date,
    required this.friends,
    this.backgroundColor,
    required this.imagePath,
    //this.imagePath2,
    //this.imagePath3,
    //this.imagePath4,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 각 모임별 페이지
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const App()), // 원하는 화면으로 전환
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(10),
        //height: 100,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
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
          leading: CircleAvatar(
            backgroundImage: AssetImage(imagePath),
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
              const SizedBox(height: 8.0), // title과 subtitle 사이의 여백
              Text(
                friends,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF646464),
                ),
                overflow: TextOverflow.ellipsis, // This will truncate the text
                maxLines: 1,
              ),
            ],
          ),
          trailing: Text(date),
        ),
      ),
    );
  }
}
