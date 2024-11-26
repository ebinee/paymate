import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paymate/header.dart';

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

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('expense')
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
    return const Scaffold(
      appBar: Header(
        headerTitle: 'MY 가계부',
      ),
    );
  }
}
