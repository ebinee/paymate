import 'package:flutter/material.dart';
import 'package:paymate/header.dart';
import 'package:paymate/main.dart';
//import ''

class GroupList extends StatefulWidget {
  const GroupList({super.key});

  @override
  State<GroupList> createState() => GroupListState();
}

class GroupListState extends State<GroupList> {
  final List<Map<String, dynamic>> groups = [
    {
      'name': '엽떡팟',
      'date': '07/22',
      'user': '김두콩, 이뚜현, 네넨이, 인지 23 이강훈',
      'color': const Color(0xFFFFB2A5).withOpacity(0.2),
      'image': 'assets/images/iceBear.jpg',
      'page': const App(),
    },
    {
      'name': '갓생스터디',
      'date': '07/22',
      'user': '김두콩, 이뚜현, 네넨이, 이숨',
      'color': const Color(0xFFFFB2A5).withOpacity(0.2),
      'image': 'assets/images/pinkBear.jpg',
      'page': const App(),
    },
    {
      'name': '계절총회',
      'date': '06/25',
      'user': '컴공 23 박우진, 인지 23 신은준, 인지 23 이강훈',
      'color': const Color(0xFFB0B0B0),
      'image': 'assets/images/iceBear.jpg',
      'page': const App(),
    },
    {
      'name': '술팟',
      'date': '06/22',
      'user': '컴공 23 하성준, 이뚜현, 컴공 23 김병규',
      'color': const Color(0xFFB0B0B0),
      'image': 'assets/images/pinkBear.jpg',
      'page': const App(),
    },
    {
      'name': '종강총회',
      'date': '06/21',
      'user': '강지현, 강민서, 김효정, 두소원, 박현빈',
      'color': const Color(0xFFB0B0B0),
      'image': 'assets/images/pinkBear.jpg',
      'page': const App(),
    },
    {
      'name': '밥약',
      'date': '06/10',
      'user': '컴공 23 하성준, 이숨, 박건형, 이서준',
      'color': const Color(0xFFB0B0B0),
      'image': 'assets/images/pinkBear.jpg',
      'page': const App(),
    },
    // 여기에 그룹 데이터를 추가하세요...
  ];

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                groups[index]['page']), // 채팅창(?) 같은 곳으로 이동
                      );
                    },
                    child: GroupCard(
                      groupName: groups[index]['name'],
                      date: groups[index]['date'],
                      //friends: (groups[index]['user'] as Set<String>).join(', '),
                      friends: groups[index]['user'],
                      backgroundColor: groups[index]['color'],
                      imagePath: groups[index]['image'],
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
  final String date;
  final String friends;
  final Color? backgroundColor;
  final String imagePath;

  const GroupCard({
    super.key,
    required this.groupName,
    required this.date,
    required this.friends,
    this.backgroundColor,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 8.0),
              Text(
                friends,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF646464),
                ),
                overflow: TextOverflow.ellipsis,
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

/* 여기서부터 현비 Time~ */
class AddGroupList extends StatefulWidget {
  const AddGroupList({super.key});

  @override
  State<AddGroupList> createState() => _AddGroupList();
}

class _AddGroupList extends State<AddGroupList> {
  final List<Map<String, String>> friends = [
    {'name': '김예빈', 'id': 'MYBIN'},
    {'name': '한현비', 'id': 'NENEN2YA'},
    {'name': '이수민', 'id': 'SOOOMBB'},
    {'name': '박우진', 'id': 'WOOOOOJIN'},
    {'name': '이강훈', 'id': 'KANGHOOOON'},
    {'name': '엄마', 'id': 'MAMMI'},
  ];

  String meetingName = ''; // 모임 이름
  Set<int> selectedFriends = {}; // 선택된 친구
  List<Map<String, String>> selectedProfiles = []; // 선택된 친구 리스트

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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupChat(
                      meetingName: meetingName,
                      selectedProfiles: selectedProfiles,
                    ),
                  ),
                );
              },
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

class GroupChat extends StatefulWidget {
  final String meetingName; // 모임 이름
  final List<Map<String, String>> selectedProfiles; // 선택된 프로필

  const GroupChat({
    super.key,
    required this.meetingName,
    required this.selectedProfiles,
  });

  @override
  GroupChatState createState() => GroupChatState();
}

class GroupChatState extends State<GroupChat> {
  final List<Map<String, dynamic>> _schedules = [];

  void _navigateToAddSchedule() async {
    final scheduleData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSchedule(
          selectedFriends: widget.selectedProfiles, // 선택된 친구 목록 전달
        ),
      ),
    );

    if (scheduleData != null) {
      setState(() {
        _schedules.add(scheduleData);
      });
    }
  }

  final Map<String, IconData> _categoryIcons = {
    '식비': Icons.fastfood,
    '카페 간식': Icons.local_cafe,
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
    final profilesWithMe = [
      {'name': '나'},
      ...widget.selectedProfiles,
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
            if (profilesWithMe.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: profilesWithMe.map((profile) {
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
            ..._schedules.map((schedule) {
              // 일정에 내 프로필을 추가한 프로필 목록
              final scheduleProfiles = [
                {'name': '나'},
                ...schedule['friends'],
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
                              schedule['name'], // 일정 이름
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF646464),
                              ),
                            ),
                            const SizedBox(height: 5),
                            // 일정 친구들 프로필
                            Row(
                              children: scheduleProfiles.map<Widget>((friend) {
                              // `friend`가 Map 타입인지 확인하고 `name`이 문자열인지 확인
                                final name = friend is Map<String, dynamic> ? friend['name'] : null;
                                final displayName = (name is String && name.isNotEmpty) ? name : ' ';

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
                                        displayName.isNotEmpty ? displayName[0] : ' ', // 이름의 첫 글자만 표시
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
                                '${schedule['amount']}원',
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
        onPressed: _navigateToAddSchedule,
        backgroundColor: const Color(0xFFFFB2A5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50), // 동그란 모양을 유지하기 위해 borderRadius를 설정
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}



class AddSchedule extends StatefulWidget {
  final List<Map<String, String>> selectedFriends; // 선택된 친구들 목록

  const AddSchedule({super.key, required this.selectedFriends});

  @override
  AddScheduleState createState() => AddScheduleState();
}

class AddScheduleState extends State<AddSchedule> {
  final TextEditingController _scheduleNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedCategory;
  final Set<String> _selectedFriends = {};

  final List<String> _categories = [
    '식비',
    '카페 간식',
    '편의점/잡화',
    '취미/여가',
    '의료/건강',
    '교통',
    '미용',
    '여행',
    '술/유흥',
    '쇼핑',
    '저축',
    '교육',
    '공과금',
    '기타'
  ];

  @override
 Widget build(BuildContext context) {
  return Scaffold(
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(50.0),
      child: AppBar(
        backgroundColor: const Color(0xFFF2E8DA),
        elevation: 0,
        title: const Text(
          '일정 추가',
          style: TextStyle(color: Color(0xFF646464)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF646464)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    ),
    backgroundColor: Colors.white,
    body: SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 50, 40, 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '일정이름',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF646464),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _scheduleNameController,
                      decoration: InputDecoration(
                        hintText: '일정 이름을 입력하세요.',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF646464),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        filled: true,
                        fillColor: const Color(0xFFFFB2A5).withOpacity(0.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: const Color(0xFFFFB2A5).withOpacity(0.6),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: const Color(0xFFFFB2A5).withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '카테고리',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF646464),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        filled: true,
                        fillColor: const Color(0xFFFFB2A5).withOpacity(0.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: const Color(0xFFFFB2A5).withOpacity(0.6),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: const Color(0xFFFFB2A5).withOpacity(0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFFFB2A5),
                          ),
                        ),
                      ),
                      dropdownColor: Colors.white,
                      focusColor: const Color(0xFFFFB2A5),
                      menuMaxHeight: 250,
                      value: _selectedCategory,
                      items: _categories
                          .map((category) => DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '금액',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF646464),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '금액을 입력하세요.',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF646464),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        filled: true,
                        fillColor: const Color(0xFFFFB2A5).withOpacity(0.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: const Color(0xFFFFB2A5).withOpacity(0.6),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: const Color(0xFFFFB2A5).withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '친구',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF646464),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        itemCount: widget.selectedFriends.length,
                        itemBuilder: (context, index) {
                          final friend = widget.selectedFriends[index]['name']!;
                          final isSelected = _selectedFriends.contains(friend);
                          return CheckboxListTile(
                            title: Text(friend),
                            value: isSelected,
                            activeColor: const Color(0xFFFFB2A5),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  _selectedFriends.add(friend);
                                } else {
                                  _selectedFriends.remove(friend);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _createSchedule,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        '일정 생성',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }



  void _createSchedule() {
    if (_scheduleNameController.text.isEmpty ||
        _selectedCategory == null ||
        _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필드를 입력해 주세요')),
      );
      return;
    }

    final scheduleData = {
      'name': _scheduleNameController.text,
      'category': _selectedCategory!,
      'friends': _selectedFriends.toList(),
      'amount': _amountController.text,
    };

    Navigator.pop(context, scheduleData);
  }
}