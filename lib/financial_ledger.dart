import 'package:flutter/material.dart';

class FinancialLedger extends StatefulWidget {
  const FinancialLedger({super.key});

  @override
  State<FinancialLedger> createState() => FinancialLedgerState();
}

class FinancialLedgerState extends State<FinancialLedger> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
