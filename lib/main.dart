import 'package:flutter/material.dart';
import 'package:paymate/financial_ledger.dart';
import 'package:paymate/friend_list.dart';
import 'package:paymate/group_list.dart';

void main() {
  runApp(const MaterialApp(
    home: App(),
  ));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _Appstate();
}

class _Appstate extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E8DA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/images/paymate_logo.png',
                    width: 200,
                    height: 65,
                    fit: BoxFit.fill,
                  ),
                  const Icon(
                    Icons.person,
                    color: Color(0xFF646464),
                    size: 45,
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text('MY 가계부'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FinancialLedger()),
                      );
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    child: const Text('MY 친구 목록'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FriendList()));
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                child: const Text('MY 모임 목록'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GroupList()));
                },
              ),
              const SizedBox(
                height: 30,
              ),
              const Text('monthly 지출'),
            ],
          ),
        ),
      ),
    );
  }
}
