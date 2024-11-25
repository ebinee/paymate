import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paymate/day_expense.dart';
import 'package:paymate/header.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class FinancialLedger extends StatefulWidget {
  const FinancialLedger({super.key});

  @override
  State<FinancialLedger> createState() => FinancialLedgerState();
}

class FinancialLedgerState extends State<FinancialLedger> {
  Map<String, double> categoryExpense = {};
  double totalExpense = 0.0;

  IconData getIconForCategory(String category) {
    switch (category) {
      case '식비':
        return Icons.local_dining_rounded;
      case '쇼핑':
        return Icons.shopping_cart_rounded;
      case '카페/간식':
        return Icons.local_cafe_rounded;
      case '편의점/잡화':
        return Icons.shopping_bag_rounded;
      case '취미/여가':
        return Icons.sports_esports_rounded;
      case '의료/건강':
        return Icons.local_hospital_rounded;
      case '교통':
        return Icons.directions_bus_rounded;
      case '미용':
        return Icons.brush_rounded;
      case '여행':
        return Icons.flight_rounded;
      case '술/유흥':
        return Icons.local_bar_rounded;
      case '저축':
        return Icons.savings_rounded;
      case '교육':
        return Icons.school_rounded;
      case '공과금':
        return Icons.receipt;
      default:
        return Icons.dataset_rounded;
    }
  }

  @override
  void initState() {
    super.initState();
    monthlyData();
  }

  Future<void> monthlyData() async {
    DateTime startMonth =
        DateTime(DateTime.now().year, DateTime.now().month, 1);
    DateTime endMonth =
        DateTime(DateTime.now().year, DateTime.now().month + 1, 1)
            .subtract(const Duration(days: 1));

    User? user = FirebaseAuth.instance.currentUser;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('expense')
        .where('uid', isEqualTo: '${user?.uid}')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startMonth))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endMonth))
        .get();

    double tempTotal = 0.0;
    Map<String, double> tempCategoryExpense = {};

    for (var doc in snapshot.docs) {
      String categories = doc['category'];
      double amount = doc['money'].toDouble();

      if (tempCategoryExpense.containsKey(categories)) {
        tempCategoryExpense[categories] =
            tempCategoryExpense[categories]! + amount;
      } else {
        tempCategoryExpense[categories] = amount;
      }

      tempTotal += amount;
    }

    setState(() {
      categoryExpense = tempCategoryExpense;
      totalExpense = tempTotal;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sortedCategoryExpense = categoryExpense.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Scaffold(
      appBar: const Header(
        headerTitle: 'MY 가계부',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'CATEROGY 지출',
                  style: TextStyle(
                    color: Color(0xFF646464),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: 350,
                  height: 230,
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFFFB2A5)),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: sortedCategoryExpense.take(4).map((entry) {
                      double percent = entry.value / totalExpense;
                      return CategoryBar(
                          categoryPercent: percent,
                          categotyIcon: getIconForCategory(entry.key),
                          categoryText: entry.key);
                    }).toList(),
                  ),
                ),
                const CalendarScreen()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryBar extends StatelessWidget {
  final double categoryPercent;
  final IconData categotyIcon;
  final String categoryText;

  const CategoryBar({
    super.key,
    required this.categoryPercent,
    required this.categotyIcon,
    required this.categoryText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFFB2A5),
            ),
            child: Icon(
              categotyIcon,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    categoryText,
                    style: const TextStyle(
                      color: Color(0xFF646464),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              LinearPercentIndicator(
                width: 240,
                lineHeight: 13.0,
                percent: categoryPercent,
                backgroundColor: Colors.grey[300],
                progressColor: const Color(0xFFFFCAC0),
                barRadius: const Radius.circular(3),
                trailing: Text(
                  '${(categoryPercent * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Color(0xFF646464),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: focusedDay,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DayExpense(selectedDay: selectedDay),
          ),
        );
      },
      selectedDayPredicate: (day) {
        return isSameDay(selectedDay, day);
      },
      headerStyle: HeaderStyle(
          titleCentered: true,
          titleTextFormatter: (date, locale) =>
              DateFormat.yMMMM(locale).format(date),
          formatButtonVisible: false,
          titleTextStyle: const TextStyle(
            fontSize: 18,
            color: Color(0xFF646464),
          ),
          leftChevronIcon: const Icon(
            Icons.chevron_left_rounded,
            color: Color(0xFF646464),
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFF646464),
          )),
      calendarStyle: const CalendarStyle(
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
