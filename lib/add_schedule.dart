import 'package:flutter/material.dart';
//import 'package:paymate/main.dart';
import 'package:paymate/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:intl/intl.dart';
//import 'group_list.dart';


class AddSchedule extends StatefulWidget {
  final List<Map<String, dynamic>> groupuser; // 선택된 친구들 목록

  const AddSchedule({
    super.key, 
    required this.groupuser});

  @override
  AddScheduleState createState() => AddScheduleState();
}

class AddScheduleState extends State<AddSchedule> {
  final TextEditingController _scheduleNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedCategory;
  final Set<String> _selectedFriends = {};
  final List<Map<String,dynamic>> groupUser = [];

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
                        itemCount: widget.groupuser.length,
                        itemBuilder: (context, index) {
                          final friend = widget.groupuser[index]['name']!;
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