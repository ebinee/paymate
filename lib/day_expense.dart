import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDay;
  }

  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    String locale = Localizations.localeOf(context).toString();

    final Map<DateTime, List<Map<String, dynamic>>> expenses = {
      DateTime(2024, 8, 6): [
        {
          'category_icon': const Icon(Icons.local_dining_rounded),
          'category': '식비',
          'expense_name': '엽기떡볶이',
          'money': 4000
        },
        {
          'category_icon': const Icon(Icons.shopping_cart_rounded),
          'category': '쇼핑',
          'expense_name': '키링',
          'money': 16000
        },
        {
          'category_icon': const Icon(Icons.coffee_rounded),
          'category': '카페/간식',
          'expense_name': '와플',
          'money': 4900
        },
      ],
      DateTime(2024, 8, 7): [
        {
          'category_icon': const Icon(Icons.local_dining_rounded),
          'category': '식비',
          'expense_name': '샌드위치',
          'money': 3000
        },
        {
          'category_icon': const Icon(Icons.coffee_rounded),
          'category': '카페/간식',
          'expense_name': '칸나',
          'money': 6000
        },
      ],
    };

    final selectedDate =
        DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);

    final dayexp = expenses[selectedDate] ?? [];

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
                width: 300,
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
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: 300,
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
                        '${dayexp.fold<int>(0, (sum, item) => sum + item['money'] as int)} 원',
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
                  itemCount: dayexp.length,
                  itemBuilder: (ctx, index) {
                    final expense = dayexp[index];
                    return ListTile(
                      leading: expense['category_icon'],
                      title: Text(
                        '${expense['category']}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text('${expense['expense_name']}'),
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
              const Row(
                children: [
                  Icon(Icons.add_rounded),
                  Text('지출 추가'),
                ],
              )
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
