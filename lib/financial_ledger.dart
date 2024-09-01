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
  @override
  Widget build(BuildContext context) {
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
                  width: 300,
                  height: 230,
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFFFB2A5)),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      CategoryBar(
                          categoryPercent: 0.7,
                          categotyIcon: Icons.local_dining_rounded,
                          categoryText: '음식'),
                      CategoryBar(
                          categoryPercent: 0.21,
                          categotyIcon: Icons.coffee_rounded,
                          categoryText: '카페/간식'),
                      CategoryBar(
                          categoryPercent: 0.05,
                          categotyIcon: Icons.shopping_cart_rounded,
                          categoryText: '쇼핑'),
                      CategoryBar(
                          categoryPercent: 0.02,
                          categotyIcon: Icons.gamepad_rounded,
                          categoryText: '취미/여가'),
                    ],
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
                width: 200,
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
