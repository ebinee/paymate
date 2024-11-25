import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paymate/add_day_expense.dart';
import 'package:paymate/header.dart';
import 'package:table_calendar/table_calendar.dart';

class DayExpense extends StatefulWidget {
  final DateTime selectedDay;

  const DayExpense({
    super.key,
    required this.selectedDay,
  });

  @override
  State<DayExpense> createState() => _DayExpenseState();
}

class _DayExpenseState extends State<DayExpense> {
  late DateTime _selectedDay;
  String? _selectedCategory;
  final firestore = FirebaseFirestore.instance;

  Map<String, IconData> iconMap = {};

  Stream<List<Map<String, dynamic>>> getData() {
    DateTime startDay = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
      00,
      00,
      00,
    );
    DateTime endDay = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
      23,
      59,
      59,
    );

    return firestore
        .collection('expense')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDay))
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                'category_icon': getIconForCategory(doc['category']),
                'category': doc['category'],
                'title': doc['title'],
                'money': doc['money'],
              };
            }).toList());
  }

  Icon getIconForCategory(String category) {
    switch (category) {
      case '식비':
        return const Icon(Icons.local_dining_rounded);
      case '쇼핑':
        return const Icon(Icons.shopping_cart_rounded);
      case '카페/간식':
        return const Icon(Icons.local_cafe_rounded);
      case '편의점/잡화':
        return const Icon(Icons.shopping_bag_rounded);
      case '취미/여가':
        return const Icon(Icons.sports_esports_rounded);
      case '의료/건강':
        return const Icon(Icons.local_hospital_rounded);
      case '교통':
        return const Icon(Icons.directions_bus_rounded);
      case '미용':
        return const Icon(Icons.brush_rounded);
      case '여행':
        return const Icon(Icons.flight_rounded);
      case '술/유흥':
        return const Icon(Icons.local_bar_rounded);
      case '저축':
        return const Icon(Icons.savings_rounded);
      case '교육':
        return const Icon(Icons.school_rounded);
      case '공과금':
        return const Icon(Icons.receipt);
      default:
        return const Icon(Icons.dataset_rounded);
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDay;
    _selectedCategory = null;
    getData();
  }

  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _selectedCategory = null;
    });
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    String locale = Localizations.localeOf(context).toString();

    return Scaffold(
      appBar: const Header(headerTitle: 'DAILY 지출'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 350,
                height: 90,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFFFB2A5)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WeekCalendar(
                    selectedDay: _selectedDay,
                    onDaySelected: _onDaySelected,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.MMMMd(locale).format(_selectedDay),
                    style: const TextStyle(
                      color: Color(0xFF646464),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: getData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error');
                      }

                      final dayexp = snapshot.data!;

                      return DropButton(
                        categoryItem: dayexp.map((e) => e['category']).toList(),
                        selectedCategory: _onCategorySelected,
                        selectedValue: _selectedCategory,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error');
                  }

                  final dayexp = snapshot.data!;
                  final filterdExp = _selectedCategory == null
                      ? dayexp
                      : dayexp
                          .where((expense) =>
                              expense['category'] == _selectedCategory)
                          .toList();

                  return Column(
                    children: [
                      Container(
                        width: 350,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFFFB2A5)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'DAILY 지출',
                                style: TextStyle(
                                  color: Color(0xFF646464),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${dayexp.fold<int>(0, (total, item) => total + item['money'] as int)} 원',
                                style: const TextStyle(
                                  color: Color(0xFFDE8286),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          itemCount: filterdExp.length,
                          itemBuilder: (ctx, index) {
                            final expense = filterdExp[index];
                            return ListTile(
                              leading: expense['category_icon'],
                              title: Text(
                                '${expense['category']}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text('${expense['title']}'),
                              trailing: Text(
                                '${expense['money']} 원',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              tileColor: const Color(0xFFFFF0ED),
                              textColor: const Color(0xFF646464),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.add_rounded),
                            label: const Text(
                              '지출 추가',
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddDayExpense(
                                            selectedDate: _selectedDay,
                                          )));
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeekCalendar extends StatefulWidget {
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDaySelected;

  const WeekCalendar({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  State<WeekCalendar> createState() => _WeekCalendarState();
}

class _WeekCalendarState extends State<WeekCalendar> {
  late DateTime focusedDay;
  late DateTime selectedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = widget.selectedDay;
    focusedDay = widget.selectedDay;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: focusedDay,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        setState(() {
          this.selectedDay = selectedDay;
          this.focusedDay = focusedDay;
        });
        widget.onDaySelected(selectedDay);
      },
      selectedDayPredicate: (day) {
        return isSameDay(selectedDay, day);
      },
      onPageChanged: (focusedDay) {
        setState(() {
          this.focusedDay = focusedDay;
        });
      },
      headerVisible: false,
      calendarFormat: CalendarFormat.week,
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.white,
        ),
        todayTextStyle: TextStyle(
          fontSize: 13,
          color: Color(0xFF646464),
        ),
        selectedDecoration: BoxDecoration(
          color: Color(0xFFFFB2A5),
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
        defaultTextStyle: TextStyle(
          fontSize: 13,
          color: Color(0xFF646464),
        ),
        weekendTextStyle: TextStyle(
          fontSize: 13,
          color: Color(0xFF646464),
        ),
      ),
    );
  }
}

class DropButton extends StatefulWidget {
  final List categoryItem;
  final ValueChanged<String?> selectedCategory;
  final String? selectedValue;

  const DropButton({
    super.key,
    required this.categoryItem,
    required this.selectedCategory,
    required this.selectedValue,
  });

  @override
  State<DropButton> createState() => _DropButtonState();
}

class _DropButtonState extends State<DropButton> {
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF646464)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
          ),
          child: DropdownButton(
            hint: const Text('카테고리'),
            value: _selectedCategory,
            items: ['전체', ...widget.categoryItem]
                .map((category) => DropdownMenuItem<String>(
                      value: category == '전체' ? null : category,
                      child: Text(category),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
              widget.selectedCategory(value);
            },
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            iconSize: 25,
            underline: Container(),
            style: const TextStyle(
              color: Color(0xFF646464),
              fontSize: 15,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
      ),
    );
  }
}
