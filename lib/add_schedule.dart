import 'package:flutter/material.dart';
//import 'package:paymate/main.dart';
import 'package:paymate/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:intl/intl.dart';
//import 'group_list.dart';


class AddSchedule extends StatefulWidget {
  final List<Map<String, dynamic>> groupuser; // 선택된 친구들 목록
  final String groupId;

  const AddSchedule({
    super.key, 
    required this.groupuser,
    required this.groupId,
    });

  @override
  AddScheduleState createState() => AddScheduleState();
}

class AddScheduleState extends State<AddSchedule> {
  final TextEditingController _scheduleNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedCategory;
  final List<Map<String,dynamic>> scheduleUser = [];

  final List<String> _categories = [
    '식비',
    '카페/간식',
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

  bool _isCreateButtonEnabled() {
    return (_scheduleNameController.text.isNotEmpty &&
        _selectedCategory != null &&
        _amountController.text.isNotEmpty);
  }

  @override
 Widget build(BuildContext context) {
  return Scaffold(
      appBar: const Header(headerTitle: '모임 목록'),
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
                        itemCount: widget.groupuser.length,
                        itemBuilder: (context, index) {
                          final friend = widget.groupuser[index]!;
                          final isSelected = scheduleUser.contains(friend);
                          return CheckboxListTile(
                            title: Text(friend['name']),
                            value: isSelected,
                            activeColor: const Color(0xFFFFB2A5),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  scheduleUser.add(friend);
                                } else {
                                  scheduleUser.remove(friend);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _isCreateButtonEnabled()
                      ? () async{
                        try{
                          final firestore = FirebaseFirestore.instance;
                        // 'group' 컬렉션에 새 문서 생성 및 데이터 저장
                        // 현재 그룹 문서 가져오기
            final groupDoc = firestore.collection('group').doc(widget.groupId);

            // 기존 schedule 데이터를 읽어옴
            final groupSnapshot = await groupDoc.get();
            final existingSchedule = (groupSnapshot.data()?['schedule'] ?? []) as List;

            // 새로운 스케줄 데이터 생성
            final newSchedule = {
              'category': _selectedCategory!,
              'money': int.parse(_amountController.text), // 금액은 숫자로 저장
              'scheduleCreator': {'id':'User1','name':'User1'}, // 생성 시간
              'scheduleDate': Timestamp.now(), // 생성 시간
              'schedule_user': scheduleUser, // 선택된 친구 목록
              'title': _scheduleNameController.text, // 일정 이름
            };

            // 기존 데이터에 새 데이터를 추가
            existingSchedule.add(newSchedule);

            // 그룹 문서의 schedule 필드 업데이트
            await groupDoc.update({'schedule': existingSchedule});
if(mounted){
      Navigator.pop(context);
}}
catch(e){
                        // 에러 핸들링 (예: 스낵바로 에러 메시지 표시)
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('스케쥴 생성 실패: $e')),
                          );
                        }
                      }
                    }
                  : null,
                      
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
}