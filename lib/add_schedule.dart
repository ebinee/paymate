import 'package:flutter/material.dart';
import 'package:paymate/group_list.dart'; // 현비 언니 페이지로

class AddSchedule extends StatefulWidget {
  const AddSchedule({super.key});

  @override
  State<AddSchedule> createState() => AddScheduleState();
}

class AddScheduleState extends State<AddSchedule> {
  final TextEditingController _scheduleNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedCategory;
  String? _selectedFriend;

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
  final List<String> _friends = [
    '김두콩',
    '이뚜현',
    '네넨이',
    '최지뇽',
    '컴공 23 박우진',
    '인지 23 이강훈',
    '인지 23 신은준',
    '컴공 23 하성준'
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
              '일정 추가',
              style: TextStyle(color: Color(0xFF646464)),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded,
                  color: Color(0xFF646464)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const GroupList()));
              },
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 50, 40, 20),
              child: Container(
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
                        //labelText: '일정 이름을 입력하세요.',
                        hintText: '일정 이름을 입력하세요.',
                        hintStyle: const TextStyle(
                          fontSize: 14, // Change the font size
                          color: Color(0xFF646464),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        filled: true,
                        fillColor: const Color(0xFFFFB2A5).withOpacity(0.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: const Color(0xFFFFB2A5)
                                .withOpacity(0.6), // fill 색상과 동일하게 설정
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: const Color(0xFFFFB2A5)
                                .withOpacity(0.2), // 비활성화된 상태의 테두리 색상
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
                        //labelText: '카테고리를 선택하세요.',
                        // hintText: '카테고리를 선택하세요.',
                        // hintStyle: const TextStyle(
                        //   fontSize: 14, // Change the font size
                        //   color: Color(0xFF646464),
                        // ),
                        contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        filled: true,
                        fillColor: const Color(0xFFFFB2A5).withOpacity(0.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: const Color(0xFFFFB2A5)
                                .withOpacity(0.6), // fill 색상과 동일하게 설정
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: const Color(0xFFFFB2A5)
                                .withOpacity(0.2), // 비활성화된 상태의 테두리 색상
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFFFB2A5), // 활성화된 상태의 테두리 색상
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
                        // labelText: '금액을 입력하세요.',
                        hintText: '금액을 입력하세요.',
                        hintStyle: const TextStyle(
                          fontSize: 14, // Change the font size
                          color: Color(0xFF646464),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        filled: true,
                        fillColor: const Color(0xFFFFB2A5).withOpacity(0.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: const Color(0xFFFFB2A5)
                                .withOpacity(0.6), // fill 색상과 동일하게 설정
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: const Color(0xFFFFB2A5)
                                .withOpacity(0.2), // 비활성화된 상태의 테두리 색상
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
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        //labelText: '친구를 선택하세요.',
                        // hintText: '친구를 선택하세요.',
                        // hintStyle: const TextStyle(
                        //   fontSize: 14, // Change the font size
                        //   color: Color(0xFF646464),
                        // ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 20),
                        filled: true,
                        fillColor: const Color(0xFFFFB2A5).withOpacity(0.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: const Color(0xFFFFB2A5)
                                .withOpacity(0.6), // fill 색상과 동일하게 설정
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: const Color(0xFFFFB2A5)
                                .withOpacity(0.2), // 비활성화된 상태의 테두리 색상
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFFFB2A5), // 활성화된 상태의 테두리 색상
                          ),
                        ),
                      ),
                      menuMaxHeight: 250,
                      dropdownColor: Colors.white,
                      value: _selectedFriend,
                      items: _friends
                          .map((friend) => DropdownMenuItem<String>(
                                value: friend,
                                child: Text(friend),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedFriend = value;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        // Handle form submission here
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 50.0),
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
            ),
          ),
        ));
  }
}
