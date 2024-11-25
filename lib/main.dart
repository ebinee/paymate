import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:paymate/financial_ledger.dart';
import 'package:paymate/firebase_options.dart';
import 'package:paymate/friend_list.dart';
import 'package:paymate/group_list.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:paymate/header.dart';
import 'package:paymate/new_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.white,
      body: App(),
    ),
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
    BarData barData = BarData(
      mon: 5,
      tue: 7,
      wed: 6,
      thu: 8,
      fri: 5,
      sat: 4,
    );
    barData.initializeBarData();

    return Stack(
      children: [
        ClipPath(
          clipper: TrapezoidClipper(),
          child: Container(
            width: double.infinity,
            height: 230,
            color: const Color(0xFFF2E8DA),
          ),
        ),
        Center(
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
                      _navigateToNewPage(context);
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 25),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 25),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GroupList()));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black54,
                  backgroundColor: const Color(0xFFFFB2A5).withOpacity(0.7),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "MONTHLY 지출",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 20.0, top: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFFFB2A5),
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: BarChart(
                          BarChartData(
                            borderData: FlBorderData(
                              show: false,
                            ),
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    const days = [
                                      'FEB',
                                      'MAR',
                                      'APRIL',
                                      'MAY',
                                      'JUN',
                                      'JUL',
                                    ];
                                    return Text(
                                      days[value.toInt()],
                                      style: const TextStyle(fontSize: 12),
                                    );
                                  },
                                ),
                              ),
                            ),
                            barGroups: barData.barData
                                .map(
                                  (data) => BarChartGroupData(
                                    x: data.x,
                                    barRods: [
                                      BarChartRodData(
                                        toY: data.y,
                                        color: const Color(0xFFFFB2A5),
                                        width: 35,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ))),
            ]),
          ),
        ),
      ],
    );
  }

  void _navigateToNewPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const NewPage(id: "USER", name: "사용자")),
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

class IndividualBar {
  final int x;
  final double y;

  IndividualBar({
    required this.x,
    required this.y,
  });
}

class BarData {
  final double mon;
  final double tue;
  final double wed;
  final double thu;
  final double fri;
  final double sat;

  BarData({
    required this.mon,
    required this.tue,
    required this.wed,
    required this.thu,
    required this.fri,
    required this.sat,
  });

  List<IndividualBar> barData = [];
  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: mon),
      IndividualBar(x: 1, y: tue),
      IndividualBar(x: 2, y: wed),
      IndividualBar(x: 3, y: thu),
      IndividualBar(x: 4, y: fri),
      IndividualBar(x: 5, y: sat),
    ];
  }
}
