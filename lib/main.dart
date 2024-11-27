import 'package:flutter/material.dart';
import 'package:paymate/financial_ledger.dart';
import 'package:paymate/friend_list.dart';
import 'package:paymate/group_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:paymate/my_info.dart';
import 'package:paymate/sign_in.dart';
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
  // Future<Map<int, int>>? _monthlyExpense;

  /*
  @override
  void initState() {
    super.initState();
    _monthlyExpense = fetchMonthlyExpense(); // Firebase 데이터 가져오기
  }
  */
  Stream<Map<int, int>> fetchMonthlyExpenseStream() {
    return FirebaseFirestore.instance
        .collection('expense')
        .where('uid', isEqualTo: user?.uid)
        .snapshots()
        .map((snapshot) {
      Map<int, int> monthlyExpense = {};
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();

        // 'date' 필드를 Timestamp로 처리
        Timestamp timestamp = data['date'];
        DateTime dateTime = timestamp.toDate().toLocal();
        int month = dateTime.month;

        // 'money' 필드 처리
        int money = data['money'];

        // 월별 합산
        if (monthlyExpense.containsKey(month)) {
          monthlyExpense[month] = monthlyExpense[month]! + money;
        } else {
          monthlyExpense[month] = money;
        }
      }
      return monthlyExpense;
    });
  }

  Widget buildBarChart(Map<int, int> monthlyExpense) {
    // 월 이름 매핑
    const monthNames = {
      //1: "JAN",
      //2: "FEB",
      //3: "MAR",
      //4: "APR",
      //5: "MAY",
      6: "JUN",
      7: "JUL",
      8: "AUG",
      9: "SEP",
      10: "OCT",
      11: "NOV",
      //12: "DEC"
    };

    return Container(
      // Chart 겉의 테두리
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      width: MediaQuery.of(context).size.width * 0.85, // 화면 너비의 80%
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color(0xFFFFB2A5).withOpacity(0.3), width: 1),
        borderRadius: BorderRadius.circular(12), // Rounded border
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          maxY: (() {
            final maxExpense =
                monthlyExpense.values.reduce((a, b) => a > b ? a : b);
            return maxExpense.toDouble() + (maxExpense / 4).toDouble();
          })(),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: (() {
            final maxExpense =
                monthlyExpense.values.reduce((a, b) => a > b ? a : b);
            return [6, 7, 8, 9, 10, 11].map((month) {
              final double value = monthlyExpense[month]?.toDouble() ?? 0.0;
              return BarChartGroupData(
                x: month,
                barRods: [
                  BarChartRodData(
                    toY: value,
                    color: value == maxExpense.toDouble()
                        ? const Color(0xFFFFB2A5).withOpacity(0.7) // 최대값 막대 색상
                        : const Color(0xFFFFB2A5).withOpacity(0.3), // 나머지 막대 색상
                    width: 35,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ],
                showingTooltipIndicators: [0], // Tooltip 활성화
              );
            }).toList();
          })(),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // 우측 숫자 숨기기
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // 상단 레이블 제거
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final month = monthNames[value.toInt()] ?? '';
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      month,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF646464),
                          decoration: TextDecoration.none),
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipMargin: -5, // 툴팁과 막대 사이의 간격
              tooltipHorizontalAlignment:
                  FLHorizontalAlignment.center, // 툴팁을 막대 중앙에 정렬
              getTooltipColor: (group) => Colors.transparent, // 툴팁 배경색 설정
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final maxExpense = monthlyExpense.isNotEmpty
                    ? monthlyExpense.values.reduce((a, b) => a > b ? a : b)
                    : 0;
                final isMaxValue = rod.toY == maxExpense.toDouble();

                return BarTooltipItem(
                  (rod.toY ~/ 10000).toString(), // 막대의 값을 표시
                  TextStyle(
                    color: isMaxValue
                        ? const Color(0xFFF97272) // 최대값 막대의 툴팁 텍스트 색상
                        : const Color(0xFF646464), // 나머지 막대의 툴팁 텍스트 색상
                    fontWeight: FontWeight.bold, // 텍스트 굵게
                    fontSize: 12,
                    decoration: TextDecoration.none,
                  ),
                );
              },
              fitInsideVertically: true, // 툴팁이 차트의 위아래를 넘지 않도록 제한 (수직)
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.white,
      ),
      ClipPath(
        clipper: TrapezoidClipper(),
        child: Container(
          width: double.infinity,
          height: 230, // 높이 조정 가능
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
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Go to FinancialLedger()
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
            // Go to GroupList()
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupList(
                              user: user,
                            )));
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black54,
                //foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFFFB2A5).withOpacity(0.7),
                padding: const EdgeInsets.symmetric(
                    horizontal: 0, vertical: 0), // 패딩
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // 모서리 둥글기
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
                    Icons.group_outlined, // 사람 모양 아이콘
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
                        Icons.arrow_forward_ios, // 화살표 아이콘
                        size: 20,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Container(
              padding: const EdgeInsets.only(left: 25.0), // 왼쪽 정렬
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "MONTHLY 지출",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      decoration: TextDecoration.none),
                ),
              ),
            ),
            // const SizedBox(height: 5),
            // 차트 추가
            StreamBuilder<Map<int, int>>(
              stream:
                  fetchMonthlyExpenseStream(), // Firebase에서 데이터를 가져오는 Future
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 240, // 차트 높이 설정
                      child: buildBarChart(snapshot.data!), // 차트 위젯 생성
                    ),
                  );
                } else {
                  return const Center(child: Text('No data available.'));
                }
              },
            ),
          ]),
        ),
      ),
    ]);
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
    return false; // 클리퍼 재사용 여부
  }
}
