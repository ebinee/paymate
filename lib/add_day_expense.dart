import 'package:flutter/material.dart';
import 'package:paymate/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDayExpense extends StatefulWidget {
  final DateTime selectedDate;

  const AddDayExpense({
    super.key,
    required this.selectedDate,
  });

  @override
  State<AddDayExpense> createState() => _AddDayExpenseState();
}

class _AddDayExpenseState extends State<AddDayExpense> {
  List<String> categories = [
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
    '기타',
  ];
  String? selectedCategory;
  int currentStep = 0;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedCategory = categories[categories.length - 1];
  }

  bool _validateCurrentStep() {
    if (currentStep == 0) {
      return titleController.text.isNotEmpty;
    } else if (currentStep == 1) {
      return amountController.text.isNotEmpty;
    } else if (currentStep == 2) {
      return selectedCategory != null && selectedCategory!.isNotEmpty;
    }
    return true;
  }

  Future<void> _saveToDatabase() async {
    try {
      await FirebaseFirestore.instance.collection('expense').add({
        'title': titleController.text,
        'money': int.parse(amountController.text),
        'category': selectedCategory,
        'date': Timestamp.fromDate(widget.selectedDate),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('지출 내역이 성공적으로 저장되었습니다!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('저장 중 오류가 발생했습니다. 다시 시도해주세요.')),
        );
      }
    }
  }

  void _continue() {
    if (_validateCurrentStep()) {
      if (currentStep < 2) {
        setState(() {
          currentStep++;
        });
      } else {
        _saveToDatabase();
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('필수 입력 사항입니다.')),
        );
      });
    }
  }

  void _canceled() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  void stepTapped(int step) {
    setState(() {
      currentStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(headerTitle: '지출 추가'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Theme(
            data: ThemeData(
                colorScheme: const ColorScheme.light(
              primary: Color(0xFFFFB2A5),
            )),
            child: Stepper(
              currentStep: currentStep,
              onStepContinue: _continue,
              onStepTapped: stepTapped,
              onStepCancel: _canceled,
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  children: <Widget>[
                    if (currentStep == 2)
                      ElevatedButton(
                        onPressed:
                            _validateCurrentStep() ? _saveToDatabase : null,
                        child: const Text('확인'),
                      )
                    else
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: const Text('계속'),
                      ),
                    if (currentStep > 0)
                      TextButton(
                        onPressed: details.onStepCancel,
                        child: const Text('취소'),
                      ),
                  ],
                );
              },
              steps: [
                Step(
                  title: const Text('지출 이름'),
                  content: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: '지출 이름',
                        ),
                        controller: titleController,
                      ),
                    ],
                  ),
                ),
                Step(
                  title: const Text('지출 금액'),
                  content: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: '지출한 금액을 입력해주세요',
                        ),
                        controller: amountController,
                      ),
                    ],
                  ),
                ),
                Step(
                  title: const Text('카테고리 선택'),
                  content: Column(
                    children: [
                      DropdownButtonFormField(
                        value: selectedCategory,
                        items: categories
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
