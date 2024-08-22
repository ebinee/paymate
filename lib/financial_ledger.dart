import 'package:flutter/material.dart';
import 'package:paymate/header.dart';

class FinancialLedger extends StatefulWidget {
  const FinancialLedger({super.key});

  @override
  State<FinancialLedger> createState() => FinancialLedgerState();
}

class FinancialLedgerState extends State<FinancialLedger> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Header(
        headerTitle: 'MY 가계부',
      ),
    );
  }
}
