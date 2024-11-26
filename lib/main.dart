import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:paymate/financial_ledger.dart';
import 'package:paymate/firebase_options.dart';
import 'package:paymate/friend_list.dart';
import 'package:paymate/group_list.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:paymate/header.dart';
import 'package:paymate/sign_in.dart';
import 'package:paymate/my_info.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    home: SignIn(),
  ));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _Appstate();
}

class _Appstate extends State<App> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E8DA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(children: [
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyInfo()),
                    );
                  },
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF646464),
                    size: 45,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FinancialLedger()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black54,
                    backgroundColor: Colors.white.withOpacity(0.9),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        'MY \n가계부',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Color(0xFFFFB2A5),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FriendList()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black54,
                    backgroundColor: Colors.white.withOpacity(0.9),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        'MY \n친구목록',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Color(0xFFFFB2A5),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const GroupList()));
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black54,
                backgroundColor: const Color(0xFFFFB2A5),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                maximumSize: const Size(330, 130),
              ),
              child: const Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    'MY \n모임목록',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  Icon(
                    Icons.group_outlined,
                    size: 130,
                    color: Colors.white70,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 85,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.only(left: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${user?.uid}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class TrapezoidClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 40);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
